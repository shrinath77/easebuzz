package com.easybuzz.servlet;

import com.easybuzz.util.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CheckoutServlet.class.getName());

    /**
     * GET /checkout — forward to the checkout page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.info("GET /checkout - Forwarding to checkout.jsp");
        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    /**
     * POST /checkout — handle AJAX payment requests from checkout.jsp
     * Expects a JSON body: { "method": "card|upi|netbanking|wallet|bnpl", "amount": "1500.00", ... }
     * Returns: { "status": "success|error", "message": "..." }
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            // Read JSON request body
            StringBuilder sb = new StringBuilder();
            BufferedReader reader = request.getReader();
            String line;
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }

            String body = sb.toString();
            LOGGER.info("Payment request received: " + body);

            // Extract the "method" field from JSON using simple string parsing
            String method = "UNKNOWN";
            if (body.contains("\"method\"")) {
                int start = body.indexOf("\"method\"") + 10;
                while (start < body.length() && (body.charAt(start) == ' ' || body.charAt(start) == ':' || body.charAt(start) == '"')) {
                    start++;
                }
                int end = body.indexOf("\"", start);
                if (end > start) {
                    method = body.substring(start, end).toUpperCase();
                }
            }

            // Read amount from the JSON body
            String amount = "0.00";
            if (body.contains("\"amount\"")) {
                int aStart = body.indexOf("\"amount\"") + 10;
                while (aStart < body.length() && (body.charAt(aStart) == ' ' || body.charAt(aStart) == ':' || body.charAt(aStart) == '"')) {
                    aStart++;
                }
                int aEnd = body.indexOf("\"", aStart);
                if (aEnd > aStart) amount = body.substring(aStart, aEnd);
            }

            LOGGER.info("Payment Method: " + method + " | Amount: ₹" + amount);

            // Get txnid from session to identify which record to update
            HttpSession session = request.getSession(false);
            String txnid = (session != null) ? (String) session.getAttribute("txnid") : null;

            // TODO: Integrate with real EaseBuzz payment gateway here
            // For now, simulate a successful payment response
            String easebuzzTxnId = "EB" + System.currentTimeMillis();
            String bankRefNum = "BRN" + System.currentTimeMillis();

            // UPDATE transaction with success details
            updateTransactionStatus(txnid, "SUCCESS", method, easebuzzTxnId, bankRefNum, null);

            String jsonResponse = "{"
                    + "\"status\":\"success\","
                    + "\"message\":\"Payment of \\u20B9" + amount + " received via " + method + ". Transaction ID: " + easebuzzTxnId + "\""
                    + "}";

            LOGGER.info("Payment successful - TxnID: " + easebuzzTxnId);
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Payment processing failed", e);

            // Try to mark the transaction as FAILED in DB
            HttpSession session = request.getSession(false);
            String txnid = (session != null) ? (String) session.getAttribute("txnid") : null;
            updateTransactionStatus(txnid, "FAILED", null, null, null, e.getMessage());

            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{"
                    + "\"status\":\"error\","
                    + "\"message\":\"Payment processing failed. Please try again.\""
                    + "}");
        }
    }

    /**
     * Updates transaction status and related fields in the transactions table.
     *
     * @param txnid           Transaction ID (unique)
     * @param status          Payment status (SUCCESS, FAILED, PENDING)
     * @param paymentMode     Payment method used (UPI, CARD, NETBANKING, WALLET, BNPL)
     * @param easebuzzTxnId   EaseBuzz transaction ID returned from gateway
     * @param bankRefNum      Bank reference number
     * @param errorMessage    Error message if payment failed
     */
    private void updateTransactionStatus(String txnid, String status, String paymentMode,
                                          String easebuzzTxnId, String bankRefNum, String errorMessage) {
        if (txnid == null || txnid.isEmpty()) {
            LOGGER.warning("Cannot update status — txnid is null or empty");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null) {
                String sql = "UPDATE transactions SET " +
                        "payment_status = ?, " +
                        "payment_mode = ?, " +
                        "easebuzz_txn_id = ?, " +
                        "bank_ref_num = ?, " +
                        "error_message = ? " +
                        "WHERE txnid = ?";

                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, status);
                    ps.setString(2, paymentMode);
                    ps.setString(3, easebuzzTxnId);
                    ps.setString(4, bankRefNum);
                    ps.setString(5, errorMessage);
                    ps.setString(6, txnid);

                    int rows = ps.executeUpdate();
                    LOGGER.info("Transaction updated: status=" + status + ", txnid=" + txnid + " (" + rows + " row updated)");
                }
            } else {
                LOGGER.severe("Database connection is NULL. Cannot update transaction status.");
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Failed to update transaction status for txnid: " + txnid, ex);
        }
    }
}
