package com.easybuzz.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/failure")
public class PaymentFailure extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String status = request.getParameter("status");
        String txnid = request.getParameter("txnid");
        String amount = request.getParameter("amount");
        String error = request.getParameter("error");

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println(generateFailurePage(txnid, status, amount, error));
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        doPost(request, response);
    }

    private String generateFailurePage(String txnid, String status, String amount, String error) {
        StringBuilder html = new StringBuilder();
        
        html.append("<!DOCTYPE html>");
        html.append("<html lang=\"en\">");
        html.append("<head>");
        html.append("    <meta charset=\"UTF-8\">");
        html.append("    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">");
        html.append("    <title>Payment Failed - EaseBuzz</title>");
        html.append("    <link href=\"https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap\" rel=\"stylesheet\">");
        html.append("    <style>");
        html.append(getFailurePageStyles());
        html.append("    </style>");
        html.append("</head>");
        html.append("<body>");
        
        html.append("    <div class=\"container\">");
        html.append("        <div class=\"failure-card\">");
        
        // Failure Icon
        html.append("            <div class=\"icon-container failure\">");
        html.append("                <svg width=\"80\" height=\"80\" viewBox=\"0 0 24 24\" fill=\"none\">");
        html.append("                    <circle cx=\"12\" cy=\"12\" r=\"10\" stroke=\"#dc3545\" stroke-width=\"2\"/>");
        html.append("                    <path d=\"M15 9l-6 6M9 9l6 6\" stroke=\"#dc3545\" stroke-width=\"2\" stroke-linecap=\"round\"/>");
        html.append("                </svg>");
        html.append("            </div>");
        
        // Failure Message
        html.append("            <h1 class=\"title\">Payment Failed</h1>");
        html.append("            <p class=\"message\">We're sorry, but your payment could not be processed.</p>");
        
        // Transaction Details
        html.append("            <div class=\"details-container\">");
        html.append("                <h3>Transaction Details</h3>");
        html.append("                <div class=\"detail-row\">");
        html.append("                    <span class=\"label\">Transaction ID:</span>");
        html.append("                    <span class=\"value\">").append(txnid != null ? txnid : "N/A").append("</span>");
        html.append("                </div>");
        
        if (amount != null) {
            html.append("                <div class=\"detail-row\">");
            html.append("                    <span class=\"label\">Amount:</span>");
            html.append("                    <span class=\"value\">₹").append(amount).append("</span>");
            html.append("                </div>");
        }
        
        html.append("                <div class=\"detail-row\">");
        html.append("                    <span class=\"label\">Status:</span>");
        html.append("                    <span class=\"value status-failure\">").append(status != null ? status : "failure").append("</span>");
        html.append("                </div>");
        
        if (error != null && !error.isEmpty()) {
            html.append("                <div class=\"detail-row\">");
            html.append("                    <span class=\"label\">Error:</span>");
            html.append("                    <span class=\"value error-message\">").append(error).append("</span>");
            html.append("                </div>");
        }
        
        html.append("            </div>");
        
        // Action Buttons
        html.append("            <div class=\"actions\">");
        html.append("                <button onclick=\"retryPayment()\" class=\"btn btn-primary\">Try Again</button>");
        html.append("                <button onclick=\"goHome()\" class=\"btn btn-secondary\">Back to Home</button>");
        html.append("            </div>");
        
        // Help Section
        html.append("            <div class=\"help-section\">");
        html.append("                <h4>Need Help?</h4>");
        html.append("                <p>If you were charged, please contact our support team with your transaction ID.</p>");
        html.append("                <div class=\"contact-info\">");
        html.append("                    <p><strong>Email:</strong> support@easebuzz.com</p>");
        html.append("                    <p><strong>Phone:</strong> 1800-123-4567</p>");
        html.append("                </div>");
        html.append("            </div>");
        
        html.append("        </div>");
        html.append("    </div>");
        
        // JavaScript
        html.append("    <script>");
        html.append("        function retryPayment() {");
        html.append("            window.location.href = 'merchant-form.jsp';");
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

    private String getFailurePageStyles() {
        return """
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Inter', Arial, sans-serif;
            }

            body {
                background: linear-gradient(135deg, #fee2e2 0%, #fecaca 50%, #fca5a5 100%);
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

            .failure-card {
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 60px rgba(220, 53, 69, 0.15);
                padding: 40px 30px;
                text-align: center;
                border: 1px solid rgba(220, 53, 69, 0.2);
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
                background: rgba(220, 53, 69, 0.1);
                animation: pulse 2s infinite;
            }

            .icon-container.failure {
                border: 3px solid #dc3545;
            }

            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }

            .title {
                font-size: 32px;
                font-weight: 700;
                color: #dc3545;
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

            .status-failure {
                color: #dc3545 !important;
                font-weight: 700;
            }

            .error-message {
                color: #dc3545 !important;
                font-size: 13px;
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
                background: linear-gradient(135deg, #dc3545, #c82333);
                color: white;
                box-shadow: 0 4px 15px rgba(220, 53, 69, 0.3);
            }

            .btn-primary:hover {
                background: linear-gradient(135deg, #c82333, #bd2130);
                transform: translateY(-1px);
                box-shadow: 0 6px 20px rgba(220, 53, 69, 0.4);
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

            .help-section {
                background: #fff3cd;
                border: 1px solid #ffeaa7;
                border-radius: 12px;
                padding: 20px;
                text-align: left;
            }

            .help-section h4 {
                font-size: 16px;
                font-weight: 600;
                color: #856404;
                margin-bottom: 10px;
                text-align: center;
            }

            .help-section p {
                font-size: 14px;
                color: #856404;
                margin-bottom: 15px;
                line-height: 1.4;
            }

            .contact-info p {
                font-size: 13px;
                margin-bottom: 5px;
            }

            .contact-info strong {
                color: #856404;
            }

            @media (max-width: 480px) {
                .failure-card {
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
            }
            """;
    }
}
