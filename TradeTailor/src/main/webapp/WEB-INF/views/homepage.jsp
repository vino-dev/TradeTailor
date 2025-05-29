<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Trade Tailor Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }

        .navbar {
            background-color: #1a1a1a;
            color: white;
            padding: 10px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 999;
        }

        .navbar .left {
            display: flex;
            align-items: center;
        }

        .navbar .title {
            font-size: 20px;
            font-weight: bold;
            margin-right: 20px;
        }

        .navbar .hamburger {
            font-size: 24px;
            cursor: pointer;
        }

        .navbar .right {
            display: flex;
            gap: 20px;
            font-size: 16px;
        }

        .navbar .right div {
            cursor: pointer;
        }

        .sidebar-left, .sidebar-account {
            position: fixed;
            top: 50px;
            height: 100%;
            background-color: #333;
            color: white;
            padding: 20px;
            width: 220px;
            transition: transform 0.3s ease;
            z-index: 1000;
        }

        .sidebar-left {
            left: 0;
            transform: translateX(-100%);
        }

        .sidebar-account {
            right: 0;
            transform: translateX(100%);
            background-color: #444;
        }

        .sidebar-left.active {
            transform: translateX(0);
        }

        .sidebar-account.active {
            transform: translateX(0);
        }

        .sidebar-item {
            margin-bottom: 15px;
            cursor: pointer;
        }

        .sidebar-item:hover {
            color: #00bfff;
        }

        .content {
            padding: 80px 20px;
        }

        .signout-btn {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #ff3333;
            color: white;
            border: none;
            cursor: pointer;
        }

        .signout-btn:hover {
            background-color: #cc0000;
        }

        h2 {
            color: #333;
        }
    </style>
</head>
<body>

    <div class="navbar">
        <div class="left">
            <div class="title">Trade Tailor</div>
            <div class="hamburger" onclick="toggleSidebar('left')">
                <i class="fas fa-bars"></i>
            </div>
        </div>
        <div class="right">
            <div onclick="navigate('home')">Home</div>
            <div onclick="navigate('watchlist')">Watchlist</div>
            <div onclick="toggleSidebar('account')">Account</div>
            <div onclick="location.href='logout.jsp'">Sign Out</div>
        </div>
    </div>

    <div class="sidebar-left" id="leftSidebar">
        <div class="sidebar-item">Home</div>
        <div class="sidebar-item">Generate Report</div>
        <div class="sidebar-item">Report Customizer</div>
    </div>

    <div class="sidebar-account" id="accountSidebar">
        <h3>Account Info</h3>
        <p><strong>Name:</strong> Santhoshi</p>
        <p><strong>Email:</strong> santhoshi@example.com</p>
        <p><strong>Phone:</strong> 9876543210</p>
        <button class="signout-btn">Sign Out</button>
    </div>

    <div class="content">
        <h2>Welcome, Santhoshi!</h2>
        <p>This is your Trade Tailor dashboard.</p>
    </div>

    <script>
        function toggleSidebar(side) {
            const leftSidebar = document.getElementById('leftSidebar');
            const accountSidebar = document.getElementById('accountSidebar');

            if (side === 'left') {
                leftSidebar.classList.toggle('active');
                accountSidebar.classList.remove('active');
            } else if (side === 'account') {
                accountSidebar.classList.toggle('active');
                leftSidebar.classList.remove('active');
            }
        }

       
    </script>
</body>
</html>
