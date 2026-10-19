<%@ page language="java" import="java.sql.*" %>

<%
try
{
    String driver = "oracle.jdbc.driver.OracleDriver";
    Class.forName(driver);
    String url = "jdbc:oracle:thin:@localhost:1521:XE";
    String useridDB = "system";
    String passwordDB = "ayush";
    Connection con = DriverManager.getConnection(
        url,
        useridDB,
        passwordDB
    );
    String categoryName =request.getParameter("categoryName");
    String categoryStatus =request.getParameter("categoryStatus");
    String categoryDescription =request.getParameter("categoryDescription");
    String categoryId ="CAT" + System.currentTimeMillis();
    String query =
        "INSERT INTO AK_CATEGORY " +
        "(CATEGORY_ID, CATEGORY_NAME, DESCRIPTION, STATUS) " +
        "VALUES (?, ?, ?, ?)";
    PreparedStatement ps = con.prepareStatement(query);
    ps.setString(1, categoryId);
    ps.setString(2, categoryName);

    ps.setString(3, categoryDescription);

    ps.setString(4, categoryStatus);


    int result = ps.executeUpdate();


    if(result > 0)
    {
        response.sendRedirect(
            "categories.jsp?success=true"
        );
    }
    else
    {
        response.sendRedirect(
            "categories.jsp?error=true"
        );
    }
    ps.close();
    con.close();
}
catch(Exception e)
{
    out.println(e);
}

%>