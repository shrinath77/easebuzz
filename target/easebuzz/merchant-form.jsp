<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<!DOCTYPE html>
<html>
<head>
<title>Merchant Transaction Form</title>
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Inter', Arial, sans-serif;
}

body {
    background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 50%, #90caf9 100%);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 30px 15px;
    position: relative;
    overflow: hidden;
}

.page-wrapper {
    display: flex;
    width: 950px;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(33,150,243,0.15), 0 4px 12px rgba(33,150,243,0.08);
    background: #fff;
    border: 1px solid rgba(33,150,243,0.2);
    animation: slideUp 0.6s ease-out;
}

/* LEFT BRANDING PANEL */
.side-panel {
    width: 300px;
    background: linear-gradient(160deg, #2196f3 0%, #1976d2 40%, #1565c0 100%);
    color: #fff;
    padding: 40px 30px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
    overflow: hidden;
    flex-shrink: 0;
}

.side-panel::before {
    content: '';
    position: absolute;
    top: -60px; right: -60px;
    width: 200px; height: 200px;
    border-radius: 50%;
    background: rgba(255,255,255,0.05);
}

.side-panel::after {
    content: '';
    position: absolute;
    bottom: -40px; left: -40px;
    width: 150px; height: 150px;
    border-radius: 50%;
    background: rgba(255,255,255,0.04);
}

.side-brand {
    display: flex;
    align-items: center;
    gap: 12px;
    position: relative;
    z-index: 1;
}

.side-brand img {
    width: 50px; height: 50px;
    border-radius: 12px;
    border: 2px solid rgba(255,255,255,0.2);
    padding: 3px;
    background: rgba(255,255,255,0.1);
}

.side-brand-text h2 {
    font-size: 18px;
    font-weight: 700;
    letter-spacing: -0.3px;
}

.side-brand-text p {
    font-size: 11px;
    opacity: 0.8;
    text-transform: uppercase;
    letter-spacing: 0.5px;
    margin-top: 2px;
}

.side-info {
    position: relative;
    z-index: 1;
    margin-top: 35px;
}

.side-info h3 {
    font-size: 22px;
    font-weight: 700;
    line-height: 1.3;
    margin-bottom: 12px;
}

.side-info p {
    font-size: 13px;
    opacity: 0.85;
    line-height: 1.6;
}

.side-features {
    position: relative;
    z-index: 1;
    margin-top: 30px;
}

.side-feature {
    display: flex;
    align-items: center;
    gap: 10px;
    padding: 10px 0;
    font-size: 13px;
    font-weight: 500;
    opacity: 0.9;
}

.side-feature span.icon {
    font-size: 18px;
    width: 24px;
    text-align: center;
}

.side-footer {
    position: relative;
    z-index: 1;
    font-size: 12px;
    opacity: 0.7;
    letter-spacing: 0.3px;
}

/* FORM PANEL */
.form-panel {
    flex: 1;
    padding: 35px 40px;
    overflow-y: auto;
    max-height: 90vh;
}

.form-panel::-webkit-scrollbar {
    width: 6px;
}

.form-panel::-webkit-scrollbar-thumb {
    background: #ccc;
    border-radius: 10px;
}

.form-header {
    margin-bottom: 25px;
}

.form-header h2 {
    font-size: 22px;
    font-weight: 700;
    color: #1a1a2e;
    letter-spacing: -0.3px;
}

.form-header p {
    font-size: 13px;
    color: #888;
    margin-top: 4px;
}

/* SECTION GROUPS */
.form-section {
    margin-bottom: 22px;
}

.section-title {
    font-size: 13px;
    font-weight: 700;
    color: #1976d2;
    text-transform: uppercase;
    letter-spacing: 0.8px;
    margin-bottom: 12px;
    padding-bottom: 6px;
    border-bottom: 2px solid #e3f2fd;
    display: flex;
    align-items: center;
    gap: 6px;
}

.form-row {
    display: flex;
    gap: 16px;
    margin-bottom: 0;
}

.form-group {
    flex: 1;
    margin-bottom: 14px;
}

label {
    font-weight: 600;
    display: block;
    margin-bottom: 5px;
    font-size: 13px;
    color: #444;
}

.required {
    color: #e53935;
    margin-left: 2px;
}

input, select {
    width: 100%;
    padding: 11px 14px;
    border-radius: 10px;
    border: 1.5px solid #e0e0e0;
    font-size: 14px;
    font-family: 'Inter', Arial, sans-serif;
    transition: all 0.25s ease;
    background: #fafbfc;
    color: #333;
}

input:focus, select:focus {
    outline: none;
    border-color: #1976d2;
    box-shadow: 0 0 0 3px rgba(33,150,243,0.15);
    background: #fff;
}

input::placeholder {
    color: #aaa;
    font-weight: 400;
}

/* UDF GRID */
.udf-grid {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 12px;
}

.udf-grid .form-group {
    margin-bottom: 0;
}

/* SUBMIT BUTTON */
.btn {
    margin-top: 8px;
    background: linear-gradient(135deg, #2196f3, #1976d2);
    color: white;
    border: none;
    padding: 15px;
    width: 100%;
    font-size: 16px;
    font-weight: 700;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    letter-spacing: 0.3px;
    box-shadow: 0 4px 15px rgba(33,150,243,0.3);
    font-family: 'Inter', Arial, sans-serif;
}

.btn:hover {
    background: linear-gradient(135deg, #1976d2, #1565c0);
    box-shadow: 0 6px 20px rgba(33,150,243,0.4);
    transform: translateY(-1px);
}

.btn:active {
    transform: translateY(0);
    box-shadow: 0 2px 8px rgba(33,150,243,0.3);
}
</style>
</head>
<body>

<div class="page-wrapper">

    <!-- LEFT BRANDING PANEL -->
    <div class="side-panel">
        <div>
            <div class="side-brand">
                <img src="images/splogo.png" alt="SP Logo">
                <div class="side-brand-text">
                    <h2>SP Transaction Hub</h2>
                    <p>Secure Payments</p>
                </div>
            </div>

            <div class="side-info">
                <h3>Start a New Transaction</h3>
                <p>Fill in the merchant and customer details to initiate a secure payment.</p>
            </div>

            <div class="side-features">
                <div class="side-feature"><span class="icon">🔒</span> AES-256 Encrypted</div>
                <div class="side-feature"><span class="icon">⚡</span> Instant Processing</div>
                <div class="side-feature"><span class="icon">🛡️</span> PCI DSS Compliant</div>
                <div class="side-feature"><span class="icon">📊</span> Real-time Tracking</div>
            </div>
        </div>

        <div class="side-footer">🔒 Secured by SP Transaction Hub</div>
    </div>

    <!-- FORM PANEL -->
    <div class="form-panel">
        <div class="form-header">
            <h2>Merchant Transaction Form</h2>
            <p>Fields marked with <span style="color:#e53935;">*</span> are required</p>
        </div>

        <form action="PaymentProcess" method="post">

            <!-- MERCHANT DETAILS -->
            <div class="form-section">
                <div class="section-title">🏢 Merchant Details</div>
                <div class="form-group">
                    <label>Merchant ID <span class="required">*</span></label>
                    <input type="text" name="merchantId" placeholder="Enter merchant ID" required>
                </div>
                <div class="form-group">
                    <label>Merchant Transaction ID <span class="required">*</span></label>
                    <input type="text" name="merchantTxnId" placeholder="Unique transaction identifier" required>
                </div>
            </div>

            <!-- PAYMENT DETAILS -->
            <div class="form-section">
                <div class="section-title">💰 Payment Details</div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Amount (₹) <span class="required">*</span></label>
                        <input type="number" name="amount" placeholder="e.g. 1500.00"
                               step="0.01" min="1" required
                               oninput="this.value = this.value.replace(/[^0-9.]/g, '')">
                    </div>
                    <div class="form-group">
                                                                    </div>
                </div>
            </div>

            <!-- CUSTOMER DETAILS -->
            <div class="form-section">
                <div class="section-title">👤 Customer Details</div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Customer Email <span class="required">*</span></label>
                        <input type="email" name="customerEmail" placeholder="customer@email.com" required>
                    </div>
                    <div class="form-group">
                        <label>Customer Mobile <span class="required">*</span></label>
                        <input type="text" name="customerMobile" placeholder="10-digit number" maxlength="10"
                               oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    </div>
                </div>
            </div>

            <!-- UDF FIELDS -->
            <div class="form-section">
                <div class="section-title">📝 Custom Fields (Optional)</div>
                <div class="udf-grid">
                    <div class="form-group"><label>UDF 1</label><input type="text" name="udf1" placeholder="—"></div>
                    <div class="form-group"><label>UDF 2</label><input type="text" name="udf2" placeholder="—"></div>
                    <div class="form-group"><label>UDF 3</label><input type="text" name="udf3" placeholder="—"></div>
                    <div class="form-group"><label>UDF 4</label><input type="text" name="udf4" placeholder="—"></div>
                    <div class="form-group"><label>UDF 5</label><input type="text" name="udf5" placeholder="—"></div>
                    <div class="form-group"><label>UDF 6</label><input type="text" name="udf6" placeholder="—"></div>
                </div>
            </div>

            <!-- CONFIGURATION -->
            <div class="form-section">
                <div class="section-title">⚙️ Configuration</div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Account Type</label>
                        <select name="accountType">
                            <option value="SAVINGS">Savings</option>
                            <option value="CURRENT">Current</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Transaction Type</label>
                        <select name="txType">
                            <option value="SALE">Sale</option>
                        </select>
                    </div>
                </div>
                <div class="form-group">
                    <label>Merchant Return URL</label>
                    <input type="url" name="returnUrl" placeholder="https://yoursite.com/callback">
                </div>
                <div class="form-group">
                    <label>Merchant Push URL</label>
                    <input type="url" name="pushUrl" placeholder="https://yoursite.com/webhook">
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label>Reseller ID</label>
                        <input type="text" name="resellerId" placeholder="Optional">
                    </div>
                    <div class="form-group">
                        <label>Reseller Mobile</label>
                        <input type="text" name="resellerMobile" placeholder="Optional">
                    </div>
                </div>
            </div>

            <!-- SUBMIT -->
            <button type="submit" class="btn">🔒 Submit Transaction</button>

        </form>
    </div>

</div>

</body>
</html>