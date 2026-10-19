<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"%>

<%

    String adminName = (String) session.getAttribute("admin_id");

    if (adminName == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String dbUser = "system";
    String dbPass = "ayush";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    int totalProducts = 0;
    int totalOrders = 0;
    int totalCustomers = 0;
    double totalRevenue = 0;

    try {

        Class.forName(driver);

        con = DriverManager.getConnection(url, dbUser, dbPass);

        /*
         * =========================
         * TOTAL PRODUCTS
         * =========================
         */

        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM AK_PRODUCT"
        );

        rs = ps.executeQuery();

        if (rs.next()) {
            totalProducts = rs.getInt(1);
        }

        rs.close();
        ps.close();


        /*
         * =========================
         * TOTAL ORDERS
         * =========================
         */

        ps = con.prepareStatement(
            "SELECT COUNT(*) FROM AK_ORDER"
        );

        rs = ps.executeQuery();

        if (rs.next()) {
            totalOrders = rs.getInt(1);
        }

        rs.close();
        ps.close();


        /*
         * =========================
         * TOTAL CUSTOMERS
         * =========================
         *
         * Customer count is calculated
         * from unique customer names
         * present in AK_ORDER.
         */

        ps = con.prepareStatement(
            "SELECT COUNT(DISTINCT CUSTOMER_NAME) FROM AK_ORDER"
        );

        rs = ps.executeQuery();

        if (rs.next()) {
            totalCustomers = rs.getInt(1);
        }

        rs.close();
        ps.close();


        /*
         * =========================
         * TOTAL REVENUE
         * =========================
         *
         * Cancelled orders are excluded.
         */

        ps = con.prepareStatement(
            "SELECT NVL(SUM(TOTAL_AMOUNT),0) " +
            "FROM AK_ORDER " +
            "WHERE UPPER(NVL(STATUS,'PENDING')) <> 'CANCELLED'"
        );

        rs = ps.executeQuery();

        if (rs.next()) {
            totalRevenue = rs.getDouble(1);
        }

        rs.close();
        ps.close();

    } catch (Exception e) {

        e.printStackTrace();

    } finally {

        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}

    }

%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard - AK Shop</title>

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
           SIDEBAR
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
           MAIN
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
           STATISTICS
        ========================== */

        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-top: 25px;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 21px;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            transition: 0.25s;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.09);
        }

        .stat-icon {
            height: 55px;
            width: 55px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ffffff;
            font-size: 25px;
            flex-shrink: 0;
        }

        .blue {
            background: #2563eb;
        }

        .green {
            background: #16a34a;
        }

        .orange {
            background: #ea580c;
        }

        .purple {
            background: #9333ea;
        }

        .stat-card p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }

        .stat-card h3 {
            margin: 5px 0;
            color: #111827;
            font-size: 25px;
        }

        .stat-card small {
            color: #9ca3af;
            font-size: 12px;
        }

        /* =========================
           SECTIONS
        ========================== */

        .dashboard-section {
            margin-top: 30px;
        }

        .section-heading {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 14px;
        }

        .section-heading h4 {
            margin: 0;
            color: #1f2937;
            font-size: 19px;
            font-weight: 700;
        }

        .section-heading a {
            color: #2563eb;
            font-size: 14px;
            text-decoration: none;
            font-weight: 600;
        }

        .section-heading a:hover {
            text-decoration: underline;
        }

        /* =========================
           QUICK ACTIONS
        ========================== */

        .quick-actions {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
        }

        .quick-action {
            background: #ffffff;
            color: #1f2937;
            text-decoration: none;
            padding: 22px 12px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            transition: 0.25s;
            font-weight: 600;
        }

        .quick-action:hover {
            background: #2563eb;
            color: #ffffff;
            transform: translateY(-3px);
        }

        .quick-action i {
            font-size: 22px;
        }

        /* =========================
           TABLE
        ========================== */

        .table-box {
            overflow-x: auto;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 650px;
        }

        th {
            padding: 15px 18px;
            background: #f9fafb;
            color: #4b5563;
            text-align: left;
            font-size: 13px;
        }

        td {
            padding: 15px 18px;
            border-top: 1px solid #e5e7eb;
            font-size: 14px;
            color: #374151;
        }

        tr:hover td {
            background: #f9fafb;
        }

        .badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .badge-success {
            background: #dcfce7;
            color: #15803d;
        }

        .badge-warning {
            background: #fef3c7;
            color: #b45309;
        }

        .badge-danger {
            background: #fee2e2;
            color: #dc2626;
        }

        .badge-blue {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .update-stock-btn {
            display: inline-block;
            background: #2563eb;
            color: white;
            padding: 8px 12px;
            font-size: 13px;
            border-radius: 6px;
            text-decoration: none;
        }

        .update-stock-btn:hover {
            background: #1d4ed8;
            color: white;
        }

        .empty-row {
            text-align: center;
            padding: 30px;
            color: #9ca3af;
        }

        /* =========================
           RESPONSIVE
        ========================== */

        @media (max-width: 1100px) {

            .stats-row,
            .quick-actions {
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
                font-size: 0;
                padding: 14px 5px;
            }

            .admin-menu a i {
                font-size: 21px;
            }

            .admin-main {
                width: calc(100% - 70px);
                margin-left: 70px;
                padding: 15px;
            }

            .admin-topbar {
                padding: 16px;
            }

            .admin-profile span {
                display: none;
            }

        }

        @media (max-width: 500px) {

            .stats-row,
            .quick-actions {
                grid-template-columns: 1fr;
            }

            .admin-topbar h4 {
                font-size: 19px;
            }

        }

    </style>

</head>


<body>

<div class="admin-wrapper">

    <!-- =========================
         SIDEBAR
    ========================== -->

    <aside class="admin-sidebar">

        <div class="admin-logo">

            <i class="bi bi-shop"></i>

            <span>AK Shop</span>

        </div>


        <ul class="admin-menu">

            <li>

                <a href="home.jsp" class="active">

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


        <!-- TOPBAR -->

        <div class="admin-topbar">

            <div>

                <h4>Admin Dashboard</h4>

                <p>Welcome back, <%= adminName %></p>

            </div>


            <div class="admin-profile">

                <i class="bi bi-person-circle"></i>

                <span><%= adminName %></span>

            </div>

        </div>


        <!-- =========================
             STATISTICS
        ========================== -->

        <div class="stats-row">


            <!-- PRODUCTS -->

            <div class="stat-card">

                <div class="stat-icon blue">

                    <i class="bi bi-box-seam"></i>

                </div>

                <div>

                    <p>Total Products</p>

                    <h3><%= totalProducts %></h3>

                    <small>Products in store</small>

                </div>

            </div>


            <!-- ORDERS -->

            <div class="stat-card">

                <div class="stat-icon green">

                    <i class="bi bi-cart-check"></i>

                </div>

                <div>

                    <p>Total Orders</p>

                    <h3><%= totalOrders %></h3>

                    <small>All orders</small>

                </div>

            </div>


            <!-- REVENUE -->

            <div class="stat-card">

                <div class="stat-icon orange">

                    <i class="bi bi-currency-rupee"></i>

                </div>

                <div>

                    <p>Total Revenue</p>

                    <h3>
                        ₹<%= String.format("%.2f", totalRevenue) %>
                    </h3>

                    <small>From non-cancelled orders</small>

                </div>

            </div>


            <!-- CUSTOMERS -->

            <div class="stat-card">

                <div class="stat-icon purple">

                    <i class="bi bi-people"></i>

                </div>

                <div>

                    <p>Total Customers</p>

                    <h3><%= totalCustomers %></h3>

                    <small>Unique customers</small>

                </div>

            </div>

        </div>


        <!-- =========================
             QUICK ACTIONS
        ========================== -->

        <section class="dashboard-section">

            <div class="section-heading">

                <h4>Quick Actions</h4>

            </div>


            <div class="quick-actions">

                <a href="products.jsp?action=add"
                   class="quick-action">

                    <i class="bi bi-plus-circle"></i>

                    Add Product

                </a>


                <a href="categories.jsp?action=add"
                   class="quick-action">

                    <i class="bi bi-tag"></i>

                    Add Category

                </a>


                <a href="orders.jsp"
                   class="quick-action">

                    <i class="bi bi-eye"></i>

                    View Orders

                </a>


                <a href="reports.jsp"
                   class="quick-action">

                    <i class="bi bi-file-earmark-bar-graph"></i>

                    View Reports

                </a>

            </div>

        </section>


        <!-- =========================
             RECENT ORDERS
        ========================== -->

        <section class="dashboard-section">

            <div class="section-heading">

                <h4>Recent Orders</h4>

                <a href="orders.jsp">
                    View All Orders
                </a>

            </div>


            <div class="table-box">

                <table>

                    <thead>

                        <tr>

                            <th>Order ID</th>

                            <th>Customer</th>

                            <th>Amount</th>

                            <th>Date</th>

                            <th>Status</th>

                        </tr>

                    </thead>


                    <tbody>

<%

    Connection orderCon = null;
    PreparedStatement orderPs = null;
    ResultSet orderRs = null;

    try {

        Class.forName(driver);

        orderCon = DriverManager.getConnection(
            url,
            dbUser,
            dbPass
        );

        orderPs = orderCon.prepareStatement(

            "SELECT ORDER_ID, CUSTOMER_NAME, TOTAL_AMOUNT, " +
            "ORDER_DATE, STATUS " +
            "FROM AK_ORDER " +
            "ORDER BY ORDER_DATE DESC " +
            "FETCH FIRST 5 ROWS ONLY"

        );

        orderRs = orderPs.executeQuery();

        boolean hasRecentOrders = false;


        while (orderRs.next()) {

            hasRecentOrders = true;

            String orderId =
                orderRs.getString("ORDER_ID");

            String customer =
                orderRs.getString("CUSTOMER_NAME");

            double amount =
                orderRs.getDouble("TOTAL_AMOUNT");

            Timestamp orderDate =
                orderRs.getTimestamp("ORDER_DATE");

            String status =
                orderRs.getString("STATUS");


            if (status == null) {
                status = "Pending";
            }


            String badgeClass = "badge-warning";


            if ("Delivered".equalsIgnoreCase(status)) {

                badgeClass = "badge-success";

            }
            else if ("Cancelled".equalsIgnoreCase(status)) {

                badgeClass = "badge-danger";

            }
            else if ("Shipped".equalsIgnoreCase(status)) {

                badgeClass = "badge-blue";

            }
            else if ("Processing".equalsIgnoreCase(status)) {

                badgeClass = "badge-warning";

            }

%>

                        <tr>

                            <td>

                                <strong style="color:#2563eb;">
                                    #<%= orderId %>
                                </strong>

                            </td>


                            <td>

                                <%= customer %>

                            </td>


                            <td>

                                <strong>
                                    ₹<%= String.format("%.2f", amount) %>
                                </strong>

                            </td>


                            <td>

                                <%

                                    if (orderDate != null) {

                                        out.print(
                                            orderDate.toString()
                                            .replace(".0", "")
                                        );

                                    } else {

                                        out.print("-");

                                    }

                                %>

                            </td>


                            <td>

                                <span class="badge <%= badgeClass %>">

                                    <%= status %>

                                </span>

                            </td>

                        </tr>

<%

        }


        if (!hasRecentOrders) {

%>

                        <tr>

                            <td colspan="5"
                                class="empty-row">

                                <i class="bi bi-cart-x"
                                   style="font-size:30px;"></i>

                                <br><br>

                                No orders available.

                            </td>

                        </tr>

<%

        }


    } catch (Exception e) {

%>

                        <tr>

                            <td colspan="5"
                                class="empty-row"
                                style="color:#dc2626;">

                                Unable to load orders.

                            </td>

                        </tr>

<%

    } finally {

        try {
            if (orderRs != null)
                orderRs.close();
        } catch (Exception e) {}

        try {
            if (orderPs != null)
                orderPs.close();
        } catch (Exception e) {}

        try {
            if (orderCon != null)
                orderCon.close();
        } catch (Exception e) {}

    }

%>

                    </tbody>

                </table>

            </div>

        </section>


        <!-- =========================
             LOW STOCK PRODUCTS
        ========================== -->

        <section class="dashboard-section">

            <div class="section-heading">

                <h4>Low Stock Products</h4>

                <a href="products.jsp">
                    Manage Products
                </a>

            </div>


            <div class="table-box">

                <table>

                    <thead>

                        <tr>

                            <th>Product</th>

                            <th>Category</th>

                            <th>Stock Available</th>

                            <th>Action</th>

                        </tr>

                    </thead>


                    <tbody>

<%

    Connection productCon = null;
    PreparedStatement productPs = null;
    ResultSet productRs = null;

    try {

        Class.forName(driver);

        productCon = DriverManager.getConnection(
            url,
            dbUser,
            dbPass
        );


        productPs = productCon.prepareStatement(

            "SELECT PRODUCT_ID, PRODUCT_NAME, CATEGORY, STOCK " +
            "FROM AK_PRODUCT " +
            "WHERE STOCK <= 5 " +
            "ORDER BY STOCK ASC " +
            "FETCH FIRST 5 ROWS ONLY"

        );


        productRs = productPs.executeQuery();

        boolean hasLowStock = false;


        while (productRs.next()) {

            hasLowStock = true;

            String productId =
                productRs.getString("PRODUCT_ID");

            String productName =
                productRs.getString("PRODUCT_NAME");

            String category =
                productRs.getString("CATEGORY");

            int stock =
                productRs.getInt("STOCK");

%>

                        <tr>

                            <td>

                                <strong>
                                    <%= productName %>
                                </strong>

                            </td>


                            <td>

                                <%= category %>

                            </td>


                            <td>

                                <%

                                    if (stock == 0) {

                                %>

                                    <span class="badge badge-danger">
                                        Out of Stock
                                    </span>

                                <%

                                    }
                                    else if (stock <= 2) {

                                %>

                                    <span class="badge badge-danger">
                                        Only <%= stock %> left
                                    </span>

                                <%

                                    }
                                    else {

                                %>

                                    <span class="badge badge-warning">
                                        Only <%= stock %> left
                                    </span>

                                <%

                                    }

                                %>

                            </td>


                            <td>

                                <a href="products.jsp?edit=<%= productId %>"
                                   class="update-stock-btn">

                                    <i class="bi bi-pencil"></i>

                                    Update Stock

                                </a>

                            </td>

                        </tr>

<%

        }


        if (!hasLowStock) {

%>

                        <tr>

                            <td colspan="4"
                                class="empty-row">

                                <i class="bi bi-check-circle"
                                   style="font-size:30px;color:#16a34a;"></i>

                                <br><br>

                                All products have sufficient stock.

                            </td>

                        </tr>

<%

        }


    } catch (Exception e) {

%>

                        <tr>

                            <td colspan="4"
                                class="empty-row"
                                style="color:#dc2626;">

                                Unable to load stock information.

                            </td>

                        </tr>

<%

    } finally {

        try {
            if (productRs != null)
                productRs.close();
        } catch (Exception e) {}

        try {
            if (productPs != null)
                productPs.close();
        } catch (Exception e) {}

        try {
            if (productCon != null)
                productCon.close();
        } catch (Exception e) {}

    }

%>

                    </tbody>

                </table>

            </div>

        </section>


    </main>

</div>

</body>

</html>