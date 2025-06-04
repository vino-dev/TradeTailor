<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.TradeTailor.TradeTailor.model.CalendarEvent" %>
<%@ page import="com.TradeTailor.TradeTailor.model.StockNews" %>
<%@ page import="java.util.*" %>

<%
    Map<String, Object> usStatus = (Map<String, Object>) request.getAttribute("usStatus");
    List<StockNews> newsList = (List<StockNews>) request.getAttribute("newsList");
    List<CalendarEvent> calendarEvents = (List<CalendarEvent>) request.getAttribute("events");
    Map<String, Double> topQuotes = (Map<String, Double>) request.getAttribute("topQuotes");
    Map<String, Long> volumes = (Map<String, Long>) request.getAttribute("volumes"); // Ensure volumes is correctly retrieved
%>

<html>
<head>
    <title>TradeTailor | Dashboard</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* CSS Variables for theming - Copied from your Home JSP */
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
            --section-bg: #2d3748; /* Used for section backgrounds */
            --section-heading-color: #90cdf4;
            --sub-heading-color: #a0aec0;
            --card-shadow: rgba(0, 0, 0, 0.3);
            --border-color: #63b3ed; /* Used for table borders and general borders */
            --table-header-bg: #2d3748; /* Darker header for dark mode table */
            --table-row-hover-bg: #3a4a5a; /* Hover for table rows */
            --input-bg: #4a5568;
            --input-text-color: #e2e8f0;
            --input-border-color: #63b3ed;
            --button-bg: #3182ce;
            --button-hover-bg: #2b6cb0;
            --chart-text-color: #e2e8f0; /* Color for chart labels and tooltips in dark mode */
            --positive-change-color: green;
            --negative-change-color: red;
        }

        body.light-mode {
            /* Light Mode Colors - Copied from your Home JSP */
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
            --section-bg: #ffffff; /* Used for section backgrounds */
            --section-heading-color: #3182ce;
            --sub-heading-color: #63b3ed;
            --card-shadow: rgba(0, 0, 0, 0.1);
            --border-color: #a0aec0; /* Used for table borders and general borders */
            --table-header-bg: #edf2f7; /* Lighter header for light mode table */
            --table-row-hover-bg: #f0f4f7; /* Hover for table rows */
            --input-bg: #ffffff;
            --input-text-color: #2d3748;
            --input-border-color: #a0aec0;
            --button-bg: #3182ce;
            --button-hover-bg: #2b6cb0;
            --chart-text-color: #2d3748; /* Color for chart labels and tooltips in light mode */
            --positive-change-color: green;
            --negative-change-color: red;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background-color);
            color: var(--text-color);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        /* General layout and styling for Navbar, Sidebar, Buttons - Consistent with Home JSP */
        .navbar {
            background-color: var(--navbar-bg);
            color: var(--navbar-link-color);
            padding: 14px 25px;
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 999;
            height: 65px;
            box-sizing: border-box;
            box-shadow: 0 2px 8px var(--card-shadow);
            transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        .navbar .left {
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .navbar .hamburger {
            font-size: 26px;
            cursor: pointer;
            color: var(--navbar-icon-color);
            transition: color 0.3s ease;
        }

        .navbar .title {
            font-size: 22px;
            font-weight: bold;
            color: var(--navbar-icon-color);
            transition: color 0.3s ease;
        }

        .navbar .right {
            display: flex;
            gap: 20px;
            font-size: 17px;
            align-items: center;
        }

        .navbar a, .nav-link-button {
            color: var(--navbar-link-color);
            text-decoration: none;
            cursor: pointer;
            padding: 8px 15px;
            border-radius: 5px;
            font-family: inherit;
            transition: background-color 0.3s ease, color 0.3s ease;
            border: none;
            background: none;
            font-size: 17px;
        }

        .navbar a:hover,
        .nav-link-button:hover {
            background-color: var(--navbar-link-hover-bg);
            color: var(--text-color);
            box-shadow: 0 2px 5px var(--card-shadow);
        }

        .theme-toggle-btn {
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
            top: 65px;
            height: calc(100% - 65px);
            background-color: var(--sidebar-bg);
            color: var(--sidebar-link-color);
            padding: 20px 0;
            width: 240px;
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
            background-color: var(--sidebar-bg);
            transform: translateX(100%);
            padding-left: 20px;
            padding-right: 20px;
        }

        .sidebar-left.active {
            transform: translateX(0);
        }

        .sidebar-account.active {
            transform: translateX(0);
        }

        .sidebar-left a {
            display: block;
            padding: 14px 20px;
            color: var(--sidebar-link-color);
            text-decoration: none;
            border-radius: 0;
            margin-bottom: 5px;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .sidebar-left a:hover {
            background-color: var(--sidebar-link-hover-bg);
            color: white;
        }

        .signout-btn {
            margin-top: 30px;
            padding: 12px 25px;
            background-color: var(--signout-btn-bg);
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 8px;
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .signout-btn:hover {
            background-color: var(--signout-btn-hover-bg);
            transform: translateY(-2px);
        }

        h3 {
            color: var(--section-heading-color);
            margin-bottom: 15px;
            transition: color 0.3s ease;
        }

        .sidebar-account p {
            margin-bottom: 8px;
            color: var(--paragraph-color);
            transition: color 0.3s ease;
        }

        .container {
            padding: 1rem 2rem;
            padding-top: 80px; /* Adjust for fixed navbar */
        }

        .content-flexbox {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
        }

        .left-column {
            flex: 1;
            min-width: 300px;
        }

        .right-column {
            flex: 2;
            min-width: 400px;
            display: flex;
            flex-direction: column;
            gap: 2rem;
        }

        .charts-row {
            display: flex;
            gap: 2rem;
            flex-wrap: wrap;
            justify-content: space-around;
        }

        .section {
            background-color: var(--section-bg);
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 4px 12px var(--card-shadow);
            margin-bottom: 0; /* Let flexbox gap handle spacing */
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }
        .left-column .section {
             margin-bottom: 2rem; /* Restore margin for sections in left column */
        }

        .section h3 {
            color: var(--section-heading-color);
            margin-bottom: 1rem;
            transition: color 0.3s ease;
        }

        .market-open {
            color: var(--positive-change-color);
            font-weight: bold;
        }

        .market-closed {
            color: var(--negative-change-color);
            font-weight: bold;
        }

        .label {
            font-weight: bold;
            color: var(--sub-heading-color);
            transition: color 0.3s ease;
        }

        /* News Vertical Scroll specific styles */
        .news-vertical-scroll-container {
            max-height: 250px; /* Fixed height for vertical scroll */
            overflow-y: auto; /* Enable vertical scrolling */
            padding-right: 10px; /* Space for scrollbar */
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background-color: var(--input-bg);
            transition: background-color 0.3s ease, border-color 0.3s ease;
            box-shadow: inset 0 0 5px rgba(0, 0, 0, 0.1); /* Subtle inner shadow */
        }

        .news-vertical-scroll-container ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .news-vertical-scroll-container li {
            margin-bottom: 0.8rem;
            padding: 0.5rem;
            border-bottom: 1px solid var(--border-color);
            transition: border-color 0.3s ease;
        }

        .news-vertical-scroll-container li:last-child {
            border-bottom: none;
        }

        .news-vertical-scroll-container li a {
            color: var(--heading-color);
            text-decoration: none;
            font-weight: bold;
            display: block; /* Make the link take full width */
            margin-bottom: 5px;
            transition: color 0.3s ease;
        }

        .news-vertical-scroll-container li a:hover {
            text-decoration: underline;
        }

        .news-vertical-scroll-container li small {
            color: var(--paragraph-color);
            font-size: 0.9em;
            transition: color 0.3s ease;
        }


        .scrollable-box { /* This is for Upcoming Events table */
            max-height: 250px; /* Adjusted height for better scroll */
            overflow-y: auto;
            padding-right: 10px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background-color: var(--input-bg); /* Use input background for scrollable areas */
            transition: background-color 0.3s ease, border-color 0.3s ease;
        }

        .scrollable-box ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .scrollable-box li {
            margin-bottom: 0.8rem;
            padding: 0.5rem;
            border-bottom: 1px solid var(--border-color);
            transition: border-color 0.3s ease;
        }

        .scrollable-box li:last-child {
            border-bottom: none;
        }

        .scrollable-box li a {
            color: var(--heading-color);
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        .scrollable-box li a:hover {
            text-decoration: underline;
        }

        .scrollable-box small {
            color: var(--paragraph-color);
            font-size: 0.9em;
            transition: color 0.3s ease;
        }


        .event-table {
            width: 100%;
            border-collapse: collapse;
            color: var(--text-color);
            transition: color 0.3s ease;
        }

        .event-table th, .event-table td {
            border: 1px solid var(--border-color);
            padding: 0.8rem;
            text-align: left;
            transition: border-color 0.3s ease;
        }

        .event-table th {
            background-color: var(--table-header-bg);
            color: var(--section-heading-color);
            font-weight: bold;
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .event-table tr:nth-child(even) {
            background-color: rgba(0, 0, 0, 0.05); /* Slightly different background for even rows */
            transition: background-color 0.3s ease;
        }
        body.light-mode .event-table tr:nth-child(even) {
             background-color: rgba(0, 0, 0, 0.02);
        }

        .event-table tr:hover {
            background-color: var(--table-row-hover-bg);
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        /* Chart Wrapper for consistent aspect ratio/height */
        .chart-wrapper {
            position: relative; /* Needed for absolute positioning of canvas */
            width: 100%;
            height: 300px; /* Adjust as needed */
        }

        .chart-wrapper canvas {
            position: absolute; /* Take canvas out of flow for proper sizing */
            width: 100% !important;
            height: 100% !important;
            top: 0;
            left: 0;
        }

        /* Specific styles for chart containers within the charts-row */
        .pie-chart-container, .volume-chart-container {
            flex: 1;
            min-width: 280px;
            max-width: 50%;
            padding: 1rem;
            box-sizing: border-box;
        }

        .pie-chart-container .chart-wrapper,
        .volume-chart-container .chart-wrapper {
            height: 300px; /* Or use padding-bottom for aspect ratio */
        }

        .indices-wrapper {
            display: flex; /* Enable flexbox for centering */
            justify-content: center; /* Center items horizontally */
            flex-wrap: wrap; /* Allow widgets to wrap to the next line */
            padding: 1rem 2rem 0; /* Maintain padding from the top and sides */
            gap: 15px; /* Space between widgets */
            padding-top: 80px; /* Space for the fixed navbar */
        }

        .index-widget {
            background-color: var(--section-bg);
            border: 1px solid var(--border-color);
            padding: 10px 15px;
            width: 180px;
            text-align: center;
            border-radius: 10px;
            box-shadow: 0 4px 10px var(--card-shadow);
            transition: background-color 0.3s ease, border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .index-widget h3 {
            color: var(--heading-color);
            margin-bottom: 5px;
            font-size: 1.2rem;
            transition: color 0.3s ease;
        }
        .index-widget p {
            color: var(--paragraph-color);
            margin-bottom: 3px;
            font-size: 0.95rem;
            transition: color 0.3s ease;
        }

        .positive {
            color: var(--positive-change-color) !important;
            font-weight: bold;
        }
        .negative {
            color: var(--negative-change-color) !important;
            font-weight: bold;
        }
    </style>
</head>
<body>
<div class="navbar">
    <div class="left">
        <div class="hamburger" onclick="toggleSidebar('left')"><i class="fas fa-bars"></i></div>
        <div class="title">Trade Tailor</div>
    </div>
    <div class="right">
        <a href="home">Home</a>
        <a href="watchlist">Watchlist</a>
        <button type="button" class="nav-link-button" onclick="toggleSidebar('account')">Account</button>
        <button type="button" class="theme-toggle-btn" id="themeToggle">Dark Theme</button>
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
<div class="indices-wrapper">
    <%
        Map<String, String[]> indices = (Map<String, String[]>) request.getAttribute("indices");
        if (indices != null) {
            for (Map.Entry<String, String[]> entry : indices.entrySet()) {
                String key = entry.getKey();
                String[] val = entry.getValue();
                String price = val[0];
                String change = val[1];
                String changeClass = change.startsWith("+") ? "positive" : "negative";
    %>
        <div class="index-widget">
            <h3><%= key %></h3>
            <p>Price: $<%= price %></p>
            <p class="<%= changeClass %>">Change: <%= change %></p>
        </div>
    <%
            }
        }
    %>
</div>
<div class="container">
    <div class="content-flexbox">
        <div class="left-column">
            <div class="section">
                <h3>US Market Status</h3>
                <%
                    if (usStatus != null) {
                        boolean isOpen = Boolean.parseBoolean(usStatus.get("isOpen").toString());
                %>
                    <p><span class="label">Status:</span>
                        <span class="<%= isOpen ? "market-open" : "market-closed" %>">
                            <%= isOpen ? "OPEN 🟢" : "CLOSED 🔴" %>
                        </span>
                    </p>
                    <p><span class="label">Holiday:</span> <%= usStatus.get("holiday") %></p>
                <% } else { %>
                    <p>Status not available.</p>
                <% } %>
            </div>

            <div class="section">
                <h3>Latest Stock News</h3>
                <div class="news-vertical-scroll-container">
                    <ul>
                        <%
                            if (newsList != null && !newsList.isEmpty()) {
                                for (StockNews news : newsList) {
                        %>
                            <li>
                                <a href="<%= news.getUrl() %>" target="_blank"><%= news.getHeadline() %></a><br>
                                <small><%= news.getDatetime() %></small>
                            </li>
                        <% }
                        } else { %>
                            <li>No news data available.</li>
                        <% } %>
                    </ul>
                </div>
            </div>

            <div class="section">
                <h3>Upcoming Events</h3>
                <div class="scrollable-box">
                    <table class="event-table">
                        <thead>
                            <tr>
                                <th>Date</th>
                                <th>Type</th>
                                <th>Title</th>
                                <th>Details</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (calendarEvents != null) {
                                    for (CalendarEvent event : calendarEvents) {
                            %>
                                <tr>
                                    <td><%= event.getDate() %></td>
                                    <td><%= event.getType() %></td>
                                    <td><%= event.getTitle() %></td>
                                    <td><%= event.getDetails() %></td>
                                </tr>
                            <% } } else { %>
                                <tr><td colspan="4">No events available.</td></tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div class="right-column">
            <div class="section">
                <h3>Stock Price Chart</h3>
                <div class="chart-wrapper">
                    <canvas id="stockChart"></canvas>
                </div>
            </div>

            <div class="charts-row">
                <div class="section pie-chart-container">
                    <h3>Stock Price Distribution (Pie Chart)</h3>
                    <div class="chart-wrapper">
                        <canvas id="stockPieChart"></canvas>
                    </div>
                </div>
                
                <div class="section volume-chart-container">
                    <h3>Top Symbols Volume</h3>
                    <div class="chart-wrapper">
                        <canvas id="volumeChart"></canvas>      
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    function toggleSidebar(side) {
        const left = document.getElementById("leftSidebar");
        const right = document.getElementById("accountSidebar");
        if (side === 'left') {
            left.classList.toggle("active");
            right.classList.remove("active");
        } else {
            right.classList.toggle("active");
            left.classList.remove("active");
        }
    }

    // Theme Toggle Logic
    const themeToggleBtn = document.getElementById('themeToggle');
    const body = document.body;

    // Function to get computed style variable
    function getCssVariable(variableName) {
        return getComputedStyle(document.documentElement).getPropertyValue(variableName).trim();
    }

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
        // Update chart colors based on theme
        updateChartColors();
    }

    // Function to update chart colors
    function updateChartColors() {
        const currentTheme = localStorage.getItem('theme') || 'dark';
        const chartLabelColor = getCssVariable('--chart-text-color');

        if (stockChart) {
            stockChart.options.scales.x.ticks.color = chartLabelColor;
            stockChart.options.scales.y.ticks.color = chartLabelColor;
            stockChart.options.plugins.legend.labels.color = chartLabelColor;
            stockChart.update();
        }
        if (pieChart) {
            pieChart.options.plugins.legend.labels.color = chartLabelColor;
            pieChart.update();
        }
        if (volumeChart) {
            volumeChart.options.scales.x.ticks.color = chartLabelColor;
            volumeChart.options.scales.y.ticks.color = chartLabelColor;
            volumeChart.options.plugins.legend.labels.color = chartLabelColor;
            volumeChart.update();
        }
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
    });

    // Event listener for theme toggle button
    themeToggleBtn.addEventListener('click', () => {
        if (body.classList.contains('light-mode')) {
            setTheme('dark');
        } else {
            setTheme('light');
        }
    });


    // Render Stock Price Chart (Line Chart)
    const stockChartCtx = document.getElementById('stockChart').getContext('2d');
    const stockChart = new Chart(stockChartCtx, {
        type: 'line',
        data: {
            labels: [
                <% if (topQuotes != null) {
                    for (String key : topQuotes.keySet()) { %>
                        "<%= key %>",
                <% }} %>
            ],
            datasets: [{
                label: 'Stock Prices',
                data: [
                    <% if (topQuotes != null) {
                        for (Double value : topQuotes.values()) { %>
                            <%= value %>,
                    <% }} %>
                ],
                borderColor: '#2563eb',
                backgroundColor: 'rgba(37, 99, 235, 0.2)',
                borderWidth: 2,
                tension: 0.1 // Smooths the line
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // CRITICAL for responsive charts in flexbox
            scales: {
                y: {
                    beginAtZero: false,
                    ticks: {
                        color: getCssVariable('--chart-text-color')
                    }
                },
                x: {
                    ticks: {
                        color: getCssVariable('--chart-text-color')
                    }
                }
            },
            plugins: {
                legend: {
                    labels: {
                        color: getCssVariable('--chart-text-color')
                    }
                }
            }
        }
    });

    // Render Stock Price Distribution (Pie Chart)
    const pieCtx = document.getElementById('stockPieChart').getContext('2d');
    const pieChart = new Chart(pieCtx, {
        type: 'pie',
        data: {
            labels: [
                <% if (topQuotes != null) {
                    for (String key : topQuotes.keySet()) { %>
                        "<%= key %>",
                <% }} %>
            ],
            datasets: [{
                data: [
                    <% if (topQuotes != null) {
                        for (Double value : topQuotes.values()) { %>
                            <%= value %>,
                    <% }} %>
                ],
                backgroundColor: [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0', '#9966FF', '#FF9F40', '#E7E9ED', '#8AC926', '#FFCA3A', '#6A4C93'
                ],
                hoverOffset: 4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    labels: {
                        color: getCssVariable('--chart-text-color')
                    }
                }
            }
        }
    });

    // Render Top Symbols Volume (Bar Chart)
    const volumeCtx = document.getElementById('volumeChart').getContext('2d');
    const volumeChart = new Chart(volumeCtx, {
        type: 'bar',
        data: {
            labels: [
                <% if (volumes != null) {
                    for (String symbol : volumes.keySet()) { %>
                        "<%= symbol %>",
                <% }} %>
            ],
            datasets: [{
                label: 'Volume',
                data: [
                    <% if (volumes != null) {
                        for (Long vol : volumes.values()) { %>
                            <%= vol %>,
                    <% }} %>
                ],
                backgroundColor: [
                    'rgba(255, 99, 132, 0.7)',
                    'rgba(54, 162, 235, 0.7)',
                    'rgba(255, 206, 86, 0.7)',
                    'rgba(75, 192, 192, 0.7)',
                    'rgba(153, 102, 255, 0.7)',
                    'rgba(255, 159, 64, 0.7)',
                    'rgba(199, 199, 199, 0.7)',
                    'rgba(83, 102, 255, 0.7)',
                    'rgba(255, 99, 71, 0.7)',
                    'rgba(60, 179, 113, 0.7)'
                ],
                borderColor: [
                    'rgba(255, 99, 132, 1)',
                    'rgba(54, 162, 235, 1)',
                    'rgba(255, 206, 86, 1)',
                    'rgba(75, 192, 192, 1)',
                    'rgba(153, 102, 255, 1)',
                    'rgba(255, 159, 64, 1)',
                    'rgba(199, 199, 199, 1)',
                    'rgba(83, 102, 255, 1)',
                    'rgba(255, 99, 71, 1)',
                    'rgba(60, 179, 113, 1)'
                ],
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        color: getCssVariable('--chart-text-color')
                    }
                },
                x: {
                    ticks: {
                        color: getCssVariable('--chart-text-color')
                    }
                }
            },
            plugins: {
                legend: {
                    labels: {
                        color: getCssVariable('--chart-text-color')
                    }
                }
            }
        }
    });

    // Initial chart color update on load
    updateChartColors();

</script>

</body>
</html>