<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Trade Tailor Report Customizer</title>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f0f2f5;
        }

        .navbar {
            background-color: #1a1a1a;
            color: white;
            padding: 14px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: fixed;
            top: 0;
            width: 100%;
            height: 60px;
            z-index: 1000;
        }

        .navbar .left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar .hamburger {
            font-size: 24px;
            cursor: pointer;
        }

        .navbar .title {
            font-size: 20px;
            font-weight: bold;
        }

        .navbar .right a,
        .nav-link-button {
            color: white;
            text-decoration: none;
            margin-left: 10px;
            padding: 6px 12px;
            border-radius: 4px;
            transition: background-color 0.3s ease;
        }

        .navbar a:hover,
        .nav-link-button:hover {
            background-color: #00bfff;
        }

        .sidebar-left,
        .sidebar-account {
            position: fixed;
            top: 60px;
            height: calc(100% - 60px);
            width: 220px;
            background-color: #333;
            color: white;
            padding: 20px;
            transform: translateX(-100%);
            transition: transform 0.3s ease;
            z-index: 999;
        }

        .sidebar-left.active {
            transform: translateX(0);
        }

        .sidebar-account {
            right: 0;
            background-color: #444;
            transform: translateX(100%);
        }

        .sidebar-account.active {
            transform: translateX(0);
        }

        .sidebar-left a {
            color: white;
            display: block;
            margin-bottom: 10px;
            text-decoration: none;
        }

        .sidebar-left a:hover {
            background-color: #00bfff;
            padding-left: 5px;
        }

        .signout-btn {
            margin-top: 20px;
            background-color: #ff3333;
            color: white;
            padding: 10px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        .content {
            padding: 80px 20px 20px 20px;
            max-width: 900px;
            margin: auto;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }

        .form-group input[type="email"] {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .submit-btn {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
        }

        .submit-btn:hover {
            background-color: #0056b3;
        }

        #chart-container {
            margin: 30px auto;
            max-width: 700px;
        }

        #preview {
            margin-top: 20px;
            border: 1px solid #ccc;
            padding: 15px;
            background-color: #fafafa;
        }

        #preview img {
            width: 400px;
            margin-top: 10px;
        }
    </style>
</head>
<body>

<!-- Navbar -->
<div class="navbar">
    <div class="left">
        <div class="hamburger" onclick="toggleSidebar('left')">
            <i class="fas fa-bars"></i>
        </div>
        <div class="title">Trade Tailor</div>
    </div>
    <div class="right">
        <a href="home">Home</a>
        <a href="watchlist">Watchlist</a>
        <button class="nav-link-button" onclick="toggleSidebar('account')">Account</button>
        <a href="logout.jsp">Sign Out</a>
    </div>
</div>

<!-- Sidebars -->
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

<!-- Main Content -->
<div class="content">
    <h2>Schedule Your Daily Report</h2>

    <!-- Show success message -->
    <c:if test="${param.scheduled == 'true'}">
        <p style="color: green; font-weight: bold;">Report scheduled successfully! You will receive the daily report email at 11 AM.</p>
    </c:if>

    <form action="/scheduleReportEmail" method="post">
        <div class="form-group">
            <label for="email">Enter your email to receive the daily report at 11 AM:</label>
            <input type="email" id="email" name="email" placeholder="yourname@example.com" required />
        </div>

        <div class="form-group">
            <label for="symbol">Enter stock symbol for the report (e.g. AAPL):</label>
            <input type="text" id="symbol" name="symbol" placeholder="AAPL" required />
        </div>

        <button type="submit" class="submit-btn">Schedule Report</button>
    </form>
    
    <div id="chart-container">
        <canvas id="earningsChart"></canvas>
    </div>

    <div id="preview">
        <h3>Email Preview</h3>
        <p><strong>Subject:</strong> TradeTailor Daily Report</p>
        <p><strong>Body:</strong></p>
        <p>Hi,<br><br>
            Please find attached your customized stock report with EPS forecast data.<br><br>
            Regards,<br>Trade Tailor Team
        </p>
        <img id="chartPreview" />
    </div>
</div>

<script>
    function toggleSidebar(side) {
        const leftSidebar = document.getElementById('leftSidebar');
        const accountSidebar = document.getElementById('accountSidebar');
        if (side === 'left') {
            leftSidebar.classList.toggle('active');
            accountSidebar.classList.remove('active');
        } else {
            accountSidebar.classList.toggle('active');
            leftSidebar.classList.remove('active');
        }
    }

    const labels = ["AAPL", "MSFT", "GOOGL", "AMZN", "TSLA"];
    const data = [2.3, 1.9, 2.5, 3.1, 2.8];

    const ctx = document.getElementById('earningsChart').getContext('2d');
    const chart = new Chart(ctx, {
        type: 'bar',
        data: {
            labels: labels,
            datasets: [{
                label: 'EPS Estimate',
                data: data,
                backgroundColor: 'rgba(54, 162, 235, 0.6)'
            }]
        },
        options: {
            responsive: true,
            plugins: {
                title: {
                    display: true,
                    text: 'Upcoming Earnings EPS Estimates'
                }
            }
        }
    });

    setTimeout(() => {
        const base64Image = chart.toBase64Image();
        document.getElementById('chartPreview').src = base64Image;
    }, 1000);
</script>

</body>
</html>
