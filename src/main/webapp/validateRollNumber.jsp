<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.jsp.util.PropertiesUtil" %>
<%@ page import="com.jsp.util.RedisUtil" %>
<%@ page import="redis.clients.jedis.Jedis" %>
<%
    String rollNumber = request.getParameter("rollNumber");
    boolean isValid = false;

    // Check Redis cache first
    Jedis jedis = RedisUtil.getJedis();
    String studentDetails = jedis.get("student:" + rollNumber);

    if (studentDetails == null) {
        // Not in cache, check database
        String dbUrl = PropertiesUtil.getProperty("db.url");
        String dbUsername = PropertiesUtil.getProperty("db.username");
        String dbPassword = PropertiesUtil.getProperty("db.password");

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
            PreparedStatement ps = con.prepareStatement("SELECT * FROM student_details WHERE id=?");
            ps.setString(1, rollNumber);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                // Student found, add to cache
                studentDetails = rs.getString("name") + "," +
                                 rs.getString("phone_number") + "," +
                                 rs.getString("aadhar_number") + "," +
                                 rs.getString("father_name");

                jedis.setex("student:" + rollNumber, 60, studentDetails); // Cache for 60 seconds
                isValid = true;
            }

            con.close();
        } catch(Exception e) {
            out.println(e);
        }
    } else {
        // Found in cache
        isValid = true;
    }

    if(isValid) {
        response.sendRedirect("studentDetails.jsp?rollNumber=" + rollNumber);
    } else {
%>
    <h1>Invalid Roll Number</h1>
    <p>The roll number <%= rollNumber %> is invalid.</p>
    <form action="index.jsp">
        <button class="back-button" type="submit"></button>
    </form>
<%
    }
    // Close Redis connection (optional)
    RedisUtil.close();
%>
