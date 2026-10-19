<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*,java.text.SimpleDateFormat,java.util.*" %>

<%!
    private String esc(String s) {
        if (s == null) return "";
        return s.replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }

    private String money(double amount) {
        return String.format(java.util.Locale.US, "₹%,.2f", amount);
    }

    private String statusClass(String status) {
        if (status == null) return "processing";

        String s = status.toLowerCase();

        if (s.contains("deliver")) return "delivered";
        if (s.contains("ship")) return "shipped";
        if (s.contains("cancel")) return "cancelled";
        if (s.contains("pack")) return "packed";
        if (s.contains("confirm")) return "confirmed";

        return "processing";
    }

    private int trackingStep(String status) {
        if (status == null) return 2;

        String s = status.toLowerCase();

        if (s.contains("cancel")) return -1;
        if (s.contains("deliver")) return 5;
        if (s.contains("out for delivery")) return 4;
        if (s.contains("ship")) return 3;
        if (s.contains("pack")) return 2;
        if (s.contains("confirm")) return 1;

        return 0;
    }
%>

<%
    Boolean customerLoggedIn =
        (Boolean) session.getAttribute("customerLoggedIn");

    if (customerLoggedIn == null || !customerLoggedIn) {
        response.sendRedirect(
            request.getContextPath() + "/pages/login.jsp"
        );
        return;
    }

    String customerId =
        (String) session.getAttribute("customerId");

    String customerName =
        (String) session.getAttribute("customerName");

    String customerEmail =
        (String) session.getAttribute("customerEmail");

    if (customerId == null || customerEmail == null) {
        response.sendRedirect(
            request.getContextPath() + "/pages/login.jsp"
        );
        return;
    }

    if (customerName == null || customerName.trim().isEmpty()) {
        customerName = "Customer";
    }

    String selectedOrderId = request.getParameter("orderId");

    Connection con = null;
    PreparedStatement psOrders = null;
    PreparedStatement psSelected = null;

    ResultSet rsOrders = null;
    ResultSet rsSelected = null;

    List<Map<String, Object>> orders = new ArrayList<>();

    Map<String, Object> selectedOrder = null;

    try {

        Class.forName("oracle.jdbc.driver.OracleDriver");

        String dbUrl =
            "jdbc:oracle:thin:@localhost:1521:XE";

        String dbUser = "system";
        String dbPassword = "ayush";

        con = DriverManager.getConnection(
            dbUrl,
            dbUser,
            dbPassword
        );

        /* =========================================
           ALL CUSTOMER ORDERS
           ========================================= */

        String orderSql =
            "SELECT " +
            "ORDER_ID, " +
            "CUSTOMER_NAME, " +
            "CUSTOMER_EMAIL, " +
            "TOTAL_AMOUNT, " +
            "ORDER_DATE, " +
            "STATUS, " +
            "SHIPPING_ADDRESS " +
            "FROM AK_ORDER " +
            "WHERE CUSTOMER_EMAIL = ? " +
            "ORDER BY ORDER_DATE DESC";

        psOrders = con.prepareStatement(orderSql);

        psOrders.setString(1, customerEmail);

        rsOrders = psOrders.executeQuery();

        SimpleDateFormat sdf =
            new SimpleDateFormat(
                "dd MMM yyyy, hh:mm a"
            );

        while (rsOrders.next()) {

            Map<String, Object> order =
                new HashMap<>();

            order.put(
                "ORDER_ID",
                rsOrders.getString("ORDER_ID")
            );

            order.put(
                "CUSTOMER_NAME",
                rsOrders.getString("CUSTOMER_NAME")
            );

            order.put(
                "CUSTOMER_EMAIL",
                rsOrders.getString("CUSTOMER_EMAIL")
            );

            order.put(
                "TOTAL_AMOUNT",
                rsOrders.getDouble("TOTAL_AMOUNT")
            );

            Timestamp orderDate =
                rsOrders.getTimestamp("ORDER_DATE");

            order.put(
                "ORDER_DATE",
                orderDate != null
                    ? sdf.format(orderDate)
                    : "N/A"
            );

            order.put(
                "STATUS",
                rsOrders.getString("STATUS")
            );

            order.put(
                "SHIPPING_ADDRESS",
                rsOrders.getString("SHIPPING_ADDRESS")
            );

            orders.add(order);
        }


        /* =========================================
           SELECTED ORDER FOR TRACKING
           ========================================= */

        if (selectedOrderId != null &&
            !selectedOrderId.trim().isEmpty()) {

            String selectedSql =
                "SELECT " +
                "o.ORDER_ID, " +
                "o.CUSTOMER_NAME, " +
                "o.CUSTOMER_EMAIL, " +
                "o.TOTAL_AMOUNT, " +
                "o.ORDER_DATE, " +
                "o.STATUS, " +
                "o.SHIPPING_ADDRESS, " +
                "p.PAYMENT_ID, " +
                "p.PAYMENT_METHOD, " +
                "p.PAYMENT_STATUS, " +
                "p.PAYMENT_DATE " +
                "FROM AK_ORDER o " +
                "LEFT JOIN AK_PAYMENT p " +
                "ON o.ORDER_ID = p.ORDER_ID " +
                "WHERE o.ORDER_ID = ? " +
                "AND o.CUSTOMER_EMAIL = ?";

            psSelected =
                con.prepareStatement(selectedSql);

            psSelected.setString(
                1,
                selectedOrderId
            );

            psSelected.setString(
                2,
                customerEmail
            );

            rsSelected =
                psSelected.executeQuery();

            if (rsSelected.next()) {

                selectedOrder =
                    new HashMap<>();

                selectedOrder.put(
                    "ORDER_ID",
                    rsSelected.getString("ORDER_ID")
                );

                selectedOrder.put(
                    "CUSTOMER_NAME",
                    rsSelected.getString("CUSTOMER_NAME")
                );

                selectedOrder.put(
                    "CUSTOMER_EMAIL",
                    rsSelected.getString("CUSTOMER_EMAIL")
                );

                selectedOrder.put(
                    "TOTAL_AMOUNT",
                    rsSelected.getDouble("TOTAL_AMOUNT")
                );

                Timestamp orderDate =
                    rsSelected.getTimestamp("ORDER_DATE");

                selectedOrder.put(
                    "ORDER_DATE",
                    orderDate != null
                        ? sdf.format(orderDate)
                        : "N/A"
                );

                selectedOrder.put(
                    "STATUS",
                    rsSelected.getString("STATUS")
                );

                selectedOrder.put(
                    "SHIPPING_ADDRESS",
                    rsSelected.getString("SHIPPING_ADDRESS")
                );

                selectedOrder.put(
                    "PAYMENT_ID",
                    rsSelected.getString("PAYMENT_ID")
                );

                selectedOrder.put(
                    "PAYMENT_METHOD",
                    rsSelected.getString("PAYMENT_METHOD")
                );

                selectedOrder.put(
                    "PAYMENT_STATUS",
                    rsSelected.getString("PAYMENT_STATUS")
                );

                Timestamp paymentDate =
                    rsSelected.getTimestamp("PAYMENT_DATE");

                selectedOrder.put(
                    "PAYMENT_DATE",
                    paymentDate != null
                        ? sdf.format(paymentDate)
                        : "N/A"
                );
            }
        }

        /*
         * If user opens order.jsp directly,
         * automatically select latest order.
         */
        if (selectedOrder == null && !orders.isEmpty()) {

            Map<String, Object> firstOrder =
                orders.get(0);

            String firstOrderId =
                (String) firstOrder.get("ORDER_ID");

            String selectedSql =
                "SELECT " +
                "o.ORDER_ID, " +
                "o.CUSTOMER_NAME, " +
                "o.CUSTOMER_EMAIL, " +
                "o.TOTAL_AMOUNT, " +
                "o.ORDER_DATE, " +
                "o.STATUS, " +
                "o.SHIPPING_ADDRESS, " +
                "p.PAYMENT_ID, " +
                "p.PAYMENT_METHOD, " +
                "p.PAYMENT_STATUS, " +
                "p.PAYMENT_DATE " +
                "FROM AK_ORDER o " +
                "LEFT JOIN AK_PAYMENT p " +
                "ON o.ORDER_ID = p.ORDER_ID " +
                "WHERE o.ORDER_ID = ? " +
                "AND o.CUSTOMER_EMAIL = ?";

            if (psSelected != null) {
                psSelected.close();
            }

            psSelected =
                con.prepareStatement(selectedSql);

            psSelected.setString(
                1,
                firstOrderId
            );

            psSelected.setString(
                2,
                customerEmail
            );

            if (rsSelected != null) {
                rsSelected.close();
            }

            rsSelected =
                psSelected.executeQuery();

            if (rsSelected.next()) {

                selectedOrder =
                    new HashMap<>();

                selectedOrder.put(
                    "ORDER_ID",
                    rsSelected.getString("ORDER_ID")
                );

                selectedOrder.put(
                    "CUSTOMER_NAME",
                    rsSelected.getString("CUSTOMER_NAME")
                );

                selectedOrder.put(
                    "CUSTOMER_EMAIL",
                    rsSelected.getString("CUSTOMER_EMAIL")
                );

                selectedOrder.put(
                    "TOTAL_AMOUNT",
                    rsSelected.getDouble("TOTAL_AMOUNT")
                );

                Timestamp orderDate =
                    rsSelected.getTimestamp("ORDER_DATE");

                selectedOrder.put(
                    "ORDER_DATE",
                    orderDate != null
                        ? sdf.format(orderDate)
                        : "N/A"
                );

                selectedOrder.put(
                    "STATUS",
                    rsSelected.getString("STATUS")
                );

                selectedOrder.put(
                    "SHIPPING_ADDRESS",
                    rsSelected.getString("SHIPPING_ADDRESS")
                );

                selectedOrder.put(
                    "PAYMENT_ID",
                    rsSelected.getString("PAYMENT_ID")
                );

                selectedOrder.put(
                    "PAYMENT_METHOD",
                    rsSelected.getString("PAYMENT_METHOD")
                );

                selectedOrder.put(
                    "PAYMENT_STATUS",
                    rsSelected.getString("PAYMENT_STATUS")
                );
            }
        }

    } catch (Exception e) {

        e.printStackTrace();

    } finally {

        try {
            if (rsOrders != null) rsOrders.close();
        } catch (Exception e) {}

        try {
            if (rsSelected != null) rsSelected.close();
        } catch (Exception e) {}

        try {
            if (psOrders != null) psOrders.close();
        } catch (Exception e) {}

        try {
            if (psSelected != null) psSelected.close();
        } catch (Exception e) {}

        try {
            if (con != null) con.close();
        } catch (Exception e) {}
    }
%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<title>My Orders - AYUSH LABEL</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">


<link rel="preconnect"
      href="https://fonts.googleapis.com">

<link rel="preconnect"
      href="https://fonts.gstatic.com"
      crossorigin>

<link
href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Poppins:wght@300;400;500;600&display=swap"
rel="stylesheet">


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background: #090909;
    color: #f4f0e8;
    font-family: 'Poppins', sans-serif;
}

a {
    text-decoration: none;
    color: inherit;
}


/* =========================================
   TOP BAR
   ========================================= */

.top-bar {
    height: 38px;
    background: #0d0d0d;
    border-bottom: 1px solid #242424;

    display: flex;
    align-items: center;
    justify-content: space-between;

    padding: 0 7%;
    font-size: 12px;
    color: #c8c2b7;
}

.top-left {
    color: #e4b94f;
}

.top-right {
    display: flex;
    height: 100%;
}

.top-right a {
    padding: 0 25px;

    display: flex;
    align-items: center;

    border-left: 1px solid #292929;

    transition: .3s;
}

.top-right a:last-child {
    border-right: 1px solid #292929;
}

.top-right a:hover,
.top-right .active {
    color: #e4b94f;
}


/* =========================================
   NAVBAR
   ========================================= */

.navbar {
    height: 82px;

    background: #0b0b0b;

    border-bottom: 1px solid #252525;

    display: flex;
    align-items: center;

    padding: 0 7%;

    justify-content: space-between;
}

.logo {
    width: 105px;
}

.logo img {
    width: 100%;
    display: block;
}

.nav-links {
    display: flex;
    gap: 38px;
    margin-left: 30px;
    flex: 1;
    justify-content: center;
}

.nav-links a {
    font-size: 14px;
    color: #ddd;
    transition: .3s;
}

.nav-links a:hover {
    color: #e4b94f;
}

.nav-icons {
    display: flex;
    gap: 30px;
    font-size: 26px;
}

.icon-box {
    position: relative;
}

.icon-count {
    position: absolute;
    top: -7px;
    right: -10px;

    width: 17px;
    height: 17px;

    background: #d9ad39;
    color: #111;

    font-size: 10px;

    display: flex;
    align-items: center;
    justify-content: center;

    font-weight: 600;
}


/* =========================================
   HERO
   ========================================= */

.hero {
    height: 155px;

    position: relative;

    background:
        linear-gradient(
            90deg,
            rgba(0,0,0,.95),
            rgba(0,0,0,.55),
            rgba(0,0,0,.95)
        ),
        url("images/order-banner.jpg");

    background-size: cover;
    background-position: center;

    border-bottom: 1px solid #8d6b21;

    display: flex;
    align-items: center;

    padding: 0 7%;
}

.hero h1 {
    font-family: 'Cormorant Garamond', serif;

    font-size: 50px;
    font-weight: 500;

    letter-spacing: .5px;
}

.hero p {
    margin-top: 8px;

    color: #e3b747;

    font-size: 11px;

    letter-spacing: 5px;
}


/* =========================================
   MAIN
   ========================================= */

.main-container {
    width: 92%;
    max-width: 1450px;

    margin: 30px auto 60px;

    display: grid;

    grid-template-columns:
        260px
        minmax(450px, 1fr)
        310px;

    gap: 22px;
}


/* =========================================
   SIDEBAR
   ========================================= */

.sidebar-card {
    border: 1px solid #292929;

    background: #0c0c0c;

    margin-bottom: 20px;
}

.profile-mini {
    padding: 22px;
}

.avatar {
    width: 48px;
    height: 48px;

    border: 1px solid #d5a936;
    border-radius: 50%;

    display: flex;
    align-items: center;
    justify-content: center;

    color: #e0b445;

    font-family: 'Cormorant Garamond', serif;
    font-size: 21px;
}

.profile-mini-top {
    display: flex;
    gap: 13px;
    align-items: center;
}

.profile-mini h3 {
    font-size: 14px;
    font-weight: 500;
}

.profile-mini p {
    color: #8e8e8e;
    font-size: 11px;
    margin-top: 3px;

    word-break: break-word;
}

.side-menu {
    border-top: 1px solid #292929;
}

.side-menu a {
    display: flex;

    align-items: center;
    gap: 15px;

    padding: 16px 20px;

    font-size: 13px;

    color: #ddd;

    border-bottom: 1px solid #202020;

    transition: .3s;
}

.side-menu a:hover,
.side-menu a.active {
    color: #f0c64e;

    background:
        linear-gradient(
            90deg,
            rgba(212,165,54,.16),
            transparent
        );

    border-left: 4px solid #e0b33f;

    padding-left: 16px;
}

.side-icon {
    width: 20px;
    text-align: center;
    color: #e0b33f;
}


/* promo */

.promo {
    height: 245px;

    padding: 25px;

    position: relative;

    overflow: hidden;

    background:
        linear-gradient(
            90deg,
            rgba(0,0,0,.9),
            rgba(0,0,0,.55)
        ),
        url("images/order-promo.jpg");

    background-size: cover;
    background-position: center;
}

.promo h3 {
    font-family: 'Cormorant Garamond', serif;

    color: #e7bc50;

    font-size: 25px;

    line-height: 1.1;

    margin-bottom: 18px;
}

.promo p {
    color: #ddd;

    font-size: 11px;

    line-height: 2;
}

.shop-btn {
    display: inline-block;

    margin-top: 18px;

    padding: 10px 18px;

    background: #e4b94f;

    color: #111;

    font-size: 11px;

    font-weight: 600;
}


/* =========================================
   ORDER CONTENT
   ========================================= */

.orders-panel {
    min-width: 0;
}

.section-head {
    border: 1px solid #292929;

    background: #0c0c0c;

    padding: 21px;

    display: flex;

    justify-content: space-between;
    align-items: center;

    margin-bottom: 12px;
}

.section-head h2 {
    font-family: 'Cormorant Garamond', serif;

    font-size: 29px;

    font-weight: 600;
}

.section-head p {
    color: #888;

    font-size: 11px;

    margin-top: 3px;
}

.order-select {
    background: #0b0b0b;

    color: #ddd;

    border: 1px solid #353535;

    padding: 10px 15px;

    outline: none;
}


/* order card */

.order-card {
    background: #0c0c0c;

    border: 1px solid #292929;

    margin-bottom: 12px;

    padding: 18px;

    transition: .3s;

    position: relative;
}

.order-card:hover {
    border-color: #866b2d;
}

.order-card.selected {
    border-color: #d4a938;

    box-shadow:
        0 0 25px rgba(211,166,54,.05);
}

.order-card-top {
    display: flex;

    gap: 18px;

    align-items: center;
}


/* product image placeholder */

.product-image {
    width: 112px;
    height: 112px;

    flex-shrink: 0;

    background:
        linear-gradient(
            145deg,
            #242424,
            #0d0d0d
        );

    border: 1px solid #303030;

    display: flex;
    align-items: center;
    justify-content: center;

    color: #676767;

    text-align: center;

    font-size: 10px;

    padding: 10px;
}

.order-info {
    flex: 1;
    min-width: 0;
}

.order-number {
    color: #eee;

    font-size: 13px;

    font-weight: 500;
}

.order-date {
    color: #777;

    font-size: 10px;

    margin-top: 5px;
}

.order-total {
    font-size: 18px;

    color: #e4b94f;

    margin-top: 12px;

    font-family:
        'Cormorant Garamond',
        serif;

    font-weight: 600;
}


/* status */

.status {
    display: inline-block;

    padding: 5px 10px;

    font-size: 9px;

    letter-spacing: .4px;

    border-radius: 3px;

    white-space: nowrap;
}

.status.processing {
    background: #6a4e09;
    color: #ffd65d;
}

.status.shipped {
    background: #123f55;
    color: #6dd7ff;
}

.status.delivered {
    background: #104d2d;
    color: #63e79a;
}

.status.cancelled {
    background: #551c1c;
    color: #ff7474;
}

.status.packed,
.status.confirmed {
    background: #38311b;
    color: #e9ca65;
}


/* buttons */

.order-actions {
    display: flex;

    justify-content: flex-end;

    gap: 9px;

    margin-top: 17px;
}

.btn {
    padding: 9px 18px;

    background: transparent;

    border: 1px solid #555;

    color: #ddd;

    font-family: 'Poppins', sans-serif;

    font-size: 10px;

    cursor: pointer;

    transition: .3s;
}

.btn:hover {
    border-color: #d8aa38;

    color: #e5b83f;
}

.btn-track {
    border-color: #a47b1f;

    color: #e4b94f;
}


/* =========================================
   TRACKING
   ========================================= */

.tracking-card {
    background: #0c0c0c;

    border: 1px solid #292929;

    padding: 20px;

    position: sticky;

    top: 20px;
}

.tracking-title {
    font-family: 'Cormorant Garamond', serif;

    font-size: 26px;

    font-weight: 600;
}

.tracking-id {
    font-size: 10px;

    color: #777;

    margin-top: 4px;

    word-break: break-all;
}


/* timeline */

.timeline {
    margin-top: 25px;

    position: relative;
}

.timeline::before {
    content: "";

    position: absolute;

    left: 10px;

    top: 10px;

    bottom: 10px;

    width: 1px;

    background: #3b3b3b;
}

.timeline-item {
    position: relative;

    padding-left: 34px;

    min-height: 57px;
}

.timeline-dot {
    position: absolute;

    left: 0;

    top: 0;

    width: 21px;

    height: 21px;

    border-radius: 50%;

    border: 1px solid #555;

    background: #0b0b0b;

    z-index: 2;

    display: flex;

    align-items: center;

    justify-content: center;

    font-size: 10px;
}

.timeline-item.done .timeline-dot {
    background: #1c7b45;

    border-color: #3cae6a;

    color: white;
}

.timeline-item.current .timeline-dot {
    background: #dcae2f;

    border-color: #f0ca64;

    color: #111;
}

.timeline-item.done .timeline-dot::after {
    content: "✓";
}

.timeline-item.current .timeline-dot::after {
    content: "•";
}

.timeline-item h4 {
    font-size: 12px;

    color: #ddd;

    font-weight: 500;
}

.timeline-item.current h4 {
    color: #e6b943;
}

.timeline-item p {
    font-size: 9px;

    color: #777;

    margin-top: 4px;
}


/* divider */

.divider {
    height: 1px;

    background: #292929;

    margin: 15px 0;
}


/* tracking information */

.info-row {
    margin-bottom: 15px;
}

.info-label {
    color: #777;

    font-size: 9px;

    text-transform: uppercase;

    letter-spacing: 1px;
}

.info-value {
    color: #ddd;

    font-size: 11px;

    margin-top: 4px;

    line-height: 1.6;

    word-break: break-word;
}

.gold {
    color: #e5b83f;
}


/* payment */

.payment-box {
    padding: 13px;

    border: 1px solid #292929;

    margin-top: 17px;
}

.payment-box-title {
    color: #888;

    font-size: 9px;

    text-transform: uppercase;

    letter-spacing: 1px;

    margin-bottom: 9px;
}

.payment-status {
    color: #62dc93;

    font-size: 11px;
}


/* address */

.address-card {
    background: #0c0c0c;

    border: 1px solid #292929;

    padding: 18px;

    margin-top: 18px;
}

.address-title {
    color: #e2b544;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;

    margin-bottom: 9px;
}

.address-text {
    color: #bbb;

    font-size: 10px;

    line-height: 1.7;
}


/* empty */

.empty-orders {
    border: 1px dashed #353535;

    padding: 70px 20px;

    text-align: center;

    color: #777;
}

.empty-orders h3 {
    font-family: 'Cormorant Garamond', serif;

    font-size: 30px;

    color: #ccc;

    margin-bottom: 8px;
}

.empty-orders p {
    font-size: 11px;
}


/* footer */

footer {
    border-top: 1px solid #222;

    text-align: center;

    padding: 25px;

    color: #666;

    font-size: 10px;

    letter-spacing: .5px;
}


/* responsive */

@media(max-width:1100px) {

    .main-container {
        grid-template-columns:
            220px
            1fr;
    }

    .tracking-column {
        grid-column: 1 / -1;
    }

    .tracking-card {
        position: static;
    }

}

@media(max-width:750px) {

    .top-bar {
        padding: 0 15px;
    }

    .top-left {
        display: none;
    }

    .top-right {
        width: 100%;
        justify-content: flex-end;
    }

    .top-right a {
        padding: 0 10px;
        font-size: 10px;
    }

    .navbar {
        padding: 0 20px;
    }

    .nav-links {
        display: none;
    }

    .hero {
        padding: 0 25px;
    }

    .hero h1 {
        font-size: 38px;
    }

    .main-container {
        width: 94%;

        grid-template-columns: 1fr;
    }

    .sidebar {
        display: none;
    }

    .order-card-top {
        align-items: flex-start;
    }

    .product-image {
        width: 85px;
        height: 85px;
    }

    .section-head {
        align-items: flex-start;

        flex-direction: column;

        gap: 15px;
    }

}

</style>

</head>


<body>


<!-- =========================================
     TOP BAR
     ========================================= -->

<div class="top-bar">

    <div class="top-left">
        Free shipping for standard order over ₹100
    </div>

    <div class="top-right">

        <a href="help.jsp">
            Help & FAQs
        </a>

        <a href="my-account.jsp">
            My Account
        </a>

        <a href="logout.jsp">
            Logout
        </a>

        <a href="order.jsp" class="active">
            Order
        </a>

    </div>

</div>


<!-- =========================================
     NAVBAR
     ========================================= -->

<nav class="navbar">

    <a href="../index.jsp" class="logo">

        <!-- Agar tumhare logo ka path different hai
             to sirf ye path change karna -->

        <img src="images/logo.png"
             alt="AYUSH LABEL">

    </a>


    <div class="nav-links">

        <a href="../index.jsp">
            Home
        </a>

        <a href="shop.jsp">
            Shop
        </a>

        <a href="features.jsp">
            Features
        </a>

        <a href="blog.jsp">
            Blog
        </a>

        <a href="about.jsp">
            About
        </a>

        <a href="contact.jsp">
            Contact
        </a>

    </div>


    <div class="nav-icons">

        <a href="cart.jsp"
           class="icon-box">

            🛒

            <span class="icon-count"
                  id="cartCount">
                0
            </span>

        </a>


        <a href="wishlist.jsp"
           class="icon-box">

            ♡

            <span class="icon-count"
                  id="wishlistCount">
                0
            </span>

        </a>

    </div>

</nav>


<!-- =========================================
     HERO
     ========================================= -->

<section class="hero">

    <div>

        <h1>
            My Orders
        </h1>

        <p>
            TRACK &nbsp; • &nbsp;
            MANAGE &nbsp; • &nbsp;
            SHOP AGAIN
        </p>

    </div>

</section>


<!-- =========================================
     MAIN
     ========================================= -->

<div class="main-container">


    <!-- =====================================
         LEFT SIDEBAR
         ===================================== -->

    <aside class="sidebar">


        <div class="sidebar-card">

            <div class="profile-mini">

                <div class="profile-mini-top">

                    <div class="avatar">

                        <%
                            String initials = "C";

                            if (customerName != null &&
                                !customerName.trim().isEmpty()) {

                                String[] parts =
                                    customerName.trim().split("\\s+");

                                initials =
                                    parts[0].substring(0,1).toUpperCase();

                                if (parts.length > 1) {

                                    initials +=
                                        parts[parts.length - 1]
                                        .substring(0,1)
                                        .toUpperCase();
                                }
                            }
                        %>

                        <%= esc(initials) %>

                    </div>


                    <div>

                        <h3>
                            <%= esc(customerName) %>
                        </h3>

                        <p>
                            <%= esc(customerEmail) %>
                        </p>

                    </div>

                </div>

            </div>


            <div class="side-menu">

                <a href="my-account.jsp">

                    <span class="side-icon">
                        ♙
                    </span>

                    Profile

                </a>


                <a href="order.jsp"
                   class="active">

                    <span class="side-icon">
                        ▣
                    </span>

                    Orders

                </a>


                <a href="my-account.jsp#addresses">

                    <span class="side-icon">
                        ♧
                    </span>

                    Addresses

                </a>


                <a href="change-password.jsp">

                    <span class="side-icon">
                        🔒
                    </span>

                    Change Password

                </a>


                <a href="messages.jsp">

                    <span class="side-icon">
                        ✉
                    </span>

                    Messages

                </a>

            </div>

        </div>


        <div class="sidebar-card promo">

            <h3>
                Your Style<br>
                Our Priority
            </h3>

            <p>
                • Premium Fashion<br>
                • Secure Shopping<br>
                • Track Your Orders
            </p>

            <a href="product.jsp"
               class="shop-btn">

                SHOP NOW →

            </a>

        </div>

    </aside>


    <!-- =====================================
         ORDER LIST
         ===================================== -->

    <section class="orders-panel">


        <div class="section-head">

            <div>

                <h2>
                    Order History
                </h2>

                <p>
                    View and track all your orders
                </p>

            </div>


            <select class="order-select"
                    onchange="filterOrders(this.value)">

                <option value="all">
                    All Orders
                </option>

                <option value="processing">
                    Processing
                </option>

                <option value="shipped">
                    Shipped
                </option>

                <option value="delivered">
                    Delivered
                </option>

                <option value="cancelled">
                    Cancelled
                </option>

            </select>

        </div>


        <%
            if (orders.isEmpty()) {
        %>

            <div class="empty-orders">

                <h3>
                    No Orders Yet
                </h3>

                <p>
                    Your placed orders will appear here.
                </p>

                <a href="product.jsp"
                   class="shop-btn">

                    START SHOPPING →

                </a>

            </div>

        <%
            } else {

                for (Map<String,Object> order : orders) {

                    String oid =
                        (String) order.get("ORDER_ID");

                    String status =
                        (String) order.get("STATUS");

                    String orderDate =
                        (String) order.get("ORDER_DATE");

                    double total =
                        (Double) order.get("TOTAL_AMOUNT");

                    boolean isSelected =
                        selectedOrder != null &&
                        oid.equals(
                            selectedOrder.get("ORDER_ID")
                        );
        %>


        <div class="order-card <%= isSelected ? "selected" : "" %>"
             data-status="<%= esc(status) %>">


            <div class="order-card-top">


                <!-- PRODUCT AREA -->

                <div class="product-image">

                    Product details<br>
                    available in<br>
                    order items

                </div>


                <!-- ORDER INFO -->

                <div class="order-info">

                    <div class="order-number">

                        Order #
                        <%= esc(oid) %>

                    </div>


                    <div class="order-date">

                        <%= esc(orderDate) %>

                    </div>


                    <div class="order-total">

                        <%= money(total) %>

                    </div>

                </div>


                <!-- STATUS -->

                <div>

                    <span class="status
                        <%= statusClass(status) %>">

                        <%= esc(
                            status == null
                            ? "Processing"
                            : status.toUpperCase()
                        ) %>

                    </span>

                </div>

            </div>


            <div class="order-actions">


                <a class="btn btn-track"
                   href="order.jsp?orderId=<%= java.net.URLEncoder.encode(
                       oid,
                       "UTF-8"
                   ) %>">

                    ⌖ &nbsp; TRACK ORDER

                </a>


                <a class="btn"
                   href="order-details.jsp?orderId=<%= java.net.URLEncoder.encode(
                       oid,
                       "UTF-8"
                   ) %>">

                    VIEW DETAILS

                </a>


            </div>


        </div>


        <%
                }
            }
        %>

    </section>


    <!-- =====================================
         RIGHT TRACKING
         ===================================== -->

    <aside class="tracking-column">


    <%
        if (selectedOrder != null) {

            String selectedId =
                (String) selectedOrder.get("ORDER_ID");

            String selectedStatus =
                (String) selectedOrder.get("STATUS");

            int currentStep =
                trackingStep(selectedStatus);

            String paymentMethod =
                (String) selectedOrder.get("PAYMENT_METHOD");

            String paymentStatus =
                (String) selectedOrder.get("PAYMENT_STATUS");

            String shippingAddress =
                (String) selectedOrder.get("SHIPPING_ADDRESS");

            if (shippingAddress == null ||
                shippingAddress.trim().isEmpty()) {

                shippingAddress = "Not provided";
            }
    %>


        <div class="tracking-card">


            <div class="tracking-title">

                Order Tracking

            </div>


            <div class="tracking-id">

                #<%= esc(selectedId) %>

            </div>


            <div class="timeline">


                <!-- STEP 1 -->

                <div class="timeline-item
                    <%= currentStep >= 0 && currentStep != -1
                        ? "done"
                        : "" %>">

                    <div class="timeline-dot"></div>

                    <h4>
                        Order Placed
                    </h4>

                    <p>
                        Order received
                    </p>

                </div>


                <!-- STEP 2 -->

                <div class="timeline-item
                    <%= currentStep >= 1
                        ? "done"
                        : "" %>">

                    <div class="timeline-dot"></div>

                    <h4>
                        Order Confirmed
                    </h4>

                    <p>
                        Order confirmed
                    </p>

                </div>


                <!-- STEP 3 -->

                <div class="timeline-item
                    <%= currentStep >= 2
                        ? "done"
                        : "" %>">

                    <div class="timeline-dot"></div>

                    <h4>
                        Packed
                    </h4>

                    <p>
                        Preparing your order
                    </p>

                </div>


                <!-- STEP 4 -->

                <div class="timeline-item
                    <%= currentStep >= 3
                        ? "done"
                        : "" %>">

                    <div class="timeline-dot"></div>

                    <h4>
                        Shipped
                    </h4>

                    <p>
                        Order dispatched
                    </p>

                </div>


                <!-- STEP 5 -->

                <div class="timeline-item
                    <%= currentStep == 4
                        ? "current"
                        : (currentStep > 4
                            ? "done"
                            : "") %>">

                    <div class="timeline-dot"></div>

                    <h4>
                        Out for Delivery
                    </h4>

                    <p>
                        Delivery partner is carrying
                        your order
                    </p>

                </div>


                <!-- STEP 6 -->

                <div class="timeline-item
                    <%= currentStep >= 5
                        ? "current"
                        : "" %>">

                    <div class="timeline-dot"></div>

                    <h4>
                        Delivered
                    </h4>

                    <p>
                        Order delivered
                    </p>

                </div>


            </div>


            <div class="divider"></div>


            <!-- ORDER STATUS -->

            <div class="info-row">

                <div class="info-label">
                    Current Status
                </div>

                <div class="info-value gold">

                    <%= esc(
                        selectedStatus == null
                        ? "Processing"
                        : selectedStatus
                    ) %>

                </div>

            </div>


            <!-- TOTAL -->

            <div class="info-row">

                <div class="info-label">
                    Order Total
                </div>

                <div class="info-value gold">

                    <%= money(
                        (Double) selectedOrder.get(
                            "TOTAL_AMOUNT"
                        )
                    ) %>

                </div>

            </div>


            <!-- PAYMENT -->

            <div class="payment-box">

                <div class="payment-box-title">

                    Payment

                </div>

                <div class="info-value">

                    <%= esc(
                        paymentMethod == null
                        ? "Not available"
                        : paymentMethod
                    ) %>

                </div>

                <div class="payment-status">

                    <%= esc(
                        paymentStatus == null
                        ? "Not available"
                        : paymentStatus
                    ) %>

                </div>

            </div>


        </div>


        <!-- SHIPPING ADDRESS -->

        <div class="address-card">

            <div class="address-title">

                ♧ &nbsp; Shipping Address

            </div>

            <div class="address-text">

                <%= esc(shippingAddress)
                    .replace("\n", "<br>") %>

            </div>


            <a class="btn"
               style="
                    display:block;
                    text-align:center;
                    margin-top:15px;
               "
               href="order-details.jsp?orderId=<%= java.net.URLEncoder.encode(
                   selectedId,
                   "UTF-8"
               ) %>">

                VIEW ORDER DETAILS

            </a>

        </div>


    <%
        } else {
    %>


        <div class="tracking-card">

            <div class="tracking-title">
                Order Tracking
            </div>

            <div class="tracking-id">
                Select an order to track
            </div>

            <div class="empty-orders"
                 style="
                    margin-top:20px;
                    padding:35px 15px;
                 ">

                Select an order from
                Order History.

            </div>

        </div>


    <%
        }
    %>


    </aside>

</div>


<!-- =========================================
     FOOTER
     ========================================= -->

<footer>

    © 2026 AYUSH LABEL
    &nbsp; — &nbsp;
    Fashion
    &nbsp; • &nbsp;
    Lifestyle
    &nbsp; • &nbsp;
    You

</footer>


<script>

/* =========================================
   ORDER FILTER
   ========================================= */

function filterOrders(value) {

    const cards =
        document.querySelectorAll(
            ".order-card"
        );

    cards.forEach(function(card) {

        const status =
            card
            .getAttribute("data-status")
            .toLowerCase();

        if (value === "all") {

            card.style.display = "";

            return;
        }

        if (status.includes(value)) {

            card.style.display = "";

        } else {

            card.style.display = "none";

        }

    });

}


/* =========================================
   CART COUNT
   ========================================= */

try {

    const cart =
        JSON.parse(
            localStorage.getItem("ayushCart")
        ) || [];

    let count = 0;

    cart.forEach(function(item) {

        count +=
            Number(item.quantity || item.qty || 1);

    });

    const cartCount =
        document.getElementById(
            "cartCount"
        );

    if (cartCount) {
        cartCount.textContent = count;
    }

} catch (e) {

    console.log(e);

}

</script>


</body>

</html>