<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trade Tailor Report Customizer</title>
 <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
     <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f0f2f5; /* Added background for consistency */
        }

        .navbar {
            background-color: #1a1a1a;
            color: white;
            padding: 14px 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 999;
            height: 60px;
            box-sizing: border-box;
        }

        .navbar .left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar .hamburger {
            font-size: 24px;
            cursor: pointer;
            color: white;
        }

        .navbar .title {
            font-size: 20px;
            font-weight: bold;
        }

        .navbar .right {
            display: flex;
            gap: 15px;
            font-size: 16px;
            align-items: center;
        }

        .navbar a, .nav-link-button {
            color: white;
            text-decoration: none;
            cursor: pointer;
            padding: 6px 12px;
            border-radius: 4px;
            font-family: inherit;
            transition: background-color 0.3s ease;
            border: none;
            background: none;
            font-size: 16px;
        }

        .navbar a:hover,
        .nav-link-button:hover {
            background-color: #00bfff;
            color: white;
        }

        .sidebar-left, .sidebar-account {
            position: fixed;
            top: 60px;
            height: calc(100% - 60px); /* Adjust to fill remaining height */
            background-color: #333;
            color: white;
            padding: 20px;
            width: 220px;
            transition: transform 0.3s ease;
            z-index: 1000;
            box-sizing: border-box;
            overflow-y: auto; /* Added for scroll if content overflows */
        }

        .sidebar-left {
            left: 0;
            transform: translateX(-100%);
            display: flex;
            flex-direction: column;
        }

        .sidebar-account {
            right: 0;
            background-color: #444;
            transform: translateX(100%);
        }

        .sidebar-left.active {
            transform: translateX(0);
        }

        .sidebar-account.active {
            transform: translateX(0);
        }

        .sidebar-left a {
            display: block;
            padding: 12px 16px;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 10px;
            transition: background-color 0.3s ease;
        }

        .sidebar-left a:hover {
            background-color: #00bfff;
        }

        .content {
            padding: 100px 20px 20px 20px;
            /* Adjust padding to account for fixed navbar and potentially sidebars */
            margin-left: 0; /* Default */
            margin-right: 0; /* Default */
            transition: margin-left 0.3s ease, margin-right 0.3s ease;
        }

        .content.sidebar-left-active {
            margin-left: 220px; /* Shift content when left sidebar is open */
        }

        .content.sidebar-account-active {
            margin-right: 220px; /* Shift content when account sidebar is open */
        }

        .signout-btn {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #ff3333;
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }

        .signout-btn:hover {
            background-color: #cc0000;
        }

        h2 {
            color: #333;
            text-align: center; /* Center the heading */
            margin-bottom: 30px; /* Add some space below the heading */
        }

        /* Styling for the export buttons container */
        .export-buttons-container {
            display: flex;
            justify-content: center; /* Center buttons horizontally */
            gap: 15px; /* Space between buttons */
            margin-top: 20px; /* Space from the top of the content area */
        }

        .export-buttons-container button {
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #007bff;
            color: white;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease;
        }

        .export-buttons-container button:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="left">
            <div class="hamburger" onclick="toggleSidebar('left')">
                <i class="fas fa-bars"></i>
            </div>
            <div class="title">Trade Tailor</div>
        </div>
        <div class="right">
            <a href="homepage">Home</a>
            <a href="watchlist">Watchlist</a>
            <button type="button" class="nav-link-button" onclick="toggleSidebar('account')">Account</button>
            <a href="logout.jsp">Sign Out</a>
        </div>
    </div>

    <div class="sidebar-left" id="leftSidebar">
        <a href="dashboard">Dashboard</a>
        <a href="generateReport">Generate Report</a>
        <a href="reportCustomizer">Report Customizer</a>
    </div>

    <div class="sidebar-account" id="accountSidebar">
        <h3>Account Info</h3>
        <p><strong>Name:</strong> Santhoshi</p>
        <p><strong>Email:</strong> santhoshi@example.com</p>
        <p><strong>Phone:</strong> 9876543210</p>
        <form action="logout.jsp" method="post">
            <button type="submit" class="signout-btn">Sign Out</button>
        </form>
    </div>

    <div class="content" id="mainContent">
        <h2>Report Customizer</h2>
        <div class="export-buttons-container">
            <button onclick="exportCSVServer()">Export CSV (Server)</button>
            <button onclick="exportExcelServer()">Export Excel (Server)</button>
            <button onclick="exportPDFServer()">Export PDF (Server)</button>
        </div>
        <%-- You can add more customization options here later --%>
    </div>

    <script>
        function toggleSidebar(side) {
            const leftSidebar = document.getElementById('leftSidebar');
            const accountSidebar = document.getElementById('accountSidebar');
            const mainContent = document.getElementById('mainContent');

            if (side === 'left') {
                leftSidebar.classList.toggle('active');
                mainContent.classList.toggle('sidebar-left-active');
                accountSidebar.classList.remove('active'); // Close other sidebar if open
                mainContent.classList.remove('sidebar-account-active'); // Adjust content margin
            } else if (side === 'account') {
                accountSidebar.classList.toggle('active');
                mainContent.classList.toggle('sidebar-account-active');
                leftSidebar.classList.remove('active'); // Close other sidebar if open
                mainContent.classList.remove('sidebar-left-active'); // Adjust content margin
            }
        }

        function exportCSVServer() {

window.location.href = "/export/csv1?symbol=${symbol}";

}



function exportExcelServer() {

window.location.href = "/export/excel1?symbol=${symbol}";

}

function exportPDFServer() {

window.location.href = "/export/pdf1?symbol=${symbol}";

}
</script>

</body>

</html>