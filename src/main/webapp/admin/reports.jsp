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

    <title>Reports - AK Shop</title>

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
           REPORT STATISTICS
        ========================== */

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 21px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
        }

        .stat-icon {
            height: 55px;
            width: 55px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 24px;
            flex-shrink: 0;
        }

        .green {
            background: #16a34a;
        }

        .blue {
            background: #2563eb;
        }

        .purple {
            background: #9333ea;
        }

        .orange {
            background: #ea580c;
        }

        .stat-card p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }

        .stat-card h3 {
            margin: 5px 0 4px;
            color: #111827;
            font-size: 24px;
        }

        .stat-card small {
            color: #9ca3af;
            font-size: 12px;
        }

        /* =========================
           REPORT TABLE
        ========================== */

        .page-card {
            background: #ffffff;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            margin-bottom: 25px;
        }

        .table-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 20px;
        }

        .table-heading h2 {
            margin: 0;
            color: #111827;
            font-size: 20px;
        }

        .download-btn {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: #2563eb;
            color: #ffffff;
            border: none;
            border-radius: 7px;
            padding: 10px 13px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
        }

        .download-btn:hover {
            background: #1d4ed8;
            color: #ffffff;
        }

        .table-box {
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 700px;
            border-collapse: collapse;
        }

        th {
            padding: 14px 16px;
            background: #f9fafb;
            color: #4b5563;
            text-align: left;
            font-size: 13px;
        }

        td {
            padding: 15px 16px;
            color: #374151;
            border-top: 1px solid #e5e7eb;
            font-size: 14px;
        }

        tr:hover td {
            background: #f9fafb;
        }

        .rank {
            width: 32px;
            height: 32px;
            background: #dbeafe;
            color: #1d4ed8;
            display: flex;
            justify-content: center;
            align-items: center;
            border-radius: 50%;
            font-size: 13px;
            font-weight: 700;
        }

        .product-name {
            font-weight: 600;
            color: #1f2937;
        }

        .revenue {
            color: #15803d;
            font-weight: 700;
        }

        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 1100px) {
            .stats-row {
                grid-template-columns: repeat(2, 1fr);
            }
        }

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

            .table-heading {
                flex-direction: column;
                align-items: flex-start;
            }
        }

        @media (max-width: 500px) {
            .stats-row {
                grid-template-columns: 1fr;
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
                <a href="reports.jsp" class="active">
                    <i class="bi bi-bar-chart"></i>
                    Reports
                </a>
            </li>

            <li>
                <a href="change_password.jsp">
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
                <h4>Business Reports</h4>
                <p>View sales, orders, customers, and business performance.</p>
            </div>

            <div class="admin-profile">
                <i class="bi bi-person-circle"></i>
                <span><%= adminName %></span>
            </div>

        </div>

        <!-- REPORT SUMMARY CARDS -->

        <div class="stats-row">

            <div class="stat-card">
                <div class="stat-icon green">
                    <i class="bi bi-currency-rupee"></i>
                </div>

                <div>
                    <p>Total Revenue</p>
                    <h3>₹85,000</h3>
                    <small>All time sales</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon blue">
                    <i class="bi bi-calendar-day"></i>
                </div>

                <div>
                    <p>Today's Sales</p>
                    <h3>₹5,000</h3>
                    <small>Today</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon purple">
                    <i class="bi bi-cart-check"></i>
                </div>

                <div>
                    <p>Total Orders</p>
                    <h3>450</h3>
                    <small>All orders</small>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon orange">
                    <i class="bi bi-people"></i>
                </div>

                <div>
                    <p>Total Customers</p>
                    <h3>320</h3>
                    <small>Registered users</small>
                </div>
            </div>

        </div>

        <!-- TOP SELLING PRODUCTS -->

        <section class="page-card">

            <div class="table-heading">

                <h2>
                    <i class="bi bi-trophy"></i>
                    Top Selling Products
                </h2>

                <button type="button" class="download-btn">
                    <i class="bi bi-download"></i>
                    Download Report
                </button>

            </div>

            <div class="table-box">

                <table>

                    <thead>
                        <tr>
                            <th>Rank</th>
                            <th>Product</th>
                            <th>Category</th>
                            <th>Quantity Sold</th>
                            <th>Revenue</th>
                        </tr>
                    </thead>

                    <tbody>

                        <tr>
                            <td>
                                <div class="rank">1</div>
                            </td>

                            <td class="product-name">Sample T-Shirt</td>
                            <td>Men</td>
                            <td>150</td>
                            <td class="revenue">₹1,49,850</td>
                        </tr>

                        <tr>
                            <td>
                                <div class="rank">2</div>
                            </td>

                            <td class="product-name">Casual Shoes</td>
                            <td>Footwear</td>
                            <td>100</td>
                            <td class="revenue">₹1,99,900</td>
                        </tr>

                        <tr>
                            <td>
                                <div class="rank">3</div>
                            </td>

                            <td class="product-name">Classic Shirt</td>
                            <td>Men</td>
                            <td>80</td>
                            <td class="revenue">₹79,920</td>
                        </tr>

                    </tbody>

                </table>

            </div>

        </section>

    </main>

</div>

</body>
</html>