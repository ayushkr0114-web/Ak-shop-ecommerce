<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*,java.io.*,java.util.Base64"%>

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

String url = "jdbc:oracle:thin:@localhost:1521:XE";
String useridDB = "system";
String passwordDB = "ayush";

String message = "";
String messageType = "";

String editId = request.getParameter("edit");


/* =========================================================
   DATABASE ACTIONS
   ========================================================= */

try {

    Class.forName("oracle.jdbc.driver.OracleDriver");

    Connection con = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );


    /* =====================================================
       DELETE PRODUCT
       ===================================================== */

    String deleteId = request.getParameter("delete");

    if (deleteId != null && !deleteId.trim().equals("")) {

        String oldImages = "";

        PreparedStatement getImage =
            con.prepareStatement(
                "SELECT IMAGE FROM AK_PRODUCT " +
                "WHERE TRIM(PRODUCT_ID)=TRIM(?)"
            );

        getImage.setString(1, deleteId.trim());

        ResultSet imageRs = getImage.executeQuery();

        if (imageRs.next()) {
            oldImages = imageRs.getString("IMAGE");
        }

        imageRs.close();
        getImage.close();


        PreparedStatement ps =
            con.prepareStatement(
                "DELETE FROM AK_PRODUCT " +
                "WHERE TRIM(PRODUCT_ID)=TRIM(?)"
            );

        ps.setString(1, deleteId.trim());

        int result = ps.executeUpdate();

        ps.close();
        con.close();


        if (result > 0 &&
            oldImages != null &&
            !oldImages.trim().equals("")) {

            String uploadPath =
                application.getRealPath(
                    "/images/product-image"
                );

            if (uploadPath != null) {

                String[] images =
                    oldImages.split(",");

                for (String img : images) {

                    img = img.trim();

                    if (!img.equals("")) {

                        File oldFile =
                            new File(uploadPath, img);

                        if (oldFile.exists()) {
                            oldFile.delete();
                        }
                    }
                }
            }
        }


        if (result > 0) {

            response.sendRedirect(
                "products.jsp?success=deleted"
            );

        } else {

            response.sendRedirect(
                "products.jsp?error=delete"
            );
        }

        return;
    }


    /* =====================================================
       ADD / UPDATE
       ===================================================== */

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String action =
            request.getParameter("action");

        String productName =
            request.getParameter("productName");

        String category =
            request.getParameter("category");

        String price =
            request.getParameter("price");

        String stock =
            request.getParameter("stock");

        String description =
            request.getParameter("description");


        String image1Data =
            request.getParameter("image1Data");

        String image2Data =
            request.getParameter("image2Data");


        String image1Name =
            request.getParameter("image1Name");

        String image2Name =
            request.getParameter("image2Name");


        String image1 = null;
        String image2 = null;


        String uploadPath =
            application.getRealPath(
                "/images/product-image"
            );

        if (uploadPath == null) {

            throw new Exception(
                "Image folder path not found."
            );
        }

        File uploadFolder =
            new File(uploadPath);

        if (!uploadFolder.exists()) {
            uploadFolder.mkdirs();
        }


        if (image1Data != null &&
            !image1Data.trim().equals("")) {

            int comma =
                image1Data.indexOf(",");

            if (comma >= 0) {

                image1Data =
                    image1Data.substring(
                        comma + 1
                    );
            }


            byte[] imageBytes =
                Base64.getDecoder().decode(
                    image1Data
                );


            if (imageBytes.length > 700 * 1024) {

                throw new Exception(
                    "Image 1 size must be less than 700 KB."
                );
            }


            String extension = ".jpg";

            if (image1Name != null) {

                String lower =
                    image1Name.toLowerCase();

                if (lower.endsWith(".png")) {
                    extension = ".png";
                }
                else if (lower.endsWith(".jpeg")) {
                    extension = ".jpeg";
                }
                else if (lower.endsWith(".webp")) {
                    extension = ".webp";
                }
                else if (lower.endsWith(".gif")) {
                    extension = ".gif";
                }
            }


            image1 =
                "IMG_" +
                System.currentTimeMillis() +
                "_1" +
                extension;


            File imageFile =
                new File(
                    uploadFolder,
                    image1
                );


            FileOutputStream fos =
                new FileOutputStream(imageFile);

            fos.write(imageBytes);

            fos.close();
        }


        if (image2Data != null &&
            !image2Data.trim().equals("")) {

            int comma =
                image2Data.indexOf(",");

            if (comma >= 0) {

                image2Data =
                    image2Data.substring(
                        comma + 1
                    );
            }


            byte[] imageBytes =
                Base64.getDecoder().decode(
                    image2Data
                );


            if (imageBytes.length > 700 * 1024) {

                throw new Exception(
                    "Image 2 size must be less than 700 KB."
                );
            }


            String extension = ".jpg";

            if (image2Name != null) {

                String lower =
                    image2Name.toLowerCase();

                if (lower.endsWith(".png")) {
                    extension = ".png";
                }
                else if (lower.endsWith(".jpeg")) {
                    extension = ".jpeg";
                }
                else if (lower.endsWith(".webp")) {
                    extension = ".webp";
                }
                else if (lower.endsWith(".gif")) {
                    extension = ".gif";
                }
            }


            image2 =
                "IMG_" +
                System.currentTimeMillis() +
                "_2" +
                extension;


            File imageFile =
                new File(
                    uploadFolder,
                    image2
                );


            FileOutputStream fos =
                new FileOutputStream(imageFile);

            fos.write(imageBytes);

            fos.close();
        }


        if ("update".equals(action)) {

            String productId =
                request.getParameter("productId");


            String oldImages = "";

            PreparedStatement getOld =
                con.prepareStatement(
                    "SELECT IMAGE FROM AK_PRODUCT " +
                    "WHERE TRIM(PRODUCT_ID)=TRIM(?)"
                );

            getOld.setString(
                1,
                productId.trim()
            );

            ResultSet oldRs =
                getOld.executeQuery();

            if (oldRs.next()) {

                oldImages =
                    oldRs.getString("IMAGE");
            }

            oldRs.close();
            getOld.close();


            String finalImages;


            if (image1 == null &&
                image2 == null) {

                finalImages = oldImages;

            }
            else {

                String oldImage1 = "";
                String oldImage2 = "";


                if (oldImages != null &&
                    !oldImages.trim().equals("")) {

                    String[] old =
                        oldImages.split(",");

                    if (old.length > 0) {
                        oldImage1 =
                            old[0].trim();
                    }

                    if (old.length > 1) {
                        oldImage2 =
                            old[1].trim();
                    }
                }


                if (image1 == null) {
                    image1 = oldImage1;
                }

                if (image2 == null) {
                    image2 = oldImage2;
                }


                finalImages =
                    image1 + "," + image2;
            }


            String updateSQL =
                "UPDATE AK_PRODUCT SET " +
                "PRODUCT_NAME=?, " +
                "CATEGORY=?, " +
                "PRICE=?, " +
                "STOCK=?, " +
                "IMAGE=?, " +
                "DESCRIPTION=? " +
                "WHERE TRIM(PRODUCT_ID)=TRIM(?)";


            PreparedStatement ps =
                con.prepareStatement(updateSQL);


            ps.setString(1, productName);
            ps.setString(2, category);
            ps.setDouble(3, Double.parseDouble(price));
            ps.setInt(4, Integer.parseInt(stock));
            ps.setString(5, finalImages);
            ps.setString(6, description);
            ps.setString(7, productId.trim());


            int result =
                ps.executeUpdate();

            ps.close();


            if (result > 0 &&
                oldImages != null &&
                !oldImages.trim().equals("") &&
                (image1Data != null ||
                 image2Data != null)) {

                String[] old =
                    oldImages.split(",");


                for (String oldImg : old) {

                    oldImg =
                        oldImg.trim();

                    if (!oldImg.equals("")) {

                        File oldFile =
                            new File(
                                uploadFolder,
                                oldImg
                            );

                        if (oldFile.exists()) {
                            oldFile.delete();
                        }
                    }
                }
            }


            con.close();


            if (result > 0) {

                response.sendRedirect(
                    "products.jsp?success=updated"
                );

            } else {

                response.sendRedirect(
                    "products.jsp?error=update"
                );
            }

            return;
        }


        if ("add".equals(action)) {


            if (image1 == null ||
                image2 == null) {

                con.close();

                response.sendRedirect(
                    "products.jsp?error=add"
                );

                return;
            }


            String productId =
                "PROD" +
                System.currentTimeMillis();


            String images =
                image1 + "," + image2;


            String insertSQL =
                "INSERT INTO AK_PRODUCT " +
                "(PRODUCT_ID, PRODUCT_NAME, CATEGORY, PRICE, STOCK, IMAGE, DESCRIPTION) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";


            PreparedStatement ps =
                con.prepareStatement(insertSQL);


            ps.setString(1, productId);
            ps.setString(2, productName);
            ps.setString(3, category);
            ps.setDouble(4, Double.parseDouble(price));
            ps.setInt(5, Integer.parseInt(stock));
            ps.setString(6, images);
            ps.setString(7, description);


            int result =
                ps.executeUpdate();


            ps.close();
            con.close();


            if (result > 0) {

                response.sendRedirect(
                    "products.jsp?success=added"
                );

            } else {

                response.sendRedirect(
                    "products.jsp?error=add"
                );
            }

            return;
        }
    }


    con.close();

} catch (Exception e) {

    message =
        "Database Error: " +
        e.getMessage();

    messageType = "error";
}


/* =========================================================
   SUCCESS / ERROR
   ========================================================= */

String success =
    request.getParameter("success");

String error =
    request.getParameter("error");


if ("added".equals(success)) {

    message =
        "Product added successfully!";

    messageType = "success";

}
else if ("updated".equals(success)) {

    message =
        "Product updated successfully!";

    messageType = "success";

}
else if ("deleted".equals(success)) {

    message =
        "Product deleted successfully!";

    messageType = "success";

}
else if ("add".equals(error)) {

    message =
        "Product add failed!";

    messageType = "error";

}
else if ("update".equals(error)) {

    message =
        "Product update failed!";

    messageType = "error";

}
else if ("delete".equals(error)) {

    message =
        "Product delete failed!";

    messageType = "error";
}


/* =========================================================
   EDIT PRODUCT
   ========================================================= */

String editName = "";
String editCategory = "";
String editPrice = "";
String editStock = "";
String editImage = "";
String editDescription = "";


if (editId != null &&
    !editId.trim().equals("")) {

    Connection editCon = null;
    PreparedStatement editPs = null;
    ResultSet editRs = null;


    try {

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );


        editCon =
            DriverManager.getConnection(
                url,
                useridDB,
                passwordDB
            );


        String editSQL =
            "SELECT PRODUCT_NAME, CATEGORY, PRICE, STOCK, IMAGE, DESCRIPTION " +
            "FROM AK_PRODUCT " +
            "WHERE TRIM(PRODUCT_ID)=TRIM(?)";


        editPs =
            editCon.prepareStatement(
                editSQL
            );


        editPs.setString(
            1,
            editId.trim()
        );


        editRs =
            editPs.executeQuery();


        if (editRs.next()) {

            editName =
                editRs.getString(
                    "PRODUCT_NAME"
                );

            editCategory =
                editRs.getString(
                    "CATEGORY"
                );

            editPrice =
                editRs.getString(
                    "PRICE"
                );

            editStock =
                editRs.getString(
                    "STOCK"
                );

            editImage =
                editRs.getString(
                    "IMAGE"
                );

            editDescription =
                editRs.getString(
                    "DESCRIPTION"
                );

        } else {

            message =
                "Product not found!";

            messageType =
                "error";
        }


    } catch (Exception e) {

        message =
            "Edit Error: " +
            e.getMessage();

        messageType =
            "error";

    } finally {

        try {
            if (editRs != null)
                editRs.close();
        } catch (Exception e) {}

        try {
            if (editPs != null)
                editPs.close();
        } catch (Exception e) {}

        try {
            if (editCon != null)
                editCon.close();
        } catch (Exception e) {}
    }
}

%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>Products - AK Shop</title>

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
    font-size: 20px;
    color: #111827;
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
    margin-bottom: 8px;
    color: #374151;
    font-size: 14px;
    font-weight: 600;
}

.form-group input,
.form-group select,
.form-group textarea {
    width: 100%;
    padding: 12px;
    border: 1px solid #d8dee8;
    border-radius: 8px;
    outline: none;
    font-size: 14px;
    font-family: Arial, sans-serif;
}

.form-group input:focus,
.form-group select:focus,
.form-group textarea:focus {
    border-color: #2563eb;
    box-shadow: 0 0 0 3px rgba(37,99,235,0.12);
}

.form-group textarea {
    min-height: 110px;
    resize: vertical;
}

.image-upload-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 20px;
    margin-top: 5px;
}

.image-box {
    border: 1px dashed #cbd5e1;
    border-radius: 10px;
    padding: 18px;
    background: #f8fafc;
    transition: 0.2s;
}

.image-box:hover {
    border-color: #2563eb;
    background: #f8fbff;
}

.image-box-title {
    font-size: 14px;
    font-weight: 600;
    color: #374151;
    margin-bottom: 12px;
}

.image-box input[type="file"] {
    background: #ffffff;
    cursor: pointer;
}

.selected-name {
    margin-top: 8px;
    font-size: 12px;
    color: #6b7280;
    word-break: break-all;
}

.preview-area {
    margin-top: 12px;
    display: flex;
    gap: 10px;
    align-items: center;
}

.preview-image {
    width: 90px;
    height: 90px;
    object-fit: cover;
    border-radius: 9px;
    border: 1px solid #d8dee8;
    background: #ffffff;
}

.current-label {
    font-size: 12px;
    color: #6b7280;
}

.add-btn {
    margin-top: 22px;
    background: #2563eb;
    color: white;
    border: none;
    padding: 12px 20px;
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
    margin-left: 10px;
    padding: 12px 20px;
    background: #6b7280;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-size: 14px;
    font-weight: 600;
}

.cancel-btn:hover {
    background: #4b5563;
}

.table-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 15px;
    margin-bottom: 20px;
}

.table-top h2 {
    margin: 0;
}

.search-product {
    width: 280px;
    padding: 11px 13px;
    border: 1px solid #d8dee8;
    border-radius: 8px;
    outline: none;
}

.search-product:focus {
    border-color: #2563eb;
}

.table-box {
    overflow-x: auto;
}

table {
    width: 100%;
    min-width: 1000px;
    border-collapse: collapse;
}

th {
    padding: 14px 16px;
    background: #f9fafb;
    color: #4b5563;
    font-size: 13px;
    text-align: left;
}

td {
    padding: 15px 16px;
    color: #374151;
    font-size: 14px;
    border-top: 1px solid #e5e7eb;
    vertical-align: middle;
}

tr:hover td {
    background: #f9fafb;
}

.table-images {
    display: flex;
    gap: 7px;
    align-items: center;
}

.table-product-image {
    width: 55px;
    height: 55px;
    object-fit: cover;
    border-radius: 8px;
    border: 1px solid #e5e7eb;
    background: #ffffff;
}

.no-image {
    width: 55px;
    height: 55px;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #f3f4f6;
    border-radius: 8px;
    color: #9ca3af;
    font-size: 10px;
}

.action-btn {
    border: none;
    padding: 8px 10px;
    border-radius: 6px;
    color: white;
    cursor: pointer;
    margin-right: 5px;
    text-decoration: none;
    display: inline-block;
    font-size: 13px;
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

.message {
    padding: 12px 15px;
    border-radius: 8px;
    margin-bottom: 20px;
    font-size: 14px;
    font-weight: 600;
}

.success {
    background: #dcfce7;
    color: #166534;
}

.error {
    background: #fee2e2;
    color: #991b1b;
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

    .admin-profile span {
        display: none;
    }

    .form-grid {
        grid-template-columns: 1fr;
    }

    .image-upload-grid {
        grid-template-columns: 1fr;
    }

    .table-top {
        flex-direction: column;
        align-items: flex-start;
    }

    .search-product {
        width: 100%;
    }
}

</style>

</head>


<body>

<div class="admin-wrapper">


<%
request.setAttribute(
    "page",
    "products"
);
%>
<%@ include file="sidebar.jspf" %>


<main class="admin-main">


<div class="admin-topbar">

    <div>

        <h4>Product Management</h4>

        <p>
            Add, modify, or remove products from your shop.
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

<div class="message <%= messageType %>">

    <%= message %>

</div>

<% } %>


<!-- =====================================================
     ADD / EDIT FORM
     ===================================================== -->

<section class="page-card">


<% if (editId != null &&
       !editId.trim().equals("")) { %>

    <h2>

        <i class="bi bi-pencil-square"></i>

        Edit Product

    </h2>

<% } else { %>

    <h2>

        <i class="bi bi-plus-circle"></i>

        Add New Product

    </h2>

<% } %>


<form action="products.jsp"
      method="post"
      id="productForm">


<% if (editId != null &&
       !editId.trim().equals("")) { %>

    <input type="hidden"
           name="action"
           value="update">

    <input type="hidden"
           name="productId"
           value="<%= escapeHtml(editId) %>">

<% } else { %>

    <input type="hidden"
           name="action"
           value="add">

<% } %>


<input type="hidden"
       name="image1Data"
       id="image1Data">

<input type="hidden"
       name="image2Data"
       id="image2Data">

<input type="hidden"
       name="image1Name"
       id="image1Name">

<input type="hidden"
       name="image2Name"
       id="image2Name">


<div class="form-grid">


<!-- PRODUCT NAME -->

<div class="form-group">

    <label>Product Name</label>

    <input type="text"
           name="productName"
           placeholder="Enter product name"
           value="<%= editId != null ? escapeHtml(editName) : "" %>"
           required>

</div>


<!-- CATEGORY -->

<div class="form-group">

    <label>Category</label>

    <select name="category"
            id="category"
            required>

        <option value="">
            Select Category
        </option>

<%
Connection categoryCon = null;
PreparedStatement categoryPs = null;
ResultSet categoryRs = null;

try {
    Class.forName("oracle.jdbc.driver.OracleDriver");

    categoryCon = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );

    String categoryQuery =
        "SELECT CATEGORY_ID, CATEGORY_NAME " +
        "FROM AK_CATEGORY " +
        "WHERE UPPER(TRIM(STATUS)) = 'ACTIVE' " +
        "ORDER BY CATEGORY_NAME";

    categoryPs =
        categoryCon.prepareStatement(categoryQuery);

    categoryRs =
        categoryPs.executeQuery();

    boolean categoryFound = false;

    while (categoryRs.next()) {
        categoryFound = true;

        String categoryId =
            categoryRs.getString("CATEGORY_ID");

        String categoryName =
            categoryRs.getString("CATEGORY_NAME");
%>

        <option value="<%= escapeHtml(categoryId) %>"
            <%= categoryId != null &&
                categoryId.equalsIgnoreCase(editCategory)
                    ? "selected"
                    : "" %>>

            <%= escapeHtml(categoryName) %>

        </option>

<%
    }

    if (!categoryFound) {
%>

        <option value="">
            No active category found
        </option>

<%
    }

} catch (Exception e) {
%>

        <option value="">
            Category loading failed
        </option>

<%
} finally {
    try {
        if (categoryRs != null)
            categoryRs.close();
    } catch (Exception e) {}

    try {
        if (categoryPs != null)
            categoryPs.close();
    } catch (Exception e) {}

    try {
        if (categoryCon != null)
            categoryCon.close();
    } catch (Exception e) {}
}
%>

    </select>

</div>


<!-- PRICE -->

<div class="form-group">

    <label>Price (₹)</label>

    <input type="number"
           name="price"
           placeholder="Enter price"
           min="0"
           step="0.01"
           value="<%= editId != null ? escapeHtml(editPrice) : "" %>"
           required>

</div>


<!-- STOCK -->

<div class="form-group">

    <label>Stock Quantity</label>

    <input type="number"
           name="stock"
           placeholder="Enter stock quantity"
           min="0"
           value="<%= editId != null ? escapeHtml(editStock) : "" %>"
           required>

</div>


<!-- =====================================================
     TWO IMAGES
     ===================================================== -->

<div class="form-group full">

    <label>
        Product Images
    </label>


    <div class="image-upload-grid">


        <!-- IMAGE 1 -->

        <div class="image-box">

            <div class="image-box-title">

                <i class="bi bi-image"></i>

                Product Image 1

            </div>


            <input type="file"
                   id="productImage1"
                   accept="image/jpeg,image/png,image/webp,image/gif">


            <div class="selected-name"
                 id="image1Selected">

                Select first product image

            </div>


            <div class="preview-area">

                <%

                String oldImage1 = "";

                if (editImage != null &&
                    !editImage.trim().equals("")) {

                    String[] oldImages =
                        editImage.split(",");

                    if (oldImages.length >= 1) {

                        oldImage1 =
                            oldImages[0].trim();
                    }
                }

                %>


                <% if (!oldImage1.equals("")) { %>

                    <img src="../images/product-image/<%= escapeHtml(oldImage1) %>"
                         class="preview-image"
                         id="preview1">

                <% } else { %>

                    <img src=""
                         class="preview-image"
                         id="preview1"
                         style="display:none;">

                <% } %>


                <div class="current-label">

                    <% if (!oldImage1.equals("")) { %>

                        Current Image 1

                    <% } %>

                </div>

            </div>

        </div>


        <!-- IMAGE 2 -->

        <div class="image-box">

            <div class="image-box-title">

                <i class="bi bi-images"></i>

                Product Image 2

            </div>


            <input type="file"
                   id="productImage2"
                   accept="image/jpeg,image/png,image/webp,image/gif">


            <div class="selected-name"
                 id="image2Selected">

                Select second product image

            </div>


            <div class="preview-area">

                <%

                String oldImage2 = "";

                if (editImage != null &&
                    !editImage.trim().equals("")) {

                    String[] oldImages =
                        editImage.split(",");

                    if (oldImages.length >= 2) {

                        oldImage2 =
                            oldImages[1].trim();
                    }
                }

                %>


                <% if (!oldImage2.equals("")) { %>

                    <img src="../images/product-image/<%= escapeHtml(oldImage2) %>"
                         class="preview-image"
                         id="preview2">

                <% } else { %>

                    <img src=""
                         class="preview-image"
                         id="preview2"
                         style="display:none;">

                <% } %>


                <div class="current-label">

                    <% if (!oldImage2.equals("")) { %>

                        Current Image 2

                    <% } %>

                </div>

            </div>

        </div>


    </div>

</div>


<!-- DESCRIPTION -->

<div class="form-group full">

    <label>
        Product Description
    </label>

    <textarea name="description"
              placeholder="Enter product description"><%= editId != null && editDescription != null ? escapeHtml(editDescription) : "" %></textarea>

</div>


</div>


<% if (editId != null &&
       !editId.trim().equals("")) { %>


    <button type="submit"
            class="add-btn"
            id="submitBtn">

        <i class="bi bi-check-circle"></i>

        Update Product

    </button>


    <a href="products.jsp"
       class="cancel-btn">

        Cancel

    </a>


<% } else { %>


    <button type="submit"
            class="add-btn"
            id="submitBtn">

        <i class="bi bi-plus-circle"></i>

        Add Product

    </button>


<% } %>


</form>

</section>


<!-- =====================================================
     PRODUCT TABLE
     ===================================================== -->

<section class="page-card">


<div class="table-top">

    <h2>
        All Products
    </h2>


    <input type="text"
           id="searchProduct"
           class="search-product"
           placeholder="Search Product...">

</div>


<div class="table-box">


<table id="productTable">


<thead>

<tr>

    <th>ID</th>

    <th>Product</th>

    <th>Category</th>

    <th>Price</th>

    <th>Stock</th>

    <th>Images</th>

    <th>Action</th>

</tr>

</thead>


<tbody>


<%

Connection tableCon = null;

PreparedStatement tablePs = null;

ResultSet tableRs = null;


try {

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );


    tableCon =
        DriverManager.getConnection(
            url,
            useridDB,
            passwordDB
        );


    String query =
        "SELECT p.PRODUCT_ID, " +
        "p.PRODUCT_NAME, " +
        "p.CATEGORY, " +
        "c.CATEGORY_NAME AS CATEGORY_NAME, " +
        "p.PRICE, " +
        "p.STOCK, " +
        "p.IMAGE, " +
        "p.DESCRIPTION " +
        "FROM AK_PRODUCT p " +
        "LEFT JOIN AK_CATEGORY c " +
        "ON TRIM(p.CATEGORY) = TRIM(c.CATEGORY_ID) " +
        "ORDER BY p.PRODUCT_NAME";


    tablePs =
        tableCon.prepareStatement(query);


    tableRs =
        tablePs.executeQuery();


    while (tableRs.next()) {


        String productId =
            tableRs.getString(
                "PRODUCT_ID"
            );


        String productName =
            tableRs.getString(
                "PRODUCT_NAME"
            );


        String productCategory =
            tableRs.getString(
                "CATEGORY_NAME"
            );


        String productPrice =
            tableRs.getString(
                "PRICE"
            );


        String productStock =
            tableRs.getString(
                "STOCK"
            );


        String productImage =
            tableRs.getString(
                "IMAGE"
            );

%>


<tr>


    <td>
        <%= escapeHtml(productId) %>
    </td>


    <td>

        <strong>
            <%= escapeHtml(productName) %>
        </strong>

    </td>


    <td>
        <%= escapeHtml(productCategory != null ? productCategory : "") %>
    </td>


    <td>
        ₹<%= escapeHtml(productPrice) %>
    </td>


    <td>
        <%= escapeHtml(productStock) %>
    </td>


    <td>

        <div class="table-images">


        <%

        if (productImage != null &&
            !productImage.trim().equals("")) {


            String[] images =
                productImage.split(",");


            for (String img : images) {

                img =
                    img.trim();

                if (!img.equals("")) {

        %>


                    <img src="../images/product-image/<%= escapeHtml(img) %>"
                         class="table-product-image"
                         alt="<%= escapeHtml(productName) %>">


        <%

                }

            }


        } else {

        %>


            <div class="no-image">

                No Image

            </div>


        <%

        }

        %>


        </div>

    </td>


    <td>


        <a href="products.jsp?edit=<%= escapeHtml(productId) %>"
           class="action-btn edit-btn">

            <i class="bi bi-pencil-square"></i>

            Edit

        </a>


        <a href="products.jsp?delete=<%= escapeHtml(productId) %>"
           class="action-btn delete-btn"
           onclick="return confirm('Are you sure you want to delete this product?');">

            <i class="bi bi-trash"></i>

            Delete

        </a>


    </td>


</tr>


<%

    }


} catch (Exception e) {

%>


<tr>

    <td colspan="7">

        Database Error:
        <%= escapeHtml(e.getMessage()) %>

    </td>

</tr>


<%

} finally {


    try {

        if (tableRs != null)
            tableRs.close();

    } catch (Exception e) {}


    try {

        if (tablePs != null)
            tablePs.close();

    } catch (Exception e) {}


    try {

        if (tableCon != null)
            tableCon.close();

    } catch (Exception e) {}

}

%>


</tbody>

</table>

</div>

</section>


</main>

</div>


<!-- =====================================================
     IMAGE UPLOAD SCRIPT
     ===================================================== -->

<script>


let image1Data = "";

let image2Data = "";


document.getElementById(
    "productImage1"
).addEventListener(
    "change",
    function() {


        let file =
            this.files[0];


        if (!file) {
            return;
        }


        if (file.size > 700 * 1024) {

            alert(
                "Image 1 must be less than 700 KB."
            );

            this.value = "";

            return;
        }


        if (!file.type.startsWith("image/")) {

            alert(
                "Please select a valid image."
            );

            this.value = "";

            return;
        }


        document.getElementById(
            "image1Selected"
        ).innerText =
            file.name;


        let reader =
            new FileReader();


        reader.onload =
            function(e) {


                image1Data =
                    e.target.result;


                let preview =
                    document.getElementById(
                        "preview1"
                    );


                preview.src =
                    e.target.result;


                preview.style.display =
                    "block";

            };


        reader.readAsDataURL(file);

    }
);


document.getElementById(
    "productImage2"
).addEventListener(
    "change",
    function() {


        let file =
            this.files[0];


        if (!file) {
            return;
        }


        if (file.size > 700 * 1024) {

            alert(
                "Image 2 must be less than 700 KB."
            );

            this.value = "";

            return;
        }


        if (!file.type.startsWith("image/")) {

            alert(
                "Please select a valid image."
            );

            this.value = "";

            return;
        }


        document.getElementById(
            "image2Selected"
        ).innerText =
            file.name;


        let reader =
            new FileReader();


        reader.onload =
            function(e) {


                image2Data =
                    e.target.result;


                let preview =
                    document.getElementById(
                        "preview2"
                    );


                preview.src =
                    e.target.result;


                preview.style.display =
                    "block";

            };


        reader.readAsDataURL(file);

    }
);


document.getElementById(
    "productForm"
).addEventListener(
    "submit",
    function(e) {


        let action =
            document.querySelector(
                'input[name="action"]'
            ).value;


        if (action === "add") {


            if (image1Data === "") {

                e.preventDefault();

                alert(
                    "Please select Product Image 1."
                );

                return;
            }


            if (image2Data === "") {

                e.preventDefault();

                alert(
                    "Please select Product Image 2."
                );

                return;
            }

        }


        document.getElementById(
            "image1Data"
        ).value =
            image1Data;


        document.getElementById(
            "image2Data"
        ).value =
            image2Data;


        let file1 =
            document.getElementById(
                "productImage1"
            ).files[0];


        let file2 =
            document.getElementById(
                "productImage2"
            ).files[0];


        if (file1) {

            document.getElementById(
                "image1Name"
            ).value =
                file1.name;

        }


        if (file2) {

            document.getElementById(
                "image2Name"
            ).value =
                file2.name;

        }


    }
);


document.getElementById(
    "searchProduct"
).addEventListener(
    "keyup",
    function() {


        let search =
            this.value.toLowerCase();


        let rows =
            document.querySelectorAll(
                "#productTable tbody tr"
            );


        rows.forEach(
            function(row) {


                let text =
                    row.innerText.toLowerCase();


                if (text.includes(search)) {

                    row.style.display =
                        "";

                } else {

                    row.style.display =
                        "none";
                }

            }
        );

    }
);

</script>


</body>

</html>