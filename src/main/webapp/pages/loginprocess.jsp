<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
    import="java.sql.*" %>

<%
String loginId = request.getParameter("loginId");
String password = request.getParameter("password");

if (loginId == null) {
    loginId = "";
}

if (password == null) {
    password = "";
}

loginId = loginId.trim();

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {

    String driver = "oracle.jdbc.driver.OracleDriver";
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String useridDB = "system";
    String passwordDB = "ayush";

    Class.forName(driver);

    con = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );

    String sql =
        "SELECT CUSTOMER_ID, CUSTOMER_NAME, CUSTOMER_EMAIL, " +
        "CUSTOMER_PHONE, STATUS " +
        "FROM AK_CUSTOMER " +
        "WHERE (CUSTOMER_EMAIL = ? OR CUSTOMER_PHONE = ?) " +
        "AND CUSTOMER_PASSWORD = ?";

    ps = con.prepareStatement(sql);

    ps.setString(1, loginId);
    ps.setString(2, loginId);
    ps.setString(3, password);

    rs = ps.executeQuery();

    if (rs.next()) {

        session.setAttribute(
            "customerId",
            rs.getString("CUSTOMER_ID")
        );

        session.setAttribute(
            "customerName",
            rs.getString("CUSTOMER_NAME")
        );

        session.setAttribute(
            "customerEmail",
            rs.getString("CUSTOMER_EMAIL")
        );

        session.setAttribute(
            "customerPhone",
            rs.getString("CUSTOMER_PHONE")
        );

        session.setAttribute(
            "customerLoggedIn",
            true
        );

        response.sendRedirect(
            request.getContextPath() + "/index.jsp"
        );

        return;

    } else {

        response.sendRedirect(
            request.getContextPath() + "/pages/login.jsp?error=true"
        );

        return;
    }

}
catch (Exception e) {

    e.printStackTrace();

    response.sendRedirect(
        request.getContextPath() + "/pages/login.jsp?error=true"
    );

    return;

}
finally {

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