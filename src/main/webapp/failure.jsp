<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String status = (String) request.getAttribute("status");
    String txnid = (String) request.getAttribute("txnid");
    String amount = (String) request.getAttribute("amount");
    String error = (String) request.getAttribute("error");
    
    if (status == null) status = "failure";
    if (txnid == null) txnid = "N/A";
    if (amount == null) amount = "0.00";
    if (error == null) error = "Payment could not be processed";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Failed</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #ff6b6b 0%, #ee5a24 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .failure-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            max-width: 420px;
            width: 100%;
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
        
        .failure-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            animation: shake 0.5s ease-in-out;
        }
        
        .failure-icon::before {
            content: "✕";
            color: white;
            font-size: 36px;
            font-weight: bold;
        }
        
        @keyframes shake {
            0%, 100% { transform: translateX(0); }
            25% { transform: translateX(-5px); }
            75% { transform: translateX(5px); }
        }
        
        h1 {
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .subtitle {
            color: #718096;
            font-size: 14px;
            margin-bottom: 30px;
        }
        
        .transaction-info {
            background: #fff5f5;
            border: 1px solid #fed7d7;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #fed7d7;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            color: #718096;
            font-size: 13px;
            font-weight: 500;
        }
        
        .info-value {
            color: #2d3748;
            font-size: 14px;
            font-weight: 600;
        }
        
        .status-failed {
            color: #e53e3e !important;
            font-weight: 700;
        }
        
        .error-box {
            background: #fffaf0;
            border: 1px solid #feb2b2;
            border-radius: 8px;
            padding: 12px;
            margin-bottom: 25px;
            font-size: 13px;
            color: #c53030;
        }
        
        .btn-group {
            display: flex;
            gap: 12px;
            margin-bottom: 20px;
        }
        
        .btn {
            flex: 1;
            padding: 12px 20px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #ff6b6b, #ee5a24);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(255, 107, 107, 0.3);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .help-section {
            background: #f7fafc;
            border-radius: 10px;
            padding: 15px;
            font-size: 12px;
            color: #4a5568;
        }
        
        .help-title {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }
        
        @media (max-width: 480px) {
            .failure-card {
                padding: 30px 20px;
            }
            
            h1 {
                font-size: 24px;
            }
            
            .btn-group {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<div class="failure-card">
    <div class="failure-icon"></div>
    <h1>Payment Failed</h1>
    <p class="subtitle">We couldn't process your payment</p>
    
    <div class="transaction-info">
        <div class="info-row">
            <span class="info-label">Transaction ID</span>
            <span class="info-value"><%= txnid %></span>
        </div>
        <% if (amount != null && !amount.equals("0.00")) { %>
        <div class="info-row">
            <span class="info-label">Amount</span>
            <span class="info-value">₹<%= amount %></span>
        </div>
        <% } %>
        <div class="info-row">
            <span class="info-label">Status</span>
            <span class="info-value status-failed"><%= status %></span>
        </div>
    </div>
    
    <% if (error != null && !error.equals("Payment could not be processed")) { %>
    <div class="error-box">
        <strong>Error:</strong> <%= error %>
    </div>
    <% } %>
    
    <div class="btn-group">
        <button onclick="window.location='merchant-form.jsp'" class="btn btn-primary">🔄 Try Again</button>
        <button onclick="window.location='merchant-form.jsp'" class="btn btn-secondary">🏠 Home</button>
    </div>
    
    <div class="help-section">
        <div class="help-title">💡 Need Help?</div>
        <div>Contact support with your transaction ID</div>
        <div>📧 support@easebuzz.com | 📞 1800-123-4567</div>
    </div>
</div>

</body>
</html>
