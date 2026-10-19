<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    // Admin login session destroy karega
    session.invalidate();

    // Main shopping website ke home page par redirect karega
    response.sendRedirect("home.jsp");
    return;
%>