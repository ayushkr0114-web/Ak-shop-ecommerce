<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Register | AYUSH LABEL</title>

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

.register-wrapper {

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


/* =========================
   LOGO
========================= */

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
   REGISTER CARD
========================= */

.register-card {

    width: 100%;

    max-width: 535px;

    background: #ffffff;

    border: 1px solid #e5e1d8;

    border-radius: 18px;

    padding: 38px 55px;

    position: relative;

    box-shadow:
        0 20px 60px rgba(0,0,0,0.08);
}


.register-card::before {

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
   REGISTER LOGO
========================= */

.register-logo {

    display: block;

    width: 145px;

    max-height: 90px;

    object-fit: contain;

    margin: 0 auto 10px;
}


/* =========================
   HEADING
========================= */

.register-heading {

    text-align: center;
}


.register-heading h2 {

    font-family: 'Cormorant Garamond', serif;

    font-size: 40px;

    font-weight: 600;

    color: #151515;

    margin-bottom: 3px;
}


.register-heading p {

    color: #888;

    font-size: 11px;
}


/* =========================
   ORNAMENT
========================= */

.ornament {

    width: 100%;

    display: flex;

    align-items: center;

    gap: 12px;

    margin: 16px 0 22px;
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
   ERROR / SUCCESS
========================= */

.error-message {

    background: #fff4f4;

    border: 1px solid #efcccc;

    color: #c62828;

    padding: 10px 12px;

    border-radius: 7px;

    text-align: center;

    font-size: 11px;

    margin-bottom: 18px;
}


.success-message {

    background: #f1faf3;

    border: 1px solid #c8e6cc;

    color: #2e7d32;

    padding: 10px 12px;

    border-radius: 7px;

    text-align: center;

    font-size: 11px;

    margin-bottom: 18px;
}


/* =========================
   INPUT
========================= */

.input-group {

    margin-bottom: 17px;

    width: 100%;
}


.input-group label {

    display: block;

    color: #292929;

    font-size: 11px;

    font-weight: 500;

    margin-bottom: 7px;
}


.input-wrapper {

    position: relative;

    width: 100%;
}


.input-icon {

    position: absolute;

    left: 14px;

    top: 50%;

    transform: translateY(-50%);

    color: #888;

    font-size: 15px;

    z-index: 2;
}


.input-wrapper input {

    width: 100%;

    height: 49px;

    border: 1px solid #dcd8d0;

    border-radius: 7px;

    background: #ffffff;

    outline: none;

    padding: 0 42px;

    font-family: 'Poppins', sans-serif;

    font-size: 11px;

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
   CONTACT ROW
========================= */

.contact-row {

    display: flex;

    gap: 14px;
}


.contact-row .input-group {

    flex: 1;
}


.contact-note {

    color: #999;

    font-size: 9px;

    margin-top: -8px;

    margin-bottom: 17px;

    line-height: 1.5;
}


/* =========================
   PASSWORD EYE
========================= */

.password-eye {

    position: absolute;

    right: 14px;

    top: 50%;

    transform: translateY(-50%);

    color: #777;

    cursor: pointer;

    font-size: 14px;

    user-select: none;
}


/* =========================
   TERMS
========================= */

.terms {

    display: flex;

    align-items: flex-start;

    gap: 7px;

    margin: 3px 0 18px;

    color: #777;

    font-size: 10px;

    line-height: 1.5;
}


.terms input {

    margin-top: 2px;

    accent-color: #b98627;

    cursor: pointer;
}


.terms a {

    color: #a47721;

    text-decoration: none;
}


.terms a:hover {

    color: #111;

    text-decoration: underline;
}


/* =========================
   REGISTER BUTTON
========================= */

.register-btn {

    width: 100%;

    height: 51px;

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

    font-size: 11px;

    font-weight: 600;

    letter-spacing: 2px;

    cursor: pointer;

    position: relative;

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


.register-btn:hover::after {

    right: 13px;
}


/* =========================
   LOGIN LINK
========================= */

.login-link {

    text-align: center;

    margin-top: 19px;

    color: #888;

    font-size: 10px;
}


.login-link a {

    color: #a47721;

    font-weight: 600;

    text-decoration: none;

    margin-left: 5px;

    transition: 0.3s;
}


.login-link a:hover {

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

    .register-card {

        padding: 35px 40px;
    }

    .features {

        gap: 12px;
    }

    .feature-text span {

        display: none;
    }
}


@media (max-width: 800px) {

    .register-wrapper {

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

    .register-card {

        max-width: 600px;

        padding: 35px 25px;
    }

    .security-bar {

        display: none;
    }
}


@media (max-width: 600px) {

    .contact-row {

        display: block;
    }

    .contact-row .input-group {

        margin-bottom: 17px;
    }
}


@media (max-width: 450px) {

    .left-section {

        min-height: 320px;
    }

    .left-content h1 {

        font-size: 40px;
    }

    .register-heading h2 {

        font-size: 36px;
    }

    .register-card {

        padding: 30px 20px;
    }
}

</style>

</head>


<body>


<div class="register-wrapper">


<!-- =========================
     LEFT SECTION
========================= -->

<section class="left-section">

    <img src="../images/icons/logo-01.png"
         class="brand-logo"
         alt="AYUSH LABEL">


    <div class="left-content">

        <div class="small-title">
            AYUSH LABEL
        </div>

        <h1>
            YOUR STYLE
            <br>
            <span>STARTS HERE.</span>
        </h1>

        <div class="gold-line"></div>

        <p>
            Create your AYUSH LABEL account and discover
            premium fashion, accessories and lifestyle
            products crafted to define your unique style.
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
========================= -->

<section class="right-section">


<div class="register-card">


<img src="../images/icons/logo-01.png"
     class="register-logo"
     alt="AYUSH LABEL">


<div class="register-heading">

    <h2>
        Create Account
    </h2>

    <p>
        Join AYUSH LABEL and start shopping
    </p>

</div>


<div class="ornament">

    <span>◇</span>

</div>


<!-- =========================
     SERVER MESSAGE
========================= -->

<%

String error = request.getParameter("error");

String success = request.getParameter("success");

if ("name".equals(error)) {

%>

<div class="error-message">
    Please enter your full name.
</div>

<%

}

if ("contact".equals(error)) {

%>

<div class="error-message">
    Please enter either Email or Phone Number.
</div>

<%

}

if ("password".equals(error)) {

%>

<div class="error-message">
    Password and Confirm Password do not match.
</div>

<%

}

if ("duplicate".equals(error)) {

%>

<div class="error-message">
    This Email or Phone Number is already registered.
</div>

<%

}

if ("db".equals(error)) {

%>

<div class="error-message">
    Registration failed. Please try again.
</div>

<%

}

if ("success".equals(success)) {

%>

<div class="success-message">
    Registration successful. Please login.
</div>

<%

}

%>


<!-- =========================
     REGISTER FORM
========================= -->

<form action="registerprocess.jsp"
      method="post"
      onsubmit="return validateRegister()">


<!-- FULL NAME -->

<div class="input-group">

    <label for="fullname">
        FULL NAME
    </label>

    <div class="input-wrapper">

        <span class="input-icon">
            👤
        </span>

        <input
            type="text"
            name="fullname"
            id="fullname"
            placeholder="Enter your full name"
            autocomplete="name"
            required>

    </div>

</div>


<!-- EMAIL + PHONE -->

<div class="contact-row">


<div class="input-group">

    <label for="email">
        EMAIL ADDRESS
    </label>

    <div class="input-wrapper">

        <span class="input-icon">
            ✉
        </span>

        <input
            type="email"
            name="email"
            id="email"
            placeholder="Enter email (optional)"
            autocomplete="email">

    </div>

</div>


<div class="input-group">

    <label for="phone">
        PHONE NUMBER
    </label>

    <div class="input-wrapper">

        <span class="input-icon">
            ☎
        </span>

        <input
            type="tel"
            name="phone"
            id="phone"
            placeholder="Enter phone (optional)"
            autocomplete="tel"
            maxlength="10">

    </div>

</div>


</div>


<div class="contact-note">
    Enter at least one contact detail: Email address or Phone Number.
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
            name="password"
            id="password"
            placeholder="Create password"
            autocomplete="new-password"
            required>

        <span
            class="password-eye"
            id="passwordEye"
            onclick="togglePassword('password','passwordEye')">
            👁
        </span>

    </div>

</div>


<!-- CONFIRM PASSWORD -->

<div class="input-group">

    <label for="confirmPassword">
        CONFIRM PASSWORD
    </label>

    <div class="input-wrapper">

        <span class="input-icon">
            🔒
        </span>

        <input
            type="password"
            name="confirmPassword"
            id="confirmPassword"
            placeholder="Confirm password"
            autocomplete="new-password"
            required>

        <span
            class="password-eye"
            id="confirmPasswordEye"
            onclick="togglePassword('confirmPassword','confirmPasswordEye')">
            👁
        </span>

    </div>

</div>


<!-- TERMS -->

<label class="terms">

    <input
        type="checkbox"
        id="terms"
        required>

    <span>

        I agree to the
        <a href="#" onclick="return false;">
            Terms & Conditions
        </a>

        and

        <a href="#" onclick="return false;">
            Privacy Policy
        </a>.

    </span>

</label>


<!-- REGISTER BUTTON -->

<button
    type="submit"
    class="register-btn">

    CREATE ACCOUNT

</button>


</form>


<!-- LOGIN LINK -->

<div class="login-link">

    Already have an account?

    <a href="login.jsp">
        Login
    </a>

</div>


</div>


<!-- SECURITY BAR -->

<div class="security-bar">

    <div class="security-item">

        <span>✓</span>

        SECURE SHOPPING

    </div>


    <div class="security-item">

        <span>◇</span>

        PREMIUM QUALITY

    </div>


    <div class="security-item">

        <span>↻</span>

        EASY RETURNS

    </div>

</div>


</section>


</div>


<script>


/* =========================
   PASSWORD TOGGLE
========================= */

function togglePassword(inputId, eyeId) {

    const password =
        document.getElementById(inputId);

    const eye =
        document.getElementById(eyeId);


    if (password.type === "password") {

        password.type = "text";

        eye.innerHTML = "🙈";

    } else {

        password.type = "password";

        eye.innerHTML = "👁";

    }

}


/* =========================
   REGISTER VALIDATION
========================= */

function validateRegister() {

    const email =
        document.getElementById("email").value.trim();

    const phone =
        document.getElementById("phone").value.trim();

    const password =
        document.getElementById("password").value;

    const confirmPassword =
        document.getElementById("confirmPassword").value;


    /* EMAIL OR PHONE */

    if (email === "" && phone === "") {

        alert("Please enter either Email Address or Phone Number.");

        return false;
    }


    /* PHONE VALIDATION */

    if (phone !== "") {

        const phonePattern = /^[0-9]{10}$/;

        if (!phonePattern.test(phone)) {

            alert("Please enter a valid 10 digit phone number.");

            return false;
        }
    }


    /* PASSWORD MATCH */

    if (password !== confirmPassword) {

        alert("Password and Confirm Password do not match.");

        return false;
    }


    return true;
}

</script>


</body>

</html>