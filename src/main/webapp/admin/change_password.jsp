<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String adminName = (String) session.getAttribute("admin_id");

    if (adminName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Change Password - AK Shop</title>

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f5f7fb;
            color: #1f2937;
        }

        .admin-wrapper {
            display: flex;
            min-height: 100vh;
        }

        /* =========================
           SAME SIDEBAR
        ========================== */

        .admin-sidebar {
            width: 250px;
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            background: #111827;
            z-index: 100;
        }

        .admin-logo {
            height: 75px;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0 25px;
            color: #ffffff;
            font-size: 23px;
            font-weight: bold;
            border-bottom: 1px solid #374151;
        }

        .admin-logo i {
            color: #60a5fa;
            font-size: 28px;
        }

        .admin-menu {
            list-style: none;
            padding: 20px 12px;
            margin: 0;
        }

        .admin-menu li {
            margin-bottom: 6px;
        }

        .admin-menu a {
            display: flex;
            align-items: center;
            gap: 14px;
            color: #d1d5db;
            text-decoration: none;
            padding: 13px 15px;
            border-radius: 8px;
            transition: 0.25s;
            font-size: 15px;
        }

        .admin-menu a:hover,
        .admin-menu a.active {
            background: #2563eb;
            color: #ffffff;
        }

        .admin-menu a i {
            font-size: 19px;
        }

        .admin-menu .logout-link:hover {
            background: #dc2626;
        }

        /* =========================
           MAIN CONTENT
        ========================== */

        .admin-main {
            width: calc(100% - 250px);
            margin-left: 250px;
            padding: 25px;
        }

        .admin-topbar {
            background: #ffffff;
            padding: 18px 25px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            margin-bottom: 25px;
        }

        .admin-topbar h4 {
            margin: 0;
            color: #111827;
            font-size: 23px;
            font-weight: 700;
        }

        .admin-topbar p {
            margin: 5px 0 0;
            color: #6b7280;
            font-size: 14px;
        }

        .admin-profile {
            display: flex;
            align-items: center;
            gap: 9px;
            color: #374151;
            font-weight: 600;
        }

        .admin-profile i {
            color: #2563eb;
            font-size: 29px;
        }

        /* =========================
           PASSWORD CARD
        ========================== */

        .password-card {
            width: 100%;
            max-width: 650px;
            background: #ffffff;
            border-radius: 12px;
            padding: 30px;
            margin: 35px auto;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
        }

        .password-card h2 {
            margin: 0 0 7px;
            color: #111827;
            font-size: 23px;
        }

        .password-card > p {
            margin: 0 0 27px;
            color: #6b7280;
            font-size: 14px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 19px;
        }

        .form-group label {
            margin-bottom: 8px;
            color: #374151;
            font-size: 14px;
            font-weight: 600;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            top: 50%;
            left: 14px;
            color: #6b7280;
            transform: translateY(-50%);
            font-size: 17px;
        }

        .input-wrapper input {
            width: 100%;
            height: 47px;
            padding: 0 45px;
            border: 1px solid #d8dee8;
            border-radius: 8px;
            outline: none;
            font-family: Arial, sans-serif;
            font-size: 14px;
        }

        .input-wrapper input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .show-password {
            position: absolute;
            right: 13px;
            left: auto !important;
            top: 50%;
            transform: translateY(-50%);
            color: #6b7280;
            font-size: 17px;
            cursor: pointer;
        }

        .password-note {
            display: flex;
            gap: 9px;
            align-items: flex-start;
            padding: 13px;
            border-radius: 8px;
            background: #eff6ff;
            color: #1d4ed8;
            margin-bottom: 22px;
            font-size: 13px;
            line-height: 1.5;
        }

        .password-note i {
            font-size: 17px;
        }

        .change-btn {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            width: 100%;
            height: 48px;
            background: #2563eb;
            color: #ffffff;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
        }

        .change-btn:hover {
            background: #1d4ed8;
        }

        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 768px) {

            .admin-sidebar {
                width: 70px;
            }

            .admin-logo {
                padding: 0;
                justify-content: center;
            }

            .admin-logo span {
                display: none;
            }

            .admin-menu {
                padding: 20px 8px;
            }

            .admin-menu a {
                justify-content: center;
                padding: 14px 5px;
                font-size: 0;
            }

            .admin-menu a i {
                font-size: 21px;
            }

            .admin-main {
                width: calc(100% - 70px);
                margin-left: 70px;
                padding: 15px;
            }

            .admin-profile span {
                display: none;
            }

            .password-card {
                margin: 20px auto;
                padding: 24px 20px;
            }
        }

    </style>

</head>

<body>

<div class="admin-wrapper">

    <!-- =========================
         SAME SIDEBAR
    ========================== -->

    <aside class="admin-sidebar">

        <div class="admin-logo">
            <i class="bi bi-shop"></i>
            <span>AK Shop</span>
        </div>

        <ul class="admin-menu">

            <li>
                <a href="home.jsp">
                    <i class="bi bi-speedometer2"></i>
                    Dashboard
                </a>
            </li>

            <li>
                <a href="products.jsp">
                    <i class="bi bi-box-seam"></i>
                    Products
                </a>
            </li>

            <li>
                <a href="categories.jsp">
                    <i class="bi bi-tags"></i>
                    Categories
                </a>
            </li>

            <li>
                <a href="orders.jsp">
                    <i class="bi bi-cart-check"></i>
                    Orders
                </a>
            </li>

            <li>
                <a href="customers.jsp">
                    <i class="bi bi-people"></i>
                    Customers
                </a>
            </li>

            <li>
                <a href="payments.jsp">
                    <i class="bi bi-credit-card"></i>
                    Payments
                </a>
            </li>

            <li>
                <a href="reports.jsp">
                    <i class="bi bi-bar-chart"></i>
                    Reports
                </a>
            </li>

            <li>
                <a href="change_password.jsp" class="active">
                    <i class="bi bi-lock"></i>
                    Change Password
                </a>
            </li>

            <li>
                <a href="logout.jsp" class="logout-link">
                    <i class="bi bi-box-arrow-right"></i>
                    Logout
                </a>
            </li>

        </ul>

    </aside>

    <!-- =========================
         MAIN CONTENT
    ========================== -->

    <main class="admin-main">

        <div class="admin-topbar">

            <div>
                <h4>Change Password</h4>
                <p>Update your administrator account password.</p>
            </div>

            <div class="admin-profile">
                <i class="bi bi-person-circle"></i>
                <span><%= adminName %></span>
            </div>

        </div>

        <!-- CHANGE PASSWORD FORM -->

        <section class="password-card">

            <h2>
                <i class="bi bi-shield-lock"></i>
                Password Security
            </h2>

            <p>Enter your existing password and choose a strong new password.</p>

            <div class="password-note">
                <i class="bi bi-info-circle"></i>
                <span>
                    Use at least 8 characters with a combination of uppercase letters,
                    lowercase letters, numbers, and special characters.
                </span>
            </div>

            <form action="#" method="post" onsubmit="return validatePassword();">

                <div class="form-group">

                    <label for="currentPassword">Current Password</label>

                    <div class="input-wrapper">
                        <i class="bi bi-lock"></i>

                        <input type="password"
                               id="currentPassword"
                               name="currentPassword"
                               placeholder="Enter current password"
                               required>

                        <i class="bi bi-eye show-password"
                           onclick="togglePassword('currentPassword', this)"></i>
                    </div>

                </div>

                <div class="form-group">

                    <label for="newPassword">New Password</label>

                    <div class="input-wrapper">
                        <i class="bi bi-key"></i>

                        <input type="password"
                               id="newPassword"
                               name="newPassword"
                               placeholder="Enter new password"
                               required>

                        <i class="bi bi-eye show-password"
                           onclick="togglePassword('newPassword', this)"></i>
                    </div>

                </div>

                <div class="form-group">

                    <label for="confirmPassword">Confirm New Password</label>

                    <div class="input-wrapper">
                        <i class="bi bi-shield-lock"></i>

                        <input type="password"
                               id="confirmPassword"
                               name="confirmPassword"
                               placeholder="Confirm new password"
                               required>

                        <i class="bi bi-eye show-password"
                           onclick="togglePassword('confirmPassword', this)"></i>
                    </div>

                </div>

                <button type="submit" class="change-btn">
                    <i class="bi bi-check-circle"></i>
                    Change Password
                </button>

            </form>

        </section>

    </main>

</div>

<script>

    function togglePassword(inputId, icon) {

        const passwordInput = document.getElementById(inputId);

        if (passwordInput.type === "password") {
            passwordInput.type = "text";
            icon.classList.remove("bi-eye");
            icon.classList.add("bi-eye-slash");
        } else {
            passwordInput.type = "password";
            icon.classList.remove("bi-eye-slash");
            icon.classList.add("bi-eye");
        }
    }

    function validatePassword() {

        const newPassword = document.getElementById("newPassword").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (newPassword.length < 8) {
            alert("New password must contain at least 8 characters.");
            return false;
        }

        if (newPassword !== confirmPassword) {
            alert("New password and confirm password do not match.");
            return false;
        }

        return true;
    }

</script>

</body>
</html>