<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"
    import="java.math.BigDecimal"
    import="java.util.UUID"
%>

<%
    /*
     * ============================================================
     * AK SHOP - PROCESS ORDER
     * JSP + JDBC + ORACLE
     *
     * TABLES:
     * AK_ORDER
     * AK_PAYMENT
     *
     * AK_ORDER COLUMNS:
     * ORDER_ID
     * CUSTOMER_NAME
     * CUSTOMER_EMAIL
     * TOTAL_AMOUNT
     * ORDER_DATE
     * STATUS
     * SHIPPING_ADDRESS
     *
     * AK_PAYMENT COLUMNS:
     * PAYMENT_ID
     * ORDER_ID
     * CUSTOMER_NAME
     * AMOUNT
     * PAYMENT_METHOD
     * PAYMENT_STATUS
     * PAYMENT_DATE
     * ============================================================
     */

    request.setCharacterEncoding("UTF-8");

    Connection con = null;

    PreparedStatement orderStmt = null;
    PreparedStatement paymentStmt = null;

    boolean transactionStarted = false;

    try {

        // ========================================================
        // 1. GET PAYMENT METHOD
        // ========================================================

        String paymentMethod =
            request.getParameter("paymentMethod");

        if (paymentMethod == null ||
            paymentMethod.trim().isEmpty()) {

            response.sendRedirect(
                "payment.jsp?error=Please+select+payment+method"
            );

            return;
        }

        paymentMethod = paymentMethod.trim();


        // ========================================================
        // 2. GET CART ITEMS
        // ========================================================

        String[] productNames =
            request.getParameterValues("productName");

        String[] productPrices =
            request.getParameterValues("productPrice");

        String[] productQtys =
            request.getParameterValues("productQty");


        if (productNames == null ||
            productPrices == null ||
            productQtys == null ||
            productNames.length == 0) {

            response.sendRedirect(
                "payment.jsp?error=Your+cart+is+empty"
            );

            return;
        }


        // ========================================================
        // 3. CHECK CART DATA
        // ========================================================

        if (productNames.length != productPrices.length ||
            productNames.length != productQtys.length) {

            throw new Exception(
                "Invalid cart data."
            );
        }


        // ========================================================
        // 4. DATABASE CONNECTION
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


        // IMPORTANT:
        // Manual transaction mode

        con.setAutoCommit(false);

        transactionStarted = true;


        // ========================================================
        // 5. CALCULATE TOTAL AMOUNT
        // ========================================================

        BigDecimal totalAmount =
            BigDecimal.ZERO;


        for (int i = 0;
             i < productNames.length;
             i++) {

            if (productPrices[i] == null ||
                productQtys[i] == null) {

                throw new Exception(
                    "Invalid product information."
                );
            }


            BigDecimal price;

            int quantity;


            try {

                price =
                    new BigDecimal(
                        productPrices[i].trim()
                    );

                quantity =
                    Integer.parseInt(
                        productQtys[i].trim()
                    );

            } catch (Exception ex) {

                throw new Exception(
                    "Invalid product price or quantity."
                );
            }


            if (quantity <= 0) {

                throw new Exception(
                    "Invalid product quantity."
                );
            }


            if (price.compareTo(
                    BigDecimal.ZERO
                ) < 0) {

                throw new Exception(
                    "Invalid product price."
                );
            }


            BigDecimal itemTotal =
                price.multiply(
                    BigDecimal.valueOf(quantity)
                );


            totalAmount =
                totalAmount.add(
                    itemTotal
                );
        }


        // ========================================================
        // 6. CUSTOMER NAME
        // ========================================================

        String customerName =
            "Guest";


        Object customerNameObject =
            session.getAttribute(
                "customerName"
            );


        if (customerNameObject != null) {

            String sessionName =
                customerNameObject
                    .toString()
                    .trim();


            if (!sessionName.isEmpty()) {

                customerName =
                    sessionName;
            }
        }


        // ========================================================
        // 7. CUSTOMER EMAIL
        // ========================================================

        String customerEmail =
            request.getParameter("customerEmail");


        if (customerEmail == null ||
            customerEmail.trim().isEmpty()) {

            Object emailObject =
                session.getAttribute(
                    "customerEmail"
                );


            if (emailObject != null) {

                customerEmail =
                    emailObject
                        .toString()
                        .trim();

            } else {

                customerEmail = "";
            }
        } else {

            customerEmail =
                customerEmail.trim();
        }


        // ========================================================
        // 8. SHIPPING ADDRESS
        // ========================================================

        String shippingAddress =
            request.getParameter(
                "shippingAddress"
            );


        if (shippingAddress == null ||
            shippingAddress.trim().isEmpty()) {

            Object addressObject =
                session.getAttribute(
                    "shippingAddress"
                );


            if (addressObject != null) {

                shippingAddress =
                    addressObject
                        .toString()
                        .trim();

            } else {

                shippingAddress = "";
            }

        } else {

            shippingAddress =
                shippingAddress.trim();
        }


        // ========================================================
        // 9. PAYMENT STATUS
        // ========================================================

        String paymentStatus;


        if (paymentMethod.equalsIgnoreCase(
                "Cash on Delivery")) {

            paymentStatus =
                "PENDING";

        } else {

            /*
             * NOTE:
             * Actual payment gateway is not connected yet.
             * Therefore online payment is currently treated
             * as demo PAID.
             */

            paymentStatus =
                "PAID";
        }


        // ========================================================
        // 10. ORDER STATUS
        // ========================================================

        String orderStatus;

        if (paymentMethod.equalsIgnoreCase(
                "Cash on Delivery")) {

            orderStatus =
                "Processing";

        } else {

            orderStatus =
                "Processing";
        }


        // ========================================================
        // 11. GENERATE ORDER ID
        // ========================================================

        String orderId =
            "ORD-" +
            UUID.randomUUID()
                .toString()
                .replace("-", "")
                .substring(0, 20)
                .toUpperCase();


        // ========================================================
        // 12. GENERATE PAYMENT ID
        // ========================================================

        String paymentId =
            "PAY-" +
            UUID.randomUUID()
                .toString()
                .replace("-", "")
                .substring(0, 20)
                .toUpperCase();


        // ========================================================
        // 13. INSERT INTO AK_ORDER
        // ========================================================

        String orderSql =
            "INSERT INTO AK_ORDER " +
            "(ORDER_ID, CUSTOMER_NAME, CUSTOMER_EMAIL, " +
            "TOTAL_AMOUNT, ORDER_DATE, STATUS, SHIPPING_ADDRESS) " +
            "VALUES (?, ?, ?, ?, SYSTIMESTAMP, ?, ?)";


        orderStmt =
            con.prepareStatement(
                orderSql
            );


        // ORDER_ID

        orderStmt.setString(
            1,
            orderId
        );


        // CUSTOMER_NAME

        orderStmt.setString(
            2,
            customerName
        );


        // CUSTOMER_EMAIL

        orderStmt.setString(
            3,
            customerEmail
        );


        // TOTAL_AMOUNT

        orderStmt.setBigDecimal(
            4,
            totalAmount
        );


        // STATUS

        orderStmt.setString(
            5,
            orderStatus
        );


        // SHIPPING_ADDRESS

        orderStmt.setString(
            6,
            shippingAddress
        );


        // ========================================================
        // 14. EXECUTE ORDER INSERT
        // ========================================================

        int orderRowsInserted =
            orderStmt.executeUpdate();


        if (orderRowsInserted != 1) {

            throw new Exception(
                "Order record could not be created."
            );
        }


        // ========================================================
        // 15. INSERT INTO AK_PAYMENT
        // ========================================================

        String paymentSql =
            "INSERT INTO AK_PAYMENT " +
            "(PAYMENT_ID, ORDER_ID, CUSTOMER_NAME, " +
            "AMOUNT, PAYMENT_METHOD, PAYMENT_STATUS, PAYMENT_DATE) " +
            "VALUES (?, ?, ?, ?, ?, ?, SYSTIMESTAMP)";


        paymentStmt =
            con.prepareStatement(
                paymentSql
            );


        // PAYMENT_ID

        paymentStmt.setString(
            1,
            paymentId
        );


        // ORDER_ID

        paymentStmt.setString(
            2,
            orderId
        );


        // CUSTOMER_NAME

        paymentStmt.setString(
            3,
            customerName
        );


        // AMOUNT

        paymentStmt.setBigDecimal(
            4,
            totalAmount
        );


        // PAYMENT_METHOD

        paymentStmt.setString(
            5,
            paymentMethod
        );


        // PAYMENT_STATUS

        paymentStmt.setString(
            6,
            paymentStatus
        );


        // ========================================================
        // 16. EXECUTE PAYMENT INSERT
        // ========================================================

        int paymentRowsInserted =
            paymentStmt.executeUpdate();


        if (paymentRowsInserted != 1) {

            throw new Exception(
                "Payment record could not be created."
            );
        }


        // ========================================================
        // 17. COMMIT BOTH RECORDS
        // ========================================================

        con.commit();


        // ========================================================
        // 18. SUCCESS REDIRECT
        // ========================================================

        response.sendRedirect(
            "payment-success.jsp" +
            "?orderId=" +
            orderId +
            "&transactionId=" +
            paymentId
        );

        return;


    } catch (Exception e) {


        // ========================================================
        // ROLLBACK
        // ========================================================

        try {

            if (con != null &&
                transactionStarted &&
                !con.getAutoCommit()) {

                con.rollback();
            }

        } catch (Exception rollbackError) {

            // Ignore rollback error
        }


        // ========================================================
        // ERROR PAGE
        // ========================================================

        response.setContentType(
            "text/html;charset=UTF-8"
        );

%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>Order Error - AK Shop</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f7f7f7;
            padding: 50px;
        }

        .error-box {
            max-width: 700px;
            margin: auto;
            background: white;
            padding: 30px;
            border: 1px solid #ddd;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.08);
        }

        h2 {
            color: #c62828;
        }

        pre {
            background: #f5f5f5;
            padding: 15px;
            overflow-x: auto;
            white-space: pre-wrap;
            word-break: break-word;
            border-radius: 6px;
        }

        a {
            display: inline-block;
            margin-top: 20px;
            padding: 12px 20px;
            background: #222;
            color: white;
            text-decoration: none;
            border-radius: 6px;
        }

        a:hover {
            background: #000;
        }

    </style>

</head>

<body>

    <div class="error-box">

        <h2>Order Processing Failed</h2>

        <p>
            Your order could not be processed.
        </p>

        <pre><%= e.getMessage() %></pre>

        <a href="payment.jsp">
            Back to Payment
        </a>

    </div>

</body>

</html>

<%

    } finally {


        // ========================================================
        // CLOSE ORDER STATEMENT
        // ========================================================

        try {

            if (orderStmt != null) {
                orderStmt.close();
            }

        } catch (Exception ignored) {
        }


        // ========================================================
        // CLOSE PAYMENT STATEMENT
        // ========================================================

        try {

            if (paymentStmt != null) {
                paymentStmt.close();
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