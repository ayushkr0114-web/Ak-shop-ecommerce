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

    String message = "";
    String error = "";

    /*
     * =========================
     * UPDATE ORDER STATUS
     * =========================
     */
    if ("POST".equalsIgnoreCase(request.getMethod())
            && "updateStatus".equals(request.getParameter("action"))) {

        String orderId = request.getParameter("orderId");
        String status = request.getParameter("status");

        if (orderId != null && status != null) {

            try {

                Class.forName(driver);

                con = DriverManager.getConnection(url, dbUser, dbPass);

                ps = con.prepareStatement(
                    "UPDATE AK_ORDER SET STATUS = ? WHERE TRIM(ORDER_ID) = TRIM(?)"
                );

                ps.setString(1, status);
                ps.setString(2, orderId);

                int updated = ps.executeUpdate();

                if (updated > 0) {
                    response.sendRedirect("orders.jsp?msg=updated");
                    return;
                }

            } catch (Exception e) {

                error = e.getMessage();

            } finally {

                try { if (ps != null) ps.close(); } catch (Exception e) {}
                try { if (con != null) con.close(); } catch (Exception e) {}

            }
        }
    }

    if ("updated".equals(request.getParameter("msg"))) {
        message = "Order status updated successfully.";
    }

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Orders - AK Shop</title>

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
========================= */

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
========================= */

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
    box-shadow: 0 2px 10px rgba(0,0,0,0.06);
    margin-bottom: 25px;
}

.admin-topbar h4 {
    margin: 0;
    color: #111827;
    font-size: 23px;
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
   MESSAGE
========================= */

.success-message {
    background: #dcfce7;
    color: #166534;
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 20px;
    border: 1px solid #bbf7d0;
}

.error-message {
    background: #fee2e2;
    color: #991b1b;
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 20px;
    border: 1px solid #fecaca;
}

/* =========================
   STATISTICS
========================= */

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
    box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}

.stat-icon {
    width: 55px;
    height: 55px;
    border-radius: 12px;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #ffffff;
    font-size: 24px;
    flex-shrink: 0;
}

.orange {
    background: #ea580c;
}

.blue {
    background: #2563eb;
}

.green {
    background: #16a34a;
}

.red {
    background: #dc2626;
}

.stat-card p {
    margin: 0;
    color: #6b7280;
    font-size: 14px;
}

.stat-card h3 {
    margin: 5px 0 0;
    color: #111827;
    font-size: 25px;
}

/* =========================
   TABLE
========================= */

.page-card {
    background: #ffffff;
    padding: 25px;
    border-radius: 12px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}

.table-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 20px;
}

.table-heading h2 {
    margin: 0;
    color: #111827;
    font-size: 20px;
}

.search-order {
    width: 300px;
    padding: 11px 13px;
    border: 1px solid #d8dee8;
    border-radius: 8px;
    outline: none;
    font-size: 14px;
}

.search-order:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
}

.table-box {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 950px;
    border-collapse: collapse;
}

th {
    padding: 14px 16px;
    background: #f9fafb;
    color: #4b5563;
    text-align: left;
    font-size: 13px;
    white-space: nowrap;
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

.order-id {
    font-weight: 700;
    color: #2563eb;
}

.amount {
    font-weight: 700;
    color: #111827;
}

.date-text {
    white-space: nowrap;
}

/* =========================
   STATUS
========================= */

.status-select {
    padding: 8px 10px;
    border-radius: 7px;
    border: 1px solid #d8dee8;
    outline: none;
    font-size: 13px;
    background: #ffffff;
    cursor: pointer;
}

.status-select:focus {
    border-color: #2563eb;
}

.update-btn {
    border: none;
    background: #2563eb;
    color: #ffffff;
    padding: 8px 11px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
}

.update-btn:hover {
    background: #1d4ed8;
}

.badge {
    display: inline-block;
    padding: 5px 10px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
}

.badge-pending {
    background: #fef3c7;
    color: #b45309;
}

.badge-processing {
    background: #dbeafe;
    color: #1d4ed8;
}

.badge-shipped {
    background: #e0e7ff;
    color: #4338ca;
}

.badge-delivered {
    background: #dcfce7;
    color: #15803d;
}

.badge-cancelled {
    background: #fee2e2;
    color: #b91c1c;
}

/* =========================
   VIEW BUTTON
========================= */

.view-btn {
    display: inline-flex;
    align-items: center;
    gap: 6px;
    background: #111827;
    color: #ffffff;
    border: none;
    padding: 8px 12px;
    border-radius: 6px;
    cursor: pointer;
    font-size: 13px;
}

.view-btn:hover {
    background: #374151;
}

/* =========================
   MODAL
========================= */

.modal {
    display: none;
    position: fixed;
    z-index: 999;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background: rgba(0,0,0,0.45);
    align-items: center;
    justify-content: center;
}

.modal-box {
    background: #ffffff;
    width: 500px;
    max-width: 92%;
    border-radius: 12px;
    padding: 25px;
    box-shadow: 0 10px 40px rgba(0,0,0,0.2);
}

.modal-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
}

.modal-header h3 {
    margin: 0;
    font-size: 20px;
}

.close-btn {
    border: none;
    background: transparent;
    font-size: 25px;
    cursor: pointer;
    color: #6b7280;
}

.detail-row {
    display: flex;
    justify-content: space-between;
    gap: 20px;
    padding: 11px 0;
    border-bottom: 1px solid #e5e7eb;
}

.detail-label {
    color: #6b7280;
    font-size: 14px;
}

.detail-value {
    color: #111827;
    font-weight: 600;
    text-align: right;
    font-size: 14px;
}

/* =========================
   RESPONSIVE
========================= */

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

    .search-order {
        width: 100%;
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
     SIDEBAR
========================= -->

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
            <a href="orders.jsp" class="active">
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
========================= -->

<main class="admin-main">

    <div class="admin-topbar">

        <div>

            <h4>Order Management</h4>

            <p>View and manage all customer orders.</p>

        </div>

        <div class="admin-profile">

            <i class="bi bi-person-circle"></i>

            <span><%= adminName %></span>

        </div>

    </div>


    <% if (!message.isEmpty()) { %>

        <div class="success-message">
            <i class="bi bi-check-circle"></i>
            <%= message %>
        </div>

    <% } %>


    <% if (!error.isEmpty()) { %>

        <div class="error-message">
            <i class="bi bi-exclamation-circle"></i>
            <%= error %>
        </div>

    <% } %>


    <!-- =========================
         STATISTICS
    ========================== -->

    <div class="stats-row">

<%

    int pendingCount = 0;
    int processingCount = 0;
    int deliveredCount = 0;
    int cancelledCount = 0;

    try {

        Class.forName(driver);

        con = DriverManager.getConnection(url, dbUser, dbPass);

        ps = con.prepareStatement(
            "SELECT STATUS, COUNT(*) CNT FROM AK_ORDER GROUP BY STATUS"
        );

        rs = ps.executeQuery();

        while (rs.next()) {

            String st = rs.getString("STATUS");

            int count = rs.getInt("CNT");

            if ("Pending".equalsIgnoreCase(st)) {
                pendingCount = count;
            }
            else if ("Processing".equalsIgnoreCase(st)) {
                processingCount = count;
            }
            else if ("Delivered".equalsIgnoreCase(st)) {
                deliveredCount = count;
            }
            else if ("Cancelled".equalsIgnoreCase(st)) {
                cancelledCount = count;
            }
        }

    } catch (Exception e) {

        error = e.getMessage();

    } finally {

        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}

    }

%>

        <div class="stat-card">

            <div class="stat-icon orange">
                <i class="bi bi-clock-history"></i>
            </div>

            <div>

                <p>Pending Orders</p>

                <h3><%= pendingCount %></h3>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon blue">
                <i class="bi bi-gear"></i>
            </div>

            <div>

                <p>Processing</p>

                <h3><%= processingCount %></h3>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon green">
                <i class="bi bi-check-circle"></i>
            </div>

            <div>

                <p>Delivered</p>

                <h3><%= deliveredCount %></h3>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon red">
                <i class="bi bi-x-circle"></i>
            </div>

            <div>

                <p>Cancelled</p>

                <h3><%= cancelledCount %></h3>

            </div>

        </div>

    </div>


    <!-- =========================
         ORDER TABLE
    ========================== -->

    <section class="page-card">

        <div class="table-heading">

            <h2>
                <i class="bi bi-cart-check"></i>
                All Orders
            </h2>

            <input
                type="text"
                id="searchOrder"
                class="search-order"
                placeholder="Search Order ID or Customer...">

        </div>


        <div class="table-box">

            <table id="orderTable">

                <thead>

                    <tr>

                        <th>Order ID</th>

                        <th>Customer</th>

                        <th>Amount</th>

                        <th>Date</th>

                        <th>Current Status</th>

                        <th>Update Status</th>

                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>

<%

    try {

        Class.forName(driver);

        con = DriverManager.getConnection(url, dbUser, dbPass);

        ps = con.prepareStatement(
            "SELECT ORDER_ID, CUSTOMER_NAME, CUSTOMER_EMAIL, " +
            "TOTAL_AMOUNT, ORDER_DATE, STATUS, SHIPPING_ADDRESS " +
            "FROM AK_ORDER ORDER BY ORDER_DATE DESC"
        );

        rs = ps.executeQuery();

        boolean hasOrders = false;

        while (rs.next()) {

            hasOrders = true;

            String orderId = rs.getString("ORDER_ID");
            String customerName = rs.getString("CUSTOMER_NAME");
            String customerEmail = rs.getString("CUSTOMER_EMAIL");
            double amount = rs.getDouble("TOTAL_AMOUNT");
            Timestamp orderDate = rs.getTimestamp("ORDER_DATE");
            String status = rs.getString("STATUS");
            String address = rs.getString("SHIPPING_ADDRESS");

            if (status == null) {
                status = "Pending";
            }

            String badgeClass = "badge-pending";

            if ("Processing".equalsIgnoreCase(status)) {
                badgeClass = "badge-processing";
            }
            else if ("Shipped".equalsIgnoreCase(status)) {
                badgeClass = "badge-shipped";
            }
            else if ("Delivered".equalsIgnoreCase(status)) {
                badgeClass = "badge-delivered";
            }
            else if ("Cancelled".equalsIgnoreCase(status)) {
                badgeClass = "badge-cancelled";
            }

%>

                    <tr class="order-row"
                        data-search="<%= orderId.toLowerCase() %> <%= customerName.toLowerCase() %>">

                        <td class="order-id">
                            #<%= orderId %>
                        </td>

                        <td>
                            <strong><%= customerName %></strong>
                        </td>

                        <td class="amount">
                            ₹<%= String.format("%.2f", amount) %>
                        </td>

                        <td class="date-text">

                            <%
                                if (orderDate != null) {
                                    out.print(orderDate.toString().replace(".0", ""));
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

                        <td>

                            <form method="post"
                                  action="orders.jsp"
                                  style="display:flex; gap:6px;">

                                <input
                                    type="hidden"
                                    name="action"
                                    value="updateStatus">

                                <input
                                    type="hidden"
                                    name="orderId"
                                    value="<%= orderId %>">

                                <select
                                    name="status"
                                    class="status-select">

                                    <option
                                        value="Pending"
                                        <%= "Pending".equalsIgnoreCase(status) ? "selected" : "" %>>
                                        Pending
                                    </option>

                                    <option
                                        value="Processing"
                                        <%= "Processing".equalsIgnoreCase(status) ? "selected" : "" %>>
                                        Processing
                                    </option>

                                    <option
                                        value="Shipped"
                                        <%= "Shipped".equalsIgnoreCase(status) ? "selected" : "" %>>
                                        Shipped
                                    </option>

                                    <option
                                        value="Delivered"
                                        <%= "Delivered".equalsIgnoreCase(status) ? "selected" : "" %>>
                                        Delivered
                                    </option>

                                    <option
                                        value="Cancelled"
                                        <%= "Cancelled".equalsIgnoreCase(status) ? "selected" : "" %>>
                                        Cancelled
                                    </option>

                                </select>

                                <button
                                    type="submit"
                                    class="update-btn">

                                    <i class="bi bi-check2"></i>

                                </button>

                            </form>

                        </td>

                        <td>

                            <button
                                type="button"
                                class="view-btn"
                                onclick="viewOrder(
                                    '<%= orderId.replace("'", "\\'") %>',
                                    '<%= customerName.replace("'", "\\'") %>',
                                    '<%= customerEmail == null ? "" : customerEmail.replace("'", "\\'") %>',
                                    '<%= String.format("%.2f", amount) %>',
                                    '<%= status.replace("'", "\\'") %>',
                                    '<%= address == null ? "" : address.replace("'", "\\'") %>'
                                )">

                                <i class="bi bi-eye"></i>

                                View

                            </button>

                        </td>

                    </tr>

<%

        }

        if (!hasOrders) {

%>

                    <tr>

                        <td colspan="7"
                            style="text-align:center; padding:35px; color:#6b7280;">

                            <i class="bi bi-cart-x"
                               style="font-size:35px;"></i>

                            <br><br>

                            No orders found.

                        </td>

                    </tr>

<%

        }

    } catch (Exception e) {

%>

                    <tr>

                        <td colspan="7"
                            style="text-align:center; color:#dc2626; padding:25px;">

                            Database Error: <%= e.getMessage() %>

                        </td>

                    </tr>

<%

    } finally {

        try { if (rs != null) rs.close(); } catch (Exception e) {}
        try { if (ps != null) ps.close(); } catch (Exception e) {}
        try { if (con != null) con.close(); } catch (Exception e) {}

    }

%>

                </tbody>

            </table>

        </div>

    </section>

</main>

</div>


<!-- =========================
     VIEW ORDER MODAL
========================= -->

<div id="orderModal" class="modal">

    <div class="modal-box">

        <div class="modal-header">

            <h3>
                <i class="bi bi-receipt"></i>
                Order Details
            </h3>

            <button
                class="close-btn"
                onclick="closeModal()">

                &times;

            </button>

        </div>


        <div class="detail-row">

            <span class="detail-label">
                Order ID
            </span>

            <span class="detail-value"
                  id="modalOrderId">
            </span>

        </div>


        <div class="detail-row">

            <span class="detail-label">
                Customer
            </span>

            <span class="detail-value"
                  id="modalCustomer">
            </span>

        </div>


        <div class="detail-row">

            <span class="detail-label">
                Email
            </span>

            <span class="detail-value"
                  id="modalEmail">
            </span>

        </div>


        <div class="detail-row">

            <span class="detail-label">
                Total Amount
            </span>

            <span class="detail-value"
                  id="modalAmount">
            </span>

        </div>


        <div class="detail-row">

            <span class="detail-label">
                Status
            </span>

            <span class="detail-value"
                  id="modalStatus">
            </span>

        </div>


        <div class="detail-row">

            <span class="detail-label">
                Shipping Address
            </span>

            <span class="detail-value"
                  id="modalAddress">
            </span>

        </div>

    </div>

</div>


<script>

/* =========================
   SEARCH
========================= */

document.getElementById("searchOrder").addEventListener("keyup", function() {

    let search = this.value.toLowerCase().trim();

    let rows = document.querySelectorAll(".order-row");

    rows.forEach(function(row) {

        let text = row.getAttribute("data-search");

        if (text.includes(search)) {

            row.style.display = "";

        } else {

            row.style.display = "none";

        }

    });

});


/* =========================
   VIEW ORDER
========================= */

function viewOrder(orderId, customer, email, amount, status, address) {

    document.getElementById("modalOrderId").innerText = "#" + orderId;

    document.getElementById("modalCustomer").innerText = customer;

    document.getElementById("modalEmail").innerText =
        email === "" ? "-" : email;

    document.getElementById("modalAmount").innerText =
        "₹" + amount;

    document.getElementById("modalStatus").innerText =
        status;

    document.getElementById("modalAddress").innerText =
        address === "" ? "-" : address;

    document.getElementById("orderModal").style.display = "flex";
}


/* =========================
   CLOSE MODAL
========================= */

function closeModal() {

    document.getElementById("orderModal").style.display = "none";

}


window.onclick = function(event) {

    let modal = document.getElementById("orderModal");

    if (event.target === modal) {

        closeModal();

    }

};

</script>

</body>

</html>