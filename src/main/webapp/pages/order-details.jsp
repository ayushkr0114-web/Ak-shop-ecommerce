<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"
    import="java.math.BigDecimal"
%>

<%
    // ============================================================
    // GET ORDER ID
    // ============================================================

    String orderId = request.getParameter("orderId");

    if (orderId == null || orderId.trim().isEmpty()) {
        response.sendRedirect(
            request.getContextPath() + "/index.jsp"
        );
        return;
    }

    orderId = orderId.trim();


    // ============================================================
    // VARIABLES
    // ============================================================

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String customerName = "Guest";
    String customerEmail = "";
    String shippingAddress = "";

    String totalAmount = "0.00";

    String orderDate = "";
    String orderStatus = "";

    String paymentId = "";
    String paymentMethod = "";
    String paymentStatus = "";
    String paymentDate = "";


    try {

        // ========================================================
        // DATABASE CONNECTION
        // ========================================================

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );

        String dbUrl =
            "jdbc:oracle:thin:@localhost:1521:XE";

        String dbUser =
            "system";

        String dbPassword =
            "ayush";


        con = DriverManager.getConnection(
            dbUrl,
            dbUser,
            dbPassword
        );


        // ========================================================
        // GET ORDER + PAYMENT DETAILS
        // ========================================================

        String sql =
            "SELECT " +
            "o.ORDER_ID, " +
            "o.CUSTOMER_NAME AS ORDER_CUSTOMER_NAME, " +
            "o.CUSTOMER_EMAIL, " +
            "o.TOTAL_AMOUNT, " +
            "o.ORDER_DATE, " +
            "o.STATUS AS ORDER_STATUS, " +
            "o.SHIPPING_ADDRESS, " +
            "p.PAYMENT_ID, " +
            "p.PAYMENT_METHOD, " +
            "p.PAYMENT_STATUS, " +
            "p.PAYMENT_DATE " +
            "FROM AK_ORDER o " +
            "LEFT JOIN AK_PAYMENT p " +
            "ON o.ORDER_ID = p.ORDER_ID " +
            "WHERE o.ORDER_ID = ?";


        ps = con.prepareStatement(sql);

        ps.setString(
            1,
            orderId
        );

        rs = ps.executeQuery();


        // ========================================================
        // CHECK ORDER
        // ========================================================

        if (!rs.next()) {

            response.sendRedirect(
                request.getContextPath() + "/index.jsp"
            );

            return;
        }


        // ========================================================
        // ORDER INFORMATION
        // ========================================================

        String dbCustomerName =
            rs.getString("ORDER_CUSTOMER_NAME");

        if (dbCustomerName != null &&
            !dbCustomerName.trim().isEmpty()) {

            customerName =
                dbCustomerName;
        }


        customerEmail =
            rs.getString("CUSTOMER_EMAIL");

        if (customerEmail == null) {
            customerEmail = "";
        }


        shippingAddress =
            rs.getString("SHIPPING_ADDRESS");

        if (shippingAddress == null ||
            shippingAddress.trim().isEmpty()) {

            shippingAddress = "Not provided";
        }


        BigDecimal amount =
            rs.getBigDecimal("TOTAL_AMOUNT");

        if (amount != null) {

            totalAmount =
                amount.toString();
        }


        Timestamp orderTimestamp =
            rs.getTimestamp("ORDER_DATE");

        if (orderTimestamp != null) {

            orderDate =
                orderTimestamp.toString();
        }


        orderStatus =
            rs.getString("ORDER_STATUS");

        if (orderStatus == null ||
            orderStatus.trim().isEmpty()) {

            orderStatus = "-";
        }


        // ========================================================
        // PAYMENT INFORMATION
        // ========================================================

        paymentId =
            rs.getString("PAYMENT_ID");

        if (paymentId == null ||
            paymentId.trim().isEmpty()) {

            paymentId = "Not available";
        }


        paymentMethod =
            rs.getString("PAYMENT_METHOD");

        if (paymentMethod == null ||
            paymentMethod.trim().isEmpty()) {

            paymentMethod = "Not available";
        }


        paymentStatus =
            rs.getString("PAYMENT_STATUS");

        if (paymentStatus == null ||
            paymentStatus.trim().isEmpty()) {

            paymentStatus = "Not available";
        }


        Timestamp paymentTimestamp =
            rs.getTimestamp("PAYMENT_DATE");

        if (paymentTimestamp != null) {

            paymentDate =
                paymentTimestamp.toString();
        } else {

            paymentDate = "Not available";
        }


        // ========================================================
        // STATUS CLASS
        // ========================================================

        String orderStatusClass =
            "status-other";

        if ("Processing".equalsIgnoreCase(orderStatus)) {

            orderStatusClass =
                "status-processing";

        } else if ("Shipped".equalsIgnoreCase(orderStatus)) {

            orderStatusClass =
                "status-shipped";

        } else if ("Delivered".equalsIgnoreCase(orderStatus)) {

            orderStatusClass =
                "status-delivered";

        } else if ("Cancelled".equalsIgnoreCase(orderStatus)) {

            orderStatusClass =
                "status-cancelled";
        }


        String paymentStatusClass =
            "status-other";

        if ("PAID".equalsIgnoreCase(paymentStatus)) {

            paymentStatusClass =
                "status-paid";

        } else if ("PENDING".equalsIgnoreCase(paymentStatus)) {

            paymentStatusClass =
                "status-pending";

        } else if ("FAILED".equalsIgnoreCase(paymentStatus)) {

            paymentStatusClass =
                "status-failed";
        }

%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Order Details - AK Shop</title>


    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f5f5f5;
            font-family: Arial, sans-serif;
            color: #222;
        }

        .container {
            width: 92%;
            max-width: 1050px;
            margin: 40px auto;
        }

        /* ================= HEADER ================= */

        .header {
            background: #ffffff;
            padding: 28px;
            border: 1px solid #ddd;
            margin-bottom: 20px;
        }

        .header h1 {
            margin: 0 0 12px;
            font-size: 30px;
        }

        .header p {
            margin: 6px 0;
            color: #666;
        }

        .order-id {
            color: #222;
            font-weight: bold;
        }

        /* ================= CARD ================= */

        .card {
            background: #ffffff;
            border: 1px solid #ddd;
            margin-bottom: 20px;
        }

        .card-header {
            padding: 18px 20px;
            border-bottom: 1px solid #ddd;
            font-size: 18px;
            font-weight: bold;
        }

        .card-body {
            padding: 20px;
        }

        /* ================= INFO GRID ================= */

        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .info {
            border: 1px solid #eee;
            padding: 16px;
            background: #fff;
            min-height: 75px;
        }

        .info small {
            display: block;
            color: #777;
            margin-bottom: 7px;
            font-size: 13px;
        }

        .info strong {
            font-size: 15px;
            word-break: break-word;
        }

        /* ================= STATUS ================= */

        .status-paid {
            color: #198754;
            font-weight: bold;
        }

        .status-pending {
            color: #d97706;
            font-weight: bold;
        }

        .status-failed {
            color: #c62828;
            font-weight: bold;
        }

        .status-processing {
            color: #2563eb;
            font-weight: bold;
        }

        .status-shipped {
            color: #7c3aed;
            font-weight: bold;
        }

        .status-delivered {
            color: #198754;
            font-weight: bold;
        }

        .status-cancelled {
            color: #c62828;
            font-weight: bold;
        }

        .status-other {
            color: #555;
            font-weight: bold;
        }

        /* ================= TOTAL ================= */

        .amount-box {
            margin-top: 20px;
            padding: 22px;
            background: #fafafa;
            border: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .amount-label {
            font-size: 16px;
            color: #555;
        }

        .amount {
            font-size: 26px;
            font-weight: bold;
        }

        /* ================= ADDRESS ================= */

        .address-box {
            margin-top: 20px;
            padding: 18px;
            border: 1px solid #eee;
            background: #fafafa;
        }

        .address-box small {
            display: block;
            color: #777;
            margin-bottom: 8px;
        }

        .address-box strong {
            line-height: 1.6;
        }

        /* ================= BUTTONS ================= */

        .buttons {
            margin-top: 25px;
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn {
            display: inline-block;
            padding: 13px 22px;
            text-decoration: none;
            border: 1px solid #222;
            cursor: pointer;
            font-size: 14px;
            border-radius: 4px;
        }

        .primary {
            background: #222;
            color: #fff;
        }

        .primary:hover {
            background: #000;
        }

        .secondary {
            background: #fff;
            color: #222;
        }

        .secondary:hover {
            background: #f2f2f2;
        }

        /* ================= NOTE ================= */

        .note {
            margin-top: 20px;
            padding: 16px;
            background: #fafafa;
            border-left: 4px solid #222;
            color: #555;
            line-height: 1.6;
        }

        /* ================= MOBILE ================= */

        @media(max-width: 700px) {

            .container {
                width: 94%;
                margin: 20px auto;
            }

            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 24px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .amount-box {
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }

        }

    </style>

</head>


<body>

<div class="container">


    <!-- =======================================================
         HEADER
         ======================================================= -->

    <div class="header">

        <h1>
            Order Details
        </h1>

        <p>
            Order ID:
            <span class="order-id">
                <%= orderId %>
            </span>
        </p>

        <p>
            Order Date:
            <%= orderDate %>
        </p>

    </div>


    <!-- =======================================================
         ORDER INFORMATION
         ======================================================= -->

    <div class="card">

        <div class="card-header">
            Order Information
        </div>

        <div class="card-body">

            <div class="info-grid">


                <div class="info">

                    <small>
                        Order ID
                    </small>

                    <strong>
                        <%= orderId %>
                    </strong>

                </div>


                <div class="info">

                    <small>
                        Customer Name
                    </small>

                    <strong>
                        <%= customerName %>
                    </strong>

                </div>


                <div class="info">

                    <small>
                        Customer Email
                    </small>

                    <strong>
                        <%= customerEmail.isEmpty()
                            ? "Not provided"
                            : customerEmail %>
                    </strong>

                </div>


                <div class="info">

                    <small>
                        Order Status
                    </small>

                    <strong class="<%= orderStatusClass %>">

                        <%= orderStatus %>

                    </strong>

                </div>


                <div class="info">

                    <small>
                        Order Date
                    </small>

                    <strong>
                        <%= orderDate %>
                    </strong>

                </div>


                <div class="info">

                    <small>
                        Payment Date
                    </small>

                    <strong>
                        <%= paymentDate %>
                    </strong>

                </div>


            </div>


            <!-- SHIPPING ADDRESS -->

            <div class="address-box">

                <small>
                    Shipping Address
                </small>

                <strong>
                    <%= shippingAddress %>
                </strong>

            </div>


            <!-- TOTAL -->

            <div class="amount-box">

                <div class="amount-label">
                    Total Order Amount
                </div>

                <div class="amount">
                    ₹<%= totalAmount %>
                </div>

            </div>

        </div>

    </div>


    <!-- =======================================================
         PAYMENT INFORMATION
         ======================================================= -->

    <div class="card">

        <div class="card-header">
            Payment Information
        </div>

        <div class="card-body">

            <div class="info-grid">


                <div class="info">

                    <small>
                        Payment ID
                    </small>

                    <strong>
                        <%= paymentId %>
                    </strong>

                </div>


                <div class="info">

                    <small>
                        Payment Method
                    </small>

                    <strong>
                        <%= paymentMethod %>
                    </strong>

                </div>


                <div class="info">

                    <small>
                        Payment Status
                    </small>

                    <strong class="<%= paymentStatusClass %>">

                        <%= paymentStatus %>

                    </strong>

                </div>


                <div class="info">

                    <small>
                        Payment Amount
                    </small>

                    <strong>
                        ₹<%= totalAmount %>
                    </strong>

                </div>


            </div>

        </div>

    </div>


    <!-- =======================================================
         ORDER NOTE
         ======================================================= -->

    <div class="note">

        <strong>Order Information:</strong>

        Your order has been recorded successfully.

        Order and payment information has been loaded
        directly from the AK_ORDER and AK_PAYMENT tables.

    </div>


    <!-- =======================================================
         BUTTONS
         ======================================================= -->

    <div class="buttons">

        <a
            href="<%= request.getContextPath() %>/index.jsp"
            class="btn primary">

            Continue Shopping

        </a>


        <button
            onclick="window.print()"
            class="btn secondary">

            Print Order

        </button>

    </div>


</div>

</body>

</html>


<%

    } catch (Exception e) {

%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Order Error - AK Shop</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f5f5f5;
            padding: 40px;
        }

        .error-box {
            max-width: 700px;
            margin: auto;
            background: #fff;
            border: 1px solid #ddd;
            padding: 30px;
            border-radius: 8px;
        }

        h2 {
            color: #c62828;
        }

        pre {
            background: #f5f5f5;
            padding: 15px;
            white-space: pre-wrap;
            word-break: break-word;
        }

        a {
            display: inline-block;
            margin-top: 15px;
            padding: 12px 20px;
            background: #222;
            color: #fff;
            text-decoration: none;
            border-radius: 4px;
        }

    </style>

</head>

<body>

    <div class="error-box">

        <h2>
            Unable to Load Order
        </h2>

        <p>
            There was a problem while loading the order details.
        </p>

        <pre><%= e.getMessage() %></pre>

        <a href="<%= request.getContextPath() %>/index.jsp">
            Back to Shop
        </a>

    </div>

</body>

</html>

<%

    } finally {

        // ========================================================
        // CLOSE RESULTSET
        // ========================================================

        try {

            if (rs != null) {
                rs.close();
            }

        } catch (Exception ignored) {
        }


        // ========================================================
        // CLOSE STATEMENT
        // ========================================================

        try {

            if (ps != null) {
                ps.close();
            }

        } catch (Exception ignored) {
        }


        // ========================================================
        // CLOSE CONNECTION
        // ========================================================

        try {

            if (con != null) {
                con.close();
            }

        } catch (Exception ignored) {
        }

    }

%>