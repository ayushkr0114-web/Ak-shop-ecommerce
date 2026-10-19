<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Login | AYUSH LABEL</title>

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link rel="preconnect"
          href="https://fonts.gstatic.com"
          crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Poppins:wght@300;400;500;600&display=swap"
          rel="stylesheet">


<style>

/* =========================
   RESET
========================= */

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

.login-wrapper {
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

    border-top: 1px solid rgba(255, 255, 255, 0.15);
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
   LOGIN CARD
========================= */

.login-card {

    width: 100%;

    max-width: 535px;

    background: #ffffff;

    border: 1px solid #e5e1d8;

    border-radius: 18px;

    padding: 42px 55px;

    position: relative;

    box-shadow:
        0 20px 60px rgba(0, 0, 0, 0.08);
}


.login-card::before {

    content: "";

    position: absolute;

    top: 0;

    left: 18%;

    width: 64%;

    height: 2px;

    background:
        linear-gradient(
            90deg,
            transparent,
            #c99732,
            transparent
        );
}


/* Logo */

.login-logo {

    display: block;

    width: 155px;

    max-height: 100px;

    object-fit: contain;

    margin: 0 auto 15px;
}


/* Heading */

.login-heading {

    text-align: center;
}


.login-heading h2 {

    font-family: 'Cormorant Garamond', serif;

    font-size: 42px;

    font-weight: 600;

    color: #151515;

    margin-bottom: 4px;
}


.login-heading p {

    color: #888;

    font-size: 12px;
}


/* =========================
   ORNAMENT
========================= */

.ornament {

    width: 100%;

    display: flex;

    align-items: center;

    gap: 12px;

    margin: 20px 0 28px;
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
   SUCCESS MESSAGE
========================= */

.success-message {

    background: #f1fff5;

    border: 1px solid #b9e5c5;

    color: #23833d;

    padding: 10px 12px;

    border-radius: 7px;

    text-align: center;

    font-size: 12px;

    margin-bottom: 18px;
}


/* =========================
   ERROR MESSAGE
========================= */

.error-message {

    background: #fff4f4;

    border: 1px solid #efcccc;

    color: #c62828;

    padding: 10px 12px;

    border-radius: 7px;

    text-align: center;

    font-size: 12px;

    margin-bottom: 18px;
}


/* =========================
   INPUT
========================= */

.input-group {

    margin-bottom: 20px;
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
        0 0 0 3px rgba(201, 151, 50, 0.10);
}


/* Password eye */

.password-eye {

    position: absolute;

    right: 15px;

    top: 50%;

    transform: translateY(-50%);

    color: #777;

    cursor: pointer;

    font-size: 15px;

    user-select: none;
}


/* =========================
   OPTIONS
========================= */

.options {

    display: flex;

    align-items: center;

    justify-content: space-between;

    margin: 5px 0 23px;
}


.remember {

    display: flex;

    align-items: center;

    gap: 7px;

    color: #666;

    font-size: 11px;

    cursor: pointer;
}


.remember input {

    width: 14px;

    height: 14px;

    accent-color: #b98627;

    cursor: pointer;
}


.forgot {

    color: #a47721;

    font-size: 11px;

    text-decoration: none;

    transition: 0.3s;
}


.forgot:hover {

    color: #111;

    text-decoration: underline;
}


/* =========================
   LOGIN BUTTON
========================= */

.login-btn {

    width: 100%;

    height: 52px;

    border: none;

    border-radius: 7px;

    background:
        linear-gradient(
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


.login-btn::after {

    content: "→";

    position: absolute;

    right: 18px;

    font-size: 20px;

    top: 50%;

    transform: translateY(-52%);

    transition: 0.3s;
}


.login-btn:hover {

    background:
        linear-gradient(
            90deg,
            #bd8c2c,
            #e2b85e,
            #bd8c2c
        );

    color: #111;

    box-shadow:
        0 8px 25px rgba(189, 140, 44, 0.25);
}


.login-btn:hover::after {

    right: 13px;
}


/* =========================
   DIVIDER
========================= */

.divider {

    display: flex;

    align-items: center;

    gap: 12px;

    margin: 25px 0;

    color: #aaa;

    font-size: 10px;
}


.divider::before,
.divider::after {

    content: "";

    height: 1px;

    background: #e3dfd7;

    flex: 1;
}


.divider span {

    width: 29px;

    height: 29px;

    border-radius: 50%;

    display: flex;

    align-items: center;

    justify-content: center;

    background: #faf3e2;

    color: #986d20;

    font-size: 9px;

    font-weight: 600;
}


/* =========================
   REGISTER BUTTON
========================= */

.register-btn {

    width: 100%;

    height: 52px;

    border: none;

    border-radius: 7px;

    background:
        linear-gradient(
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

    display: flex;

    align-items: center;

    justify-content: center;

    text-decoration: none;

    transition: all 0.35s ease;
}


.register-btn::after {

    content: "→";

    position: absolute;

    right: 18px;

    font-size: 20px;

    top: 50%;

    transform: translateY(-52%);

    transition: 0.3s;
}


.register-btn:hover {

    background:
        linear-gradient(
            90deg,
            #bd8c2c,
            #e2b85e,
            #bd8c2c
        );

    color: #111;

    box-shadow:
        0 8px 25px rgba(189, 140, 44, 0.25);
}


.register-btn:hover::after {

    right: 13px;
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

    .login-card {
        padding: 38px 40px;
    }

    .features {
        gap: 12px;
    }

    .feature-text span {
        display: none;
    }
}


@media (max-width: 800px) {

    .login-wrapper {
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

    .login-card {

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

    .login-heading h2 {
        font-size: 36px;
    }

    .login-card {
        padding: 30px 20px;
    }

    .options {

        align-items: flex-start;

        gap: 10px;
    }

    .forgot {
        white-space: nowrap;
    }
}

</style>

</head>


<body>


<div class="login-wrapper">


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

                THE FASHION

                <br>

                <span>YOU LOVE.</span>

            </h1>


            <div class="gold-line"></div>


            <p>

                Discover the latest collection of premium fashion,
                accessories and lifestyle products crafted to define
                your unique style.

            </p>

        </div>


        <div class="features">


            <div class="feature">

                <div class="feature-icon">
                    ✓
                </div>

                <div class="feature-text">

                    <strong>
                        PREMIUM QUALITY
                    </strong>

                    <span>
                        Curated with perfection
                    </span>

                </div>

            </div>


            <div class="feature">

                <div class="feature-icon">
                    ◇
                </div>

                <div class="feature-text">

                    <strong>
                        SECURE SHOPPING
                    </strong>

                    <span>
                        100% safe & secure
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


        <div class="login-card">


            <img src="../images/icons/logo-01.png"
                 class="login-logo"
                 alt="AYUSH LABEL">


            <div class="login-heading">

                <h2>
                    Welcome Back
                </h2>

                <p>
                    Login to your account to continue shopping
                </p>

            </div>


            <div class="ornament">

                <span>
                    ◇
                </span>

            </div>


            <!-- =========================
                 SUCCESS MESSAGE
            ========================== -->

            <%
                String registered =
                    request.getParameter("registered");

                if ("true".equals(registered)) {
            %>

                <div class="success-message">

                    Registration successful!
                    Please login with your email/phone and password.

                </div>

            <%
                }
            %>



            <!-- =========================
                 ERROR MESSAGE
            ========================== -->

            <%
                String error =
                    request.getParameter("error");

                if ("true".equals(error)) {
            %>

                <div class="error-message">

                    Invalid email/phone number or password.
                    Please try again.

                </div>

            <%
                } else if ("inactive".equals(error)) {
            %>

                <div class="error-message">

                    Your account is inactive.
                    Please contact customer support.

                </div>

            <%
                } else if ("empty".equals(error)) {
            %>

                <div class="error-message">

                    Please enter email/phone and password.

                </div>

            <%
                }
            %>



            <!-- =========================
                 LOGIN FORM
            ========================== -->

            <form action="loginprocess.jsp"
                  method="post">


                <!-- EMAIL OR PHONE -->

                <div class="input-group">

                    <label for="loginId">

                        EMAIL OR PHONE NUMBER

                    </label>


                    <div class="input-wrapper">

                        <span class="input-icon">
                            👤
                        </span>


                        <input

                            type="text"

                            name="loginId"

                            id="loginId"

                            placeholder="Enter your email or phone number"

                            autocomplete="username"

                            required>

                    </div>

                </div>



                <!-- PASSWORD -->

                <div class="input-group">

                    <label for="password">

                        PASSWORD

                    </label>


                    <div class="input-wrapper">

                        <span class="input-icon">
                            🔒
                        </span>


                        <input

                            type="password"

                            id="password"

                            name="password"

                            placeholder="Enter your password"

                            autocomplete="current-password"

                            required>


                        <span

                            class="password-eye"

                            id="passwordEye"

                            onclick="togglePassword()">

                            👁

                        </span>

                    </div>

                </div>



                <!-- OPTIONS -->

                <div class="options">


                    <label class="remember">

                        <input

                            type="checkbox"

                            name="remember">

                        Remember me

                    </label>


                    <a

                        href="forgotpassword.jsp"

                        class="forgot">

                        Forgot Password?

                    </a>


                </div>



                <!-- LOGIN BUTTON -->

                <button

                    type="submit"

                    class="login-btn">

                    LOGIN

                </button>


            </form>



            <!-- DIVIDER -->

            <div class="divider">

                <span>
                    OR
                </span>

            </div>



            <!-- REGISTER -->

            <a

                href="register.jsp"

                class="register-btn">

                REGISTER

            </a>


        </div>



        <!-- SECURITY BAR -->

        <div class="security-bar">


            <div class="security-item">

                <span>
                    ✓
                </span>

                100% SECURE PAYMENT

            </div>


            <div class="security-item">

                <span>
                    ◇
                </span>

                FREE SHIPPING & RETURNS

            </div>


            <div class="security-item">

                <span>
                    ↻
                </span>

                EASY RETURNS

            </div>


        </div>


    </section>


</div>



<script>

function togglePassword() {

    const password =
        document.getElementById("password");

    const eye =
        document.getElementById("passwordEye");


    if (password.type === "password") {

        password.type = "text";

        eye.innerHTML = "🙈";

    } else {

        password.type = "password";

        eye.innerHTML = "👁";

    }

}

</script>


</body>

</html>