<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.jsp.util.PropertiesUtil" %>
<%@ page import="com.jsp.util.RedisUtil" %>
<%@ page import="redis.clients.jedis.Jedis" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Student Details</title>
    <style>
        .back-button {
            position: absolute;
            top: 10px;
            left: 10px;
            background-image: url('path_to_arrow_icon/back_arrow_icon.png');
            width: 30px;
            height: 30px;
            background-size: cover;
            border: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <h1>Student Details</h1>

    <% 
        String rollNumber = request.getParameter("rollNumber");
        Jedis jedis = RedisUtil.getJedis();
        String studentDetails = jedis.get("student:" + rollNumber);

        if (studentDetails == null) {
            // Not in cache, fetch from database
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
                    String name = rs.getString("name");
                    String phoneNumber = rs.getString("phone_number");
                    String aadharNumber = rs.getString("aadhar_number");
                    String fatherName = rs.getString("father_name");

                    studentDetails = name + "," + phoneNumber + "," + aadharNumber + "," + fatherName;

                    // Store in Redis cache with TTL
                    jedis.setex("student:" + rollNumber, 60, studentDetails);

                    // Display the details
                    %>
                    <p>Name: <%= name %></p>
                    <p>Phone Number: <%= phoneNumber %></p>
                    <p>Aadhar Number: <%= aadharNumber %></p>
                    <p>Father Name: <%= fatherName %></p>
                    <%
                } else {
                    %>
                    <p>No student found with the provided roll number.</p>
                    <%
                }

                con.close();
            } catch(Exception e) {
                out.println(e);
            }
        } else {
            // Found in cache, display cached details
            String[] details = studentDetails.split(",");
            %>
            <p>Name: <%= details[0] %></p>
            <p>Phone Number: <%= details[1] %></p>
            <p>Aadhar Number: <%= details[2] %></p>
            <p>Father Name: <%= details[3] %></p>
            <%
        }

        // Close Redis connection (optional)
        RedisUtil.close();
    %>

    <form action="index.jsp">
        <button class="back-button" type="submit"></button>
    </form>
</body>
</html>
