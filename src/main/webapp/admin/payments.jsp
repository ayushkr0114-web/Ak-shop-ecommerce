<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*" %>

<%
/* ================= ADMIN SESSION ================= */

String adminName = (String) session.getAttribute("admin_id");

if (adminName == null) {
    response.sendRedirect("login.jsp");
    return;
}

/* ================= DATABASE ================= */

String driver = "oracle.jdbc.driver.OracleDriver";
String url = "jdbc:oracle:thin:@localhost:1521:XE";
String dbUser = "system";
String dbPassword = "ayush";

String message = "";
String error = "";

Connection con = null;
PreparedStatement ps = null;

/* ================= ACTION ================= */

String action = request.getParameter("action");

try {

    Class.forName(driver);

    con = DriverManager.getConnection(
        url,
        dbUser,
        dbPassword
    );

    /* ================= UPDATE PAYMENT ================= */

    if ("update".equals(action)) {

        String paymentId = request.getParameter("paymentId");
        String paymentStatus = request.getParameter("paymentStatus");

        if (paymentId != null && !paymentId.trim().isEmpty()
                && paymentStatus != null && !paymentStatus.trim().isEmpty()) {

            String sql =
                "UPDATE AK_PAYMENT SET PAYMENT_STATUS=? " +
                "WHERE PAYMENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, paymentStatus);
            ps.setString(2, paymentId);

            int rows = ps.executeUpdate();

            ps.close();
            ps = null;

            if (rows > 0) {
                message = "Payment status updated successfully!";
            } else {
                error = "Payment record not found.";
            }
        }
    }

    /* ================= DELETE PAYMENT ================= */

    if ("delete".equals(action)) {

        String paymentId = request.getParameter("paymentId");

        if (paymentId != null && !paymentId.trim().isEmpty()) {

            String sql =
                "DELETE FROM AK_PAYMENT WHERE PAYMENT_ID=?";

            ps = con.prepareStatement(sql);

            ps.setString(1, paymentId);

            int rows = ps.executeUpdate();

            ps.close();
            ps = null;

            if (rows > 0) {
                message = "Payment deleted successfully!";
            } else {
                error = "Payment record not found.";
            }
        }
    }

}
catch(Exception e) {

    error = e.getMessage();

}
finally {

    try {
        if (ps != null) {
            ps.close();
        }
    } catch(Exception e) {}

    try {
        if (con != null) {
            con.close();
        }
    } catch(Exception e) {}
}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Payments - Admin</title>

<link
    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
    rel="stylesheet"
>

<style>

/* ================= GLOBAL ================= */

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: Arial, sans-serif;
}

body {
    background: #f3f4f6;
    color: #111827;
}


/* ================= SIDEBAR ================= */

.sidebar {

    position: fixed;

    left: 0;
    top: 0;

    width: 250px;
    height: 100vh;

    background: #111827;

    color: white;

    padding: 25px 15px;

}

.sidebar h2 {

    text-align: center;

    margin-bottom: 35px;

    font-size: 24px;

}

.sidebar a {

    display: block;

    color: #d1d5db;

    text-decoration: none;

    padding: 13px 15px;

    margin-bottom: 6px;

    border-radius: 8px;

    font-size: 15px;

}

.sidebar a:hover {

    background: #1f2937;

    color: white;

}

.sidebar a.active {

    background: #2563eb;

    color: white;

}

.sidebar i {

    margin-right: 10px;

}


/* ================= MAIN ================= */

.main {

    margin-left: 250px;

    padding: 25px;

}


/* ================= TOPBAR ================= */

.topbar {

    background: white;

    padding: 18px 22px;

    border-radius: 10px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 25px;

    box-shadow: 0 2px 8px rgba(0,0,0,0.05);

}

.topbar h1 {

    font-size: 24px;

}

.admin {

    color: #374151;

}


/* ================= MESSAGE ================= */

.success {

    background: #dcfce7;

    color: #166534;

    padding: 12px 15px;

    border-radius: 7px;

    margin-bottom: 20px;

}

.error {

    background: #fee2e2;

    color: #991b1b;

    padding: 12px 15px;

    border-radius: 7px;

    margin-bottom: 20px;

}


/* ================= STATS ================= */

.stats {

    display: grid;

    grid-template-columns: repeat(4, 1fr);

    gap: 20px;

    margin-bottom: 25px;

}

.card {

    background: white;

    padding: 22px;

    border-radius: 10px;

    box-shadow: 0 2px 8px rgba(0,0,0,0.05);

}

.card-title {

    color: #6b7280;

    font-size: 14px;

    margin-bottom: 10px;

}

.card-value {

    font-size: 26px;

    font-weight: bold;

}


/* ================= PAYMENT BOX ================= */

.payment-box {

    background: white;

    padding: 22px;

    border-radius: 10px;

    box-shadow: 0 2px 8px rgba(0,0,0,0.05);

    overflow-x: auto;

}

.payment-header {

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 20px;

}

.payment-header h2 {

    font-size: 20px;

}


/* ================= SEARCH ================= */

.search {

    margin-bottom: 20px;

}

.search input {

    width: 350px;

    padding: 11px 14px;

    border: 1px solid #d1d5db;

    border-radius: 7px;

    outline: none;

    font-size: 14px;

}

.search input:focus {

    border-color: #2563eb;

}


/* ================= TABLE ================= */

.table-wrapper {

    overflow-x: auto;

}

table {

    width: 100%;

    border-collapse: collapse;

    min-width: 1500px;

}

th {

    background: #f9fafb;

    text-align: left;

    padding: 14px;

    font-size: 13px;

    color: #4b5563;

    border-bottom: 1px solid #e5e7eb;

    white-space: nowrap;

}

td {

    padding: 14px;

    border-bottom: 1px solid #e5e7eb;

    font-size: 13px;

    vertical-align: top;

}

tr:hover {

    background: #f9fafb;

}


/* ================= ID ================= */

.payment-id {

    font-weight: bold;

    color: #2563eb;

    white-space: nowrap;

}

.order-id {

    font-weight: 600;

    color: #374151;

    white-space: nowrap;

}


/* ================= CUSTOMER ================= */

.customer-name {

    font-weight: 600;

    color: #111827;

}

.customer-email {

    font-size: 12px;

    color: #6b7280;

    margin-top: 4px;

}


/* ================= AMOUNT ================= */

.amount {

    font-weight: bold;

    white-space: nowrap;

}


/* ================= STATUS ================= */

.status {

    padding: 5px 10px;

    border-radius: 20px;

    font-size: 11px;

    font-weight: bold;

    display: inline-block;

    white-space: nowrap;

}

.paid {

    background: #dcfce7;

    color: #166534;

}

.pending {

    background: #fef3c7;

    color: #92400e;

}

.refunded {

    background: #e0e7ff;

    color: #3730a3;

}

.failed {

    background: #fee2e2;

    color: #991b1b;

}

.processing {

    background: #dbeafe;

    color: #1d4ed8;

}

.shipped {

    background: #e0f2fe;

    color: #0369a1;

}

.cancelled {

    background: #fee2e2;

    color: #991b1b;

}

.delivered {

    background: #dcfce7;

    color: #166534;

}


/* ================= ADDRESS ================= */

.address {

    max-width: 280px;

    min-width: 220px;

    line-height: 1.5;

    color: #4b5563;

}


/* ================= ACTION ================= */

.edit-btn {

    background: #2563eb;

    color: white;

    border: none;

    padding: 7px 10px;

    border-radius: 5px;

    cursor: pointer;

    margin-right: 5px;

}

.edit-btn:hover {

    background: #1d4ed8;

}

.delete-btn {

    background: #dc2626;

    color: white;

    border: none;

    padding: 7px 10px;

    border-radius: 5px;

    cursor: pointer;

}

.delete-btn:hover {

    background: #b91c1c;

}


/* ================= MODAL ================= */

.modal {

    display: none;

    position: fixed;

    z-index: 1000;

    left: 0;

    top: 0;

    width: 100%;

    height: 100%;

    background: rgba(0,0,0,0.5);

}

.modal-content {

    background: white;

    width: 450px;

    max-width: 90%;

    margin: 10% auto;

    padding: 25px;

    border-radius: 10px;

}

.modal-content h2 {

    margin-bottom: 20px;

}

.form-group {

    margin-bottom: 15px;

}

.form-group label {

    display: block;

    margin-bottom: 6px;

    font-size: 14px;

    font-weight: bold;

}

.form-group input,

.form-group select {

    width: 100%;

    padding: 10px;

    border: 1px solid #d1d5db;

    border-radius: 6px;

    outline: none;

}

.form-group input:focus,

.form-group select:focus {

    border-color: #2563eb;

}

.form-buttons {

    display: flex;

    justify-content: flex-end;

    gap: 10px;

    margin-top: 20px;

}

.save-btn {

    background: #2563eb;

    color: white;

    border: none;

    padding: 10px 18px;

    border-radius: 6px;

    cursor: pointer;

}

.save-btn:hover {

    background: #1d4ed8;

}

.cancel-btn {

    background: #6b7280;

    color: white;

    border: none;

    padding: 10px 18px;

    border-radius: 6px;

    cursor: pointer;

}


/* ================= RESPONSIVE ================= */

@media(max-width: 1000px) {

    .stats {

        grid-template-columns: repeat(2, 1fr);

    }

}

@media(max-width: 700px) {

    .sidebar {

        width: 200px;

    }

    .main {

        margin-left: 200px;

        padding: 15px;

    }

    .stats {

        grid-template-columns: 1fr;

    }

    .search input {

        width: 100%;

    }

}

</style>

</head>


<body>


<!-- ================= SIDEBAR ================= -->

<div class="sidebar">

    <h2>Admin Panel</h2>

    <a href="home.jsp">

        <i class="bi bi-speedometer2"></i>

        Dashboard

    </a>

    <a href="products.jsp">

        <i class="bi bi-box-seam"></i>

        Products

    </a>

    <a href="categories.jsp">

        <i class="bi bi-grid"></i>

        Categories

    </a>

    <a href="orders.jsp">

        <i class="bi bi-cart3"></i>

        Orders

    </a>

    <a href="customers.jsp">

        <i class="bi bi-people"></i>

        Customers

    </a>

    <a href="payments.jsp" class="active">

        <i class="bi bi-credit-card"></i>

        Payments

    </a>

    <a href="reports.jsp">

        <i class="bi bi-bar-chart"></i>

        Reports

    </a>

    <a href="change_password.jsp">

        <i class="bi bi-key"></i>

        Change Password

    </a>

    <a href="logout.jsp">

        <i class="bi bi-box-arrow-right"></i>

        Logout

    </a>

</div>


<!-- ================= MAIN ================= -->

<div class="main">


    <!-- TOPBAR -->

    <div class="topbar">

        <h1>Payments</h1>

        <div class="admin">

            <i class="bi bi-person-circle"></i>

            <%= adminName %>

        </div>

    </div>


    <% if (!message.equals("")) { %>

        <div class="success">

            <i class="bi bi-check-circle"></i>

            <%= message %>

        </div>

    <% } %>


    <% if (!error.equals("")) { %>

        <div class="error">

            <i class="bi bi-exclamation-circle"></i>

            Database Error:

            <%= error %>

        </div>

    <% } %>


<%

/* ============================================================
   PAYMENT STATISTICS
   ============================================================ */

double totalRevenue = 0;

int successfulPayments = 0;

int pendingPayments = 0;

int refunds = 0;

Connection statCon = null;

PreparedStatement statPs = null;

ResultSet statRs = null;

try {

    Class.forName(driver);

    statCon = DriverManager.getConnection(
        url,
        dbUser,
        dbPassword
    );


    /* TOTAL PAID REVENUE */

    statPs = statCon.prepareStatement(
        "SELECT NVL(SUM(AMOUNT),0) " +
        "FROM AK_PAYMENT " +
        "WHERE UPPER(PAYMENT_STATUS)='PAID'"
    );

    statRs = statPs.executeQuery();

    if (statRs.next()) {

        totalRevenue = statRs.getDouble(1);

    }

    statRs.close();
    statPs.close();


    /* SUCCESSFUL */

    statPs = statCon.prepareStatement(
        "SELECT COUNT(*) " +
        "FROM AK_PAYMENT " +
        "WHERE UPPER(PAYMENT_STATUS)='PAID'"
    );

    statRs = statPs.executeQuery();

    if (statRs.next()) {

        successfulPayments = statRs.getInt(1);

    }

    statRs.close();
    statPs.close();


    /* PENDING */

    statPs = statCon.prepareStatement(
        "SELECT COUNT(*) " +
        "FROM AK_PAYMENT " +
        "WHERE UPPER(PAYMENT_STATUS)='PENDING'"
    );

    statRs = statPs.executeQuery();

    if (statRs.next()) {

        pendingPayments = statRs.getInt(1);

    }

    statRs.close();
    statPs.close();


    /* REFUNDED */

    statPs = statCon.prepareStatement(
        "SELECT COUNT(*) " +
        "FROM AK_PAYMENT " +
        "WHERE UPPER(PAYMENT_STATUS)='REFUNDED'"
    );

    statRs = statPs.executeQuery();

    if (statRs.next()) {

        refunds = statRs.getInt(1);

    }

}
catch(Exception e) {

}
finally {

    try {
        if (statRs != null) statRs.close();
    } catch(Exception e) {}

    try {
        if (statPs != null) statPs.close();
    } catch(Exception e) {}

    try {
        if (statCon != null) statCon.close();
    } catch(Exception e) {}

}

%>


    <!-- ================= STATS ================= -->

    <div class="stats">


        <div class="card">

            <div class="card-title">

                Total Revenue

            </div>

            <div class="card-value">

                ₹<%= String.format("%,.2f", totalRevenue) %>

            </div>

        </div>


        <div class="card">

            <div class="card-title">

                Successful Payments

            </div>

            <div class="card-value">

                <%= successfulPayments %>

            </div>

        </div>


        <div class="card">

            <div class="card-title">

                Pending Payments

            </div>

            <div class="card-value">

                <%= pendingPayments %>

            </div>

        </div>


        <div class="card">

            <div class="card-title">

                Refunds

            </div>

            <div class="card-value">

                <%= refunds %>

            </div>

        </div>


    </div>


    <!-- ================= PAYMENT TABLE ================= -->

    <div class="payment-box">


        <div class="payment-header">

            <h2>

                Customer Payment Transactions

            </h2>

        </div>


        <!-- SEARCH -->

        <div class="search">

            <input
                type="text"
                id="searchInput"
                placeholder="Search Payment ID, Order ID, Customer, Email..."
                onkeyup="searchPayments()"
            >

        </div>


        <div class="table-wrapper">


            <table id="paymentTable">


                <thead>

                    <tr>

                        <th>Payment ID</th>

                        <th>Order ID</th>

                        <th>Customer</th>

                        <th>Amount</th>

                        <th>Payment Method</th>

                        <th>Payment Status</th>

                        <th>Order Status</th>

                        <th>Shipping Address</th>

                        <th>Payment Date</th>

                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>


<%

/* ============================================================
   PAYMENT + ORDER DETAILS
   ============================================================ */

Connection tableCon = null;

PreparedStatement tablePs = null;

ResultSet tableRs = null;

try {

    Class.forName(driver);

    tableCon = DriverManager.getConnection(
        url,
        dbUser,
        dbPassword
    );


    /*
       AK_PAYMENT + AK_ORDER

       Payment table:
       PAYMENT_ID
       ORDER_ID
       CUSTOMER_NAME
       AMOUNT
       PAYMENT_METHOD
       PAYMENT_STATUS
       PAYMENT_DATE

       Order table:
       CUSTOMER_EMAIL
       STATUS
       SHIPPING_ADDRESS
    */

    String sql =

        "SELECT " +

        "p.PAYMENT_ID, " +
        "p.ORDER_ID, " +
        "p.CUSTOMER_NAME AS PAYMENT_CUSTOMER_NAME, " +
        "p.AMOUNT, " +
        "p.PAYMENT_METHOD, " +
        "p.PAYMENT_STATUS, " +
        "p.PAYMENT_DATE, " +

        "o.CUSTOMER_NAME AS ORDER_CUSTOMER_NAME, " +
        "o.CUSTOMER_EMAIL, " +
        "o.STATUS AS ORDER_STATUS, " +
        "o.SHIPPING_ADDRESS " +

        "FROM AK_PAYMENT p " +

        "LEFT JOIN AK_ORDER o " +

        "ON p.ORDER_ID = o.ORDER_ID " +

        "ORDER BY p.PAYMENT_DATE DESC";


    tablePs = tableCon.prepareStatement(sql);

    tableRs = tablePs.executeQuery();


    boolean found = false;


    while (tableRs.next()) {

        found = true;


        String paymentId =
            tableRs.getString("PAYMENT_ID");

        String orderId =
            tableRs.getString("ORDER_ID");


        String paymentCustomer =
            tableRs.getString("PAYMENT_CUSTOMER_NAME");

        String orderCustomer =
            tableRs.getString("ORDER_CUSTOMER_NAME");


        String customerName = paymentCustomer;

        if (customerName == null || customerName.trim().isEmpty()) {

            customerName = orderCustomer;

        }


        String customerEmail =
            tableRs.getString("CUSTOMER_EMAIL");


        double amount =
            tableRs.getDouble("AMOUNT");


        String method =
            tableRs.getString("PAYMENT_METHOD");


        String paymentStatus =
            tableRs.getString("PAYMENT_STATUS");


        String orderStatus =
            tableRs.getString("ORDER_STATUS");


        String shippingAddress =
            tableRs.getString("SHIPPING_ADDRESS");


        Timestamp paymentDate =
            tableRs.getTimestamp("PAYMENT_DATE");


        if (shippingAddress == null ||
            shippingAddress.trim().isEmpty()) {

            shippingAddress = "Not provided";

        }


        if (customerEmail == null ||
            customerEmail.trim().isEmpty()) {

            customerEmail = "Not available";

        }


        if (paymentStatus == null) {

            paymentStatus = "Unknown";

        }


        if (orderStatus == null) {

            orderStatus = "Unknown";

        }


        /* PAYMENT STATUS CLASS */

        String paymentStatusClass = "pending";


        if ("PAID".equalsIgnoreCase(paymentStatus)) {

            paymentStatusClass = "paid";

        }

        else if ("REFUNDED".equalsIgnoreCase(paymentStatus)) {

            paymentStatusClass = "refunded";

        }

        else if ("FAILED".equalsIgnoreCase(paymentStatus)) {

            paymentStatusClass = "failed";

        }


        /* ORDER STATUS CLASS */

        String orderStatusClass = "processing";


        if ("SHIPPED".equalsIgnoreCase(orderStatus)) {

            orderStatusClass = "shipped";

        }

        else if ("CANCELLED".equalsIgnoreCase(orderStatus)) {

            orderStatusClass = "cancelled";

        }

        else if ("DELIVERED".equalsIgnoreCase(orderStatus)) {

            orderStatusClass = "delivered";

        }

%>


                    <tr>


                        <!-- PAYMENT ID -->

                        <td>

                            <div class="payment-id">

                                <%= paymentId %>

                            </div>

                        </td>


                        <!-- ORDER ID -->

                        <td>

                            <div class="order-id">

                                <%= orderId %>

                            </div>

                        </td>


                        <!-- CUSTOMER -->

                        <td>

                            <div class="customer-name">

                                <%= customerName %>

                            </div>

                            <div class="customer-email">

                                <%= customerEmail %>

                            </div>

                        </td>


                        <!-- AMOUNT -->

                        <td>

                            <div class="amount">

                                ₹<%= String.format("%,.2f", amount) %>

                            </div>

                        </td>


                        <!-- PAYMENT METHOD -->

                        <td>

                            <%= method != null ? method : "Not available" %>

                        </td>


                        <!-- PAYMENT STATUS -->

                        <td>

                            <span class="status <%= paymentStatusClass %>">

                                <%= paymentStatus %>

                            </span>

                        </td>


                        <!-- ORDER STATUS -->

                        <td>

                            <span class="status <%= orderStatusClass %>">

                                <%= orderStatus %>

                            </span>

                        </td>


                        <!-- SHIPPING ADDRESS -->

                        <td>

                            <div class="address">

                                <%= shippingAddress %>

                            </div>

                        </td>


                        <!-- PAYMENT DATE -->

                        <td>

                            <%= paymentDate != null
                                ? paymentDate
                                : "Not available" %>

                        </td>


                        <!-- ACTION -->

                        <td>


                            <button
                                type="button"
                                class="edit-btn"
                                onclick="editPayment(
                                    '<%= paymentId.replace("'", "\\'") %>',
                                    '<%= paymentStatus %>'
                                )"
                            >

                                <i class="bi bi-pencil"></i>

                            </button>


                            <button
                                type="button"
                                class="delete-btn"
                                onclick="deletePayment(
                                    '<%= paymentId.replace("'", "\\'") %>'
                                )"
                            >

                                <i class="bi bi-trash"></i>

                            </button>


                        </td>


                    </tr>


<%

    }


    if (!found) {

%>


                    <tr>

                        <td
                            colspan="10"
                            style="
                                text-align:center;
                                padding:40px;
                                color:#6b7280;
                            "
                        >

                            <i
                                class="bi bi-credit-card"
                                style="
                                    font-size:30px;
                                    display:block;
                                    margin-bottom:10px;
                                "
                            ></i>

                            No customer payment records found.

                        </td>

                    </tr>


<%

    }

}
catch(Exception e) {

%>


                    <tr>

                        <td
                            colspan="10"
                            style="
                                color:red;
                                text-align:center;
                                padding:30px;
                            "
                        >

                            Database Error:

                            <%= e.getMessage() %>

                        </td>

                    </tr>


<%

}
finally {

    try {
        if (tableRs != null)
            tableRs.close();
    } catch(Exception e) {}

    try {
        if (tablePs != null)
            tablePs.close();
    } catch(Exception e) {}

    try {
        if (tableCon != null)
            tableCon.close();
    } catch(Exception e) {}

}

%>


                </tbody>

            </table>


        </div>


    </div>


</div>


<!-- ============================================================
     EDIT PAYMENT STATUS MODAL
     ============================================================ -->

<div class="modal" id="paymentModal">


    <div class="modal-content">


        <h2>

            Update Payment Status

        </h2>


        <form
            method="post"
            action="payments.jsp"
        >


            <input
                type="hidden"
                name="action"
                value="update"
            >


            <input
                type="hidden"
                name="paymentId"
                id="paymentId"
            >


            <div class="form-group">

                <label>

                    Payment ID

                </label>

                <input
                    type="text"
                    id="paymentIdDisplay"
                    readonly
                >

            </div>


            <div class="form-group">

                <label>

                    Payment Status

                </label>


                <select
                    name="paymentStatus"
                    id="paymentStatus"
                    required
                >

                    <option value="Paid">
                        Paid
                    </option>

                    <option value="Pending">
                        Pending
                    </option>

                    <option value="Refunded">
                        Refunded
                    </option>

                    <option value="Failed">
                        Failed
                    </option>

                </select>

            </div>


            <div class="form-buttons">


                <button
                    type="button"
                    class="cancel-btn"
                    onclick="closeModal()"
                >

                    Cancel

                </button>


                <button
                    type="submit"
                    class="save-btn"
                >

                    Update Status

                </button>


            </div>


        </form>


    </div>

</div>


<script>

/* ============================================================
   EDIT PAYMENT
   ============================================================ */

function editPayment(paymentId, status) {

    document.getElementById("paymentModal").style.display =
        "block";

    document.getElementById("paymentId").value =
        paymentId;

    document.getElementById("paymentIdDisplay").value =
        paymentId;

    document.getElementById("paymentStatus").value =
        status;

}


/* ============================================================
   CLOSE MODAL
   ============================================================ */

function closeModal() {

    document.getElementById("paymentModal").style.display =
        "none";

}


/* ============================================================
   DELETE PAYMENT
   ============================================================ */

function deletePayment(paymentId) {

    if (
        confirm(
            "Are you sure you want to delete this payment record?"
        )
    ) {

        window.location.href =
            "payments.jsp?action=delete&paymentId=" +
            encodeURIComponent(paymentId);

    }

}


/* ============================================================
   SEARCH PAYMENTS
   ============================================================ */

function searchPayments() {

    let input =
        document
        .getElementById("searchInput")
        .value
        .toLowerCase();


    let rows =
        document
        .getElementById("paymentTable")
        .getElementsByTagName("tbody")[0]
        .getElementsByTagName("tr");


    for (
        let i = 0;
        i < rows.length;
        i++
    ) {

        let text =
            rows[i].innerText.toLowerCase();


        if (text.includes(input)) {

            rows[i].style.display = "";

        }

        else {

            rows[i].style.display = "none";

        }

    }

}


/* ============================================================
   OUTSIDE MODAL CLICK
   ============================================================ */

window.onclick = function(event) {

    let modal =
        document.getElementById("paymentModal");


    if (event.target === modal) {

        modal.style.display = "none";

    }

};

</script>


</body>

</html>