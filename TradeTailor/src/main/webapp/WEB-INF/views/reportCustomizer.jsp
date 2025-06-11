<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Trade Tailor Report Customizer</title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />

    <style>
        /* CSS Variables for theming */
        :root {
            /* Dark Mode Colors (Default) */
            --background-color: #1a202c;
            --text-color: #e2e8f0;
            --heading-color: #90cdf4;
            --paragraph-color: #cbd5e0;
            --navbar-bg: #1a202c;
            --navbar-link-color: #e2e8f0;
            --navbar-link-hover-bg: #3182ce;
            --navbar-icon-color: #90cdf4;
            --sidebar-bg: #2d3748;
            --sidebar-link-color: #e2e8f0;
            --sidebar-link-hover-bg: #3182ce;
            --signout-btn-bg: #ef4444;
            --signout-btn-hover-bg: #dc2626;
            --section-bg: #2d3748; /* Used for content background */
            --section-heading-color: #90cdf4;
            --sub-heading-color: #a0aec0;
            --card-shadow: rgba(0, 0, 0, 0.3);
            --border-color: #63b3ed; /* Used for table borders and inputs */
            --input-border-color: #4a5568;
            --input-bg-color: #2d3748;
            --input-text-color: #e2e8f0;
            --button-bg-color: #3182ce;
            --button-hover-bg-color: #0056b3;
            --chart-label-color: #e2e8f0; /* Color for chart labels and titles */
        }

        body.light-mode {
            /* Light Mode Colors */
            --background-color: #f7fafc;
            --text-color: #2d3748;
            --heading-color: #3182ce;
            --paragraph-color: #4a5568;
            --navbar-bg: #ffffff;
            --navbar-link-color: #4a5568;
            --navbar-link-hover-bg: #ebf8ff;
            --navbar-icon-color: #3182ce;
            --sidebar-bg: #edf2f7;
            --sidebar-link-color: #4a5568;
            --sidebar-link-hover-bg: #e2e8f0;
            --signout-btn-bg: #c53030;
            --signout-btn-hover-bg: #9b2c2c;
            --section-bg: #ffffff; /* Used for content background */
            --section-heading-color: #3182ce;
            --sub-heading-color: #63b3ed;
            --card-shadow: rgba(0, 0, 0, 0.1);
            --border-color: #a0aec0; /* Used for table borders and inputs */
            --input-border-color: #cbd5e0;
            --input-bg-color: #ffffff;
            --input-text-color: #2d3748;
            --button-bg-color: #007BFF;
            --button-hover-bg-color: #0056b3;
            --chart-label-color: #4a5568; /* Color for chart labels and titles */
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .navbar {
            background-color: var(--navbar-bg);
            color: var(--navbar-link-color);
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
            box-shadow: 0 2px 8px var(--card-shadow);
            transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        .navbar .left {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .navbar .hamburger {
            font-size: 24px;
            cursor: pointer;
            color: var(--navbar-icon-color);
            transition: color 0.3s ease;
        }

        .navbar .title {
            font-size: 20px;
            font-weight: bold;
            color: var(--navbar-icon-color);
            transition: color 0.3s ease;
        }

        .navbar .right {
            display: flex;
            gap: 15px;
            font-size: 16px;
            align-items: center;
        }

        .navbar a, .nav-link-button {
            color: var(--navbar-link-color);
            text-decoration: none;
            cursor: pointer;
            padding: 6px 12px;
            border-radius: 4px;
            font-family: inherit;
            transition: background-color 0.3s ease, color 0.3s ease;
            border: none;
            background: none;
            font-size: 16px;
        }

        .navbar a:hover,
        .nav-link-button:hover {
            background-color: var(--navbar-link-hover-bg);
            color: var(--text-color);
            box-shadow: 0 2px 5px var(--card-shadow);
        }

        .theme-toggle-btn { /* Add this button style */
            background-color: var(--navbar-link-hover-bg);
            color: var(--text-color);
            padding: 8px 15px;
            border-radius: 5px;
            border: 1px solid var(--border-color);
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }

        .theme-toggle-btn:hover {
            background-color: var(--heading-color);
            color: white;
            box-shadow: 0 2px 5px var(--card-shadow);
        }

        .sidebar-left, .sidebar-account {
            position: fixed;
            top: 60px; /* Below navbar */
            height: calc(100% - 60px); /* Fill remaining height */
            background-color: var(--sidebar-bg);
            color: var(--sidebar-link-color);
            padding: 20px;
            width: 220px;
            transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease, color 0.3s ease;
            z-index: 1000;
            box-sizing: border-box;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
            overflow-y: auto;
        }

        .sidebar-left {
            left: 0;
            transform: translateX(-100%);
            display: flex;
            flex-direction: column;
        }

        .sidebar-account {
            right: 0;
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
            color: var(--sidebar-link-color);
            text-decoration: none;
            border-radius: 4px;
            margin-bottom: 10px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .sidebar-left a:hover {
            background-color: var(--sidebar-link-hover-bg);
            color: white;
        }

        .signout-btn {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: var(--signout-btn-bg);
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .signout-btn:hover {
            background-color: var(--signout-btn-hover-bg);
            transform: translateY(-2px);
        }

        h2, h3 {
            color: var(--heading-color);
            text-align: center;
            transition: color 0.3s ease;
        }

        .sidebar-account p {
            margin-bottom: 8px;
            color: var(--paragraph-color);
            transition: color 0.3s ease;
        }

        .content {
            padding: 80px 20px 20px 20px;
            max-width: 900px;
            margin: auto;
            background-color: var(--section-bg);
            border-radius: 8px;
            box-shadow: 0 0 10px var(--card-shadow);
            transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        .form-group {
            margin-bottom: 15px;
        }

        .form-group label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: var(--text-color);
            transition: color 0.3s ease;
        }

        .form-group input[type="email"],
        .form-group input[type="text"] {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--input-border-color);
            border-radius: 4px;
            background-color: var(--input-bg-color);
            color: var(--input-text-color);
            box-sizing: border-box; /* Ensures padding doesn't increase width */
            transition: border-color 0.3s ease, background-color 0.3s ease, color 0.3s ease;
        }

        .form-group input[type="email"]:focus,
        .form-group input[type="text"]:focus {
            outline: none;
            border-color: var(--heading-color);
            box-shadow: 0 0 0 2px rgba(144, 205, 244, 0.5); /* Focus highlight */
        }

        .submit-btn {
            background-color: var(--button-bg-color);
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .submit-btn:hover {
            background-color: var(--button-hover-bg-color);
            transform: translateY(-2px);
        }

        #chart-container {
            margin: 30px auto;
            max-width: 700px;
            background-color: var(--section-bg);
            border-radius: 8px;
            padding: 10px;
            box-shadow: 0 2px 5px var(--card-shadow);
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        #preview {
            margin-top: 20px;
            border: 1px solid var(--border-color);
            padding: 15px;
            background-color: var(--section-bg);
            border-radius: 8px;
            box-shadow: 0 2px 5px var(--card-shadow);
            transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
        }

        #preview h3, #preview p {
            color: var(--text-color); /* Ensure preview text also adapts */
            transition: color 0.3s ease;
        }

        #preview img {
            width: 400px;
            max-width: 100%; /* Make image responsive */
            height: auto;
            display: block; /* Remove extra space below image */
            margin: 10px auto 0 auto; /* Center image */
            border: 1px solid var(--input-border-color); /* Add a subtle border */
            border-radius: 4px;
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
        <a href="home">Home</a>
        <a href="watchlist">Watchlist</a>
        <button class="nav-link-button" onclick="toggleSidebar('account')">Account</button>
        <button type="button" class="theme-toggle-btn" id="themeToggle">Dark Theme</button>
        <a href="logout">Sign Out</a>
    </div>
</div>

<div class="sidebar-left" id="leftSidebar">
    <a href="dashboard">Dashboard</a>
    <a href="generateReport">Generate Report</a>
    <a href="reportCustomizer">Report Customizer</a>
</div>

<div class="sidebar-account" id="accountSidebar">
    <h3>Account Info</h3>
    <%
        // Retrieve session attributes
        String name = (String) session.getAttribute("name");
        String email = (String) session.getAttribute("email");
        String mobile = (String) session.getAttribute("mobile");
    %>
    <p><strong>Name:</strong> ${name}</p>
    <p><strong>Email:</strong>${email}</p>
    <p><strong>Phone:</strong>${mobile}</p>
    <form action="logout" method="post">
        <button type="submit" class="signout-btn">Sign Out</button>
    </form>
</div>

<div class="content">
    <h2>Schedule Your Daily Report</h2>

    <%--
    <c:if test="${param.scheduled == 'true'}">
        <p style="color: green; font-weight: bold;">Report scheduled successfully! You will receive the daily report email at 11 AM.</p>
    </c:if>
    --%>
    <%
        // Direct JSP way for success message
        String scheduledParam = request.getParameter("scheduled");
        if ("true".equals(scheduledParam)) {
    %>
            <p style="color: var(--heading-color); font-weight: bold; text-align: center; margin-bottom: 20px;">Report scheduled successfully! You will receive the daily report email at 11 AM.</p>
    <%
        }
    %>


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
    let chart; // Declare chart globally so updateChartColors can access it

    // Function to update chart colors based on theme
    function updateChartColors() {
        if (chart) {
            const chartLabelColor = getComputedStyle(document.documentElement).getPropertyValue('--chart-label-color').trim();
            chart.options.plugins.title.color = chartLabelColor; // Update title color
            chart.options.scales.x.ticks.color = chartLabelColor; // Update x-axis labels
            chart.options.scales.y.ticks.color = chartLabelColor; // Update y-axis labels
            chart.options.scales.y.title.color = chartLabelColor; // Update y-axis title
            chart.options.plugins.legend.labels.color = chartLabelColor; // Update legend labels

            // Update grid line color (if needed, match the generateReport's grid color)
            chart.options.scales.x.grid.color = 'rgba(128, 128, 128, 0.3)';
            chart.options.scales.y.grid.color = 'rgba(128, 128, 128, 0.3)';

            chart.update();
        }
    }

    // Initialize the chart
    chart = new Chart(ctx, {
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
                    text: 'Upcoming Earnings EPS Estimates',
                    color: 'var(--chart-label-color)' // Use CSS variable for title
                },
                legend: {
                    labels: {
                        color: 'var(--chart-label-color)' // Use CSS variable for legend
                    }
                }
            },
            scales: {
                x: {
                    ticks: {
                        color: 'var(--chart-label-color)' // Use CSS variable for x-axis ticks
                    },
                    grid: {
                        color: 'rgba(128, 128, 128, 0.3)' // Consistent grid color
                    }
                },
                y: {
                    ticks: {
                        color: 'var(--chart-label-color)' // Use CSS variable for y-axis ticks
                    },
                    title: {
                        display: true,
                        text: 'EPS Estimate',
                        color: 'var(--chart-label-color)' // Use CSS variable for y-axis title
                    },
                    grid: {
                        color: 'rgba(128, 128, 128, 0.3)' // Consistent grid color
                    }
                }
            }
        }
    });

    // Theme Toggle Logic - Copied from your Generate Report JSP
    const themeToggleBtn = document.getElementById('themeToggle');
    const body = document.body;

    // Function to set theme
    function setTheme(theme) {
        if (theme === 'light') {
            body.classList.add('light-mode');
            themeToggleBtn.textContent = 'Dark Theme'; // Update button text
            localStorage.setItem('theme', 'light');
        } else {
            body.classList.remove('light-mode'); // Ensure light-mode class is removed for dark theme
            themeToggleBtn.textContent = 'Light Theme'; // Update button text
            localStorage.setItem('theme', 'dark');
        }
        updateChartColors(); // Update chart colors when theme changes
    }

    // Check for saved theme on page load
    document.addEventListener('DOMContentLoaded', () => {
        const savedTheme = localStorage.getItem('theme');
        if (savedTheme) {
            setTheme(savedTheme);
        } else {
            // Default to dark mode if no preference is saved
            setTheme('dark'); // Explicitly set dark as default
        }
        updateChartColors(); // Ensure chart colors are set correctly on initial load
    });

    // Event listener for theme toggle button
    themeToggleBtn.addEventListener('click', () => {
        if (body.classList.contains('light-mode')) {
            setTheme('dark');
        } else {
            setTheme('light');
        }
    });


    setTimeout(() => {
        const base64Image = chart.toBase64Image();
        document.getElementById('chartPreview').src = base64Image;
    }, 1000);
</script>

</body>
</html>