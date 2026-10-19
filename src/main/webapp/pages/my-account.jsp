<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*"
    import="java.text.SimpleDateFormat"
    import="java.util.*" %>

<%

/* =========================================================
   CUSTOMER LOGIN CHECK
   ========================================================= */

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

if (customerId == null || customerId.trim().isEmpty()) {

    response.sendRedirect(
        request.getContextPath() + "/pages/login.jsp?error=true"
    );

    return;
}


/* =========================================================
   DATABASE VARIABLES
   ========================================================= */

Connection con = null;

PreparedStatement psCustomer = null;
PreparedStatement psStats = null;
PreparedStatement psOrders = null;
PreparedStatement psPayments = null;
PreparedStatement psAddresses = null;

ResultSet rsCustomer = null;
ResultSet rsStats = null;
ResultSet rsOrders = null;
ResultSet rsPayments = null;
ResultSet rsAddresses = null;


/* =========================================================
   SESSION DATA
   ========================================================= */

String customerName =
    (String) session.getAttribute("customerName");

String customerEmail =
    (String) session.getAttribute("customerEmail");

String customerPhone =
    (String) session.getAttribute("customerPhone");


/* =========================================================
   VARIABLES
   ========================================================= */

String dbName = "";
String dbEmail = "";
String dbPhone = "";
String dbAddress = "";
String dbStatus = "";

Timestamp createdDate = null;

int totalOrders = 0;
int processingOrders = 0;
int shippedOrders = 0;
int deliveredOrders = 0;
int cancelledOrders = 0;

double totalSpent = 0.0;
double pendingAmount = 0.0;

String message = "";
String messageType = "";


/* =========================================================
   DATE FORMAT
   ========================================================= */

SimpleDateFormat dateFormat =
    new SimpleDateFormat("dd MMM yyyy");

SimpleDateFormat dateTimeFormat =
    new SimpleDateFormat("dd MMM yyyy, hh:mm a");


/* =========================================================
   DATABASE CONNECTION
   ========================================================= */

try {

    String driver =
        "oracle.jdbc.driver.OracleDriver";

    String url =
        "jdbc:oracle:thin:@localhost:1521:XE";

    String useridDB = "system";
    String passwordDB = "ayush";

    Class.forName(driver);

    con = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );


    /* =====================================================
       PROFILE UPDATE
       ===================================================== */

    String action =
        request.getParameter("action");


    if ("updateProfile".equals(action)) {

        String newName =
            request.getParameter("newName");

        String newPhone =
            request.getParameter("newPhone");

        if (newName == null)
            newName = "";

        if (newPhone == null)
            newPhone = "";

        newName = newName.trim();
        newPhone = newPhone.trim();


        if (newName.isEmpty()) {

            message =
                "Full name cannot be empty.";

            messageType = "error";

        } else {

            String updateSql =
                "UPDATE AK_CUSTOMER " +
                "SET CUSTOMER_NAME = ?, CUSTOMER_PHONE = ? " +
                "WHERE CUSTOMER_ID = ?";

            PreparedStatement psUpdate =
                con.prepareStatement(updateSql);

            psUpdate.setString(1, newName);
            psUpdate.setString(2, newPhone);
            psUpdate.setString(3, customerId);

            int updated =
                psUpdate.executeUpdate();

            psUpdate.close();


            if (updated > 0) {

                session.setAttribute(
                    "customerName",
                    newName
                );

                session.setAttribute(
                    "customerPhone",
                    newPhone
                );

                message =
                    "Profile updated successfully.";

                messageType = "success";

            } else {

                message =
                    "Unable to update profile.";

                messageType = "error";
            }
        }
    }


    /* =====================================================
       CHANGE PASSWORD
       ===================================================== */

    if ("changePassword".equals(action)) {

        String currentPassword =
            request.getParameter("currentPassword");

        String newPassword =
            request.getParameter("newPassword");

        String confirmPassword =
            request.getParameter("confirmPassword");


        if (currentPassword == null)
            currentPassword = "";

        if (newPassword == null)
            newPassword = "";

        if (confirmPassword == null)
            confirmPassword = "";


        if (currentPassword.isEmpty() ||
            newPassword.isEmpty() ||
            confirmPassword.isEmpty()) {

            message =
                "Please fill all password fields.";

            messageType = "error";

        } else if (!newPassword.equals(confirmPassword)) {

            message =
                "New password and confirm password do not match.";

            messageType = "error";

        } else if (newPassword.length() < 6) {

            message =
                "New password must contain at least 6 characters.";

            messageType = "error";

        } else {

            String passwordSql =
                "UPDATE AK_CUSTOMER " +
                "SET CUSTOMER_PASSWORD = ? " +
                "WHERE CUSTOMER_ID = ? " +
                "AND CUSTOMER_PASSWORD = ?";

            PreparedStatement psPassword =
                con.prepareStatement(passwordSql);

            psPassword.setString(1, newPassword);
            psPassword.setString(2, customerId);
            psPassword.setString(3, currentPassword);

            int changed =
                psPassword.executeUpdate();

            psPassword.close();


            if (changed > 0) {

                message =
                    "Password changed successfully.";

                messageType = "success";

            } else {

                message =
                    "Current password is incorrect.";

                messageType = "error";
            }
        }
    }


    /* =====================================================
       ADD ADDRESS
       ===================================================== */

    if ("addAddress".equals(action)) {

        String addressLabel =
            request.getParameter("addressLabel");

        String fullName =
            request.getParameter("fullName");

        String mobile =
            request.getParameter("mobile");

        String house =
            request.getParameter("house");

        String street =
            request.getParameter("street");

        String area =
            request.getParameter("area");

        String landmark =
            request.getParameter("landmark");

        String city =
            request.getParameter("city");

        String state =
            request.getParameter("state");

        String pin =
            request.getParameter("pin");


        if (addressLabel == null)
            addressLabel = "Home";

        if (fullName == null)
            fullName = "";

        if (mobile == null)
            mobile = "";

        if (house == null)
            house = "";

        if (street == null)
            street = "";

        if (area == null)
            area = "";

        if (landmark == null)
            landmark = "";

        if (city == null)
            city = "";

        if (state == null)
            state = "";

        if (pin == null)
            pin = "";


        addressLabel = addressLabel.trim();
        fullName = fullName.trim();
        mobile = mobile.trim();
        house = house.trim();
        street = street.trim();
        area = area.trim();
        landmark = landmark.trim();
        city = city.trim();
        state = state.trim();
        pin = pin.trim();


        /* Maximum 2 addresses */

        String countSql =
            "SELECT COUNT(*) AS CNT " +
            "FROM AK_CUSTOMER_ADDRESS " +
            "WHERE CUSTOMER_ID = ?";

        PreparedStatement psCount =
            con.prepareStatement(countSql);

        psCount.setString(1, customerId);

        ResultSet rsCount =
            psCount.executeQuery();

        int addressCount = 0;

        if (rsCount.next()) {

            addressCount =
                rsCount.getInt("CNT");
        }

        rsCount.close();
        psCount.close();


        if (addressCount >= 2) {

            message =
                "You can save maximum 2 addresses.";

            messageType = "error";

        } else if (fullName.isEmpty() ||
                   house.isEmpty() ||
                   city.isEmpty() ||
                   state.isEmpty() ||
                   pin.isEmpty()) {

            message =
                "Please fill all required address fields.";

            messageType = "error";

        } else if (!pin.matches("\\d{6}")) {

            message =
                "PIN code must contain exactly 6 digits.";

            messageType = "error";

        } else if (!mobile.isEmpty() &&
                   !mobile.matches("\\d{10}")) {

            message =
                "Mobile number must contain exactly 10 digits.";

            messageType = "error";

        } else {

            String addressId =
                "ADDR-" +
                UUID.randomUUID()
                .toString()
                .replace("-", "")
                .substring(0, 16)
                .toUpperCase();


            String insertAddressSql =
                "INSERT INTO AK_CUSTOMER_ADDRESS " +
                "(ADDRESS_ID, CUSTOMER_ID, ADDRESS_LABEL, " +
                "FULL_NAME, MOBILE, HOUSE_ADDRESS, " +
                "STREET_ADDRESS, AREA, LANDMARK, CITY, " +
                "STATE_NAME, PIN_CODE, COUNTRY, CREATED_DATE) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP)";


            PreparedStatement psInsertAddress =
                con.prepareStatement(insertAddressSql);

            psInsertAddress.setString(1, addressId);
            psInsertAddress.setString(2, customerId);
            psInsertAddress.setString(3, addressLabel);
            psInsertAddress.setString(4, fullName);
            psInsertAddress.setString(5, mobile);
            psInsertAddress.setString(6, house);
            psInsertAddress.setString(7, street);
            psInsertAddress.setString(8, area);
            psInsertAddress.setString(9, landmark);
            psInsertAddress.setString(10, city);
            psInsertAddress.setString(11, state);
            psInsertAddress.setString(12, pin);
            psInsertAddress.setString(13, "India");

            int inserted =
                psInsertAddress.executeUpdate();

            psInsertAddress.close();


            if (inserted > 0) {

                message =
                    "Address saved successfully.";

                messageType = "success";

            } else {

                message =
                    "Unable to save address.";

                messageType = "error";
            }
        }
    }


    /* =====================================================
       DELETE ADDRESS
       ===================================================== */

    if ("deleteAddress".equals(action)) {

        String addressId =
            request.getParameter("addressId");

        if (addressId != null &&
            !addressId.trim().isEmpty()) {

            String deleteSql =
                "DELETE FROM AK_CUSTOMER_ADDRESS " +
                "WHERE ADDRESS_ID = ? " +
                "AND CUSTOMER_ID = ?";

            PreparedStatement psDelete =
                con.prepareStatement(deleteSql);

            psDelete.setString(1, addressId);
            psDelete.setString(2, customerId);

            int deleted =
                psDelete.executeUpdate();

            psDelete.close();


            if (deleted > 0) {

                message =
                    "Address deleted successfully.";

                messageType = "success";

            } else {

                message =
                    "Address could not be deleted.";

                messageType = "error";
            }
        }
    }


    /* =====================================================
       CUSTOMER PROFILE
       ===================================================== */

    String customerSql =
        "SELECT CUSTOMER_ID, CUSTOMER_NAME, " +
        "CUSTOMER_EMAIL, CUSTOMER_PHONE, ADDRESS, " +
        "STATUS, CREATED_DATE " +
        "FROM AK_CUSTOMER " +
        "WHERE CUSTOMER_ID = ?";

    psCustomer =
        con.prepareStatement(customerSql);

    psCustomer.setString(1, customerId);

    rsCustomer =
        psCustomer.executeQuery();


    if (rsCustomer.next()) {

        dbName =
            rsCustomer.getString("CUSTOMER_NAME");

        dbEmail =
            rsCustomer.getString("CUSTOMER_EMAIL");

        dbPhone =
            rsCustomer.getString("CUSTOMER_PHONE");

        dbAddress =
            rsCustomer.getString("ADDRESS");

        dbStatus =
            rsCustomer.getString("STATUS");

        createdDate =
            rsCustomer.getTimestamp("CREATED_DATE");
    }


    /* =====================================================
       ORDER STATISTICS
       ===================================================== */

    String statsSql =
        "SELECT " +
        "COUNT(*) AS TOTAL_ORDERS, " +

        "NVL(SUM(CASE WHEN UPPER(STATUS) = 'PROCESSING' " +
        "THEN 1 ELSE 0 END),0) AS PROCESSING_ORDERS, " +

        "NVL(SUM(CASE WHEN UPPER(STATUS) = 'SHIPPED' " +
        "THEN 1 ELSE 0 END),0) AS SHIPPED_ORDERS, " +

        "NVL(SUM(CASE WHEN UPPER(STATUS) = 'DELIVERED' " +
        "THEN 1 ELSE 0 END),0) AS DELIVERED_ORDERS, " +

        "NVL(SUM(CASE WHEN UPPER(STATUS) = 'CANCELLED' " +
        "THEN 1 ELSE 0 END),0) AS CANCELLED_ORDERS, " +

        "NVL(SUM(CASE WHEN UPPER(STATUS) <> 'CANCELLED' " +
        "THEN TOTAL_AMOUNT ELSE 0 END),0) AS TOTAL_SPENT " +

        "FROM AK_ORDER " +
        "WHERE CUSTOMER_EMAIL = ?";


    psStats =
        con.prepareStatement(statsSql);

    psStats.setString(1, dbEmail);

    rsStats =
        psStats.executeQuery();


    if (rsStats.next()) {

        totalOrders =
            rsStats.getInt("TOTAL_ORDERS");

        processingOrders =
            rsStats.getInt("PROCESSING_ORDERS");

        shippedOrders =
            rsStats.getInt("SHIPPED_ORDERS");

        deliveredOrders =
            rsStats.getInt("DELIVERED_ORDERS");

        cancelledOrders =
            rsStats.getInt("CANCELLED_ORDERS");

        totalSpent =
            rsStats.getDouble("TOTAL_SPENT");
    }


    /* =====================================================
       PENDING PAYMENT
       ===================================================== */

    String pendingSql =
        "SELECT NVL(SUM(AMOUNT),0) AS PENDING_AMOUNT " +
        "FROM AK_PAYMENT " +
        "WHERE UPPER(PAYMENT_STATUS) IN " +
        "('PENDING','PROCESSING') " +
        "AND CUSTOMER_NAME = ?";


    PreparedStatement psPending =
        con.prepareStatement(pendingSql);

    psPending.setString(1, dbName);

    ResultSet rsPending =
        psPending.executeQuery();


    if (rsPending.next()) {

        pendingAmount =
            rsPending.getDouble("PENDING_AMOUNT");
    }


    rsPending.close();
    psPending.close();

}

catch (Exception e) {

    e.printStackTrace();

    if (message.isEmpty()) {

        message =
            "Something went wrong while processing your account.";

        messageType = "error";
    }
}

%>


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<title>My Account - AYUSH LABEL</title>


<link rel="preconnect"
      href="https://fonts.googleapis.com">

<link rel="preconnect"
      href="https://fonts.gstatic.com"
      crossorigin>

<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@500;600;700&family=Poppins:wght@300;400;500;600&display=swap"
      rel="stylesheet">


<style>

* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {

    background: #080808;
    color: #f5f5f5;
    font-family: 'Poppins', sans-serif;
    min-height: 100vh;
}


/* =========================================================
   HEADER
   ========================================================= */

.header {

    height: 82px;

    display: flex;

    align-items: center;

    justify-content: space-between;

    padding: 0 6%;

    border-bottom: 1px solid #292929;

    background: #090909;

    position: sticky;

    top: 0;

    z-index: 100;
}

.logo {
    width: 145px;
}

.header-right {

    display: flex;

    align-items: center;

    gap: 25px;
}

.welcome {

    font-size: 13px;

    color: #aaa;
}

.welcome strong {

    color: #d4af37;

    font-weight: 500;
}

.back-btn {

    text-decoration: none;

    color: #d4af37;

    border: 1px solid #d4af37;

    padding: 9px 18px;

    font-size: 12px;

    letter-spacing: 1px;

    transition: 0.3s;
}

.back-btn:hover {

    background: #d4af37;

    color: #000;
}


/* =========================================================
   MAIN
   ========================================================= */

.container {

    width: 88%;

    max-width: 1450px;

    margin: 45px auto 80px;
}

.page-title {

    font-family: 'Cormorant Garamond', serif;

    font-size: 52px;

    font-weight: 600;

    letter-spacing: 1px;

    margin-bottom: 7px;
}

.page-subtitle {

    color: #888;

    font-size: 13px;

    margin-bottom: 35px;
}


/* =========================================================
   ALERT
   ========================================================= */

.alert {

    padding: 15px 20px;

    margin-bottom: 25px;

    border: 1px solid #333;

    font-size: 12px;
}

.alert.success {

    color: #5bd67d;

    border-color: #285b3a;

    background: #0c1710;
}

.alert.error {

    color: #ff7777;

    border-color: #633333;

    background: #170c0c;
}


/* =========================================================
   PROFILE HERO
   ========================================================= */

.profile-card {

    border: 1px solid #292929;

    background: linear-gradient(
        135deg,
        #111,
        #0b0b0b
    );

    padding: 30px;

    display: flex;

    justify-content: space-between;

    align-items: center;

    margin-bottom: 25px;
}

.profile-left {

    display: flex;

    align-items: center;

    gap: 22px;
}

.avatar {

    width: 75px;

    height: 75px;

    border: 1px solid #d4af37;

    border-radius: 50%;

    display: flex;

    align-items: center;

    justify-content: center;

    font-family: 'Cormorant Garamond', serif;

    font-size: 30px;

    color: #d4af37;

    background: #151515;
}

.profile-name {

    font-family: 'Cormorant Garamond', serif;

    font-size: 31px;

    color: #fff;
}

.profile-email {

    color: #888;

    font-size: 13px;

    margin-top: 4px;
}

.status {

    display: inline-block;

    margin-top: 9px;

    padding: 5px 13px;

    border: 1px solid #3c6;

    color: #5bd67d;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;
}

.member {

    text-align: right;

    color: #777;

    font-size: 12px;
}

.member span {

    display: block;

    color: #d4af37;

    font-size: 15px;

    margin-top: 5px;
}

.profile-actions {

    display: flex;

    gap: 10px;

    margin-top: 15px;
}

.gold-btn {

    background: #d4af37;

    color: #000;

    border: 1px solid #d4af37;

    padding: 10px 18px;

    cursor: pointer;

    font-size: 11px;

    letter-spacing: 1px;

    text-transform: uppercase;

    font-family: 'Poppins', sans-serif;
}

.dark-btn {

    background: transparent;

    color: #d4af37;

    border: 1px solid #d4af37;

    padding: 10px 18px;

    cursor: pointer;

    font-size: 11px;

    letter-spacing: 1px;

    text-transform: uppercase;

    font-family: 'Poppins', sans-serif;
}

.gold-btn:hover {

    background: #fff;

    border-color: #fff;
}

.dark-btn:hover {

    background: #d4af37;

    color: #000;
}


/* =========================================================
   STAT GRID
   ========================================================= */

.stats-grid {

    display: grid;

    grid-template-columns: repeat(4, 1fr);

    gap: 16px;

    margin-bottom: 35px;
}

.stat-card {

    border: 1px solid #292929;

    background: #0e0e0e;

    padding: 24px;
}

.stat-label {

    color: #777;

    font-size: 11px;

    text-transform: uppercase;

    letter-spacing: 1.2px;
}

.stat-value {

    font-family: 'Cormorant Garamond', serif;

    color: #d4af37;

    font-size: 35px;

    margin-top: 7px;
}

.stat-small {

    color: #777;

    font-size: 11px;

    margin-top: 3px;
}


/* =========================================================
   SECTION
   ========================================================= */

.section {

    border: 1px solid #292929;

    background: #0d0d0d;

    margin-bottom: 25px;
}

.section-header {

    padding: 20px 25px;

    border-bottom: 1px solid #292929;

    display: flex;

    justify-content: space-between;

    align-items: center;
}

.section-title {

    font-family: 'Cormorant Garamond', serif;

    font-size: 27px;

    color: #fff;
}

.section-label {

    font-size: 10px;

    color: #d4af37;

    letter-spacing: 1.5px;

    text-transform: uppercase;
}


/* =========================================================
   PROFILE DETAILS
   ========================================================= */

.profile-details {

    padding: 25px;

    display: grid;

    grid-template-columns: repeat(2, 1fr);

    gap: 20px;
}

.detail {

    padding: 18px;

    border: 1px solid #242424;

    background: #111;
}

.detail-label {

    color: #777;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;

    margin-bottom: 6px;
}

.detail-value {

    color: #eee;

    font-size: 14px;

    word-break: break-word;
}

.full {

    grid-column: 1 / -1;
}


/* =========================================================
   TABLE
   ========================================================= */

.table-wrapper {

    overflow-x: auto;
}

table {

    width: 100%;

    border-collapse: collapse;

    min-width: 850px;
}

th {

    text-align: left;

    color: #777;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;

    padding: 15px 20px;

    border-bottom: 1px solid #292929;
}

td {

    padding: 17px 20px;

    font-size: 12px;

    border-bottom: 1px solid #1d1d1d;

    color: #ddd;
}

tr:hover td {

    background: #111;
}

.amount {

    color: #d4af37;

    font-weight: 500;
}

.order-id {

    color: #aaa;

    font-size: 11px;
}

.badge {

    display: inline-block;

    padding: 5px 10px;

    border: 1px solid #444;

    font-size: 9px;

    text-transform: uppercase;

    letter-spacing: .7px;
}

.badge.processing {

    color: #e7b94d;

    border-color: #6b5420;
}

.badge.shipped {

    color: #7db8ff;

    border-color: #31547b;
}

.badge.delivered {

    color: #62d88a;

    border-color: #2f6a43;
}

.badge.cancelled {

    color: #ff7373;

    border-color: #6b3030;
}

.badge.paid {

    color: #62d88a;

    border-color: #2f6a43;
}

.badge.pending {

    color: #e7b94d;

    border-color: #6b5420;
}

.badge.other {

    color: #bbb;
}


/* =========================================================
   TWO COLUMN
   ========================================================= */

.two-column {

    display: grid;

    grid-template-columns: 1fr 1fr;

    gap: 25px;
}


/* =========================================================
   ADDRESS
   ========================================================= */

.address-box {

    padding: 25px;

    color: #bbb;

    font-size: 13px;

    line-height: 1.9;

    min-height: 150px;
}

.address-card {

    border: 1px solid #292929;

    background: #111;

    padding: 20px;

    margin-bottom: 15px;

    position: relative;
}

.address-card:last-child {

    margin-bottom: 0;
}

.address-label {

    color: #d4af37;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1.5px;

    margin-bottom: 8px;
}

.address-name {

    color: #fff;

    font-size: 14px;

    font-weight: 500;

    margin-bottom: 6px;
}

.address-text {

    color: #999;

    font-size: 12px;

    line-height: 1.8;
}

.address-actions {

    margin-top: 15px;

    display: flex;

    gap: 10px;
}


/* =========================================================
   EMPTY
   ========================================================= */

.empty {

    padding: 45px;

    text-align: center;

    color: #777;

    font-size: 13px;
}


/* =========================================================
   MODAL
   ========================================================= */

.modal {

    display: none;

    position: fixed;

    z-index: 9999;

    left: 0;

    top: 0;

    width: 100%;

    height: 100%;

    background: rgba(0,0,0,.85);

    overflow-y: auto;

    padding: 40px 15px;
}

.modal-box {

    width: 95%;

    max-width: 700px;

    margin: auto;

    background: #0d0d0d;

    border: 1px solid #333;

    box-shadow: 0 20px 70px rgba(0,0,0,.8);
}

.modal-header {

    padding: 22px 25px;

    border-bottom: 1px solid #292929;

    display: flex;

    justify-content: space-between;

    align-items: center;
}

.modal-title {

    font-family: 'Cormorant Garamond', serif;

    font-size: 28px;

    color: #fff;
}

.close {

    color: #aaa;

    font-size: 28px;

    cursor: pointer;
}

.close:hover {

    color: #d4af37;
}

.modal-body {

    padding: 25px;
}


/* =========================================================
   FORM
   ========================================================= */

.form-grid {

    display: grid;

    grid-template-columns: 1fr 1fr;

    gap: 17px;
}

.form-group {

    display: flex;

    flex-direction: column;

    gap: 7px;
}

.form-group.full {

    grid-column: 1 / -1;
}

.form-group label {

    color: #777;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;
}

.form-group input,
.form-group select {

    width: 100%;

    background: #111;

    color: #eee;

    border: 1px solid #333;

    padding: 12px 13px;

    outline: none;

    font-family: 'Poppins', sans-serif;

    font-size: 12px;
}

.form-group input:focus,
.form-group select:focus {

    border-color: #d4af37;
}

.form-note {

    color: #666;

    font-size: 10px;

    margin-bottom: 20px;

    line-height: 1.6;
}

.modal-footer {

    margin-top: 25px;

    display: flex;

    justify-content: flex-end;

    gap: 10px;
}


/* =========================================================
   SECURITY
   ========================================================= */

.security-box {

    padding: 25px;
}

.security-row {

    display: flex;

    justify-content: space-between;

    align-items: center;

    padding: 15px 0;

    border-bottom: 1px solid #222;
}

.security-row:last-child {

    border-bottom: none;
}

.security-title {

    font-size: 13px;

    color: #ddd;
}

.security-desc {

    color: #777;

    font-size: 10px;

    margin-top: 4px;
}

.security-status {

    color: #5bd67d;

    font-size: 10px;

    text-transform: uppercase;

    letter-spacing: 1px;
}


/* =========================================================
   FOOTER
   ========================================================= */

.footer {

    text-align: center;

    color: #555;

    font-size: 11px;

    padding-top: 20px;
}


/* =========================================================
   RESPONSIVE
   ========================================================= */

@media(max-width: 1000px) {

    .stats-grid {

        grid-template-columns: repeat(2, 1fr);
    }

    .two-column {

        grid-template-columns: 1fr;
    }
}


@media(max-width: 700px) {

    .header {

        padding: 0 20px;

        height: 70px;
    }

    .logo {

        width: 110px;
    }

    .welcome {

        display: none;
    }

    .container {

        width: 92%;

        margin-top: 30px;
    }

    .page-title {

        font-size: 40px;
    }

    .profile-card {

        flex-direction: column;

        align-items: flex-start;

        gap: 20px;
    }

    .member {

        text-align: left;
    }

    .profile-details {

        grid-template-columns: 1fr;
    }

    .full {

        grid-column: auto;
    }

    .stats-grid {

        grid-template-columns: 1fr 1fr;

        gap: 10px;
    }

    .stat-card {

        padding: 18px;
    }

    .stat-value {

        font-size: 28px;
    }

    .form-grid {

        grid-template-columns: 1fr;
    }

    .form-group.full {

        grid-column: auto;
    }
}


@media(max-width: 450px) {

    .stats-grid {

        grid-template-columns: 1fr;
    }

    .profile-left {

        align-items: flex-start;
    }

    .avatar {

        width: 60px;

        height: 60px;

        font-size: 24px;
    }

    .profile-name {

        font-size: 25px;
    }

    .profile-actions {

        flex-direction: column;
    }
}

</style>

</head>


<body>


<!-- =======================================================
     HEADER
     ======================================================= -->

<header class="header">

    <a href="<%= request.getContextPath() %>/index.jsp">

        <img
            src="<%= request.getContextPath() %>/images/icons/logo-01.png"
            class="logo"
            alt="AYUSH LABEL"
        >

    </a>


    <div class="header-right">

        <div class="welcome">

            Welcome,

            <strong>

                <%= dbName != null && !dbName.isEmpty()
                    ? dbName
                    : customerName %>

            </strong>

        </div>


        <a
            href="<%= request.getContextPath() %>/index.jsp"
            class="back-btn"
        >

            CONTINUE SHOPPING

        </a>

    </div>

</header>


<main class="container">


<h1 class="page-title">

    My Account

</h1>

<p class="page-subtitle">

    Manage your profile, orders, payments and saved addresses.

</p>


<% if (!message.isEmpty()) { %>

    <div class="alert <%= messageType %>">

        <%= message %>

    </div>

<% } %>


<!-- ===================================================
     PROFILE HERO
     =================================================== -->

<div class="profile-card">


    <div class="profile-left">

        <div class="avatar">

        <%

            String displayName =
                dbName != null && !dbName.isEmpty()
                ? dbName
                : customerName;

            String initials = "A";

            if (displayName != null &&
                !displayName.trim().isEmpty()) {

                String[] parts =
                    displayName.trim().split("\\s+");

                initials =
                    parts[0]
                    .substring(0,1)
                    .toUpperCase();

                if (parts.length > 1) {

                    initials +=
                        parts[parts.length - 1]
                        .substring(0,1)
                        .toUpperCase();
                }
            }

        %>

        <%= initials %>

        </div>


        <div>

            <div class="profile-name">

                <%= displayName %>

            </div>

            <div class="profile-email">

                <%= dbEmail %>

            </div>

            <div class="status">

                <%= dbStatus != null &&
                    !dbStatus.trim().isEmpty()
                    ? dbStatus
                    : "ACTIVE" %>

            </div>


            <div class="profile-actions">

                <button
                    class="gold-btn"
                    onclick="openModal('editProfileModal')"
                >

                    Edit Profile

                </button>


                <button
                    class="dark-btn"
                    onclick="openModal('passwordModal')"
                >

                    Change Password

                </button>

            </div>

        </div>

    </div>


    <div class="member">

        MEMBER SINCE

        <span>

        <%

            if (createdDate != null) {

                out.print(
                    dateFormat.format(createdDate)
                );

            } else {

                out.print("—");
            }

        %>

        </span>

    </div>

</div>


<!-- ===================================================
     STATISTICS
     =================================================== -->

<div class="stats-grid">


    <div class="stat-card">

        <div class="stat-label">

            Total Orders

        </div>

        <div class="stat-value">

            <%= totalOrders %>

        </div>

        <div class="stat-small">

            Orders placed

        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">

            Total Spent

        </div>

        <div class="stat-value">

            ₹<%= String.format("%.2f", totalSpent) %>

        </div>

        <div class="stat-small">

            Excluding cancelled orders

        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">

            Delivered

        </div>

        <div class="stat-value">

            <%= deliveredOrders %>

        </div>

        <div class="stat-small">

            Successfully delivered

        </div>

    </div>


    <div class="stat-card">

        <div class="stat-label">

            Pending Amount

        </div>

        <div class="stat-value">

            ₹<%= String.format("%.2f", pendingAmount) %>

        </div>

        <div class="stat-small">

            Pending / processing payments

        </div>

    </div>

</div>


<!-- ===================================================
     PERSONAL INFORMATION
     =================================================== -->

<section class="section">


<div class="section-header">

    <div class="section-title">

        Personal Information

    </div>

    <div class="section-label">

        Account Profile

    </div>

</div>


<div class="profile-details">


<div class="detail">

    <div class="detail-label">

        Customer ID

    </div>

    <div class="detail-value">

        <%= customerId %>

    </div>

</div>


<div class="detail">

    <div class="detail-label">

        Full Name

    </div>

    <div class="detail-value">

        <%= dbName %>

    </div>

</div>


<div class="detail">

    <div class="detail-label">

        Email Address

    </div>

    <div class="detail-value">

        <%= dbEmail %>

    </div>

</div>


<div class="detail">

    <div class="detail-label">

        Mobile Number

    </div>

    <div class="detail-value">

        <%= dbPhone != null &&
            !dbPhone.trim().isEmpty()
            ? dbPhone
            : "Not provided" %>

    </div>

</div>


<div class="detail full">

    <div class="detail-label">

        Account Address

    </div>

    <div class="detail-value">

        <%= dbAddress != null &&
            !dbAddress.trim().isEmpty()
            ? dbAddress
            : "No primary address saved." %>

    </div>

</div>


</div>

</section>


<!-- ===================================================
     ORDERS
     =================================================== -->

<section class="section">


<div class="section-header">

    <div class="section-title">

        My Orders

    </div>

    <div class="section-label">

        <%= totalOrders %> Total

    </div>

</div>


<div class="table-wrapper">

<table>

<thead>

<tr>

<th>Order ID</th>

<th>Date</th>

<th>Amount</th>

<th>Status</th>

<th>Shipping Address</th>

<th>Details</th>

</tr>

</thead>


<tbody>

<%

try {

    String orderSql =

        "SELECT ORDER_ID, TOTAL_AMOUNT, ORDER_DATE, " +
        "STATUS, SHIPPING_ADDRESS " +
        "FROM AK_ORDER " +
        "WHERE CUSTOMER_EMAIL = ? " +
        "ORDER BY ORDER_DATE DESC";


    psOrders =
        con.prepareStatement(orderSql);

    psOrders.setString(1, dbEmail);

    rsOrders =
        psOrders.executeQuery();


    boolean hasOrders = false;


    while (rsOrders.next()) {

        hasOrders = true;


        String orderStatus =
            rsOrders.getString("STATUS");


        if (orderStatus == null)
            orderStatus = "UNKNOWN";


        String statusClass =
            orderStatus.toLowerCase()
            .replace(" ", "-");


        if (!statusClass.equals("processing") &&
            !statusClass.equals("shipped") &&
            !statusClass.equals("delivered") &&
            !statusClass.equals("cancelled")) {

            statusClass = "other";
        }

%>

<tr>


<td>

<div class="order-id">

<%= rsOrders.getString("ORDER_ID") %>

</div>

</td>


<td>

<%

Timestamp orderDate =
    rsOrders.getTimestamp("ORDER_DATE");

if (orderDate != null) {

    out.print(
        dateTimeFormat.format(orderDate)
    );

} else {

    out.print("—");
}

%>

</td>


<td class="amount">

₹<%= String.format(
    "%.2f",
    rsOrders.getDouble("TOTAL_AMOUNT")
) %>

</td>


<td>

<span class="badge <%= statusClass %>">

<%= orderStatus %>

</span>

</td>


<td>

<%

String ship =
    rsOrders.getString("SHIPPING_ADDRESS");

if (ship != null &&
    !ship.trim().isEmpty()) {

    if (ship.length() > 80) {

        ship =
            ship.substring(0, 80)
            + "...";
    }

    out.print(ship);

} else {

    out.print("Not provided");
}

%>

</td>


<td>

<a
href="<%= request.getContextPath() %>/pages/order-details.jsp?orderId=<%= rsOrders.getString("ORDER_ID") %>"
class="dark-btn"
style="text-decoration:none;display:inline-block;"
>

VIEW

</a>

</td>


</tr>

<%

    }


    if (!hasOrders) {

%>

<tr>

<td colspan="6">

<div class="empty">

You haven't placed any orders yet.

</div>

</td>

</tr>

<%

    }

}

catch (Exception e) {

    e.printStackTrace();

%>

<tr>

<td colspan="6">

<div class="empty">

Unable to load orders.

</div>

</td>

</tr>

<%

}

%>

</tbody>

</table>

</div>

</section>


<!-- ===================================================
     ADDRESS + SECURITY
     =================================================== -->

<div class="two-column">


<!-- =================================================
     SAVED ADDRESSES
     ================================================= -->

<section class="section">


<div class="section-header">

    <div class="section-title">

        My Addresses

    </div>

    <div class="section-label">

        Maximum 2 Saved

    </div>

</div>


<div class="address-box">


<%

try {

    String addressSql =

        "SELECT ADDRESS_ID, ADDRESS_LABEL, " +
        "FULL_NAME, MOBILE, HOUSE_ADDRESS, " +
        "STREET_ADDRESS, AREA, LANDMARK, " +
        "CITY, STATE_NAME, PIN_CODE, COUNTRY " +
        "FROM AK_CUSTOMER_ADDRESS " +
        "WHERE CUSTOMER_ID = ? " +
        "ORDER BY CREATED_DATE DESC";


    psAddresses =
        con.prepareStatement(addressSql);

    psAddresses.setString(1, customerId);

    rsAddresses =
        psAddresses.executeQuery();


    boolean hasAddress = false;


    while (rsAddresses.next()) {

        hasAddress = true;

%>


<div class="address-card">


<div class="address-label">

<%= rsAddresses.getString("ADDRESS_LABEL") %>

</div>


<div class="address-name">

<%= rsAddresses.getString("FULL_NAME") %>

</div>


<div class="address-text">

<%= rsAddresses.getString("HOUSE_ADDRESS") %>

<%

String street =
    rsAddresses.getString("STREET_ADDRESS");

if (street != null &&
    !street.trim().isEmpty()) {

%>

<br><%= street %>

<%

}

String area =
    rsAddresses.getString("AREA");

if (area != null &&
    !area.trim().isEmpty()) {

%>

<br><%= area %>

<%

}

String landmark =
    rsAddresses.getString("LANDMARK");

if (landmark != null &&
    !landmark.trim().isEmpty()) {

%>

<br>Landmark: <%= landmark %>

<%

}

%>

<br>

<%= rsAddresses.getString("CITY") %>,

<%= rsAddresses.getString("STATE_NAME") %>

-

<%= rsAddresses.getString("PIN_CODE") %>

<br>

<%= rsAddresses.getString("COUNTRY") %>


<%

String addressMobile =
    rsAddresses.getString("MOBILE");

if (addressMobile != null &&
    !addressMobile.trim().isEmpty()) {

%>

<br>Mobile: <%= addressMobile %>

<%

}

%>

</div>


<div class="address-actions">


<form method="post"
      action="<%= request.getRequestURI() %>"
      style="display:inline;">

<input
    type="hidden"
    name="action"
    value="deleteAddress"
>

<input
    type="hidden"
    name="addressId"
    value="<%= rsAddresses.getString("ADDRESS_ID") %>"
>

<button
    type="submit"
    class="dark-btn"
    onclick="return confirm('Delete this saved address?');"
>

DELETE

</button>

</form>


</div>


</div>


<%

    }


    if (!hasAddress) {

%>


<div class="empty">

No saved addresses yet.

<br><br>

Click <strong style="color:#d4af37;">
ADD ADDRESS
</strong> to save your delivery address.

</div>


<%

    }

}

catch (Exception e) {

    e.printStackTrace();

%>

<div class="empty">

Unable to load saved addresses.

</div>

<%

}

%>


<%

/* Count current addresses */

int currentAddressCount = 0;

try {

    PreparedStatement psAddressCount =
        con.prepareStatement(
            "SELECT COUNT(*) AS CNT " +
            "FROM AK_CUSTOMER_ADDRESS " +
            "WHERE CUSTOMER_ID = ?"
        );

    psAddressCount.setString(1, customerId);

    ResultSet rsAddressCount =
        psAddressCount.executeQuery();

    if (rsAddressCount.next()) {

        currentAddressCount =
            rsAddressCount.getInt("CNT");
    }

    rsAddressCount.close();

    psAddressCount.close();

}

catch (Exception e) {}

%>


<% if (currentAddressCount < 2) { %>

<br>

<button
    class="gold-btn"
    onclick="openModal('addressModal')"
>

+ ADD ADDRESS

</button>

<% } %>


</div>

</section>


<!-- =================================================
     SECURITY
     ================================================= -->

<section class="section">


<div class="section-header">

<div class="section-title">

Account Security

</div>

<div class="section-label">

Protected

</div>

</div>


<div class="security-box">


<div class="security-row">

<div>

<div class="security-title">

Password

</div>

<div class="security-desc">

Your account password is protected.

</div>

</div>

<div>

<button
    class="dark-btn"
    onclick="openModal('passwordModal')"
>

CHANGE

</button>

</div>

</div>


<div class="security-row">

<div>

<div class="security-title">

Account Status

</div>

<div class="security-desc">

Current account availability.

</div>

</div>

<div class="security-status">

<%= dbStatus != null &&
    !dbStatus.trim().isEmpty()
    ? dbStatus
    : "ACTIVE" %>

</div>

</div>


<div class="security-row">

<div>

<div class="security-title">

Customer ID

</div>

<div class="security-desc">

Unique account identifier.

</div>

</div>

<div style="color:#aaa;font-size:10px;">

<%= customerId %>

</div>

</div>


</div>

</section>


</div>


<!-- ===================================================
     PAYMENT HISTORY
     =================================================== -->

<section class="section">


<div class="section-header">

<div class="section-title">

Payment History

</div>

<div class="section-label">

Transactions

</div>

</div>


<div class="table-wrapper">

<table>

<thead>

<tr>

<th>Payment ID</th>

<th>Order ID</th>

<th>Amount</th>

<th>Method</th>

<th>Status</th>

<th>Date</th>

</tr>

</thead>


<tbody>

<%

try {

    String paymentSql =

        "SELECT PAYMENT_ID, ORDER_ID, AMOUNT, " +
        "PAYMENT_METHOD, PAYMENT_STATUS, PAYMENT_DATE " +
        "FROM AK_PAYMENT " +
        "WHERE CUSTOMER_NAME = ? " +
        "ORDER BY PAYMENT_DATE DESC";


    psPayments =
        con.prepareStatement(paymentSql);

    psPayments.setString(1, dbName);

    rsPayments =
        psPayments.executeQuery();


    boolean hasPayments = false;


    while (rsPayments.next()) {

        hasPayments = true;


        String paymentStatus =
            rsPayments.getString("PAYMENT_STATUS");


        if (paymentStatus == null)
            paymentStatus = "UNKNOWN";


        String paymentStatusClass =
            paymentStatus.toLowerCase()
            .replace(" ", "-");


        if (!paymentStatusClass.equals("paid") &&
            !paymentStatusClass.equals("pending") &&
            !paymentStatusClass.equals("processing")) {

            paymentStatusClass = "other";
        }

%>

<tr>


<td>

<div class="order-id">

<%= rsPayments.getString("PAYMENT_ID") %>

</div>

</td>


<td>

<div class="order-id">

<%= rsPayments.getString("ORDER_ID") %>

</div>

</td>


<td class="amount">

₹<%= String.format(
    "%.2f",
    rsPayments.getDouble("AMOUNT")
) %>

</td>


<td>

<%= rsPayments.getString("PAYMENT_METHOD") %>

</td>


<td>

<span class="badge <%= paymentStatusClass %>">

<%= paymentStatus %>

</span>

</td>


<td>

<%

Timestamp paymentDate =
    rsPayments.getTimestamp("PAYMENT_DATE");

if (paymentDate != null) {

    out.print(
        dateTimeFormat.format(paymentDate)
    );

} else {

    out.print("—");
}

%>

</td>


</tr>

<%

    }


    if (!hasPayments) {

%>

<tr>

<td colspan="6">

<div class="empty">

No payment transactions found.

</div>

</td>

</tr>

<%

    }

}

catch (Exception e) {

    e.printStackTrace();

%>

<tr>

<td colspan="6">

<div class="empty">

Unable to load payment history.

</div>

</td>

</tr>

<%

}

%>

</tbody>

</table>

</div>

</section>


<!-- ===================================================
     ORDER STATUS
     =================================================== -->

<section class="section">


<div class="section-header">

<div class="section-title">

Order Status

</div>

<div class="section-label">

Overview

</div>

</div>


<div
class="stats-grid"
style="margin:0;padding:25px;"
>


<div class="stat-card">

<div class="stat-label">

Processing

</div>

<div class="stat-value">

<%= processingOrders %>

</div>

</div>


<div class="stat-card">

<div class="stat-label">

Shipped

</div>

<div class="stat-value">

<%= shippedOrders %>

</div>

</div>


<div class="stat-card">

<div class="stat-label">

Delivered

</div>

<div class="stat-value">

<%= deliveredOrders %>

</div>

</div>


<div class="stat-card">

<div class="stat-label">

Cancelled

</div>

<div class="stat-value">

<%= cancelledOrders %>

</div>

</div>


</div>

</section>


<div class="footer">

© <%= new GregorianCalendar()
        .get(Calendar.YEAR) %>

AYUSH LABEL — My Account

</div>


</main>


<!-- =======================================================
     EDIT PROFILE MODAL
     ======================================================= -->

<div
    id="editProfileModal"
    class="modal"
>


<div class="modal-box">


<div class="modal-header">

<div class="modal-title">

Edit Profile

</div>

<span
    class="close"
    onclick="closeModal('editProfileModal')"
>

&times;

</span>

</div>


<div class="modal-body">


<p class="form-note">

Update your personal account information.
Your registered email address is kept unchanged.

</p>


<form method="post"
      action="<%= request.getRequestURI() %>">


<input
    type="hidden"
    name="action"
    value="updateProfile"
>


<div class="form-grid">


<div class="form-group">

<label>Full Name</label>

<input
    type="text"
    name="newName"
    value="<%= dbName %>"
    maxlength="200"
    required
>

</div>


<div class="form-group">

<label>Mobile Number</label>

<input
    type="text"
    name="newPhone"
    value="<%= dbPhone != null ? dbPhone : "" %>"
    maxlength="10"
    inputmode="numeric"
    oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
>

</div>


<div class="form-group full">

<label>Email Address</label>

<input
    type="email"
    value="<%= dbEmail %>"
    readonly
>

</div>


</div>


<div class="modal-footer">

<button
    type="button"
    class="dark-btn"
    onclick="closeModal('editProfileModal')"
>

CANCEL

</button>


<button
    type="submit"
    class="gold-btn"
>

SAVE CHANGES

</button>

</div>


</form>

</div>

</div>

</div>


<!-- =======================================================
     CHANGE PASSWORD MODAL
     ======================================================= -->

<div
    id="passwordModal"
    class="modal"
>


<div class="modal-box">


<div class="modal-header">

<div class="modal-title">

Change Password

</div>

<span
    class="close"
    onclick="closeModal('passwordModal')"
>

&times;

</span>

</div>


<div class="modal-body">


<form method="post"
      action="<%= request.getRequestURI() %>">


<input
    type="hidden"
    name="action"
    value="changePassword"
>


<div class="form-grid">


<div class="form-group full">

<label>Current Password</label>

<input
    type="password"
    name="currentPassword"
    required
>

</div>


<div class="form-group">

<label>New Password</label>

<input
    type="password"
    name="newPassword"
    minlength="6"
    required
>

</div>


<div class="form-group">

<label>Confirm Password</label>

<input
    type="password"
    name="confirmPassword"
    minlength="6"
    required
>

</div>


</div>


<div class="modal-footer">

<button
    type="button"
    class="dark-btn"
    onclick="closeModal('passwordModal')"
>

CANCEL

</button>


<button
    type="submit"
    class="gold-btn"
>

UPDATE PASSWORD

</button>

</div>


</form>

</div>

</div>

</div>


<!-- =======================================================
     ADD ADDRESS MODAL
     ======================================================= -->

<div
    id="addressModal"
    class="modal"
>


<div class="modal-box">


<div class="modal-header">

<div class="modal-title">

Add New Address

</div>

<span
    class="close"
    onclick="closeModal('addressModal')"
>

&times;

</span>

</div>


<div class="modal-body">


<p class="form-note">

Save your delivery address for faster checkout.
You can keep up to 2 addresses in your account.

</p>


<form method="post"
      action="<%= request.getRequestURI() %>">


<input
    type="hidden"
    name="action"
    value="addAddress"
>


<div class="form-grid">


<div class="form-group">

<label>Address Type</label>

<select name="addressLabel">

<option value="Home">
Home
</option>

<option value="Work">
Work
</option>

<option value="Other">
Other
</option>

</select>

</div>


<div class="form-group">

<label>Full Name *</label>

<input
    type="text"
    name="fullName"
    maxlength="200"
    required
>

</div>


<div class="form-group">

<label>Mobile Number</label>

<input
    type="text"
    name="mobile"
    maxlength="10"
    inputmode="numeric"
    oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)"
>

</div>


<div class="form-group">

<label>House / Flat / Building *</label>

<input
    type="text"
    name="house"
    maxlength="250"
    required
>

</div>


<div class="form-group">

<label>Street / Road</label>

<input
    type="text"
    name="street"
    maxlength="250"
>

</div>


<div class="form-group">

<label>Area / Locality</label>

<input
    type="text"
    name="area"
    maxlength="250"
>

</div>


<div class="form-group">

<label>Landmark</label>

<input
    type="text"
    name="landmark"
    maxlength="250"
>

</div>


<div class="form-group">

<label>City *</label>

<input
    type="text"
    name="city"
    maxlength="100"
    required
>

</div>


<div class="form-group">

<label>State *</label>

<input
    type="text"
    name="state"
    maxlength="100"
    required
>

</div>


<div class="form-group">

<label>PIN Code *</label>

<input
    type="text"
    name="pin"
    maxlength="6"
    inputmode="numeric"
    oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,6)"
    required
>

</div>


<div class="form-group">

<label>Country</label>

<input
    type="text"
    value="India"
    readonly
>

</div>


</div>


<div class="modal-footer">

<button
    type="button"
    class="dark-btn"
    onclick="closeModal('addressModal')"
>

CANCEL

</button>


<button
    type="submit"
    class="gold-btn"
>

SAVE ADDRESS

</button>

</div>


</form>

</div>

</div>

</div>


<script>


/* =========================================================
   MODAL FUNCTIONS
   ========================================================= */

function openModal(id) {

    document.getElementById(id).style.display = "block";

    document.body.style.overflow = "hidden";
}


function closeModal(id) {

    document.getElementById(id).style.display = "none";

    document.body.style.overflow = "auto";
}


/* Close when clicking outside */

window.onclick = function(event) {

    if (event.target.classList.contains("modal")) {

        event.target.style.display = "none";

        document.body.style.overflow = "auto";
    }
};


</script>


</body>


</html>


<%

/* =========================================================
   CLOSE DATABASE RESOURCES
   ========================================================= */

try {
    if (rsCustomer != null)
        rsCustomer.close();
} catch (Exception e) {}

try {
    if (rsStats != null)
        rsStats.close();
} catch (Exception e) {}

try {
    if (rsOrders != null)
        rsOrders.close();
} catch (Exception e) {}

try {
    if (rsPayments != null)
        rsPayments.close();
} catch (Exception e) {}

try {
    if (rsAddresses != null)
        rsAddresses.close();
} catch (Exception e) {}

try {
    if (psCustomer != null)
        psCustomer.close();
} catch (Exception e) {}

try {
    if (psStats != null)
        psStats.close();
} catch (Exception e) {}

try {
    if (psOrders != null)
        psOrders.close();
} catch (Exception e) {}

try {
    if (psPayments != null)
        psPayments.close();
} catch (Exception e) {}

try {
    if (psAddresses != null)
        psAddresses.close();
} catch (Exception e) {}

try {
    if (con != null)
        con.close();
} catch (Exception e) {}

%>