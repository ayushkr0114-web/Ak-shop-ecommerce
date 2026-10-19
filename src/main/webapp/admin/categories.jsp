<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*" %>

<%!
public String escapeHtml(String input) {
    if (input == null) return "";
    return input
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")
        .replace("'", "&#39;");
}
%>

<%
String adminName = (String) session.getAttribute("admin_id");

if (adminName == null) {
    response.sendRedirect("login.jsp");
    return;
}

response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String message = "";
String messageType = "";

String url = "jdbc:oracle:thin:@localhost:1521:XE";
String useridDB = "system";
String passwordDB = "ayush";

Connection con = null;

try {

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );


    /* =================================================
       DELETE
       ================================================= */

    String deleteId = request.getParameter("delete");

    if (deleteId != null && !deleteId.trim().equals("")) {

        String deleteQuery =
            "DELETE FROM AK_CATEGORY " +
            "WHERE TRIM(CATEGORY_ID) = ?";

        PreparedStatement psDelete =
            con.prepareStatement(deleteQuery);

        psDelete.setString(1, deleteId.trim());

        int result = psDelete.executeUpdate();

        psDelete.close();

        if (result > 0) {
            response.sendRedirect("categories.jsp?success=deleted");
        } else {
            response.sendRedirect("categories.jsp?error=delete");
        }

        return;
    }


    /* =================================================
       POST : ADD / UPDATE
       ================================================= */

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String action = request.getParameter("action");

        String categoryName =
            request.getParameter("categoryName");

        String categoryStatus =
            request.getParameter("categoryStatus");

        String categoryDescription =
            request.getParameter("categoryDescription");


        /* =================================================
           UPDATE CATEGORY
           ================================================= */

        if ("update".equals(action)) {

            String categoryId =
                request.getParameter("categoryId");

            if (categoryId != null) {

                categoryId = categoryId.trim();
            }

            String updateQuery =
                "UPDATE AK_CATEGORY SET " +
                "CATEGORY_NAME = ?, " +
                "DESCRIPTION = ?, " +
                "STATUS = ? " +
                "WHERE TRIM(CATEGORY_ID) = ?";


            PreparedStatement psUpdate =
                con.prepareStatement(updateQuery);

            psUpdate.setString(1, categoryName);
            psUpdate.setString(2, categoryDescription);
            psUpdate.setString(3, categoryStatus);
            psUpdate.setString(4, categoryId);


            int result =
                psUpdate.executeUpdate();


            psUpdate.close();


            if (result > 0) {

                response.sendRedirect(
                    "categories.jsp?success=updated"
                );

            } else {

                response.sendRedirect(
                    "categories.jsp?error=update"
                );
            }

            return;
        }


        /* =================================================
           ADD CATEGORY
           ================================================= */

        if ("add".equals(action)) {

            String categoryId =
                "CAT" + System.currentTimeMillis() + "_" + (int)(Math.random() * 1000);


            String insertQuery =
                "INSERT INTO AK_CATEGORY " +
                "(CATEGORY_ID, CATEGORY_NAME, DESCRIPTION, STATUS) " +
                "VALUES (?, ?, ?, ?)";


            PreparedStatement psInsert =
                con.prepareStatement(insertQuery);


            psInsert.setString(1, categoryId);
            psInsert.setString(2, categoryName);
            psInsert.setString(3, categoryDescription);
            psInsert.setString(4, categoryStatus);


            int result =
                psInsert.executeUpdate();


            psInsert.close();


            if (result > 0) {

                response.sendRedirect(
                    "categories.jsp?success=added"
                );

            } else {

                response.sendRedirect(
                    "categories.jsp?error=add"
                );
            }

            return;
        }
    }


} catch (Exception e) {

    message =
        "Database Error: " + e.getMessage();

    messageType = "error";
}


/* =====================================================
   SUCCESS / ERROR MESSAGE
   ===================================================== */

String success = request.getParameter("success");
String error = request.getParameter("error");


if ("added".equals(success)) {

    message = "Category added successfully!";
    messageType = "success";

}

else if ("updated".equals(success)) {

    message = "Category updated successfully!";
    messageType = "success";

}

else if ("deleted".equals(success)) {

    message = "Category deleted successfully!";
    messageType = "success";

}

else if ("update".equals(error)) {

    message = "Category update failed!";
    messageType = "error";

}

else if ("delete".equals(error)) {

    message = "Category delete failed!";
    messageType = "error";

}

else if ("add".equals(error)) {

    message = "Category add failed!";
    messageType = "error";

}


/* =====================================================
   EDIT MODE
   ===================================================== */

String editId = request.getParameter("edit");

String editName = "";
String editDescription = "";
String editStatus = "Active";


if (editId != null && !editId.trim().equals("")) {

    PreparedStatement editPs = null;
    ResultSet editRs = null;

    try {

        String editQuery =
            "SELECT CATEGORY_NAME, DESCRIPTION, STATUS " +
            "FROM AK_CATEGORY " +
            "WHERE TRIM(CATEGORY_ID) = ?";


        editPs =
            con.prepareStatement(editQuery);


        editPs.setString(
            1,
            editId.trim()
        );


        editRs =
            editPs.executeQuery();


        if (editRs.next()) {

            editName =
                editRs.getString("CATEGORY_NAME");

            editDescription =
                editRs.getString("DESCRIPTION");

            editStatus =
                editRs.getString("STATUS");

        } else {

            message = "Category not found!";
            messageType = "error";
        }


    } catch (Exception e) {

        message =
            "Edit Error: " + e.getMessage();

        messageType = "error";

    } finally {

        try {
            if (editRs != null)
                editRs.close();
        } catch (Exception e) {}

        try {
            if (editPs != null)
                editPs.close();
        } catch (Exception e) {}
    }
}


/* =====================================================
   LIST ALL CATEGORIES
   ===================================================== */

PreparedStatement listPs = null;
ResultSet listRs = null;

%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Categories - AK Shop</title>

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

.logout-link:hover {
    background: #dc2626 !important;
}

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

.page-card {
    background: #ffffff;
    padding: 25px;
    border-radius: 12px;
    margin-bottom: 25px;
    box-shadow: 0 2px 10px rgba(0,0,0,0.06);
}

.page-card h2 {
    margin: 0 0 22px;
    color: #111827;
    font-size: 20px;
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 18px;
}

.form-group {
    display: flex;
    flex-direction: column;
}

.form-group.full {
    grid-column: 1 / -1;
}

.form-group label {
    color: #374151;
    font-size: 14px;
    font-weight: 600;
    margin-bottom: 8px;
}

.form-group input,
.form-group textarea,
.form-group select {
    width: 100%;
    padding: 12px;
    border: 1px solid #d8dee8;
    border-radius: 8px;
    outline: none;
    font-family: Arial, sans-serif;
    font-size: 14px;
}

.form-group textarea {
    min-height: 105px;
    resize: vertical;
}

.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
}

.add-btn {
    margin-top: 22px;
    background: #2563eb;
    color: #ffffff;
    padding: 12px 20px;
    border: none;
    border-radius: 8px;
    cursor: pointer;
    font-size: 14px;
    font-weight: 600;
}

.add-btn:hover {
    background: #1d4ed8;
}

.cancel-btn {
    display: inline-block;
    margin-top: 22px;
    margin-left: 8px;
    background: #6b7280;
    color: white;
    padding: 12px 20px;
    border-radius: 8px;
    text-decoration: none;
    font-size: 14px;
    font-weight: 600;
}

.cancel-btn:hover {
    background: #4b5563;
}

.table-box {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 650px;
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

.action-btn {
    padding: 8px 10px;
    border: none;
    border-radius: 6px;
    color: #ffffff;
    cursor: pointer;
    margin-right: 5px;
    font-size: 13px;
    text-decoration: none;
    display: inline-block;
}

.edit-btn {
    background: #f59e0b;
}

.edit-btn:hover {
    background: #d97706;
}

.delete-btn {
    background: #dc2626;
}

.delete-btn:hover {
    background: #b91c1c;
}

.success-message {
    background: #dcfce7;
    color: #166534;
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 20px;
}

.error-message {
    background: #fee2e2;
    color: #991b1b;
    padding: 13px 16px;
    border-radius: 8px;
    margin-bottom: 20px;
}

.edit-mode-active {
    animation: highlightForm 0.5s ease-in-out;
}

@keyframes highlightForm {
    0% { transform: scale(1); }
    50% { transform: scale(1.01); box-shadow: 0 0 30px rgba(37,99,235,0.4); }
    100% { transform: scale(1); }
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

    .form-grid {
        grid-template-columns: 1fr;
    }
}

</style>

</head>


<body>

<div class="admin-wrapper">


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
            <a href="categories.jsp"
               class="active">

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
            <a href="logout.jsp"
               class="logout-link">

                <i class="bi bi-box-arrow-right"></i>
                Logout

            </a>
        </li>

    </ul>

</aside>


<main class="admin-main">


    <div class="admin-topbar">

        <div>

            <h4>Category Management</h4>

            <p>
                Add, edit, or delete product categories.
            </p>

        </div>


        <div class="admin-profile">

            <i class="bi bi-person-circle"></i>

            <span>
                <%= escapeHtml(adminName) %>
            </span>

        </div>

    </div>


    <% if (!message.equals("")) { %>

        <div class="<%= messageType.equals("success")
                    ? "success-message"
                    : "error-message" %>">

            <%= message %>

        </div>

    <% } %>


    <!-- =================================================
         ADD / EDIT CATEGORY FORM
         ================================================= -->

    <section class="page-card" id="categoryFormSection">

        <h2>

            <i class="bi <%= editId != null
                ? "bi-pencil-square"
                : "bi-plus-circle" %>">
            </i>

            <%= editId != null
                ? "Edit Category"
                : "Add New Category" %>

        </h2>


        <form action="categories.jsp"
              method="post">


            <input type="hidden"
                   name="action"
                   value="<%= editId != null
                       ? "update"
                       : "add" %>">


            <% if (editId != null) { %>

                <input type="hidden"
                       name="categoryId"
                       value="<%= escapeHtml(editId) %>">

            <% } %>


            <div class="form-grid">


                <!-- CATEGORY NAME -->

                <div class="form-group">

                    <label>
                        Category Name
                    </label>

                    <input type="text"
                           name="categoryName"
                           placeholder="Enter category name"
                           value="<%= (editId != null && editName != null)
                               ? escapeHtml(editName)
                               : "" %>"
                           required>

                </div>


                <!-- STATUS -->

                <div class="form-group">

                    <label>
                        Category Status
                    </label>

                    <select name="categoryStatus"
                            required>

                        <option value="Active"
                            <%= "Active".equalsIgnoreCase(editStatus)
                                ? "selected"
                                : "" %>>

                            Active

                        </option>


                        <option value="Inactive"
                            <%= "Inactive".equalsIgnoreCase(editStatus)
                                ? "selected"
                                : "" %>>

                            Inactive

                        </option>

                    </select>

                </div>


                <!-- DESCRIPTION -->

                <div class="form-group full">

                    <label>
                        Description
                    </label>

                    <textarea
                        name="categoryDescription"
                        placeholder="Enter category description"><%= (editId != null && editDescription != null)
                            ? escapeHtml(editDescription)
                            : "" %></textarea>

                </div>

            </div>


            <!-- SUBMIT -->

            <button type="submit"
                    class="add-btn">

                <i class="bi <%= editId != null
                    ? "bi-check-circle"
                    : "bi-plus-circle" %>">
                </i>

                <%= editId != null
                    ? "Update Category"
                    : "Add Category" %>

            </button>


            <!-- CANCEL EDIT -->

            <% if (editId != null) { %>

                <a href="categories.jsp"
                   class="cancel-btn">

                    Cancel

                </a>

            <% } %>


        </form>

    </section>


    <!-- =================================================
         ALL CATEGORIES
         ================================================= -->

    <section class="page-card">

        <h2>

            <i class="bi bi-tags"></i>

            All Categories

        </h2>


        <div class="table-box">


            <table>

                <thead>

                    <tr>

                        <th>ID</th>

                        <th>Category Name</th>

                        <th>Description</th>

                        <th>Status</th>

                        <th>Action</th>

                    </tr>

                </thead>


                <tbody>
<%

try {

    String query =
        "SELECT CATEGORY_ID, CATEGORY_NAME, " +
        "DESCRIPTION, STATUS " +
        "FROM AK_CATEGORY " +
        "ORDER BY CATEGORY_NAME";


    listPs =
        con.prepareStatement(query);


    listRs =
        listPs.executeQuery();


    boolean hasData = false;


    while (listRs.next()) {

        hasData = true;


        String categoryId =
            listRs.getString("CATEGORY_ID");

        String categoryName =
            listRs.getString("CATEGORY_NAME");

        String description =
            listRs.getString("DESCRIPTION");

        String status =
            listRs.getString("STATUS");

%>


                    <tr>


                        <td>
                            <%= escapeHtml(categoryId) %>
                        </td>


                        <td>
                            <%= escapeHtml(categoryName) %>
                        </td>


                        <td>
                            <%= (description != null)
                                ? escapeHtml(description)
                                : "" %>
                        </td>


                        <td>
                            <%= escapeHtml(status) %>
                        </td>


                        <td>


                            <a class="action-btn edit-btn"
                               href="categories.jsp?edit=<%= escapeHtml(categoryId) %>">

                                <i class="bi bi-pencil-square"></i>

                                Edit

                            </a>


                            <a class="action-btn delete-btn"
                               href="categories.jsp?delete=<%= escapeHtml(categoryId) %>"
                               onclick="return confirm('Are you sure you want to delete this category?');">

                                <i class="bi bi-trash"></i>

                                Delete

                            </a>


                        </td>


                    </tr>


<%

    }


    if (!hasData) {

%>


                    <tr>

                        <td colspan="5"
                            style="text-align:center;">

                            No Category Found

                        </td>

                    </tr>


<%

    }


} catch (Exception e) {

%>


                    <tr>

                        <td colspan="5"
                            style="color:red;text-align:center;">

                            Database Error:
                            <%= escapeHtml(e.getMessage()) %>

                        </td>

                    </tr>


<%

} finally {

    try {

        if (listRs != null)
            listRs.close();

    } catch(Exception e) {}


    try {

        if (listPs != null)
            listPs.close();

    } catch(Exception e) {}

}

%>


                </tbody>
            </table>
        </div>
    </section>


</main>
</div>

<%

try {
    if (con != null)
        con.close();
} catch(Exception e) {}

%>

<% if (editId != null) { %>
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const formSection = document.getElementById('categoryFormSection');
        if (formSection) {
            formSection.scrollIntoView({ behavior: 'smooth', block: 'center' });
            formSection.classList.add('edit-mode-active');
        }
    });
</script>
<% } %>

</body>
</html>