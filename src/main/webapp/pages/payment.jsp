<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Payment - AK Shop</title>

<link rel="preconnect"
      href="https://fonts.googleapis.com">

<link rel="preconnect"
      href="https://fonts.gstatic.com"
      crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
      rel="stylesheet">

<link rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">


<style>

/* ================= GLOBAL ================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {

    font-family: 'Poppins', sans-serif;

    background: #ffffff;

    color: #222;
}


/* ================= TOP BAR ================= */

.top-bar {

    height: 32px;

    background: #222;

    color: #fff;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 11px;
}


/* ================= HEADER ================= */

.header {

    height: 95px;

    border-bottom: 1px solid #eee;

    display: flex;

    align-items: center;

    justify-content: center;
}

.header-inner {

    width: 1060px;

    display: flex;

    align-items: center;

    justify-content: space-between;
}

.logo {

    width: 105px;

    text-align: center;
}

.logo h2 {

    font-family: Georgia, serif;

    font-size: 25px;

    letter-spacing: 2px;

    color: #b89545;
}

.logo span {

    display: block;

    font-size: 8px;

    letter-spacing: 3px;

    color: #999;
}

.menu {

    display: flex;

    gap: 28px;

    margin-left: -80px;
}

.menu a {

    text-decoration: none;

    color: #333;

    font-size: 13px;
}

.menu a:hover {

    color: #b89545;
}

.header-icons {

    display: flex;

    gap: 25px;

    font-size: 19px;
}


/* ================= BREADCRUMB ================= */

.breadcrumb {

    width: 1060px;

    margin: 30px auto;

    font-size: 12px;

    color: #888;
}

.breadcrumb span {

    margin: 0 8px;
}


/* ================= MAIN ================= */

.checkout-container {

    width: 1060px;

    margin: 0 auto 80px;

    display: grid;

    grid-template-columns: 1.7fr 1fr;

    gap: 40px;
}


/* ================= PAYMENT BOX ================= */

.payment-box {

    border: 1px solid #e5e5e5;

    background: #fff;
}

.box-title {

    padding: 22px 28px;

    border-bottom: 1px solid #eee;

    font-size: 18px;

    font-weight: 600;
}

.secure-text {

    font-size: 11px;

    color: #777;

    margin-top: 5px;
}


/* ================= PAYMENT METHODS ================= */

.payment-methods {

    display: grid;

    grid-template-columns: repeat(2, 1fr);

    gap: 12px;

    padding: 25px 28px;

    border-bottom: 1px solid #eee;
}

.method {

    border: 1px solid #ddd;

    min-height: 75px;

    display: flex;

    align-items: center;

    gap: 15px;

    padding: 15px;

    cursor: pointer;

    transition: 0.2s;

    background: #fff;
}

.method:hover {

    border-color: #222;
}

.method.active {

    border: 1.5px solid #222;

    background: #fafafa;
}

.method input {

    accent-color: #222;
}

.method-icon {

    width: 38px;

    height: 38px;

    display: flex;

    align-items: center;

    justify-content: center;

    border: 1px solid #eee;

    border-radius: 5px;

    font-size: 18px;
}

.method-info strong {

    display: block;

    font-size: 13px;

    font-weight: 600;
}

.method-info small {

    display: block;

    font-size: 10px;

    color: #888;

    margin-top: 3px;
}


/* =========================================================
   PROFESSIONAL SHIPPING ADDRESS
========================================================= */

.shipping-address {

    padding: 28px;

    border-bottom: 1px solid #eee;

    background: #fff;
}

.shipping-address-header {

    display: flex;

    align-items: center;

    gap: 12px;

    margin-bottom: 24px;
}

.address-icon {

    width: 42px;

    height: 42px;

    border: 1px solid #e5e5e5;

    display: flex;

    align-items: center;

    justify-content: center;

    border-radius: 6px;

    color: #b89545;

    font-size: 17px;

    flex-shrink: 0;
}

.shipping-address-header h3 {

    margin: 0;

    font-size: 16px;

    font-weight: 600;
}

.shipping-address-header p {

    margin: 3px 0 0;

    color: #888;

    font-size: 10px;
}

.address-form-box {

    border: 1px solid #e5e5e5;

    background: #fafafa;

    padding: 22px;
}

.address-section-label {

    font-size: 10px;

    font-weight: 600;

    color: #777;

    letter-spacing: 0.5px;

    text-transform: uppercase;

    margin: 3px 0 14px;
}

.address-divider {

    border: 0;

    border-top: 1px solid #e8e8e8;

    margin: 3px 0 20px;
}

.address-row {

    display: flex;

    gap: 15px;
}

.address-group {

    flex: 1;

    margin-bottom: 17px;
}

.address-group.full {

    width: 100%;
}

.address-group label {

    display: block;

    font-size: 11px;

    font-weight: 500;

    color: #444;

    margin-bottom: 7px;
}

.address-group input,

.address-group select {

    width: 100%;

    height: 44px;

    border: 1px solid #dcdcdc;

    background: #fff;

    padding: 0 13px;

    outline: none;

    font-family: 'Poppins', sans-serif;

    font-size: 12px;

    color: #222;

    transition: 0.2s;
}

.address-group input::placeholder {

    color: #aaa;
}

.address-group input:focus,

.address-group select:focus {

    border-color: #222;

    box-shadow: 0 0 0 2px rgba(34, 34, 34, 0.04);
}

.required {

    color: #c62828;
}

.location-badge {

    display: inline-flex;

    align-items: center;

    gap: 6px;

    padding: 7px 10px;

    background: #fff;

    border: 1px solid #e5e5e5;

    font-size: 9px;

    color: #777;

    margin-top: 2px;
}

.location-badge i {

    color: #b89545;
}


/* ================= PAYMENT CONTENT ================= */

.payment-content {

    padding: 28px;
}

.payment-section {

    display: none;
}

.payment-section.active {

    display: block;
}

.payment-section h3 {

    font-size: 15px;

    margin-bottom: 20px;
}


/* ================= FORM ================= */

.form-row {

    display: flex;

    gap: 15px;
}

.form-group {

    margin-bottom: 18px;

    flex: 1;
}

.form-group label {

    display: block;

    font-size: 11px;

    margin-bottom: 7px;

    color: #555;
}

.form-group input,

.form-group select {

    width: 100%;

    height: 44px;

    border: 1px solid #ddd;

    padding: 0 13px;

    outline: none;

    font-family: 'Poppins';

    font-size: 12px;
}

.form-group input:focus,

.form-group select:focus {

    border-color: #222;
}


/* ================= UPI ================= */

.upi-box {

    display: flex;

    gap: 10px;
}

.upi-box input {

    flex: 1;
}

.verify-btn {

    width: 100px;

    border: none;

    background: #222;

    color: #fff;

    cursor: pointer;
}


/* ================= QR ================= */

.qr-section {

    text-align: center;

    padding: 10px;
}

.qr-placeholder {

    width: 180px;

    height: 180px;

    border: 1px solid #ddd;

    margin: 0 auto 15px;

    display: flex;

    align-items: center;

    justify-content: center;

    background: #fafafa;
}

.qr-placeholder i {

    font-size: 80px;

    color: #333;
}

.qr-section p {

    font-size: 12px;

    color: #777;
}


/* ================= BANK ================= */

.bank-list {

    display: grid;

    grid-template-columns: repeat(2, 1fr);

    gap: 10px;
}

.bank {

    border: 1px solid #ddd;

    padding: 13px;

    font-size: 12px;

    cursor: pointer;

    transition: 0.2s;
}

.bank:hover {

    border-color: #222;
}

.bank.selected {

    border: 1.5px solid #222;

    background: #fafafa;
}


/* ================= COD ================= */

.cod-info {

    padding: 20px;

    background: #fafafa;

    border: 1px solid #eee;

    font-size: 12px;

    line-height: 1.8;
}


/* ================= DEMO NOTICE ================= */

.demo-notice {

    margin-top: 18px;

    padding: 12px 15px;

    background: #fff8e6;

    border: 1px solid #f0d98c;

    color: #765b00;

    font-size: 11px;

    line-height: 1.6;
}


/* ================= ORDER SUMMARY ================= */

.summary {

    border: 1px solid #e5e5e5;

    height: fit-content;
}

.summary-title {

    padding: 22px 28px;

    border-bottom: 1px solid #eee;

    font-size: 18px;

    font-weight: 600;
}

.product {

    display: flex;

    justify-content: space-between;

    gap: 15px;

    padding: 18px 28px;

    border-bottom: 1px solid #eee;

    font-size: 12px;
}

.product-name {

    max-width: 180px;
}

.product-name small {

    display: block;

    color: #888;

    margin-top: 5px;
}

.product-image {

    width: 55px;

    height: 55px;

    border: 1px solid #eee;

    margin-right: 12px;

    overflow: hidden;

    flex-shrink: 0;
}

.product-image img {

    width: 100%;

    height: 100%;

    object-fit: cover;
}

.product-left {

    display: flex;

    align-items: center;
}

.summary-row {

    display: flex;

    justify-content: space-between;

    padding: 12px 28px;

    font-size: 12px;
}

.summary-total {

    display: flex;

    justify-content: space-between;

    padding: 20px 28px;

    border-top: 1px solid #ddd;

    font-size: 16px;

    font-weight: 600;
}


/* ================= PAY BUTTON ================= */

.pay-button {

    margin: 10px 28px 28px;

    width: calc(100% - 56px);

    height: 52px;

    border: none;

    background: #222;

    color: #fff;

    font-family: 'Poppins';

    font-size: 13px;

    font-weight: 500;

    cursor: pointer;

    transition: 0.2s;
}

.pay-button:hover {

    background: #000;
}

.pay-button:disabled {

    background: #999;

    cursor: not-allowed;
}


/* ================= SECURITY ================= */

.security {

    text-align: center;

    padding: 0 20px 25px;

    color: #888;

    font-size: 10px;
}

.security i {

    margin-right: 5px;
}


/* ================= EMPTY CART ================= */

.empty-cart {

    padding: 40px 20px;

    text-align: center;

    color: #777;

    font-size: 13px;
}

.empty-cart i {

    font-size: 40px;

    margin-bottom: 15px;

    color: #bbb;
}


/* ================= RESPONSIVE ================= */

@media(max-width: 900px) {

    .header-inner,

    .breadcrumb,

    .checkout-container {

        width: 92%;
    }

    .checkout-container {

        grid-template-columns: 1fr;
    }

    .menu {

        display: none;
    }
}

@media(max-width: 600px) {

    .payment-methods {

        grid-template-columns: 1fr;
    }

    .form-row,

    .address-row {

        flex-direction: column;

        gap: 0;
    }

    .bank-list {

        grid-template-columns: 1fr;
    }

    .header-icons {

        gap: 12px;
    }

    .shipping-address {

        padding: 20px;
    }

    .address-form-box {

        padding: 16px;
    }
}

</style>

</head>


<body>


<!-- ================= TOP BAR ================= -->

<div class="top-bar">

    Free shipping for standard order over ₹100

</div>


<!-- ================= HEADER ================= -->

<header class="header">

    <div class="header-inner">

        <div class="logo">

            <h2>AYUSH</h2>

            <span>THE LABEL</span>

        </div>


        <nav class="menu">

            <a href="../index.jsp">Home</a>

            <a href="product.jsp">Shop</a>

            <a href="#">Features</a>

            <a href="blog.jsp">Blog</a>

            <a href="about.jsp">About</a>

            <a href="contact.jsp">Contact</a>

        </nav>


        <div class="header-icons">

            <i class="fa-solid fa-magnifying-glass"></i>

            <i class="fa-solid fa-cart-shopping"></i>

            <i class="fa-regular fa-heart"></i>

        </div>

    </div>

</header>


<!-- ================= BREADCRUMB ================= -->

<div class="breadcrumb">

    <a href="../index.jsp"
       style="text-decoration:none;color:#888;">

        Home

    </a>

    <span>›</span>

    Shopping Cart

    <span>›</span>

    <strong>Payment</strong>

</div>


<!-- ================= CHECKOUT ================= -->

<div class="checkout-container">


    <!-- ================= LEFT SIDE ================= -->

    <div class="payment-box">


        <div class="box-title">

            Payment Method

            <div class="secure-text">

                <i class="fa-solid fa-lock"></i>

                Secure checkout

            </div>

        </div>


        <!-- ================= PAYMENT METHODS ================= -->

        <div class="payment-methods">


            <!-- CARD -->

            <div class="method active"
                 onclick="selectPayment('card', this)">

                <input type="radio"
                       name="paymentRadio"
                       checked>

                <div class="method-icon">

                    <i class="fa-regular fa-credit-card"></i>

                </div>

                <div class="method-info">

                    <strong>
                        Credit / Debit Card
                    </strong>

                    <small>
                        Demo payment
                    </small>

                </div>

            </div>


            <!-- UPI -->

            <div class="method"
                 onclick="selectPayment('upi', this)">

                <input type="radio"
                       name="paymentRadio">

                <div class="method-icon">

                    <i class="fa-solid fa-mobile-screen-button"></i>

                </div>

                <div class="method-info">

                    <strong>UPI</strong>

                    <small>
                        Demo payment
                    </small>

                </div>

            </div>


            <!-- NET BANKING -->

            <div class="method"
                 onclick="selectPayment('bank', this)">

                <input type="radio"
                       name="paymentRadio">

                <div class="method-icon">

                    <i class="fa-solid fa-building-columns"></i>

                </div>

                <div class="method-info">

                    <strong>Net Banking</strong>

                    <small>
                        Demo payment
                    </small>

                </div>

            </div>


            <!-- QR -->

            <div class="method"
                 onclick="selectPayment('qr', this)">

                <input type="radio"
                       name="paymentRadio">

                <div class="method-icon">

                    <i class="fa-solid fa-qrcode"></i>

                </div>

                <div class="method-info">

                    <strong>Scan QR Code</strong>

                    <small>
                        Demo payment
                    </small>

                </div>

            </div>


            <!-- COD -->

            <div class="method"
                 onclick="selectPayment('cod', this)">

                <input type="radio"
                       name="paymentRadio">

                <div class="method-icon">

                    <i class="fa-solid fa-money-bill-wave"></i>

                </div>

                <div class="method-info">

                    <strong>Cash on Delivery</strong>

                    <small>
                        Pay when order arrives
                    </small>

                </div>

            </div>


        </div>


        <!-- =====================================================
             PROFESSIONAL SHIPPING ADDRESS
        ====================================================== -->

        <div class="shipping-address">


            <div class="shipping-address-header">

                <div class="address-icon">

                    <i class="fa-solid fa-location-dot"></i>

                </div>


                <div>

                    <h3>Delivery Address</h3>

                    <p>
                        Enter the address where you want your order delivered
                    </p>

                </div>

            </div>


            <div class="address-form-box">


                <!-- CONTACT INFORMATION -->

                <div class="address-section-label">

                    Contact Information

                </div>


                <div class="address-row">


                    <!-- FULL NAME -->

                    <div class="address-group">

                        <label for="deliveryName">

                            Full Name

                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            id="deliveryName"
                            placeholder="Enter your full name"
                            maxlength="100"
                            autocomplete="name"
                            required>

                    </div>


                    <!-- MOBILE -->

                    <div class="address-group">

                        <label for="deliveryMobile">

                            Mobile Number

                            <span class="required">*</span>

                        </label>

                        <input
                            type="tel"
                            id="deliveryMobile"
                            placeholder="10-digit mobile number"
                            maxlength="10"
                            inputmode="numeric"
                            autocomplete="tel"
                            required>

                    </div>


                </div>


                <hr class="address-divider">


                <!-- ADDRESS INFORMATION -->

                <div class="address-section-label">

                    Address Information

                </div>


                <!-- HOUSE -->

                <div class="address-group full">

                    <label for="houseAddress">

                        House / Flat / Building

                        <span class="required">*</span>

                    </label>

                    <input
                        type="text"
                        id="houseAddress"
                        placeholder="House no., Flat no., Building name"
                        maxlength="150"
                        autocomplete="address-line1"
                        required>

                </div>


                <!-- STREET + LANDMARK -->

                <div class="address-row">


                    <div class="address-group">

                        <label for="streetAddress">

                            Street / Area / Locality

                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            id="streetAddress"
                            placeholder="Street, area or locality"
                            maxlength="200"
                            autocomplete="address-line2"
                            required>

                    </div>


                    <div class="address-group">

                        <label for="landmark">

                            Landmark

                        </label>

                        <input
                            type="text"
                            id="landmark"
                            placeholder="Nearby landmark (optional)"
                            maxlength="150">

                    </div>


                </div>


                <!-- CITY STATE PIN -->

                <div class="address-row">


                    <!-- CITY -->

                    <div class="address-group">

                        <label for="city">

                            City

                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            id="city"
                            placeholder="Enter city"
                            maxlength="80"
                            autocomplete="address-level2"
                            required>

                    </div>


                    <!-- STATE -->

                    <div class="address-group">

                        <label for="state">

                            State

                            <span class="required">*</span>

                        </label>

                        <select
                            id="state"
                            required>

                            <option value="">
                                Select State
                            </option>

                            <option>Andhra Pradesh</option>
                            <option>Arunachal Pradesh</option>
                            <option>Assam</option>
                            <option>Bihar</option>
                            <option>Chhattisgarh</option>
                            <option>Goa</option>
                            <option>Gujarat</option>
                            <option>Haryana</option>
                            <option>Himachal Pradesh</option>
                            <option>Jharkhand</option>
                            <option>Karnataka</option>
                            <option>Kerala</option>
                            <option>Madhya Pradesh</option>
                            <option>Maharashtra</option>
                            <option>Manipur</option>
                            <option>Meghalaya</option>
                            <option>Mizoram</option>
                            <option>Nagaland</option>
                            <option>Odisha</option>
                            <option>Punjab</option>
                            <option>Rajasthan</option>
                            <option>Sikkim</option>
                            <option>Tamil Nadu</option>
                            <option>Telangana</option>
                            <option>Tripura</option>
                            <option>Uttar Pradesh</option>
                            <option>Uttarakhand</option>
                            <option>West Bengal</option>
                            <option>Andaman and Nicobar Islands</option>
                            <option>Chandigarh</option>
                            <option>
                                Dadra and Nagar Haveli and Daman and Diu
                            </option>
                            <option>Delhi</option>
                            <option>Jammu and Kashmir</option>
                            <option>Ladakh</option>
                            <option>Lakshadweep</option>
                            <option>Puducherry</option>

                        </select>

                    </div>


                    <!-- PIN -->

                    <div class="address-group">

                        <label for="pinCode">

                            PIN Code

                            <span class="required">*</span>

                        </label>

                        <input
                            type="text"
                            id="pinCode"
                            placeholder="6-digit PIN"
                            maxlength="6"
                            inputmode="numeric"
                            autocomplete="postal-code"
                            required>

                    </div>


                </div>


                <div class="location-badge">

                    <i class="fa-solid fa-shield-halved"></i>

                    Your delivery information is used only for order processing.

                </div>


            </div>

        </div>


        <!-- ================= PAYMENT DETAILS ================= -->

        <div class="payment-content">


            <!-- ================= CARD ================= -->

            <div id="card"
                 class="payment-section active">

                <h3>
                    Card Details
                </h3>


                <div class="form-group">

                    <label>
                        Card Number
                    </label>

                    <input
                        id="cardNumber"
                        type="text"
                        placeholder="1234 5678 9012 3456"
                        maxlength="19"
                        autocomplete="off">

                </div>


                <div class="form-group">

                    <label>
                        Name on Card
                    </label>

                    <input
                        id="cardName"
                        type="text"
                        placeholder="Enter card holder name"
                        autocomplete="off">

                </div>


                <div class="form-row">


                    <div class="form-group">

                        <label>
                            Expiry Date
                        </label>

                        <input
                            id="expiry"
                            type="text"
                            placeholder="MM / YY"
                            maxlength="7"
                            autocomplete="off">

                    </div>


                    <div class="form-group">

                        <label>
                            CVV
                        </label>

                        <input
                            id="cvv"
                            type="password"
                            placeholder="•••"
                            maxlength="3"
                            autocomplete="off">

                    </div>


                </div>


                <div class="demo-notice">

                    <strong>Demo Payment Mode</strong>

                    <br>

                    No real bank transaction is performed.

                    Card number and CVV are not sent to the database.

                </div>

            </div>


            <!-- ================= UPI ================= -->

            <div id="upi"
                 class="payment-section">

                <h3>
                    Pay using UPI
                </h3>


                <div class="form-group">

                    <label>
                        UPI ID
                    </label>


                    <div class="upi-box">

                        <input
                            id="upiId"
                            type="text"
                            placeholder="example@upi">


                        <button
                            class="verify-btn"
                            type="button"
                            onclick="verifyUPI()">

                            Verify

                        </button>

                    </div>

                </div>


                <p style="font-size:11px;color:#888;">

                    UPI validation is for demo checkout only.

                </p>


                <div class="demo-notice">

                    <strong>Demo Payment Mode</strong>

                    <br>

                    No real UPI transaction will be performed.

                </div>

            </div>


            <!-- ================= NET BANKING ================= -->

            <div id="bank"
                 class="payment-section">

                <h3>
                    Select Your Bank
                </h3>


                <div class="bank-list">


                    <div class="bank"
                         onclick="selectBank(this)">

                        <i class="fa-solid fa-building-columns"></i>

                        State Bank of India

                    </div>


                    <div class="bank"
                         onclick="selectBank(this)">

                        <i class="fa-solid fa-building-columns"></i>

                        HDFC Bank

                    </div>


                    <div class="bank"
                         onclick="selectBank(this)">

                        <i class="fa-solid fa-building-columns"></i>

                        ICICI Bank

                    </div>


                    <div class="bank"
                         onclick="selectBank(this)">

                        <i class="fa-solid fa-building-columns"></i>

                        Axis Bank

                    </div>


                    <div class="bank"
                         onclick="selectBank(this)">

                        <i class="fa-solid fa-building-columns"></i>

                        Kotak Mahindra Bank

                    </div>


                    <div class="bank"
                         onclick="selectBank(this)">

                        <i class="fa-solid fa-building-columns"></i>

                        Other Banks

                    </div>


                </div>


                <div class="demo-notice">

                    <strong>Demo Payment Mode</strong>

                    <br>

                    Bank login/payment is not performed.

                    The selected method will create a demo order.

                </div>

            </div>


            <!-- ================= QR ================= -->

            <div id="qr"
                 class="payment-section">

                <h3>
                    Scan & Pay
                </h3>


                <div class="qr-section">

                    <div class="qr-placeholder">

                        <i class="fa-solid fa-qrcode"></i>

                    </div>


                    <p>

                        QR payment is currently in demo mode.

                    </p>

                </div>


                <div class="demo-notice">

                    <strong>Demo Payment Mode</strong>

                    <br>

                    This QR is only a visual placeholder.

                    No real UPI payment is performed.

                </div>

            </div>


            <!-- ================= COD ================= -->

            <div id="cod"
                 class="payment-section">

                <h3>
                    Cash on Delivery
                </h3>


                <div class="cod-info">

                    <strong>
                        Cash on Delivery selected.
                    </strong>

                    <br>
                    <br>

                    Your order will be placed now.

                    <br>

                    Payment status will remain

                    <strong>PENDING</strong>

                    until payment is collected during delivery.

                </div>

            </div>


        </div>

    </div>


    <!-- ================= RIGHT SIDE ================= -->

    <div class="summary">


        <div class="summary-title">

            Order Summary

        </div>


        <!-- CART ITEMS -->

        <div id="orderItems">

            <div class="empty-cart">

                <i class="fa-solid fa-spinner fa-spin"></i>

                <br>
                <br>

                Loading cart...

            </div>

        </div>


        <!-- SUBTOTAL -->

        <div class="summary-row">

            <span>
                Subtotal
            </span>

            <span id="subtotal">
                ₹0.00
            </span>

        </div>


        <!-- SHIPPING -->

        <div class="summary-row">

            <span>
                Shipping
            </span>

            <span id="shipping">
                FREE
            </span>

        </div>


        <!-- TOTAL -->

        <div class="summary-total">

            <span>
                Total
            </span>

            <span id="total">
                ₹0.00
            </span>

        </div>


        <!-- ================= FORM ================= -->

        <form
            id="orderForm"
            action="process-order.jsp"
            method="post">


            <input
                type="hidden"
                id="paymentMethod"
                name="paymentMethod"
                value="Credit / Debit Card">


            <input
                type="hidden"
                id="selectedBank"
                name="selectedBank"
                value="">


            <!-- COMPLETE ADDRESS WILL BE STORED HERE -->

            <input
                type="hidden"
                id="shippingAddressHidden"
                name="shippingAddress"
                value="">


        </form>


        <!-- ================= PAY BUTTON ================= -->

        <button
            id="payButton"
            class="pay-button"
            type="button"
            onclick="processPayment()">

            <i class="fa-solid fa-lock"></i>

            PAY ₹0.00

        </button>


        <div class="security">

            <i class="fa-solid fa-shield-halved"></i>

            Your card/CVV details are not stored by AK Shop

        </div>


    </div>

</div>


<!-- =========================================================
     JAVASCRIPT
========================================================= -->

<script>


/* =========================================================
   GLOBAL VARIABLES
========================================================= */

var cart = [];

var orderTotal = 0;

var selectedPaymentType = "card";

var selectedPaymentMethod =
    "Credit / Debit Card";


/* =========================================================
   ESCAPE HTML
========================================================= */

function escapeHtml(value) {

    if (value === null ||
        value === undefined) {

        return '';

    }

    return String(value)

        .replace(/&/g, '&amp;')

        .replace(/</g, '&lt;')

        .replace(/>/g, '&gt;')

        .replace(/"/g, '&quot;')

        .replace(/'/g, '&#039;');
}


/* =========================================================
   FORMAT PRICE
========================================================= */

function formatPrice(value) {

    var number =
        parseFloat(value) || 0;

    return '₹' + number.toFixed(2);
}


/* =========================================================
   LOAD CART
========================================================= */

function loadCart() {

    try {

        var storedCart =
            localStorage.getItem('ayushCart');

        if (storedCart) {

            cart =
                JSON.parse(storedCart);

        } else {

            cart = [];

        }

    } catch (error) {

        console.error(
            'Cart loading error:',
            error
        );

        cart = [];
    }

    renderCart();
}


/* =========================================================
   RENDER CART
========================================================= */

function renderCart() {

    var container =
        document.getElementById(
            'orderItems'
        );

    if (!container) {

        return;
    }

    container.innerHTML = '';

    orderTotal = 0;


    if (!Array.isArray(cart) ||
        cart.length === 0) {

        container.innerHTML =

            '<div class="empty-cart">' +

                '<i class="fa-solid fa-cart-shopping"></i>' +

                '<br><br>' +

                'Your cart is empty.' +

                '<br><br>' +

                '<a href="product.jsp" ' +

                'style="color:#222;">' +

                'Continue Shopping' +

                '</a>' +

            '</div>';

        updateTotal(0);

        return;
    }


    cart.forEach(function(item) {

        var name =
            item.name || 'Product';

        var price =
            parseFloat(item.price) || 0;

        var quantity =
            parseInt(item.quantity) || 1;

        if (quantity < 1) {

            quantity = 1;
        }

        var image =
            item.image || '';

        var itemTotal =
            price * quantity;

        orderTotal += itemTotal;


        var imageHTML = '';


        if (image) {

            imageHTML =

                '<img src="' +

                escapeHtml(image) +

                '" alt="' +

                escapeHtml(name) +

                '">';

        } else {

            imageHTML =

                '<i class="fa-solid fa-image" ' +

                'style="' +

                'width:100%;' +

                'height:100%;' +

                'display:flex;' +

                'align-items:center;' +

                'justify-content:center;' +

                'color:#aaa;' +

                '">' +

                '</i>';
        }


        var productHTML =

            '<div class="product">' +

                '<div class="product-left">' +

                    '<div class="product-image">' +

                        imageHTML +

                    '</div>' +

                    '<div class="product-name">' +

                        escapeHtml(name) +

                        '<small>' +

                            'Qty: ' +

                            quantity +

                        '</small>' +

                    '</div>' +

                '</div>' +

                '<strong>' +

                    formatPrice(itemTotal) +

                '</strong>' +

            '</div>';


        container.insertAdjacentHTML(

            'beforeend',

            productHTML

        );

    });


    updateTotal(orderTotal);
}


/* =========================================================
   UPDATE TOTAL
========================================================= */

function updateTotal(amount) {

    var subtotalElement =
        document.getElementById(
            'subtotal'
        );

    var totalElement =
        document.getElementById(
            'total'
        );

    var payButton =
        document.getElementById(
            'payButton'
        );


    if (subtotalElement) {

        subtotalElement.textContent =
            formatPrice(amount);
    }


    if (totalElement) {

        totalElement.textContent =
            formatPrice(amount);
    }


    if (payButton) {

        payButton.innerHTML =

            '<i class="fa-solid fa-lock"></i> ' +

            'PAY ' +

            formatPrice(amount);


        if (amount <= 0) {

            payButton.disabled = true;

        } else {

            payButton.disabled = false;
        }
    }
}


/* =========================================================
   SELECT PAYMENT
========================================================= */

function selectPayment(type, element) {

    document.querySelectorAll('.method')

        .forEach(function(method) {

            method.classList.remove(
                'active'
            );

        });


    element.classList.add('active');


    document.querySelectorAll(
        '.payment-section'
    )

        .forEach(function(section) {

            section.classList.remove(
                'active'
            );

        });


    var selectedSection =
        document.getElementById(type);


    if (selectedSection) {

        selectedSection.classList.add(
            'active'
        );
    }


    var radio =
        element.querySelector('input');


    if (radio) {

        radio.checked = true;
    }


    selectedPaymentType = type;


    var methodElement =
        element.querySelector(
            '.method-info strong'
        );


    if (methodElement) {

        selectedPaymentMethod =
            methodElement.textContent.trim();
    }


    var paymentMethodInput =
        document.getElementById(
            'paymentMethod'
        );


    if (paymentMethodInput) {

        paymentMethodInput.value =
            selectedPaymentMethod;
    }
}


/* =========================================================
   SELECT BANK
========================================================= */

function selectBank(element) {

    document.querySelectorAll('.bank')

        .forEach(function(bank) {

            bank.classList.remove(
                'selected'
            );

        });


    element.classList.add('selected');


    var selectedBankInput =
        document.getElementById(
            'selectedBank'
        );


    if (selectedBankInput) {

        selectedBankInput.value =
            element.textContent.trim();
    }
}


/* =========================================================
   CARD NUMBER FORMAT
========================================================= */

var cardNumber =
    document.getElementById(
        'cardNumber'
    );


if (cardNumber) {

    cardNumber.addEventListener(
        'input',
        function() {

            var value =
                this.value

                    .replace(/\D/g, '')

                    .substring(0, 16);


            var formatted =
                value.match(/.{1,4}/g);


            this.value =
                formatted
                    ? formatted.join(' ')
                    : '';

        }
    );
}


/* =========================================================
   EXPIRY FORMAT
========================================================= */

var expiry =
    document.getElementById(
        'expiry'
    );


if (expiry) {

    expiry.addEventListener(
        'input',
        function() {

            var value =
                this.value

                    .replace(/\D/g, '')

                    .substring(0, 4);


            if (value.length >= 3) {

                this.value =

                    value.substring(0, 2) +

                    ' / ' +

                    value.substring(2);

            } else {

                this.value = value;
            }

        }
    );
}


/* =========================================================
   CVV ONLY NUMBERS
========================================================= */

var cvv =
    document.getElementById(
        'cvv'
    );


if (cvv) {

    cvv.addEventListener(
        'input',
        function() {

            this.value =

                this.value

                    .replace(/\D/g, '')

                    .substring(0, 3);

        }
    );
}


/* =========================================================
   MOBILE NUMBER ONLY
========================================================= */

var deliveryMobile =
    document.getElementById(
        'deliveryMobile'
    );


if (deliveryMobile) {

    deliveryMobile.addEventListener(
        'input',
        function() {

            this.value =

                this.value

                    .replace(/\D/g, '')

                    .substring(0, 10);

        }
    );
}


/* =========================================================
   PIN CODE ONLY
========================================================= */

var pinCode =
    document.getElementById(
        'pinCode'
    );


if (pinCode) {

    pinCode.addEventListener(
        'input',
        function() {

            this.value =

                this.value

                    .replace(/\D/g, '')

                    .substring(0, 6);

        }
    );
}


/* =========================================================
   NAME ONLY
========================================================= */

var deliveryName =
    document.getElementById(
        'deliveryName'
    );


if (deliveryName) {

    deliveryName.addEventListener(
        'input',
        function() {

            this.value =

                this.value.replace(
                    /[^a-zA-Z .'-]/g,
                    ''
                );

        }
    );
}


/* =========================================================
   VERIFY UPI
========================================================= */

function verifyUPI() {

    var upi =
        document.getElementById(
            'upiId'
        );


    if (!upi) {

        return;
    }


    var value =
        upi.value.trim();


    if (!value) {

        alert(
            'Please enter your UPI ID.'
        );

        return;
    }


    var upiPattern =
        /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+$/;


    if (!upiPattern.test(value)) {

        alert(
            'Please enter a valid UPI ID.\n' +
            'Example: name@upi'
        );

        return;
    }


    alert(
        'UPI ID format verified.'
    );
}


/* =========================================================
   CREATE HIDDEN INPUT
========================================================= */

function createHiddenInput(
    name,
    value
) {

    var input =
        document.createElement(
            'input'
        );


    input.type = 'hidden';

    input.name = name;

    input.value = value;

    input.className =
        'cart-hidden-field';


    return input;
}


/* =========================================================
   PREPARE ORDER FORM
========================================================= */

function prepareOrderForm() {

    var form =
        document.getElementById(
            'orderForm'
        );


    if (!form) {

        return false;
    }


    /* ================= ADDRESS FIELDS ================= */

    var deliveryName =
        document.getElementById(
            'deliveryName'
        );

    var deliveryMobile =
        document.getElementById(
            'deliveryMobile'
        );

    var houseAddress =
        document.getElementById(
            'houseAddress'
        );

    var streetAddress =
        document.getElementById(
            'streetAddress'
        );

    var landmark =
        document.getElementById(
            'landmark'
        );

    var city =
        document.getElementById(
            'city'
        );

    var state =
        document.getElementById(
            'state'
        );

    var pinCode =
        document.getElementById(
            'pinCode'
        );


    var shippingAddressHidden =
        document.getElementById(
            'shippingAddressHidden'
        );


    if (!deliveryName ||
        !deliveryMobile ||
        !houseAddress ||
        !streetAddress ||
        !landmark ||
        !city ||
        !state ||
        !pinCode ||
        !shippingAddressHidden) {

        alert(
            'Delivery address fields are missing.'
        );

        return false;
    }


    /* ================= GET VALUES ================= */

    var fullName =
        deliveryName.value.trim();

    var mobile =
        deliveryMobile.value.trim();

    var house =
        houseAddress.value.trim();

    var street =
        streetAddress.value.trim();

    var landmarkValue =
        landmark.value.trim();

    var cityValue =
        city.value.trim();

    var stateValue =
        state.value.trim();

    var pin =
        pinCode.value.trim();


    /* ================= VALIDATION ================= */

    if (!fullName) {

        alert(
            'Please enter your full name.'
        );

        deliveryName.focus();

        return false;
    }


    if (!/^[0-9]{10}$/.test(mobile)) {

        alert(
            'Please enter a valid 10-digit mobile number.'
        );

        deliveryMobile.focus();

        return false;
    }


    if (!house) {

        alert(
            'Please enter your House / Flat / Building.'
        );

        houseAddress.focus();

        return false;
    }


    if (!street) {

        alert(
            'Please enter your Street / Area / Locality.'
        );

        streetAddress.focus();

        return false;
    }


    if (!cityValue) {

        alert(
            'Please enter your city.'
        );

        city.focus();

        return false;
    }


    if (!stateValue) {

        alert(
            'Please select your state.'
        );

        state.focus();

        return false;
    }


    if (!/^[0-9]{6}$/.test(pin)) {

        alert(
            'Please enter a valid 6-digit PIN code.'
        );

        pinCode.focus();

        return false;
    }


    /* ================= BUILD COMPLETE ADDRESS ================= */

    var address =

        'Name: ' +
        fullName +

        ', Mobile: ' +
        mobile +

        ', House / Flat / Building: ' +
        house +

        ', Street / Area / Locality: ' +
        street +

        ', Landmark: ' +
        (
            landmarkValue
                ? landmarkValue
                : 'Not provided'
        ) +

        ', City: ' +
        cityValue +

        ', State: ' +
        stateValue +

        ', PIN Code: ' +
        pin;


    /* ================= SEND TO JSP ================= */

    shippingAddressHidden.value =
        address;


    /* ================= REMOVE OLD CART FIELDS ================= */

    var oldFields =
        form.querySelectorAll(
            '.cart-hidden-field'
        );


    oldFields.forEach(function(field) {

        field.remove();

    });


    /* ================= ADD CART ITEMS ================= */

    cart.forEach(function(item) {

        var name =
            item.name || 'Product';


        var price =
            parseFloat(item.price) || 0;


        var quantity =
            parseInt(item.quantity) || 1;


        form.appendChild(

            createHiddenInput(
                'productName',
                name
            )

        );


        form.appendChild(

            createHiddenInput(
                'productPrice',
                price.toFixed(2)
            )

        );


        form.appendChild(

            createHiddenInput(
                'productQty',
                quantity
            )

        );

    });


    return true;
}


/* =========================================================
   VALIDATE CARD
========================================================= */

function validateCard() {

    var cardInput =
        document.getElementById(
            'cardNumber'
        );

    var nameInput =
        document.getElementById(
            'cardName'
        );

    var expiryInput =
        document.getElementById(
            'expiry'
        );

    var cvvInput =
        document.getElementById(
            'cvv'
        );


    var card =
        cardInput.value
            .replace(/\s/g, '');


    var name =
        nameInput.value.trim();


    var exp =
        expiryInput.value.trim();


    var cvvValue =
        cvvInput.value.trim();


    if (!/^\d{16}$/.test(card)) {

        alert(
            'Please enter a valid 16-digit card number.'
        );

        cardInput.focus();

        return false;
    }


    if (!name) {

        alert(
            'Please enter card holder name.'
        );

        nameInput.focus();

        return false;
    }


    if (!/^\d{2}\s\/\s\d{2}$/.test(exp)) {

        alert(
            'Please enter expiry date in MM / YY format.'
        );

        expiryInput.focus();

        return false;
    }


    if (!/^\d{3}$/.test(cvvValue)) {

        alert(
            'Please enter a valid 3-digit CVV.'
        );

        cvvInput.focus();

        return false;
    }


    return true;
}


/* =========================================================
   PROCESS PAYMENT
========================================================= */

function processPayment() {


    /* ================= CART CHECK ================= */

    if (!Array.isArray(cart) ||
        cart.length === 0) {

        alert(
            'Your cart is empty. Please add a product first.'
        );

        return;
    }


    /* ================= TOTAL CHECK ================= */

    if (orderTotal <= 0) {

        alert(
            'Invalid order amount.'
        );

        return;
    }


    /* ================= ADDRESS VALIDATION ================= */

    var deliveryName =
        document.getElementById(
            'deliveryName'
        );

    var deliveryMobile =
        document.getElementById(
            'deliveryMobile'
        );

    var houseAddress =
        document.getElementById(
            'houseAddress'
        );

    var streetAddress =
        document.getElementById(
            'streetAddress'
        );

    var city =
        document.getElementById(
            'city'
        );

    var state =
        document.getElementById(
            'state'
        );

    var pinCode =
        document.getElementById(
            'pinCode'
        );


    if (!deliveryName.value.trim()) {

        alert(
            'Please enter your full name.'
        );

        deliveryName.focus();

        return;
    }


    if (!/^[0-9]{10}$/.test(
        deliveryMobile.value.trim()
    )) {

        alert(
            'Please enter a valid 10-digit mobile number.'
        );

        deliveryMobile.focus();

        return;
    }


    if (!houseAddress.value.trim()) {

        alert(
            'Please enter your House / Flat / Building.'
        );

        houseAddress.focus();

        return;
    }


    if (!streetAddress.value.trim()) {

        alert(
            'Please enter your Street / Area / Locality.'
        );

        streetAddress.focus();

        return;
    }


    if (!city.value.trim()) {

        alert(
            'Please enter your city.'
        );

        city.focus();

        return;
    }


    if (!state.value.trim()) {

        alert(
            'Please select your state.'
        );

        state.focus();

        return;
    }


    if (!/^[0-9]{6}$/.test(
        pinCode.value.trim()
    )) {

        alert(
            'Please enter a valid 6-digit PIN code.'
        );

        pinCode.focus();

        return;
    }


    /* ================= CARD ================= */

    if (selectedPaymentType === 'card') {

        if (!validateCard()) {

            return;
        }
    }


    /* ================= UPI ================= */

    if (selectedPaymentType === 'upi') {

        var upiInput =
            document.getElementById(
                'upiId'
            );


        var upi =
            upiInput.value.trim();


        if (!upi) {

            alert(
                'Please enter your UPI ID.'
            );

            upiInput.focus();

            return;
        }


        var upiPattern =
            /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+$/;


        if (!upiPattern.test(upi)) {

            alert(
                'Please enter a valid UPI ID.'
            );

            upiInput.focus();

            return;
        }
    }


    /* ================= NET BANKING ================= */

    if (selectedPaymentType === 'bank') {

        var selectedBank =
            document.querySelector(
                '.bank.selected'
            );


        if (!selectedBank) {

            alert(
                'Please select your bank.'
            );

            return;
        }
    }


    /* ================= QR ================= */

    if (selectedPaymentType === 'qr') {

        var confirmQR =
            confirm(

                'Continue with Demo QR Payment?\n\n' +

                'Amount: ' +

                formatPrice(orderTotal)

            );


        if (!confirmQR) {

            return;
        }
    }


    /* ================= COD ================= */

    if (selectedPaymentType === 'cod') {

        var confirmCOD =
            confirm(

                'Place this order with Cash on Delivery?\n\n' +

                'Amount: ' +

                formatPrice(orderTotal)

            );


        if (!confirmCOD) {

            return;
        }
    }


    /* ================= PREPARE FORM ================= */

    var prepared =
        prepareOrderForm();


    if (!prepared) {

        alert(
            'Unable to prepare order.'
        );

        return;
    }


    /* ================= BUTTON ================= */

    var payButton =
        document.getElementById(
            'payButton'
        );


    if (payButton) {

        payButton.disabled = true;

        payButton.innerHTML =

            '<i class="fa-solid fa-spinner fa-spin"></i> ' +

            'Processing...';
    }


    /* ================= SUBMIT ================= */

    var orderForm =
        document.getElementById(
            'orderForm'
        );


    if (orderForm) {

        orderForm.submit();
    }

}


/* =========================================================
   PAGE LOAD
========================================================= */

document.addEventListener(
    'DOMContentLoaded',
    function() {

        loadCart();


        var paymentMethod =
            document.getElementById(
                'paymentMethod'
            );


        if (paymentMethod) {

            paymentMethod.value =
                'Credit / Debit Card';
        }

    }
);

</script>


</body>

</html>