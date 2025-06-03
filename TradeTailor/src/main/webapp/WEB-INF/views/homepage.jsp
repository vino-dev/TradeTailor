<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%
    Map<String, Double> stockData = (Map<String, Double>) request.getAttribute("stockData");
    ObjectMapper mapper = new ObjectMapper();
    String labels = mapper.writeValueAsString(stockData.keySet());
    String prices = mapper.writeValueAsString(stockData.values());
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>TradeTailor - Home</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f3f4f6;
            text-align: center;
        }

        h1 {
            margin-top: 30px;
            font-size: 2rem;
            color: #1f2937;
        }

        .orbit-container {
            position: relative;
            width: 360px;
            height: 360px;
            margin: 30px auto;
            border-radius: 50%;
            border: 3px dashed #e5e7eb;
            animation: spin 40s linear infinite;
        }

        .orbit-stock {
            position: absolute;
            width: 60px;
            height: 60px;
            line-height: 60px;
            border-radius: 50%;
            background-color: #3b82f6;
            color: white;
            font-weight: bold;
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s ease;
            white-space: pre-line;
        }

        .orbit-stock:hover {
            transform: scale(1.15);
            background-color: #2563eb;
        }

        @keyframes spin {
            100% {
                transform: rotate(360deg);
            }
        }

        .chart-container {
            width: 90%;
            max-width: 800px;
            margin: 30px auto;
        }

        .export-buttons {
            margin: 20px 0 40px 0;
        }

        .export-buttons button {
            margin: 5px 10px;
            padding: 10px 20px;
            font-size: 16px;
            background-color: #10b981;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .export-buttons button:hover {
            background-color: #059669;
        }

        @media (max-width: 500px) {
            .orbit-container {
                width: 280px;
                height: 280px;
            }

            .orbit-stock {
                width: 50px;
                height: 50px;
                line-height: 50px;
                font-size: 12px;
            }
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
            height: 100%;
            background-color: #333;
            color: white;
            padding: 20px;
            width: 220px;
            transition: transform 0.3s ease;
            z-index: 1000;
            box-sizing: border-box;
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
        }

        /* Dancing Bot Styles */
        #dancing-bot {
            position: fixed;
            bottom: 20px;
            left: 20px;
            width: 60px;
            height: 60px;
            font-size: 48px;
            cursor: pointer;
            user-select: none;
            animation: dance 1s ease-in-out infinite alternate;
            z-index: 1100;
        }

        @keyframes dance {
            0% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-10px) rotate(15deg);
            }
            100% {
                transform: translateY(0) rotate(-15deg);
            }
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

<!-- Updated Sidebar Links -->
<div class="sidebar-left" id="leftSidebar">
    <a href="dashboard">Dashboard</a>
    <a href="generateReport">Generate Report</a>
    <a href="reportCustomizer">Report Customizer</a>
</div>

<!-- Account Sidebar -->
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
    <h2>Welcome, Santhoshi!</h2>
    <p>This is your Trade Tailor dashboard.</p>
</div>

<!-- Orbit Section -->
<div class="orbit-container" id="orbit"></div>

<!-- Chart Section -->
<div class="chart-container">
    <canvas id="stockChart" height="120"></canvas>
</div>

<!-- Export Buttons -->
<div class="export-buttons">
    <button onclick="window.location.href='/api/stocks/export/excel'">📥 Export to Excel</button>
    <button onclick="window.location.href='/api/stocks/export/pdf'">📝 Export to PDF</button>
    <button onclick="window.location.href='/api/stocks/export/csv'">📊 Export to CSV</button>
</div>

<!-- Dancing Bot -->
<div id="dancing-bot" title="Dancing Bot 🤖">🤖</div>

<script>
    // Sidebar toggle functions
    function toggleSidebar(side) {
        if (side === 'left') {
            document.getElementById('leftSidebar').classList.toggle('active');
        } else if (side === 'account') {
            document.getElementById('accountSidebar').classList.toggle('active');
        }
    }

    // Orbit positions and colors for 6 stocks
    const orbitContainer = document.getElementById('orbit');
    const stockSymbols = <%= labels %>;
    const stockPrices = <%= prices %>;

    // Center of orbit
    const centerX = 180;
    const centerY = 180;
    const radius = 140;

    for (let i = 0; i < stockSymbols.length; i++) {
        const angle = (2 * Math.PI / stockSymbols.length) * i;
        const x = centerX + radius * Math.cos(angle) - 30; // 30 = half of orbit-stock width
        const y = centerY + radius * Math.sin(angle) - 30;

        const stockDiv = document.createElement('div');
        stockDiv.className = 'orbit-stock';
        stockDiv.style.left = x + 'px';
        stockDiv.style.top = y + 'px';
        stockDiv.innerHTML = stockSymbols[i] + '<br>$' + stockPrices[i].toFixed(2);
        stockDiv.title = stockSymbols[i] + " Price: $" + stockPrices[i].toFixed(2);

        orbitContainer.appendChild(stockDiv);
    }

    // Chart.js code
    const ctx = document.getElementById('stockChart').getContext('2d');
    const stockChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: stockSymbols,
            datasets: [{
                label: 'Stock Price',
                data: stockPrices,
                backgroundColor: 'rgba(59, 130, 246, 0.2)',
                borderColor: '#3b82f6',
                borderWidth: 2,
                pointRadius: 5,
                pointBackgroundColor: '#2563eb',
                fill: true,
                tension: 0.3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: false,
                    ticks: {
                        color: '#1f2937',
                        font: {size: 14}
                    }
                },
                x: {
                    ticks: {
                        color: '#1f2937',
                        font: {size: 14}
                    }
                }
            },
            plugins: {
                legend: {
                    labels: {
                        color: '#1f2937',
                        font: {size: 16}
                    }
                },
                tooltip: {
                    enabled: true,
                    mode: 'nearest'
                }
            }
        }
    });
</script>
</body>
</html>
