package com.easybuzz.servlet;

import com.easybuzz.util.DBConnection;
import com.easybuzz.util.ConfigUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/PaymentProcess")
public class PaymentProcess extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentProcess.class.getName());
    private static final String EASEBUZZ_KEY = ConfigUtil.getEasebuzzKey();
    private static final String EASEBUZZ_SALT = ConfigUtil.getEasebuzzSalt();

    private static final String EASEBUZZ_API = "https://testpay.easebuzz.in/payment/initiateLink";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            LOGGER.info("PaymentProcess initiated");

            // Generate unique transaction id
            String txnid = "EBZ" + System.currentTimeMillis();

            // Get parameters safely
            String amountRaw = getParam(request, "amount");
            String productinfo = getParam(request, "productinfo");
            String firstname = getParam(request, "firstname");

            if (firstname == null || firstname.trim().isEmpty()) {
                firstname = "Customer";
            }
            String phone = getParam(request, "customerMobile");
            String email = getParam(request, "customerEmail");
            String merchantKey = EASEBUZZ_KEY;

            // Update these URLs with your actual ngrok URL or deployment URL
            String baseUrl = request.getScheme() + "://" + request.getServerName() +
                    ":" + request.getServerPort() + request.getContextPath();
            String surl = baseUrl + "/success";
            String furl = baseUrl + "/failure";

            String amount;

            try {
                double amt = Double.parseDouble(amountRaw);
                amount = String.format("%.2f", amt);
            } catch (Exception e) {
                amount = "0.00";
            }

            LOGGER.info("TxnID: " + txnid + " Amount: " + amount);

            // Save transaction in database
            saveTransaction(merchantKey, txnid, amount, firstname, email, phone);

            // Generate hash
            String hash = generateHash(txnid, amount, productinfo, firstname, email);

            LOGGER.info("Hash generated: " + hash);

            // Call Easebuzz API
            String paymentUrl = callEasebuzzAPI(
                    txnid, amount, productinfo, firstname, email, phone, surl, furl, hash
            );

            if (paymentUrl != null) {

                LOGGER.info("Redirecting to Easebuzz payment page");

                response.sendRedirect(paymentUrl);

            } else {

                response.getWriter().write("Payment initialization failed");

            }

        } catch (Exception e) {

            LOGGER.log(Level.SEVERE, "Payment error", e);
        }
    }

    // Safe parameter fetch
    private String getParam(HttpServletRequest request, String name) {

        String value = request.getParameter(name);

        return value == null ? "" : value.trim();
    }

    // Save transaction in DB
    private void saveTransaction(String merchantKey, String txnid, String amount,
                                 String firstname, String email, String phone) {

        try (Connection conn = DBConnection.getConnection()) {

            String sql =
                    "INSERT INTO transactions(merchant_key, txnid, amount, firstname, email, phone, payment_status) VALUES (?,?,?,?,?,?,?)";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, merchantKey);
            ps.setString(2, txnid);
            ps.setString(3, amount);
            ps.setString(4, firstname);
            ps.setString(5, email);
            ps.setString(6, phone);
            ps.setString(7, "PENDING");

            ps.executeUpdate();

            LOGGER.info("Transaction inserted successfully");

        } catch (Exception e) {

            LOGGER.log(Level.SEVERE, "DB insert error", e);
        }
    }

    // Generate SHA512 hash
    private String generateHash(String txnid, String amount,
                                String productinfo, String firstname, String email) {

        try {

            String hashString = EASEBUZZ_KEY + "|" + txnid + "|" + amount + "|" +
                    productinfo + "|" + firstname + "|" + email +
                    "|||||||||||" + EASEBUZZ_SALT;


            MessageDigest md = MessageDigest.getInstance("SHA-512");

            byte[] bytes = md.digest(hashString.getBytes(StandardCharsets.UTF_8));

            StringBuilder hash = new StringBuilder();

            for (byte b : bytes) {

                String hex = Integer.toHexString(0xff & b);

                if (hex.length() == 1)
                    hash.append('0');

                hash.append(hex);
            }

            return hash.toString();

        } catch (Exception e) {

            LOGGER.log(Level.SEVERE, "Hash error", e);

            return null;
        }
    }

    // Call Easebuzz API
    private String callEasebuzzAPI(String txnid, String amount, String productinfo,
                                   String firstname, String email, String phone,
                                   String surl, String furl, String hash) {

        try {

            Map<String, String> params = new HashMap<>();

            params.put("key", EASEBUZZ_KEY);
            params.put("txnid", txnid);
            params.put("amount", amount);
            params.put("productinfo", productinfo);
            params.put("firstname", firstname);
            params.put("email", email);
            params.put("phone", phone);
            params.put("surl", surl);
            params.put("furl", furl);
            params.put("hash", hash);
            params.put("udf1", "");
            params.put("udf2", "");
            params.put("udf3", "");
            params.put("udf4", "");
            params.put("udf5", "");
            params.put("udf6", "");
            params.put("udf7", "");
            params.put("udf8", "");
            params.put("udf9", "");
            params.put("udf10", "");

            StringBuilder postData = new StringBuilder();

            for (Map.Entry<String, String> entry : params.entrySet()) {

                if (postData.length() != 0) postData.append("&");

                postData.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
                postData.append("=");
                postData.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            }

            URL url = new URL(EASEBUZZ_API);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            conn.setRequestMethod("POST");
            conn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
            conn.setDoOutput(true);

            try (OutputStream os = conn.getOutputStream()) {

                os.write(postData.toString().getBytes(StandardCharsets.UTF_8));

            }

            int responseCode = conn.getResponseCode();

            LOGGER.info(" Easebuzz response code: " + responseCode);

            if (responseCode == HttpURLConnection.HTTP_OK) {

                Scanner sc = new Scanner(conn.getInputStream());

                String response = sc.useDelimiter("\\A").next();

                sc.close();

                LOGGER.info("Easebuzz response: " + response);

                //  Check if payment request is valid
                if (response.contains("\"status\": 1")) {

                    int start = response.indexOf("\"data\": \"") + 9;
                    int end = response.indexOf("\"", start);

                    String accessKey = response.substring(start, end);

                    return "https://testpay.easebuzz.in/pay/" + accessKey;
                } else {

                    LOGGER.severe("Easebuzz Error: " + response);
                }
            }

        } catch (Exception e) {

            LOGGER.log(Level.SEVERE, "Easebuzz API error", e);
        }

        return null;
    }
}

