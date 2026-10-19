<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ page import="java.sql.*" %>

<%

String fullname = request.getParameter("fullname");
String email = request.getParameter("email");
String phone = request.getParameter("phone");
String password = request.getParameter("password");
String confirmPassword = request.getParameter("confirmPassword");

// =====================================
// CLEAN INPUT
// =====================================

if (fullname != null) {
    fullname = fullname.trim();
}

if (email != null) {
    email = email.trim();
}

if (phone != null) {
    phone = phone.trim();
}

// =====================================
// BASIC VALIDATION
// =====================================

if (fullname == null || fullname.equals("")) {

    response.sendRedirect("register.jsp?error=name");
    return;
}

// =====================================
// EMAIL OR PHONE REQUIRED
// =====================================

if ((email == null || email.equals(""))
        &&
    (phone == null || phone.equals(""))) {

    response.sendRedirect("register.jsp?error=contact");
    return;
}

// =====================================
// EMPTY VALUES = NULL
// =====================================

if (email == null || email.equals("")) {
    email = null;
}

if (phone == null || phone.equals("")) {
    phone = null;
}

// =====================================
// PASSWORD MATCH
// =====================================

if (password == null
        || confirmPassword == null
        || !password.equals(confirmPassword)) {

    response.sendRedirect("register.jsp?error=password");
    return;
}


Connection con = null;
PreparedStatement checkStmt = null;
PreparedStatement insertStmt = null;
ResultSet rs = null;

try {

    // =====================================
    // ORACLE CONNECTION
    // =====================================

    String driver =
        "oracle.jdbc.driver.OracleDriver";

    String url =
        "jdbc:oracle:thin:@localhost:1521:XE";

    String useridDB =
        "system";

    String passwordDB =
        "ayush";

    Class.forName(driver);

    con = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );


    // =====================================
    // CHECK DUPLICATE EMAIL / PHONE
    // =====================================

    String checkSQL =
        "SELECT CUSTOMER_ID " +
        "FROM AK_CUSTOMER " +
        "WHERE " +
        "(CUSTOMER_EMAIL = ? AND ? IS NOT NULL) " +
        "OR " +
        "(CUSTOMER_PHONE = ? AND ? IS NOT NULL)";

    checkStmt =
        con.prepareStatement(checkSQL);

    checkStmt.setString(1, email);
    checkStmt.setString(2, email);

    checkStmt.setString(3, phone);
    checkStmt.setString(4, phone);

    rs = checkStmt.executeQuery();


    if (rs.next()) {

        response.sendRedirect(
            "register.jsp?error=duplicate"
        );

        return;
    }


    // =====================================
    // GENERATE CUSTOMER ID
    // =====================================

    String customerId =
        "CUS" + System.currentTimeMillis();


    // =====================================
    // INSERT CUSTOMER
    // =====================================

    String insertSQL =
        "INSERT INTO AK_CUSTOMER " +
        "(CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_EMAIL, " +
        "CUSTOMER_PHONE, ADDRESS, STATUS, CREATED_DATE, " +
        "CUSTOMER_PASSWORD) " +
        "VALUES (?, ?, ?, ?, ?, ?, SYSDATE, ?)";

    insertStmt =
        con.prepareStatement(insertSQL);


    // CUSTOMER ID
    insertStmt.setString(
        1,
        customerId
    );


    // CUSTOMER NAME
    insertStmt.setString(
        2,
        fullname
    );


    // EMAIL
    if (email == null) {

        insertStmt.setNull(
            3,
            Types.VARCHAR
        );

    } else {

        insertStmt.setString(
            3,
            email
        );
    }


    // PHONE
    if (phone == null) {

        insertStmt.setNull(
            4,
            Types.VARCHAR
        );

    } else {

        insertStmt.setString(
            4,
            phone
        );
    }


    // ADDRESS
    insertStmt.setNull(
        5,
        Types.VARCHAR
    );


    // STATUS
    insertStmt.setString(
        6,
        "Active"
    );


    // =====================================
    // PASSWORD
    // EXACT PASSWORD ENTERED BY USER
    // =====================================

    insertStmt.setString(
        7,
        password
    );


    // =====================================
    // EXECUTE INSERT
    // =====================================

    int result =
        insertStmt.executeUpdate();


    // =====================================
    // SUCCESS
    // =====================================

    if (result > 0) {

        response.sendRedirect(
            "login.jsp?registered=true"
        );

        return;

    } else {

        response.sendRedirect(
            "register.jsp?error=db"
        );

        return;
    }


}
catch (Exception e) {

    e.printStackTrace();

%>

<script>

    alert("Registration Error: <%= e.getMessage() %>");

    window.location.href = "register.jsp";

</script>

<%

}
finally {

    try {

        if (rs != null)
            rs.close();

    } catch (Exception e) {}


    try {

        if (checkStmt != null)
            checkStmt.close();

    } catch (Exception e) {}


    try {

        if (insertStmt != null)
            insertStmt.close();

    } catch (Exception e) {}


    try {

        if (con != null)
            con.close();

    } catch (Exception e) {}
}

%>