<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String status = (String) request.getAttribute("status");
    String txnid = (String) request.getAttribute("txnid");
    String amount = (String) request.getAttribute("amount");
    String productinfo = (String) request.getAttribute("productinfo");
    String firstname = (String) request.getAttribute("firstname");
    
    if (status == null) status = "success";
    if (txnid == null) txnid = "N/A";
    if (amount == null) amount = "0.00";
    if (productinfo == null) productinfo = "N/A";
    if (firstname == null) firstname = "Customer";
%>

<!DOCTYPE html>
<html>
<head>
    <title>Payment Success</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Poppins', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .success-card {
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
        
        .success-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #00d2ff, #3a7bd5);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            animation: pulse 2s infinite;
        }
        
        .success-icon::before {
            content: "✓";
            color: white;
            font-size: 36px;
            font-weight: bold;
        }
        
        @keyframes pulse {
            0% { transform: scale(1); }
            50% { transform: scale(1.05); }
            100% { transform: scale(1); }
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
            background: #f7fafc;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #e2e8f0;
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
        
        .amount {
            color: #38a169 !important;
            font-size: 16px;
            font-weight: 700;
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
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        
        .btn-secondary {
            background: #e2e8f0;
            color: #4a5568;
        }
        
        .btn-secondary:hover {
            background: #cbd5e0;
        }
        
        .receipt-preview {
            background: linear-gradient(135deg, #f6f9fc, #e9ecef);
            border-radius: 10px;
            padding: 15px;
            font-size: 12px;
            color: #4a5568;
            margin-bottom: 20px;
        }
        
        .receipt-header {
            font-weight: 600;
            color: #2d3748;
            margin-bottom: 8px;
        }
        
        @media (max-width: 480px) {
            .success-card {
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

<div class="success-card">
    <div class="success-icon"></div>
    <h1>Payment Successful!</h1>
    <p class="subtitle">Thank you for your payment</p>
    
    <div class="transaction-info">
        <div class="info-row">
            <span class="info-label">Transaction ID</span>
            <span class="info-value"><%= txnid %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Amount</span>
            <span class="info-value amount">₹<%= amount %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Product</span>
            <span class="info-value"><%= productinfo %></span>
        </div>
        <div class="info-row">
            <span class="info-label">Customer</span>
            <span class="info-value"><%= firstname %></span>
        </div>
    </div>
    
    <div class="receipt-preview">
        <div class="receipt-header">🧾 Receipt #<%= txnid.substring(0, 8) %></div>
        <div>Amount: ₹<%= amount %> | Status: PAID | <%= new java.text.SimpleDateFormat("dd MMM yyyy").format(new java.util.Date()) %></div>
    </div>
    
    <div class="btn-group">
        <button onclick="downloadReceipt()" class="btn btn-primary">📄 Receipt</button>
        <button onclick="window.location='merchant-form.jsp'" class="btn btn-secondary">Home</button>
    </div>
</div>

<script>
function downloadReceipt() {
    const receipt = `Payment Receipt\n================\nID: <%= txnid %>\nAmount: ₹<%= amount %>\nStatus: <%= status %>\nDate: <%= new java.text.SimpleDateFormat("dd MMM yyyy, hh:mm a").format(new java.util.Date()) %>\n================`;
    
    const blob = new Blob([receipt], { type: 'text/plain' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = 'receipt_<%= txnid %>.txt';
    a.click();
    URL.revokeObjectURL(url);
}
</script>

</body>
</html>
