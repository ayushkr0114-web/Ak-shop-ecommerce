<%@ page language="java" import="java.sql.*" %>
<%
Connection con;
Statement stmt;
ResultSet rs;
try
{
String driver="oracle.jdbc.driver.OracleDriver";
Class.forName(driver);
String url="jdbc:oracle:thin:@localhost:1521:XE";

String useridDB="system";
String passwordDB="ayush";
con=DriverManager.getConnection(url,useridDB,passwordDB);
stmt=con.createStatement();

String adminid=request.getParameter("adminid");
String password=request.getParameter("password");

String query="SELECT ADMIN_ID FROM AK_ADMIN WHERE ADMIN_ID='"+adminid+"'AND PASSWORD='"+password+"'";
rs=stmt.executeQuery(query);

if(rs.next()==true)
{
String admin_id=rs.getString("admin_id");
session.setAttribute("admin_id",admin_id);
response.sendRedirect("home.jsp");
}
else
{
response.sendRedirect("login.jsp?error=true");
}
con.close();
}
catch(Exception e)
{
out.println(e);

}
%>