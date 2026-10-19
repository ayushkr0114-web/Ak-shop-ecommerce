<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Forgot Password | AYUSH LABEL</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Poppins:wght@300;400;500;600&display=swap"
          rel="stylesheet">


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

html,
body {
    width: 100%;
    min-height: 100%;
}

body {
    font-family: 'Poppins', sans-serif;
    background: #f8f7f4;
    color: #111;
    overflow-x: hidden;
}


/* =========================
   MAIN WRAPPER
========================= */

.forgot-wrapper {

    width: 100%;
    min-height: 100vh;

    display: flex;
}


/* =========================
   LEFT SECTION
========================= */

.left-section {

    width: 48%;
    min-height: 100vh;

    position: relative;
    overflow: hidden;

    display: flex;
    flex-direction: column;
    justify-content: space-between;

    padding: 55px 65px;

    background:

        radial-gradient(
            circle at 15% 15%,
            rgba(211, 164, 60, 0.12),
            transparent 30%
        ),

        linear-gradient(
            135deg,
            #080808 0%,
            #151515 50%,
            #080808 100%
        );

    border-right: 2px solid #b88a2d;
}


/* Decorative circles */

.left-section::before {

    content: "";

    position: absolute;

    width: 500px;
    height: 500px;

    border-radius: 50%;

    border: 1px solid rgba(211, 164, 60, 0.12);

    right: -250px;
    top: 80px;

    pointer-events: none;
}


.left-section::after {

    content: "";

    position: absolute;

    width: 350px;
    height: 350px;

    border-radius: 50%;

    border: 1px solid rgba(211, 164, 60, 0.08);

    left: -200px;
    bottom: 50px;

    pointer-events: none;
}


/* Logo */

.brand-logo {

    position: relative;
    z-index: 2;

    width: 230px;
    max-height: 130px;

    object-fit: contain;
    object-position: left center;
}


/* =========================
   LEFT CONTENT
========================= */

.left-content {

    position: relative;
    z-index: 2;

    max-width: 500px;
}


.small-title {

    color: #d2a448;

    font-size: 12px;
    font-weight: 500;

    letter-spacing: 5px;

    margin-bottom: 18px;
}


.left-content h1 {

    font-family: 'Cormorant Garamond', serif;

    color: #ffffff;

    font-size: clamp(45px, 4.2vw, 70px);

    font-weight: 600;

    line-height: 0.95;

    letter-spacing: 1px;

    margin-bottom: 28px;
}


.left-content h1 span {
    color: #d4a94b;
}


.gold-line {

    width: 85px;
    height: 2px;

    background: linear-gradient(
        90deg,
        #8b6218,
        #e3bc68,
        #8b6218
    );

    margin-bottom: 28px;
}


.left-content p {

    color: #b9b9b9;

    font-size: 13px;

    line-height: 1.9;

    max-width: 430px;
}


/* =========================
   FEATURES
========================= */

.features {

    position: relative;
    z-index: 2;

    display: flex;

    gap: 25px;

    padding-top: 25px;

    border-top: 1px solid rgba(255,255,255,0.15);
}


.feature {

    flex: 1;

    display: flex;

    align-items: center;

    gap: 10px;
}


.feature-icon {

    width: 38px;
    height: 38px;

    min-width: 38px;

    border: 1px solid #b88a2d;

    border-radius: 50%;

    display: flex;

    justify-content: center;

    align-items: center;

    color: #d7aa4c;

    font-size: 15px;
}


.feature-text strong {

    display: block;

    color: #ffffff;

    font-size: 9px;

    letter-spacing: 0.5px;

    margin-bottom: 4px;
}


.feature-text span {

    color: #888;

    font-size: 9px;
}


/* =========================
   RIGHT SECTION
========================= */

.right-section {

    width: 52%;
    min-height: 100vh;

    display: flex;

    align-items: center;
    justify-content: center;

    padding: 40px;

    position: relative;

    background:

        radial-gradient(
            circle at 90% 10%,
            rgba(211, 164, 60, 0.10),
            transparent 30%
        ),

        radial-gradient(
            circle at 10% 90%,
            rgba(211, 164, 60, 0.06),
            transparent 30%
        ),

        #fafaf8;
}


/* =========================
   FORGOT CARD
========================= */

.forgot-card {

    width: 100%;

    max-width: 535px;

    background: #ffffff;

    border: 1px solid #e5e1d8;

    border-radius: 18px;

    padding: 48px 55px;

    position: relative;

    box-shadow:
        0 20px 60px rgba(0,0,0,0.08);
}


.forgot-card::before {

    content: "";

    position: absolute;

    top: 0;
    left: 18%;

    width: 64%;
    height: 2px;

    background: linear-gradient(
        90deg,
        transparent,
        #c99732,
        transparent
    );
}


/* =========================
   LOGO
========================= */

.forgot-logo {

    display: block;

    width: 155px;
    max-height: 100px;

    object-fit: contain;

    margin: 0 auto 15px;
}


/* =========================
   HEADING
========================= */

.forgot-heading {

    text-align: center;
}


.forgot-heading h2 {

    font-family: 'Cormorant Garamond', serif;

    font-size: 42px;

    font-weight: 600;

    color: #151515;

    margin-bottom: 5px;
}


.forgot-heading p {

    color: #888;

    font-size: 12px;

    line-height: 1.7;

    max-width: 370px;

    margin: auto;
}


/* =========================
   ORNAMENT
========================= */

.ornament {

    width: 100%;

    display: flex;

    align-items: center;

    gap: 12px;

    margin: 24px 0 30px;
}


.ornament::before,
.ornament::after {

    content: "";

    height: 1px;

    background: #dfd3ba;

    flex: 1;
}


.ornament span {

    color: #b98627;

    font-size: 16px;
}


/* =========================
   INPUT
========================= */

.input-group {

    margin-bottom: 22px;
}


.input-group label {

    display: block;

    color: #292929;

    font-size: 12px;

    font-weight: 500;

    margin-bottom: 8px;
}


.input-wrapper {

    position: relative;

    width: 100%;
}


.input-icon {

    position: absolute;

    left: 15px;

    top: 50%;

    transform: translateY(-50%);

    color: #888;

    font-size: 16px;

    z-index: 2;
}


.input-wrapper input {

    width: 100%;

    height: 51px;

    border: 1px solid #dcd8d0;

    border-radius: 7px;

    background: #ffffff;

    outline: none;

    padding: 0 45px;

    font-family: 'Poppins', sans-serif;

    font-size: 12px;

    color: #222;

    transition: 0.3s;
}


.input-wrapper input::placeholder {
    color: #aaa;
}


.input-wrapper input:focus {

    border-color: #c99732;

    box-shadow:
        0 0 0 3px rgba(201,151,50,0.10);
}


/* =========================
   RESET BUTTON
========================= */

.reset-btn {

    width: 100%;

    height: 52px;

    border: none;

    border-radius: 7px;

    background: linear-gradient(
        90deg,
        #0c0c0c,
        #242424,
        #0c0c0c
    );

    color: #e4ba5e;

    font-family: 'Poppins', sans-serif;

    font-size: 12px;

    font-weight: 600;

    letter-spacing: 2px;

    cursor: pointer;

    position: relative;

    transition: all 0.35s ease;
}


.reset-btn::after {

    content: "→";

    position: absolute;

    right: 18px;

    font-size: 20px;

    top: 50%;

    transform: translateY(-52%);

    transition: 0.3s;
}


.reset-btn:hover {

    background: linear-gradient(
        90deg,
        #bd8c2c,
        #e2b85e,
        #bd8c2c
    );

    color: #111;

    box-shadow:
        0 8px 25px rgba(189,140,44,0.25);
}


.reset-btn:hover::after {
    right: 13px;
}


/* =========================
   BACK TO LOGIN
========================= */

.back-login {

    text-align: center;

    margin-top: 22px;

    color: #888;

    font-size: 11px;
}


.back-login a {

    color: #a47721;

    font-weight: 600;

    text-decoration: none;

    margin-left: 5px;

    transition: 0.3s;
}


.back-login a:hover {

    color: #111;

    text-decoration: underline;
}


/* =========================
   SECURITY BAR
========================= */

.security-bar {

    position: absolute;

    bottom: 12px;

    left: 50%;

    transform: translateX(-50%);

    width: 90%;

    display: flex;

    justify-content: center;

    gap: 35px;

    color: #999;

    font-size: 9px;

    letter-spacing: 0.3px;
}


.security-item {

    display: flex;

    align-items: center;

    gap: 6px;
}


.security-item span {

    color: #b98627;

    font-size: 13px;
}


/* =========================
   RESPONSIVE
========================= */

@media (max-width: 1000px) {

    .left-section {
        padding: 45px;
    }

    .right-section {
        padding: 30px;
    }

    .forgot-card {
        padding: 40px;
    }

    .features {
        gap: 12px;
    }

    .feature-text span {
        display: none;
    }
}


@media (max-width: 800px) {

    .forgot-wrapper {
        display: block;
    }

    .left-section {

        width: 100%;

        min-height: 360px;

        padding: 35px 25px;

        text-align: center;

        justify-content: center;
    }

    .left-section::before,
    .left-section::after {
        display: none;
    }

    .brand-logo {

        width: 190px;

        max-height: 110px;

        margin: 0 auto 20px;
    }

    .left-content {
        margin: 0 auto;
    }

    .small-title {
        margin-bottom: 12px;
    }

    .left-content h1 {

        font-size: 45px;

        margin-bottom: 18px;
    }

    .gold-line {

        margin: 0 auto 20px;
    }

    .left-content p {

        margin: auto;

        font-size: 12px;
    }

    .features {
        display: none;
    }

    .right-section {

        width: 100%;

        min-height: auto;

        padding: 30px 18px 70px;
    }

    .forgot-card {

        max-width: 600px;

        padding: 35px 25px;
    }

    .security-bar {
        display: none;
    }
}


@media (max-width: 450px) {

    .left-section {
        min-height: 320px;
    }

    .left-content h1 {
        font-size: 40px;
    }

    .forgot-heading h2 {
        font-size: 36px;
    }

    .forgot-card {
        padding: 30px 20px;
    }
}

</style>

</head>


<body>


<div class="forgot-wrapper">


    <!-- =========================
         LEFT SECTION
    ========================== -->

    <section class="left-section">

        <img src="../images/icons/logo-01.png"
             class="brand-logo"
             alt="AYUSH LABEL">


        <div class="left-content">

            <div class="small-title">
                AYUSH LABEL
            </div>


            <h1>

                SECURE YOUR

                <br>

                <span>ACCOUNT.</span>

            </h1>


            <div class="gold-line"></div>


            <p>

                Don't worry. It happens to everyone.
                Enter your registered email address and
                we'll help you securely recover access
                to your AYUSH LABEL account.

            </p>

        </div>


        <div class="features">


            <div class="feature">

                <div class="feature-icon">
                    ✓
                </div>

                <div class="feature-text">

                    <strong>
                        SECURE RECOVERY
                    </strong>

                    <span>
                        Protected account recovery
                    </span>

                </div>

            </div>


            <div class="feature">

                <div class="feature-icon">
                    ◇
                </div>

                <div class="feature-text">

                    <strong>
                        YOUR PRIVACY
                    </strong>

                    <span>
                        Your information stays safe
                    </span>

                </div>

            </div>


            <div class="feature">

                <div class="feature-icon">
                    ♡
                </div>

                <div class="feature-text">

                    <strong>
                        CUSTOMER SUPPORT
                    </strong>

                    <span>
                        We're here to help
                    </span>

                </div>

            </div>


        </div>

    </section>



    <!-- =========================
         RIGHT SECTION
    ========================== -->

    <section class="right-section">


        <div class="forgot-card">


            <img src="../images/icons/logo-01.png"
                 class="forgot-logo"
                 alt="AYUSH LABEL">


            <div class="forgot-heading">

                <h2>
                    Forgot Password?
                </h2>

                <p>
                    Enter your registered email address
                    to reset your account password.
                </p>

            </div>


            <div class="ornament">
                <span>◇</span>
            </div>



            <!-- FORM -->

            <form action="#" method="post">


                <div class="input-group">

                    <label for="email">
                        REGISTERED EMAIL
                    </label>

                    <div class="input-wrapper">

                        <span class="input-icon">
                            ✉
                        </span>

                        <input
                            type="email"
                            name="email"
                            id="email"
                            placeholder="Enter your registered email"
                            autocomplete="email"
                            required>

                    </div>

                </div>


                <button
                    type="submit"
                    class="reset-btn">

                    SEND RESET LINK

                </button>


            </form>



            <div class="back-login">

                Remember your password?

                <a href="login.jsp">
                    Back to Login
                </a>

            </div>


        </div>



        <!-- SECURITY BAR -->

        <div class="security-bar">

            <div class="security-item">

                <span>✓</span>

                SECURE ACCOUNT

            </div>


            <div class="security-item">

                <span>◇</span>

                PRIVATE & SAFE

            </div>


            <div class="security-item">

                <span>↻</span>

                ACCOUNT RECOVERY

            </div>

        </div>


    </section>


</div>

</body>

