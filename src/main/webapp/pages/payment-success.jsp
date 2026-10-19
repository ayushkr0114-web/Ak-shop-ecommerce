<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"
%>

<%
    String orderId = request.getParameter("orderId");
    String transactionId = request.getParameter("transactionId");

    if (orderId == null || orderId.trim().isEmpty()) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    String customerName = "";
    String totalAmount = "0.00";
    String paymentMethod = "";
    String paymentStatus = "";
    String paymentDate = "";

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String errorMessage = "";

    try {

        // =====================================================
        // ORACLE DATABASE CONNECTION
        // =====================================================

        Class.forName("oracle.jdbc.driver.OracleDriver");

        String dbUrl = "jdbc:oracle:thin:@localhost:1521:XE";
        String dbUser = "system";
        String dbPassword = "ayush";

        con = DriverManager.getConnection(
            dbUrl,
            dbUser,
            dbPassword
        );


        // =====================================================
        // GET PAYMENT / ORDER INFORMATION
        // =====================================================

        String sql =
            "SELECT PAYMENT_ID, ORDER_ID, CUSTOMER_NAME, " +
            "AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS, PAYMENT_DATE " +
            "FROM AK_PAYMENT " +
            "WHERE ORDER_ID = ?";

        ps = con.prepareStatement(sql);

        ps.setString(1, orderId);

        rs = ps.executeQuery();


        if (rs.next()) {

            String databasePaymentId =
                rs.getString("PAYMENT_ID");

            if (transactionId == null ||
                transactionId.trim().isEmpty()) {

                transactionId = databasePaymentId;
            }

            customerName =
                rs.getString("CUSTOMER_NAME");

            if (customerName == null ||
                customerName.trim().isEmpty()) {

                customerName = "Guest";
            }

            if (rs.getBigDecimal("AMOUNT") != null) {

                totalAmount =
                    rs.getBigDecimal("AMOUNT").toString();
            }

            paymentMethod =
                rs.getString("PAYMENT_METHOD");

            paymentStatus =
                rs.getString("PAYMENT_STATUS");

            Timestamp paymentTimestamp =
                rs.getTimestamp("PAYMENT_DATE");

            if (paymentTimestamp != null) {

                paymentDate =
                    paymentTimestamp.toString();
            }

        } else {

            errorMessage =
                "Order information not found for Order ID: "
                + orderId;
        }


    } catch (Exception e) {

        errorMessage = e.getMessage();

    } finally {

        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception ignored) {}

        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception ignored) {}

        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception ignored) {}
    }


    String statusClass = "pending";

    if ("PAID".equalsIgnoreCase(paymentStatus)) {
        statusClass = "paid";
    }
%>


<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Order Successful - AK Shop</title>


    <style>

        * {
            box-sizing: border-box;
        }

        body {

            margin: 0;

            font-family: Arial, sans-serif;

            background: #f7f7f7;

            color: #222;
        }

        .container {

            width: 90%;

            max-width: 650px;

            margin: 70px auto;
        }

        .success-card {

            background: #fff;

            padding: 40px;

            text-align: center;

            border: 1px solid #ddd;
        }

        .success-icon {

            width: 75px;

            height: 75px;

            border-radius: 50%;

            background: #222;

            color: #fff;

            display: flex;

            align-items: center;

            justify-content: center;

            margin: 0 auto 25px;

            font-size: 35px;
        }

        h1 {

            margin-bottom: 10px;
        }

        .message {

            color: #777;

            margin-bottom: 30px;
        }

        .details {

            text-align: left;

            border-top: 1px solid #eee;

            border-bottom: 1px solid #eee;

            padding: 20px 0;
        }

        .row {

            display: flex;

            justify-content: space-between;

            gap: 20px;

            padding: 10px 0;
        }

        .label {

            color: #777;
        }

        .value {

            font-weight: bold;

            text-align: right;

            word-break: break-word;
        }

        .paid {

            color: #198754;
        }

        .pending {

            color: #d97706;
        }

        .buttons {

            margin-top: 30px;

            display: flex;

            gap: 12px;

            justify-content: center;

            flex-wrap: wrap;
        }

        .btn {

            padding: 13px 22px;

            text-decoration: none;

            border: 1px solid #222;

            display: inline-block;
        }

        .btn-primary {

            background: #222;

            color: white;
        }

        .btn-secondary {

            color: #222;

            background: white;
        }

        .error-box {

            background: #fff;

            border: 1px solid #dc3545;

            color: #dc3545;

            padding: 20px;

            margin-bottom: 20px;

            text-align: left;

            word-break: break-word;
        }


        @media (max-width: 600px) {

            .container {

                width: 94%;

                margin: 30px auto;
            }

            .success-card {

                padding: 25px;
            }

            .row {

                flex-direction: column;

                gap: 5px;
            }

            .value {

                text-align: left;
            }

        }

    </style>

</head>


<body>


<div class="container">


<% if (!errorMessage.isEmpty()) { %>

    <div class="error-box">

        <strong>
            Unable to load order information.
        </strong>

        <br><br>

        <%= errorMessage %>

    </div>

<% } %>


<div class="success-card">


    <div class="success-icon">
        ✓
    </div>


    <h1>
        Order Successful!
    </h1>


    <p class="message">

        Thank you for shopping with AK Shop.

        Your order has been placed successfully.

    </p>


    <div class="details">


        <!-- ORDER ID -->

        <div class="row">

            <span class="label">
                Order ID
            </span>

            <span class="value">
                #<%= orderId %>
            </span>

        </div>


        <!-- TRANSACTION / PAYMENT ID -->

        <div class="row">

            <span class="label">
                Transaction ID
            </span>

            <span class="value">

                <%= transactionId != null &&
                    !transactionId.trim().isEmpty()
                    ? transactionId
                    : "N/A" %>

            </span>

        </div>


        <!-- CUSTOMER -->

        <div class="row">

            <span class="label">
                Customer
            </span>

            <span class="value">
                <%= customerName %>
            </span>

        </div>


        <!-- AMOUNT -->

        <div class="row">

            <span class="label">
                Amount
            </span>

            <span class="value">
                ₹<%= totalAmount %>
            </span>

        </div>


        <!-- PAYMENT METHOD -->

        <div class="row">

            <span class="label">
                Payment Method
            </span>

            <span class="value">

                <%= paymentMethod != null
                    ? paymentMethod
                    : "-" %>

            </span>

        </div>


        <!-- PAYMENT STATUS -->

        <div class="row">

            <span class="label">
                Payment Status
            </span>

            <span class="value <%= statusClass %>">

                <%= paymentStatus != null
                    ? paymentStatus
                    : "-" %>

            </span>

        </div>


        <!-- PAYMENT DATE -->

        <div class="row">

            <span class="label">
                Payment Date
            </span>

            <span class="value">

                <%= paymentDate != null &&
                    !paymentDate.isEmpty()
                    ? paymentDate
                    : "-" %>

            </span>

        </div>


    </div>


    <!-- BUTTONS -->

    <div class="buttons">


        <a
            class="btn btn-primary"
            href="<%= request.getContextPath() %>/pages/order-details.jsp?orderId=<%= orderId %>">

            View Order Details

        </a>


        <a
            class="btn btn-secondary"
            href="<%= request.getContextPath() %>/index.jsp">

            Continue Shopping

        </a>


    </div>


</div>


</div>


<script>

    // Payment successful hone ke baad cart clear karo

    localStorage.removeItem("ayushCart");

</script>


</body>

</html>