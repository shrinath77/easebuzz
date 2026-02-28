<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    // Read amount from session (set by PaymentProcess); default to 0.00 for direct access
    String sessionAmt = (String) session.getAttribute("amount");
    double amtVal = 0.00;
    try { amtVal = Double.parseDouble(sessionAmt); } catch (Exception ignored) {}
    String amount    = String.format("%.2f", amtVal);
    String amt3mo    = String.format("%.2f", amtVal / 3);
    String amt6mo    = String.format("%.2f", amtVal / 6);
    String amt12mo   = String.format("%.2f", amtVal / 12);
%>
<!DOCTYPE html>
<html>
<head>
    <link rel="icon" type="image/png"
          href="<%=request.getContextPath()%>/images/splogo.png" sizes="32x32">
    <title>SP Transaction Hub - Trusted Business</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<style>
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Inter', Arial, sans-serif;
}

body {
    background: linear-gradient(135deg, #e8ecf1 0%, #f4f6f8 50%, #e0e7ee 100%);
    min-height: 100vh;
    display: flex;
    align-items: center;
    justify-content: center;
}

.checkout-wrapper {
    width: 1020px;
    min-height: 600px;
    margin: 30px auto;
    display: flex;
    border-radius: 20px;
    overflow: hidden;
    box-shadow: 0 20px 60px rgba(0, 0, 0, 0.12), 0 4px 12px rgba(0,0,0,0.06);
    background: #fff;
    border: 1px solid rgba(255,255,255,0.6);
}

/* LEFT PANEL */
.left-panel {
    width: 35%;
    background: linear-gradient(160deg, #1a8d5a 0%, #145e3c 40%, #0a2e1d 100%);
    color: white;
    padding: 35px 30px;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    position: relative;
    overflow: hidden;
}

.left-panel::before {
    content: '';
    position: absolute;
    top: -60px; right: -60px;
    width: 200px; height: 200px;
    border-radius: 50%;
    background: rgba(255,255,255,0.05);
}

.left-panel::after {
    content: '';
    position: absolute;
    bottom: -40px; left: -40px;
    width: 150px; height: 150px;
    border-radius: 50%;
    background: rgba(255,255,255,0.04);
}

.brand {
    display: flex;
    flex-direction: row;
    align-items: center;
    gap: 12px;
    position: relative;
    z-index: 1;
}

.brand img.brand-logo {
    width: 55px;
    height: 55px;
    object-fit: contain;
    border-radius: 12px;
    flex-shrink: 0;
    border: 2px solid rgba(255,255,255,0.2);
    padding: 3px;
    background: rgba(255,255,255,0.1);
}

.brand-text h2 {
    font-size: 20px;
    font-weight: 700;
    line-height: 1.2;
    letter-spacing: -0.3px;
}

.brand-text p {
    font-size: 11px;
    opacity: 0.8;
    margin-top: 3px;
    font-weight: 500;
    letter-spacing: 0.5px;
    text-transform: uppercase;
}

.price-box {
    background: rgba(255, 255, 255, 0.12);
    backdrop-filter: blur(10px);
    padding: 22px;
    border-radius: 16px;
    margin-top: 25px;
    border: 1px solid rgba(255,255,255,0.1);
    position: relative;
    z-index: 1;
}

.price-box p {
    font-size: 13px;
    opacity: 0.85;
    font-weight: 500;
    text-transform: uppercase;
    letter-spacing: 0.8px;
}

.price-box h1 {
    margin-top: 8px;
    font-size: 40px;
    font-weight: 700;
    letter-spacing: -1px;
}

.user {
    margin-top: 20px;
    background: rgba(255, 255, 255, 0.08);
    padding: 12px;
    border-radius: 10px;
    font-size: 13px;
}

.secured {
    font-size: 12px;
    opacity: 0.8;
    font-weight: 500;
    position: relative;
    z-index: 1;
    letter-spacing: 0.3px;
}

/* RIGHT PANEL */
.right-panel {
    width: 65%;
    padding: 28px 30px;
    background: #ffffff;
}

.header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding-bottom: 5px;
}

.header h3 {
    font-size: 21px;
    font-weight: 700;
    color: #1a1a2e;
    letter-spacing: -0.3px;
}

.timer {
    font-weight: 600;
    color: #fff;
    font-size: 13px;
    background: linear-gradient(135deg, #e53935, #c62828);
    padding: 6px 14px;
    border-radius: 20px;
    letter-spacing: 0.5px;
    box-shadow: 0 2px 8px rgba(229,57,53,0.3);
}

/* PAYMENT LAYOUT */
.payment-container {
    display: flex;
    margin-top: 18px;
    height: 470px;
    border-top: 2px solid #f0f0f0;
    border-radius: 0 0 12px 12px;
}

.methods {
    width: 35%;
    border-right: 2px solid #f0f0f0;
    background: linear-gradient(180deg, #f8f9fb, #f2f4f7);
}

.method {
    padding: 15px 18px;
    cursor: pointer;
    border-bottom: 1px solid #eaedf1;
    font-weight: 600;
    font-size: 13.5px;
    color: #444;
    transition: all 0.25s ease;
    display: flex;
    align-items: center;
    gap: 10px;
    position: relative;
}

.method:hover {
    background: #edf2fb;
    color: #1a73e8;
    padding-left: 22px;
}

.method.active {
    background: linear-gradient(90deg, #e3edf7, #f0f4ff);
    font-weight: 700;
    color: #1a73e8;
    border-left: 3px solid #1a73e8;
}

.method .method-icon {
    font-size: 18px;
    width: 22px;
    text-align: center;
}

.details {
    width: 65%;
    padding: 22px 25px;
    overflow-y: auto;
}

.details input, .details select {
    width: 100%;
    padding: 12px 14px;
    margin-top: 12px;
    border: 1.5px solid #e0e0e0;
    border-radius: 10px;
    font-size: 14px;
    font-family: 'Inter', Arial, sans-serif;
    transition: all 0.25s ease;
    background: #fafbfc;
    color: #333;
}

.details input:focus, .details select:focus {
    outline: none;
    border-color: #1a73e8;
    box-shadow: 0 0 0 3px rgba(26,115,232,0.12);
    background: #fff;
}

.details input::placeholder {
    color: #aaa;
    font-weight: 400;
}

.qr-box {
    text-align: center;
}

.qr-box h4 {
    color: #2c3e50;
    font-size: 15px;
    font-weight: 600;
}

.qr-box img.qr {
    margin-top: 14px;
    border: 2px solid #eef2f7;
    padding: 10px;
    border-radius: 14px;
    box-shadow: 0 4px 15px rgba(0,0,0,0.06);
    transition: transform 0.3s ease;
}

.qr-box img.qr:hover {
    transform: scale(1.03);
}

/* UPI Logos */
.upi-logos {
    display: flex;
    justify-content: center;
    gap: 14px;
    margin-top: 18px;
}

.upi-logos img {
    width: 48px;
    height: 48px;
    object-fit: contain;
    border-radius: 12px;
    background: #fff;
    padding: 6px;
    border: 1.5px solid #e8e8e8;
    transition: all 0.25s ease;
    cursor: pointer;
}

.upi-logos img:hover {
    transform: translateY(-3px);
    box-shadow: 0 4px 12px rgba(0,0,0,0.1);
    border-color: #1a73e8;
}

/* Card Logos */
.card-logos {
    display: flex;
    gap: 10px;
    margin-bottom: 15px;
    align-items: center;
}

.card-logos img {
    width: 140px;
    height: 80px;
    object-fit: contain;
    transition: transform 0.2s ease;
}

.card-logos img:hover {
    transform: scale(1.05);
}

/* ===================== BNPL STYLES ===================== */
.bnpl-header {
    text-align: center;
    margin-bottom: 14px;
}

.bnpl-header h4 {
    font-size: 15px;
    color: #1a1a2e;
    font-weight: 700;
}

.bnpl-header p {
    font-size: 12px;
    color: #888;
    margin-top: 4px;
}

.bnpl-providers {
    display: flex;
    flex-wrap: wrap;
    gap: 8px;
    justify-content: center;
    margin-bottom: 12px;
}

.bnpl-provider-btn {
    border: 2px solid #e0e0e0;
    border-radius: 12px;
    padding: 8px 16px;
    cursor: pointer;
    font-size: 13px;
    font-weight: 600;
    background: #fff;
    transition: all 0.25s ease;
    color: #444;
    min-width: 90px;
    text-align: center;
}

.bnpl-provider-btn:hover {
    border-color: #1a73e8;
    color: #1a73e8;
    background: #f0f6ff;
    transform: translateY(-2px);
    box-shadow: 0 3px 10px rgba(26,115,232,0.1);
}

.bnpl-provider-btn.selected {
    border-color: #1a73e8;
    background: #e8f0fe;
    color: #1a73e8;
    box-shadow: 0 2px 8px rgba(26,115,232,0.15);
}

.bnpl-emi-box {
    background: linear-gradient(135deg, #f8f9fb, #f2f4f7);
    border: 1.5px solid #eaedf1;
    border-radius: 14px;
    padding: 14px 16px;
    margin-top: 12px;
    font-size: 13px;
    color: #444;
}

.bnpl-emi-box p {
    margin-bottom: 8px;
    font-weight: 700;
    color: #1a1a2e;
}

.bnpl-emi-options {
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
    margin-top: 6px;
}

.emi-option {
    border: 1.5px solid #ddd;
    border-radius: 10px;
    padding: 8px 12px;
    cursor: pointer;
    font-size: 12px;
    background: #fff;
    transition: all 0.25s ease;
    text-align: center;
    min-width: 75px;
}

.emi-option:hover {
    border-color: #1a73e8;
    color: #1a73e8;
    transform: translateY(-2px);
}

.emi-option.selected {
    border-color: #1a73e8;
    background: linear-gradient(135deg, #e8f0fe, #dce7fc);
    color: #1a73e8;
    font-weight: 700;
    box-shadow: 0 2px 8px rgba(26,115,232,0.12);
}
/* ====================================================== */

.pay-btn {
    width: 100%;
    margin-top: 22px;
    padding: 15px;
    background: linear-gradient(135deg, #1a8d5a, #145e3c);
    border: none;
    color: white;
    font-size: 16px;
    font-weight: 700;
    border-radius: 12px;
    cursor: pointer;
    transition: all 0.3s ease;
    letter-spacing: 0.3px;
    box-shadow: 0 4px 15px rgba(26,141,90,0.3);
    font-family: 'Inter', Arial, sans-serif;
}

.pay-btn:hover {
    background: linear-gradient(135deg, #157a4e, #0d4f30);
    box-shadow: 0 6px 20px rgba(26,141,90,0.4);
    transform: translateY(-1px);
}

.pay-btn:active {
    transform: translateY(0);
    box-shadow: 0 2px 8px rgba(26,141,90,0.3);
}

.pay-btn:disabled {
    background: linear-gradient(135deg, #bbb, #999);
    cursor: not-allowed;
    box-shadow: none;
    transform: none;
}

#msg {
    margin-top: 18px;
    font-weight: 600;
    text-align: center;
    font-size: 14px;
}

/* ===================== SUCCESS POPUP ===================== */
.popup-overlay {
    display: none;
    position: fixed;
    top: 0; left: 0;
    width: 100%; height: 100%;
    background: rgba(0,0,0,0.5);
    z-index: 9999;
    justify-content: center;
    align-items: center;
}
.popup-overlay.show {
    display: flex;
}
.popup-box {
    background: #fff;
    border-radius: 16px;
    padding: 40px 50px;
    text-align: center;
    box-shadow: 0 20px 60px rgba(0,0,0,0.3);
    animation: popIn 0.4s ease;
    max-width: 400px;
    width: 90%;
}
@keyframes popIn {
    0%   { transform: scale(0.5); opacity: 0; }
    100% { transform: scale(1);   opacity: 1; }
}

/* Animated Tick */
.tick-circle {
    width: 80px; height: 80px;
    border-radius: 50%;
    background: #4CAF50;
    margin: 0 auto 20px;
    display: flex;
    justify-content: center;
    align-items: center;
    animation: circleIn 0.4s ease;
}
@keyframes circleIn {
    0%   { transform: scale(0); }
    60%  { transform: scale(1.15); }
    100% { transform: scale(1); }
}
.tick-circle svg {
    stroke-dasharray: 50;
    stroke-dashoffset: 50;
    animation: drawTick 0.5s ease 0.3s forwards;
}
@keyframes drawTick {
    to { stroke-dashoffset: 0; }
}

.popup-box h2 {
    color: #2c3e50;
    font-size: 22px;
    margin-bottom: 8px;
}
.popup-box .popup-msg {
    color: #555;
    font-size: 14px;
    margin-bottom: 6px;
}
.popup-box .popup-txn {
    color: #888;
    font-size: 13px;
    margin-bottom: 22px;
}
.popup-close-btn {
    padding: 12px 40px;
    background: #4CAF50;
    color: #fff;
    border: none;
    border-radius: 8px;
    font-size: 15px;
    cursor: pointer;
    transition: 0.2s;
}
.popup-close-btn:hover {
    background: #388E3C;
}
/* ========================================================= */
</style>
</head>

<body>

<div class="checkout-wrapper">

    <!-- LEFT SIDE -->
    <div class="left-panel">
        <div>
            <div class="brand">
                <img class="brand-logo" src="images/splogo.png" alt="SP Logo">
                <div class="brand-text">
                    <h2>SP Transaction Hub</h2>
                    <p>Secure Payments</p>
                </div>
            </div>

            <div class="price-box">
                <p>Price Summary</p>
                <h1>₹<%= amount %></h1>
            </div>

            <div class="user" style="margin-top:18px;">
                <div style="display:flex; align-items:center; gap:8px; margin-bottom:6px;">
                    <span style="font-size:16px;">🛒</span>
                    <span style="font-weight:600;">Order Details</span>
                </div>
                <div style="font-size:12px; opacity:0.8; line-height:1.6;">
                    <div style="display:flex; justify-content:space-between;">
                        <span>Subtotal</span><span>₹<%= amount %></span>
                    </div>
                    <div style="display:flex; justify-content:space-between;">
                        <span>Tax & Fees</span><span>₹0.00</span>
                    </div>
                    <div style="border-top:1px solid rgba(255,255,255,0.15); margin-top:6px; padding-top:6px; display:flex; justify-content:space-between; font-weight:700; font-size:13px;">
                        <span>Total</span><span>₹<%= amount %></span>
                    </div>
                </div>
            </div>
        </div>

        <div class="secured">🔒 Secured by SP Transaction Hub</div>
    </div>

    <!-- RIGHT SIDE -->
    <div class="right-panel">
        <div class="header">
            <h3>Payment Options</h3>
            <div class="timer">
                ⏳ Time Left: <span id="countdown">05:00</span>
            </div>
        </div>

        <div class="payment-container">

            <!-- METHODS -->
            <div class="methods">
                <div class="method active" onclick="selectMethod('upi', this)"><span class="method-icon">📱</span> UPI (QR)</div>
                <div class="method" onclick="selectMethod('card', this)"><span class="method-icon">💳</span> Cards</div>
                <div class="method" onclick="selectMethod('netbanking', this)"><span class="method-icon">🏦</span> Netbanking</div>
                <div class="method" onclick="selectMethod('wallet', this)"><span class="method-icon">👛</span> Wallet</div>
                <div class="method" onclick="selectMethod('bnpl', this)">
                    <span class="method-icon">🛍️</span>
                    <div>Buy Now Pay Later
                        <div style="font-size: 10px; color: #888; font-weight: normal; margin-top: 2px;">EMI / No-Cost</div>
                    </div>
                </div>
            </div>

            <!-- DETAILS -->
            <div class="details">

                <!-- UPI SECTION -->
                <div id="upiSection">
                    <div class="qr-box">
                        <h4>Scan QR to Pay</h4>
                        <img class="qr"
                            src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=SPTransactionHubPayment" />
                        <p style="margin-top: 12px; color: #666; font-size: 13px;">Scan with any UPI App</p>
                        <div class="upi-logos">
                            <img src="images/googlepay.png" alt="GPay">
                            <img src="images/Phonepay.png" alt="PhonePe">
                            <img src="images/Paytm.png" alt="Paytm">
                        </div>
                    </div>
                </div>

                <!-- CARD SECTION -->
                <div id="cardSection" style="display: none;">
                    <div class="card-logos">
                        <img src="images/Visa.png" alt="Visa">
                        <img src="images/Mastercard.png" alt="Mastercard">
                        <img src="images/Rupay.png" alt="RuPay">
                    </div>
                    <input type="text"     id="cardNumber" placeholder="Card Number"      maxlength="19">
                    <input type="text"     id="cardName"   placeholder="Card Holder Name">
                    <input type="text"     id="cardExpiry" placeholder="MM/YY"            maxlength="5">
                    <input type="password" id="cvv"        placeholder="CVV"              maxlength="3">
                </div>

                <!-- NETBANKING SECTION -->
                <div id="netbankingSection" style="display: none;">
                    <select id="bank">
                        <option value="">Select Bank</option>
                        <option value="HDFC">HDFC Bank</option>
                        <option value="SBI">SBI</option>
                        <option value="ICICI">ICICI Bank</option>
                        <option value="AXIS">Axis Bank</option>
                    </select>
                </div>

                <!-- WALLET SECTION -->
                <div id="walletSection" style="display: none;">
                    <select id="wallet">
                        <option value="">Select Wallet</option>
                        <option value="paytm">Paytm Wallet</option>
                        <option value="amazonpay">Amazon Pay</option>
                        <option value="mobikwik">MobiKwik</option>
                        <option value="freecharge">FreeCharge</option>
                    </select>
                    <input type="text" id="walletMobile" placeholder="Registered Mobile Number" maxlength="10">
                </div>

                <!-- BNPL SECTION -->
                <div id="bnplSection" style="display: none;">

                    <div class="bnpl-header">
                        <h4>Buy Now, Pay Later</h4>
                        <p>Select a provider and choose your EMI plan</p>
                    </div>

                    <!-- Provider Buttons -->
                    <div class="bnpl-providers">
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('simpl', this)">Simpl</div>
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('lazypay', this)">LazyPay</div>
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('zestmoney', this)">ZestMoney</div>
                        <div class="bnpl-provider-btn" onclick="selectBNPLProvider('olamoney', this)">Ola Money</div>
                    </div>

                    <!-- Mobile & PAN -->
                    <input type="text" id="bnplMobile" placeholder="Registered Mobile Number" maxlength="10">
                    <input type="text" id="bnplPan"    placeholder="PAN Number (optional)"    maxlength="10"
                           style="text-transform: uppercase;">

                    <!-- EMI Plans -->
                    <div class="bnpl-emi-box">
                        <p>Choose EMI Plan:</p>
                        <div class="bnpl-emi-options">
                            <div class="emi-option" onclick="selectEMI('1', this)">
                                Pay Full<br><small>₹<%= amount %></small>
                            </div>
                            <div class="emi-option" onclick="selectEMI('3', this)">
                                3 Months<br><small>₹<%= amt3mo %>/mo</small>
                            </div>
                            <div class="emi-option" onclick="selectEMI('6', this)">
                                6 Months<br><small>₹<%= amt6mo %>/mo</small>
                            </div>
                            <div class="emi-option" onclick="selectEMI('12', this)">
                                12 Months<br><small>₹<%= amt12mo %>/mo</small>
                            </div>
                        </div>
                    </div>

                </div>
                <!-- END BNPL SECTION -->

                <button class="pay-btn" id="payBtn" onclick="payNow()"><svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" viewBox="0 0 16 16" style="vertical-align:middle;margin-right:6px;margin-bottom:2px;"><path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/></svg>Pay ₹<%= amount %></button>
                <div id="msg"></div>
            </div>

        </div>
    </div>
</div>

<script>
const AMOUNT         = "<%= amount %>";   // injected from session by JSP
let selectedMethod   = "upi";
let selectedProvider = "";
let selectedEMI      = "";

console.log("[CHECKOUT] Page Loaded - Default Method: UPI");

// =============================================
// API ENDPOINTS — FILL THESE WHEN READY
// =============================================
const API_ENDPOINTS = {
    upi:        "checkout",
    card:       "checkout",
    netbanking: "checkout",
    wallet:     "checkout",
    bnpl:       "checkout"
};

// =============================================
// AUTH TOKEN (if needed)
// =============================================
const AUTH_TOKEN = ""; // TODO: Add Bearer token or API key if required

// =============================================
// METHOD SWITCHER
// =============================================
function selectMethod(method, element) {
    console.log("[CHECKOUT] Payment Method Selected:", method);
    selectedMethod = method;

    document.querySelectorAll(".method").forEach(el => el.classList.remove("active"));
    element.classList.add("active");

    document.getElementById("upiSection").style.display        = "none";
    document.getElementById("cardSection").style.display       = "none";
    document.getElementById("netbankingSection").style.display = "none";
    document.getElementById("walletSection").style.display     = "none";
    document.getElementById("bnplSection").style.display       = "none";

    if      (method === "upi")        document.getElementById("upiSection").style.display        = "block";
    else if (method === "card")       document.getElementById("cardSection").style.display       = "block";
    else if (method === "netbanking") document.getElementById("netbankingSection").style.display = "block";
    else if (method === "wallet")     document.getElementById("walletSection").style.display     = "block";
    else if (method === "bnpl")       document.getElementById("bnplSection").style.display       = "block";
}

// =============================================
// BNPL — PROVIDER SELECTOR
// =============================================
function selectBNPLProvider(provider, element) {
    console.log("[BNPL] Provider Selected:", provider);
    selectedProvider = provider;
    document.querySelectorAll(".bnpl-provider-btn").forEach(el => el.classList.remove("selected"));
    element.classList.add("selected");
}

// =============================================
// BNPL — EMI PLAN SELECTOR
// =============================================
function selectEMI(months, element) {
    console.log("[BNPL] EMI Plan Selected:", months, "month(s)");
    selectedEMI = months;
    document.querySelectorAll(".emi-option").forEach(el => el.classList.remove("selected"));
    element.classList.add("selected");
}

// =============================================
// COUNTDOWN TIMER
// =============================================
let timeLeft = 300;
function startTimer() {
    console.log("[CHECKOUT] Timer Started: 5 Minutes");
    const countdown = document.getElementById("countdown");

    const timer = setInterval(function () {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;
        seconds = seconds < 10 ? "0" + seconds : seconds;
        countdown.innerText = minutes + ":" + seconds;

        if (timeLeft <= 0) {
            clearInterval(timer);
            console.error("[CHECKOUT] Session Expired");
            document.getElementById("msg").innerHTML =
                "<span style='color:red;'>Session Expired! Please refresh the page.</span>";
            document.getElementById("payBtn").disabled = true;
        }
        timeLeft--;
    }, 1000);
}
startTimer();

// =============================================
// BUILD PAYLOAD PER METHOD
// =============================================
function buildPayload() {
    if (selectedMethod === "upi") {
        return {
            method: "upi",
            amount: AMOUNT
        };
    } else if (selectedMethod === "card") {
        return {
            method:     "card",
            amount:     AMOUNT,
            cardNumber: $("#cardNumber").val(),
            cardName:   $("#cardName").val(),
            cardExpiry: $("#cardExpiry").val(),
            cvv:        $("#cvv").val()
        };
    } else if (selectedMethod === "netbanking") {
        return {
            method: "netbanking",
            amount: AMOUNT,
            bank:   $("#bank").val()
        };
    } else if (selectedMethod === "wallet") {
        return {
            method:       "wallet",
            amount:       AMOUNT,
            walletType:   $("#wallet").val(),
            mobileNumber: $("#walletMobile").val()
        };
    } else if (selectedMethod === "bnpl") {
        return {
            method:       "bnpl",
            amount:       AMOUNT,
            provider:     selectedProvider,
            mobileNumber: $("#bnplMobile").val(),
            pan:          $("#bnplPan").val().toUpperCase(),
            emiMonths:    selectedEMI
        };
    }
}

// =============================================
// FRONT-END VALIDATION
// =============================================
function validate() {
    if (selectedMethod === "card") {
        if (!$("#cardNumber").val() || !$("#cardName").val() ||
            !$("#cvv").val()        || !$("#cardExpiry").val()) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please fill all card details.</span>");
            return false;
        }
    }
    if (selectedMethod === "netbanking" && !$("#bank").val()) {
        $("#msg").html("<span style='color:orange;'>⚠️ Please select a bank.</span>");
        return false;
    }
    if (selectedMethod === "wallet") {
        if (!$("#wallet").val() || !$("#walletMobile").val()) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please select wallet and enter mobile number.</span>");
            return false;
        }
    }
    if (selectedMethod === "bnpl") {
        if (!selectedProvider) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please select a BNPL provider.</span>");
            return false;
        }
        if (!$("#bnplMobile").val() || $("#bnplMobile").val().length !== 10) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please enter a valid 10-digit mobile number.</span>");
            return false;
        }
        if (!selectedEMI) {
            $("#msg").html("<span style='color:orange;'>⚠️ Please select an EMI plan.</span>");
            return false;
        }
    }
    return true;
}

// =============================================
// PAY NOW — AJAX CALL
// =============================================
function payNow() {
    console.log("[PAYMENT] Initiating | Method:", selectedMethod, "| Amount: ₹" + AMOUNT);

    if (!API_ENDPOINTS[selectedMethod]) {
        console.warn("[PAYMENT] API endpoint not set for:", selectedMethod);
        $("#msg").html("<span style='color:orange;'>⚠️ API not configured yet for: <b>" + selectedMethod.toUpperCase() + "</b></span>");
        return;
    }

    if (!validate()) return;

    $("#payBtn").prop("disabled", true).html("Processing...");
    $("#msg").html("<span style='color:#555;'>⏳ Please wait...</span>");

    let headers = { "Content-Type": "application/json" };
    if (AUTH_TOKEN) headers["Authorization"] = "Bearer " + AUTH_TOKEN;

    $.ajax({
        url:         API_ENDPOINTS[selectedMethod],
        type:        "POST",
        contentType: "application/json",
        headers:     headers,
        data:        JSON.stringify(buildPayload()),

        success: function(response) {
            console.log("[PAYMENT] Success Response:", response);
            $("#payBtn").prop("disabled", false).html('<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="white" viewBox="0 0 16 16" style="vertical-align:middle;margin-right:6px;margin-bottom:2px;"><path d="M8 1a2 2 0 0 1 2 2v4H6V3a2 2 0 0 1 2-2zm3 6V3a3 3 0 0 0-6 0v4a2 2 0 0 0-2 2v5a2 2 0 0 0 2 2h6a2 2 0 0 0 2-2V9a2 2 0 0 0-2-2z"/></svg>Pay ₹' + AMOUNT);
            showSuccessPopup(response);
        },

        error: function(xhr, status, error) {
            console.error("[PAYMENT] Failed | Status:", xhr.status, "| Error:", error);
            $("#payBtn").prop("disabled", false).text("Pay ₹" + AMOUNT);
            let errMsg = "Payment Failed. Please try again.";
            if (xhr.responseJSON && xhr.responseJSON.message) errMsg = xhr.responseJSON.message;
            $("#msg").html("<span style='color:red;'>❌ " + errMsg + "</span>");
        }
    });
}

// =============================================
// SUCCESS POPUP
// =============================================
function showSuccessPopup(response) {
    let msg = response.message || "Payment Successful!";
    // Extract transaction ID from message if present
    let txnMatch = msg.match(/Transaction ID:\s*(\S+)/);
    let txnId = txnMatch ? txnMatch[1] : "";

    $("#popupMsg").text("₹" + AMOUNT + " paid via " + selectedMethod.toUpperCase());
    $("#popupTxn").text(txnId ? "Transaction ID: " + txnId : "");
    $("#successPopup").addClass("show");
}

function closePopup() {
    $("#successPopup").removeClass("show");
}
</script>

<!-- SUCCESS POPUP -->
<div class="popup-overlay" id="successPopup">
    <div class="popup-box">
        <div class="tick-circle">
            <svg width="40" height="40" viewBox="0 0 40 40" fill="none">
                <polyline points="10,20 18,28 30,12" stroke="white" stroke-width="4"
                          stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </div>
        <h2>Payment Successful!</h2>
        <p class="popup-msg" id="popupMsg"></p>
        <p class="popup-txn" id="popupTxn"></p>
        <button class="popup-close-btn" onclick="closePopup()">Done</button>
    </div>
</div>

</body>
</html>