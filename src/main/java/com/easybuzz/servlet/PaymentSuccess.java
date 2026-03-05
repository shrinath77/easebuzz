package com.easybuzz.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/success")
public class PaymentSuccess extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String txnid = request.getParameter("txnid");
        String amount = request.getParameter("amount");
        String productinfo = request.getParameter("productinfo");
        String firstname = request.getParameter("firstname");
        String email = request.getParameter("email");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println(generateSuccessPage(txnid, status, amount, productinfo, firstname, email));
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        doPost(req, res);
    }

    private String generateSuccessPage(String txnid, String status, String amount, String productinfo, String firstname, String email) {
        StringBuilder html = new StringBuilder();
        
        html.append("<!DOCTYPE html>");
        html.append("<html lang=\"en\">");
        html.append("<head>");
        html.append("    <meta charset=\"UTF-8\">");
        html.append("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        html.append("    <title>Payment Successful - EaseBuzz</title>");
        html.append("    <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap\" rel=\"stylesheet\">");
        html.append("    <style>");
        html.append(getSuccessPageStyles());
        html.append("    </style>");
        html.append("</head>");
        html.append("<body>");
        
        html.append("    <div class=\"container\">");
        html.append("        <div class=\"success-card\">");
        
        // Success Icon
        html.append("            <div class=\"icon-container success\">");
        html.append("                <svg width=\"80\" height=\"80\" viewBox=\"0 0 24 24\" fill=\"none\">");
        html.append("                    <circle cx=\"12\" cy=\"12\" r=\"10\" stroke=\"#28a745\" stroke-width=\"2\"/>");
        html.append("                    <path d=\"M9 12l2 2 4-4\" stroke=\"#28a745\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/>");
        html.append("                </svg>");
        html.append("            </div>");
        
        // Success Message
        html.append("            <h1 class=\"title\">Payment Successful!</h1>");
        html.append("            <p class=\"message\">Thank you for your payment. Your transaction has been completed successfully.</p>");
        
        // Transaction Details
        html.append("            <div class=\"details-container\">");
        html.append("                <h3>Transaction Details</h3>");
        html.append("                <div class=\"detail-row\">");
        html.append("                    <span class=\"label\">Transaction ID:</span>");
        html.append("                    <span class=\"value\">").append(txnid != null ? txnid : "N/A").append("</span>");
        html.append("                </div>");
        
        if (amount != null) {
            html.append("                <div class=\"detail-row\">");
            html.append("                    <span class=\"label\">Amount Paid:</span>");
            html.append("                    <span class=\"value amount-success\">₹").append(amount).append("</span>");
            html.append("                </div>");
        }
        
        if (productinfo != null) {
            html.append("                <div class=\"detail-row\">");
            html.append("                    <span class=\"label\">Product/Service:</span>");
            html.append("                    <span class=\"value\">").append(productinfo).append("</span>");
            html.append("                </div>");
        }
        
        if (firstname != null) {
            html.append("                <div class=\"detail-row\">");
            html.append("                    <span class=\"label\">Customer Name:</span>");
            html.append("                    <span class=\"value\">").append(firstname).append("</span>");
            html.append("                </div>");
        }
        
        html.append("                <div class=\"detail-row\">");
        html.append("                    <span class=\"label\">Payment Status:</span>");
        html.append("                    <span class=\"value status-success\">").append(status != null ? status : "success").append("</span>");
        html.append("                </div>");
        
        html.append("                <div class=\"detail-row\">");
        html.append("                    <span class=\"label\">Date & Time:</span>");
        html.append("                    <span class=\"value\">").append(new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date())).append("</span>");
        html.append("                </div>");
        
        html.append("            </div>");
        
        // Action Buttons
        html.append("            <div class=\"actions\">");
        html.append("                <button onclick=\"downloadReceipt()\" class=\"btn btn-primary\">Download Receipt</button>");
        html.append("                <button onclick=\"goHome()\" class=\"btn btn-secondary\">Back to Home</button>");
        html.append("            </div>");
        
        // Additional Info
        html.append("            <div class=\"info-section\">");
        html.append("                <h4>Receipt & Confirmation</h4>");
        html.append("                <p>A confirmation email has been sent to your registered email address.</p>");
        html.append("                <p>Please save this transaction ID for future reference.</p>");
        html.append("                <div class=\"receipt-preview\">");
        html.append("                    <div class=\"receipt-header\">");
        html.append("                        <strong>Payment Receipt</strong>");
        html.append("                        <span>#").append(txnid != null ? txnid.substring(0, 8) : "N/A").append("</span>");
        html.append("                    </div>");
        html.append("                    <div class=\"receipt-body\">");
        html.append("                        <div class=\"receipt-row\">");
        html.append("                            <span>Total Amount:</span>");
        html.append("                            <strong>₹").append(amount != null ? amount : "0.00").append("</strong>");
        html.append("                        </div>");
        html.append("                        <div class=\"receipt-row\">");
        html.append("                            <span>Status:</span>");
        html.append("                            <strong style=\"color: #28a745;\">PAID</strong>");
        html.append("                        </div>");
        html.append("                    </div>");
        html.append("                </div>");
        html.append("            </div>");
        
        html.append("        </div>");
        html.append("    </div>");
        
        // JavaScript
        html.append("    <script>");
        html.append("        function downloadReceipt() {");
        html.append("            // Create receipt content");
        html.append("            const receiptContent = `");
        html.append("Payment Receipt\\n");
        html.append("================\\n");
        html.append("Transaction ID: ").append(txnid != null ? txnid : "N/A").append("\\n");
        html.append("Amount: ₹").append(amount != null ? amount : "0.00").append("\\n");
        html.append("Status: ").append(status != null ? status : "success").append("\\n");
        html.append("Date: ").append(new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date())).append("\\n");
        html.append("================\\n");
        html.append("Thank you for your payment!`;");
        html.append("            ");
        html.append("            // Create download link");
        html.append("            const blob = new Blob([receiptContent], { type: 'text/plain' });");
        html.append("            const url = window.URL.createObjectURL(blob);");
        html.append("            const a = document.createElement('a');");
        html.append("            a.href = url;");
        html.append("            a.download = 'receipt_").append(txnid != null ? txnid : "N/A").append(".txt';");
        html.append("            document.body.appendChild(a);");
        html.append("            a.click();");
        html.append("            document.body.removeChild(a);");
        html.append("            window.URL.revokeObjectURL(url);");
        html.append("        }");
        html.append("        ");
        html.append("        function goHome() {");
        html.append("            window.location.href = 'merchant-form.jsp';");
        html.append("        }");
        html.append("    </script>");
        
        html.append("</body>");
        html.append("</html>");
        
        return html.toString();
    }

    private String getSuccessPageStyles() {
        return """
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Inter', Arial, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 50%, #b8daff 100%);
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .container {
                width: 100%;
                max-width: 500px;
            }

            .success-card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(40, 167, 69, 0.15);
                padding: 40px 30px;
                text-align: center;
                border: 1px solid rgba(40, 167, 69, 0.2);
                animation: slideUp 0.6s ease-out;
            }

            @keyframes slideUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .icon-container {
                margin: 0 auto 20px;
                width: 100px;
                height: 100px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                background: rgba(40, 167, 69, 0.1);
                animation: pulse 2s infinite;
            }

            .icon-container.success {
                border: 3px solid #28a745;
            }

            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }

            .title {
                font-size: 32px;
                font-weight: 700;
                color: #28a745;
                margin-bottom: 10px;
            }

            .message {
                font-size: 16px;
                color: #6b7280;
                margin-bottom: 30px;
                line-height: 1.5;
            }

            .details-container {
                background: #f8f9fa;
                border-radius: 12px;
                padding: 20px;
                margin-bottom: 30px;
                text-align: left;
            }

            .details-container h3 {
                font-size: 18px;
                font-weight: 600;
                color: #374151;
                margin-bottom: 15px;
                text-align: center;
            }

            .detail-row {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 0;
                border-bottom: 1px solid #e5e7eb;
            }

            .detail-row:last-child {
                border-bottom: none;
            }

            .label {
                font-weight: 500;
                color: #6b7280;
                font-size: 14px;
            }

            .value {
                font-weight: 600;
                color: #111827;
                font-size: 14px;
            }

            .amount-success {
                color: #28a745 !important;
                font-weight: 700;
                font-size: 16px;
            }

            .status-success {
                color: #28a745 !important;
                font-weight: 700;
            }

            .actions {
                display: flex;
                gap: 15px;
                margin-bottom: 30px;
                justify-content: center;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 10px;
                font-size: 16px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                font-family: 'Inter', Arial, sans-serif;
            }

            .btn-primary {
                background: linear-gradient(135deg, #28a745, #218838);
                color: white;
                box-shadow: 0 4px 15px rgba(40, 167, 69, 0.3);
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #218838, #1e7e34);
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(40, 167, 69, 0.4);
            }

            .btn-secondary {
                background: #6b7280;
                color: white;
                box-shadow: 0 4px 15px rgba(107, 114, 128, 0.3);
            }

            .btn-secondary:hover {
                background: #4b5563;
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(107, 114, 128, 0.4);
            }

            .info-section {
                background: #e7f3ff;
                border: 1px solid #b3d9ff;
                border-radius: 12px;
                padding: 20px;
                text-align: left;
            }

            .info-section h4 {
                font-size: 16px;
                font-weight: 600;
                color: #004085;
                margin-bottom: 10px;
                text-align: center;
            }

            .info-section p {
                font-size: 14px;
                color: #004085;
                margin-bottom: 10px;
                line-height: 1.4;
            }

            .receipt-preview {
                background: white;
                border: 2px dashed #004085;
                border-radius: 8px;
                padding: 15px;
                margin-top: 15px;
            }

            .receipt-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 10px;
                padding-bottom: 10px;
                border-bottom: 1px solid #e5e7eb;
            }

            .receipt-header strong {
                color: #004085;
                font-size: 14px;
            }

            .receipt-header span {
                color: #6b7280;
                font-size: 12px;
                font-family: monospace;
            }

            .receipt-row {
                display: flex;
                justify-content: space-between;
                padding: 5px 0;
                font-size: 13px;
            }

            .receipt-row span {
                color: #6b7280;
            }

            .receipt-row strong {
                color: #111827;
            }

            @media (max-width: 480px) {
                .success-card {
                    padding: 30px 20px;
                }

                .title {
                    font-size: 28px;
                }

                .actions {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                }

                .receipt-header {
                    flex-direction: column;
                    gap: 5px;
                }
            }
            """;
    }
}
