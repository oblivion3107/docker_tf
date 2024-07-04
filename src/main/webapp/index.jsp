<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Enter Roll Number</title>
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
    <h1>Enter Roll Number</h1>
    <form action="validateRollNumber.jsp" method="post">
        Roll Number: <input type="text" name="rollNumber">
        <input type="submit" value="Submit">
    </form>
</body>
</html>
