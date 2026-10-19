<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.sql.*" %>
<%
String adminName = (String) session.getAttribute("admin_id");
if (adminName == null) {
    response.sendRedirect("login.jsp");
    return;
}

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

int totalCustomers = 0;
int activeCustomers = 0;
int newThisMonth = 0;

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:XE",
        "system",
        "ayush"
    );

    /* =========================
       TOTAL CUSTOMERS
       ========================= */

    String totalSql =
        "SELECT COUNT(*) FROM AK_CUSTOMER";

    ps = con.prepareStatement(totalSql);
    rs = ps.executeQuery();

    if (rs.next()) {
        totalCustomers = rs.getInt(1);
    }

    rs.close();
    ps.close();


    /* =========================
       ACTIVE CUSTOMERS
       ========================= */

    String activeSql =
        "SELECT COUNT(*) " +
        "FROM AK_CUSTOMER " +
        "WHERE UPPER(NVL(STATUS, 'ACTIVE')) = 'ACTIVE'";

    ps = con.prepareStatement(activeSql);
    rs = ps.executeQuery();

    if (rs.next()) {
        activeCustomers = rs.getInt(1);
    }

    rs.close();
    ps.close();


    /* =========================
       NEW CUSTOMERS THIS MONTH
       ========================= */

    String newSql =
        "SELECT COUNT(*) " +
        "FROM AK_CUSTOMER " +
        "WHERE CREATED_AT >= TRUNC(SYSDATE, 'MM')";

    ps = con.prepareStatement(newSql);
    rs = ps.executeQuery();

    if (rs.next()) {
        newThisMonth = rs.getInt(1);
    }

    rs.close();
    ps.close();

} catch (Exception e) {

    e.printStackTrace();

} finally {

    try {
        if (rs != null) rs.close();
    } catch (Exception e) {}

    try {
        if (ps != null) ps.close();
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

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Customers - AK Shop</title>

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
       STATS
    ========================== */

    .stats-row {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
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

    .blue {
        background: #2563eb;
    }

    .green {
        background: #16a34a;
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
        margin: 5px 0 0;
        color: #111827;
        font-size: 25px;
    }

    /* =========================
       CUSTOMER TABLE
    ========================== */

    .page-card {
        background: #ffffff;
        padding: 25px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
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

    .search-box {
        width: 290px;
        padding: 11px 13px;
        border: 1px solid #d8dee8;
        border-radius: 8px;
        outline: none;
        font-size: 14px;
    }

    .search-box:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    .table-box {
        overflow-x: auto;
    }

    table {
        width: 100%;
        min-width: 900px;
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

    .customer-name {
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
        color: #1f2937;
    }

    .customer-avatar {
        width: 35px;
        height: 35px;
        border-radius: 50%;
        background: #dbeafe;
        color: #1d4ed8;
        display: flex;
        justify-content: center;
        align-items: center;
        font-size: 14px;
        font-weight: bold;
    }

    .status-active {
        color: #15803d;
        background: #dcfce7;
        padding: 5px 9px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }

    .status-inactive {
        color: #b91c1c;
        background: #fee2e2;
        padding: 5px 9px;
        border-radius: 20px;
        font-size: 12px;
        font-weight: bold;
    }

    .view-btn {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        background: #2563eb;
        color: #ffffff;
        border: none;
        padding: 8px 12px;
        border-radius: 6px;
        cursor: pointer;
        font-size: 13px;
    }

    .view-btn:hover {
        background: #1d4ed8;
    }

    /* =========================
       MODAL
    ========================== */

    .modal {
        display: none;
        position: fixed;
        z-index: 999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.55);
        align-items: center;
        justify-content: center;
    }

    .modal-content {
        background: #ffffff;
        width: 450px;
        max-width: 90%;
        border-radius: 12px;
        padding: 25px;
        box-shadow: 0 10px 30px rgba(0,0,0,0.2);
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
        color: #111827;
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
        gap: 15px;
        padding: 12px 0;
        border-bottom: 1px solid #e5e7eb;
    }

    .detail-label {
        font-weight: 600;
        color: #4b5563;
    }

    .detail-value {
        color: #111827;
        text-align: right;
        word-break: break-word;
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

        .search-box {
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
<!-- SIDEBAR -->

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
            <a href="customers.jsp" class="active">
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


<!-- MAIN CONTENT -->

<main class="admin-main">

    <div class="admin-topbar">

        <div>

            <h4>Customer Management</h4>

            <p>
                View all registered customers and their details.
            </p>

        </div>

        <div class="admin-profile">

            <i class="bi bi-person-circle"></i>

            <span><%= adminName %></span>

        </div>

    </div>


    <!-- CUSTOMER SUMMARY -->

    <div class="stats-row">

        <div class="stat-card">

            <div class="stat-icon blue">
                <i class="bi bi-people"></i>
            </div>

            <div>

                <p>Total Customers</p>

                <h3><%= totalCustomers %></h3>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon green">
                <i class="bi bi-person-check"></i>
            </div>

            <div>

                <p>Active Customers</p>

                <h3><%= activeCustomers %></h3>

            </div>

        </div>


        <div class="stat-card">

            <div class="stat-icon purple">
                <i class="bi bi-person-plus"></i>
            </div>

            <div>

                <p>New This Month</p>

                <h3><%= newThisMonth %></h3>

            </div>

        </div>

    </div>


    <!-- CUSTOMER TABLE -->

    <section class="page-card">

        <div class="table-heading">

            <h2>
                <i class="bi bi-people"></i>
                All Customers
            </h2>

            <input
                type="text"
                id="searchCustomer"
                class="search-box"
                placeholder="Search customer name or email"
                onkeyup="searchCustomer()">

        </div>


        <div class="table-box">

            <table id="customerTable">

                <thead>

                    <tr>

                        <th>Customer ID</th>

                        <th>Customer</th>

                        <th>Email</th>

                        <th>Phone</th>

                        <th>Address</th>

                        <th>Status</th>

                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>

                <%

                    Connection customerCon = null;
                    PreparedStatement customerPs = null;
                    ResultSet customerRs = null;

                    try {

                        Class.forName(
                            "oracle.jdbc.driver.OracleDriver"
                        );

                        customerCon = DriverManager.getConnection(
                            "jdbc:oracle:thin:@localhost:1521:XE",
                            "system",
                            "ayush"
                        );


                        /*
                         * IMPORTANT:
                         * CUSTOMER DATA IS NOW COMING
                         * ONLY FROM AK_CUSTOMER.
                         */

                        String customerSql =
                            "SELECT CUSTOMER_ID, " +
                            "CUSTOMER_NAME, " +
                            "CUSTOMER_EMAIL, " +
                            "CUSTOMER_PHONE, " +
                            "ADDRESS, " +
                            "STATUS " +
                            "FROM AK_CUSTOMER " +
                            "ORDER BY CUSTOMER_ID DESC";


                        customerPs =
                            customerCon.prepareStatement(
                                customerSql
                            );

                        customerRs =
                            customerPs.executeQuery();


                        while (customerRs.next()) {

                            String customerId =
                                customerRs.getString(
                                    "CUSTOMER_ID"
                                );

                            String customerName =
                                customerRs.getString(
                                    "CUSTOMER_NAME"
                                );

                            String customerEmail =
                                customerRs.getString(
                                    "CUSTOMER_EMAIL"
                                );

                            String customerPhone =
                                customerRs.getString(
                                    "CUSTOMER_PHONE"
                                );

                            String address =
                                customerRs.getString(
                                    "ADDRESS"
                                );

                            String status =
                                customerRs.getString(
                                    "STATUS"
                                );


                            if (customerName == null ||
                                customerName.trim().isEmpty()) {

                                customerName = "Unknown";
                            }


                            if (customerEmail == null ||
                                customerEmail.trim().isEmpty()) {

                                customerEmail = "-";
                            }


                            if (customerPhone == null ||
                                customerPhone.trim().isEmpty()) {

                                customerPhone = "-";
                            }


                            if (address == null ||
                                address.trim().isEmpty()) {

                                address = "-";
                            }


                            if (status == null ||
                                status.trim().isEmpty()) {

                                status = "ACTIVE";
                            }


                            String initials = "";

                            String[] nameParts =
                                customerName.trim()
                                            .split("\\s+");


                            if (nameParts.length >= 2) {

                                initials =
                                    nameParts[0].substring(0, 1) +
                                    nameParts[1].substring(0, 1);

                            } else if (
                                nameParts.length == 1 &&
                                nameParts[0].length() > 0
                            ) {

                                initials =
                                    nameParts[0].substring(0, 1);
                            }


                            initials =
                                initials.toUpperCase();


                            String safeName =
                                customerName
                                    .replace("\\", "\\\\")
                                    .replace("'", "\\'")
                                    .replace("\"", "\\\"");


                            String safeEmail =
                                customerEmail
                                    .replace("\\", "\\\\")
                                    .replace("'", "\\'")
                                    .replace("\"", "\\\"");


                            String safePhone =
                                customerPhone
                                    .replace("\\", "\\\\")
                                    .replace("'", "\\'")
                                    .replace("\"", "\\\"");


                            String safeAddress =
                                address
                                    .replace("\\", "\\\\")
                                    .replace("'", "\\'")
                                    .replace("\"", "\\\"");

                %>

                <tr>

                    <td>
                        <%= customerId %>
                    </td>


                    <td>

                        <div class="customer-name">

                            <div class="customer-avatar">
                                <%= initials %>
                            </div>

                            <%= customerName %>

                        </div>

                    </td>


                    <td>
                        <%= customerEmail %>
                    </td>


                    <td>
                        <%= customerPhone %>
                    </td>


                    <td>
                        <%= address %>
                    </td>


                    <td>

                        <%
                            if ("ACTIVE".equalsIgnoreCase(status)) {
                        %>

                            <span class="status-active">
                                ACTIVE
                            </span>

                        <%
                            } else {
                        %>

                            <span class="status-inactive">
                                <%= status %>
                            </span>

                        <%
                            }
                        %>

                    </td>


                    <td>

                        <button
                            type="button"
                            class="view-btn"
                            onclick="viewCustomer(
                                '<%= safeName %>',
                                '<%= safeEmail %>',
                                '<%= safePhone %>',
                                '<%= safeAddress %>',
                                '<%= status %>'
                            )">

                            <i class="bi bi-eye"></i>

                            View

                        </button>

                    </td>

                </tr>

                <%

                        }

                    } catch (Exception e) {

                %>

                <tr>

                    <td
                        colspan="7"
                        style="color:red;text-align:center;padding:20px;">

                        Database Error:
                        <%= e.getMessage() %>

                    </td>

                </tr>

                <%

                    } finally {

                        try {
                            if (customerRs != null)
                                customerRs.close();
                        } catch (Exception e) {}

                        try {
                            if (customerPs != null)
                                customerPs.close();
                        } catch (Exception e) {}

                        try {
                            if (customerCon != null)
                                customerCon.close();
                        } catch (Exception e) {}
                    }

                %>

                </tbody>

            </table>

        </div>

    </section>

</main>
</div>

<!-- CUSTOMER VIEW MODAL -->

<div class="modal" id="customerModal">
<div class="modal-content">

    <div class="modal-header">

        <h3>
            <i class="bi bi-person-circle"></i>
            Customer Details
        </h3>

        <button
            class="close-btn"
            onclick="closeCustomer()">

            &times;

        </button>

    </div>


    <div class="detail-row">

        <span class="detail-label">
            Customer
        </span>

        <span
            class="detail-value"
            id="modalName">
        </span>

    </div>


    <div class="detail-row">

        <span class="detail-label">
            Email
        </span>

        <span
            class="detail-value"
            id="modalEmail">
        </span>

    </div>


    <div class="detail-row">

        <span class="detail-label">
            Phone
        </span>

        <span
            class="detail-value"
            id="modalPhone">
        </span>

    </div>


    <div class="detail-row">

        <span class="detail-label">
            Address
        </span>

        <span
            class="detail-value"
            id="modalAddress">
        </span>

    </div>


    <div class="detail-row">

        <span class="detail-label">
            Status
        </span>

        <span
            class="detail-value"
            id="modalStatus">
        </span>

    </div>

</div>
```

</div>

<script>

    /* =========================
       SEARCH CUSTOMER
    ========================== */

    function searchCustomer() {

        var input =
            document.getElementById("searchCustomer");

        var filter =
            input.value.toLowerCase();

        var table =
            document.getElementById("customerTable");

        var rows =
            table.getElementsByTagName("tbody")[0]
                 .getElementsByTagName("tr");


        for (var i = 0; i < rows.length; i++) {

            var text =
                rows[i].innerText.toLowerCase();


            if (text.indexOf(filter) > -1) {

                rows[i].style.display = "";

            } else {

                rows[i].style.display = "none";
            }
        }
    }


    /* =========================
       VIEW CUSTOMER
    ========================== */

    function viewCustomer(
        name,
        email,
        phone,
        address,
        status
    ) {

        document.getElementById("modalName").innerText =
            name;

        document.getElementById("modalEmail").innerText =
            email;

        document.getElementById("modalPhone").innerText =
            phone;

        document.getElementById("modalAddress").innerText =
            address;

        document.getElementById("modalStatus").innerText =
            status;

        document.getElementById("customerModal").style.display =
            "flex";
    }


    /* =========================
       CLOSE MODAL
    ========================== */

    function closeCustomer() {

        document.getElementById("customerModal").style.display =
            "none";
    }


    /* =========================
       CLOSE OUTSIDE MODAL
    ========================== */

    window.onclick = function(event) {

        var modal =
            document.getElementById("customerModal");

        if (event.target === modal) {

            modal.style.display = "none";
        }
    };

</script>

</body>

</html>
