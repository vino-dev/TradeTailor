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
        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .navbar {
            background-color: #1a202c;
            color: white;
            display: flex;
            justify-content: space-between;
            padding: 1rem 2rem;
            align-items: center;
            z-index: 1001;
            position: relative;
        }

        .navbar .left {
            display: flex;
            align-items: center;
        }

        .navbar .left .hamburger {
            cursor: pointer;
            margin-right: 1rem;
            font-size: 1.2rem;
        }

        .navbar .right a,
        .navbar .right .nav-link-button {
            color: white;
            text-decoration: none;
            margin-left: 1rem;
            background: none;
            border: none;
            cursor: pointer;
            font-size: 1rem;
        }

        .container {
            padding: 1rem 2rem;
        }

        .sidebar-left, .sidebar-account {
            position: fixed;
            top: 60px;
            width: 220px;
            background-color: #1a202c;
            color: white;
            height: calc(100% - 60px);
            padding: 1rem;
            transition: transform 0.3s ease-in-out;
            z-index: 1000;
            overflow-y: auto;
        }

        .sidebar-left {
            left: 0;
            transform: translateX(-100%);
        }

        .sidebar-account {
            right: 0;
            transform: translateX(100%);
        }

        .sidebar-left.active,
        .sidebar-account.active {
            transform: translateX(0);
        }

        .sidebar-left a, .sidebar-account a {
            color: white;
            display: block;
            margin-bottom: 1rem;
            text-decoration: none;
        }

        .sidebar-account h3, .sidebar-account p {
            margin-bottom: 1rem;
        }

        .signout-btn {
            background-color: #e53e3e;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            cursor: pointer;
            border-radius: 5px;
        }

        .search-chart-container {
            margin-bottom: 2rem;
            display: flex;
            justify-content: center;
        }

        .search-box {
            padding: 0.5rem;
            width: 300px;
            border: 1px solid #ccc;
            border-radius: 5px 0 0 5px;
        }

        .search-button {
            padding: 0.5rem 1rem;
            background-color: #2563eb;
            color: white;
            border: none;
            border-radius: 0 5px 5px 0;
            cursor: pointer;
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
            background-color: white;
            padding: 1rem;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 0; /* Let flexbox gap handle spacing */
        }
        .left-column .section {
             margin-bottom: 2rem; /* Restore margin for sections in left column */
        }

        .market-open {
            color: green;
        }

        .market-closed {
            color: red;
        }

        .label {
            font-weight: bold;
        }

        .scrollable-box {
            max-height: 200px;
            overflow-y: auto;
            padding-right: 10px;
        }

        .scrollable-box ul {
            list-style-type: none;
            padding-left: 0;
        }

        .scrollable-box li {
            margin-bottom: 1rem;
        }

        .event-table {
            width: 100%;
            border-collapse: collapse;
        }

        .event-table th, .event-table td {
            border: 1px solid #ccc;
            padding: 0.5rem;
            text-align: left;
        }

        .event-table th {
            background-color: #f9fafb;
        }

        /* Chart Wrapper for consistent aspect ratio/height */
        .chart-wrapper {
            position: relative; /* Needed for absolute positioning of canvas */
            width: 100%;
            /* Option 1: Use a fixed height (e.g., 300px) */
            height: 300px; /* Adjust as needed */
            /* Option 2: Use padding-bottom for aspect ratio (e.g., 56.25% for 16:9, 75% for 4:3) */
            /* padding-bottom: 56.25%; /* For 16:9 aspect ratio */
            /* height: 0; /* Needed for padding-bottom approach */
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
            /* Ensure these also use the chart-wrapper pattern if needed,
               but direct height on canvas might be sufficient if containers constrain them */
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
        }

        .index-widget {
         background-color: white;
            border: 1px solid #ddd;
            padding: 5px;
            margin: 5px;
            width: 180px;
            display: inline-block;
            text-align: center;
            border-radius: 6px;
            box-shadow: 2px 2px 6px #ccc;
        }
        .positive { color: green; }
        .negative { color: red; }
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
    <div class="search-chart-container">
        <form action="reportgenerate" method="post">
            <input type="text" class="search-box" name="query" placeholder="Search by company">
            <button type="submit" class="search-button">Enter</button>
        </form>
    </div>

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
                <div class="scrollable-box">
                    <ul>
                        <%
                            if (newsList != null) {
                                for (StockNews news : newsList) {
                        %>
                            <li>
                                <a href="<%= news.getUrl() %>" target="_blank"><%= news.getHeadline() %></a><br>
                                <small><%= news.getDatetime() %></small>
                            </li>
                        <% } } else { %>
                            <li>No news data available.</li>
                        <% } %>
                    </ul>
                </div>
            </div>

            <div class="section">
                <h3>Upcoming Events</h3>
                <div class="scrollable-box">
                    <table class="event-table">
                        <tr>
                            <th>Date</th>
                            <th>Type</th>
                            <th>Title</th>
                            <th>Details</th>
                        </tr>
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
                    beginAtZero: false
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
                label: 'Stock Prices',
                data: [
                    <% if (topQuotes != null) {
                        for (Double value : topQuotes.values()) { %>
                            <%= value %>,
                    <% }} %>
                ],
                backgroundColor: [
                    '#2563eb',
                    '#34d399',
                    '#fbbf24',
                    '#f87171',
                    '#60a5fa',
                    '#a78bfa',
                    '#f43f5e',
                    '#10b981',
                    '#facc15',
                    '#3b82f6',
                    '#eab308',
                    '#be185d',
                    '#6d28d9',
                    '#06b6d4',
                    '#f97316'
                ],
                borderColor: '#fff',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // CRITICAL for responsive charts in flexbox
            plugins: {
                legend: {
                    position: 'right',
                },
                tooltip: {
                    enabled: true
                }
            }
        }
    });

    window.onload = function() {
        const scrollContainer = document.querySelector('.scrollable-box');
        if (!scrollContainer) return;

        let scrollAmount = 0;
        const scrollStep = 1;
        const scrollInterval = 50;

        function scrollNews() {
            scrollAmount += scrollStep;
            const maxScroll = scrollContainer.scrollHeight - scrollContainer.clientHeight;
            if (scrollAmount >= maxScroll) {
                scrollAmount = 0;
            }
            scrollContainer.scrollTop = scrollAmount;
        }

        // Only start auto-scrolling if the element is actually scrollable
        if (scrollContainer.scrollHeight > scrollContainer.clientHeight) {
            setInterval(scrollNews, scrollInterval);
        }
    }

    const symbols = [
        <%
            if (volumes != null) {
                Iterator<String> keys = volumes.keySet().iterator();
                while (keys.hasNext()) {
                    String symbol = keys.next();
                    out.print("'" + symbol + "'");
                    if (keys.hasNext()) {
                        out.print(", ");
                    }
                }
            }
        %>
    ];

    const volumesData = [
        <%
            if (volumes != null) {
                Iterator<Long> vals = volumes.values().iterator();
                while (vals.hasNext()) {
                    Long vol = vals.next();
                    out.print(vol);
                    if (vals.hasNext()) {
                        out.print(", ");
                    }
                }
            }
        %>
    ];

    // Render Top Symbols Volume (Bar Chart)
    const volumeChartCtx = document.getElementById('volumeChart').getContext('2d');
    const volumeChart = new Chart(volumeChartCtx, {
        type: 'bar',
        data: {
            labels: symbols,
            datasets: [{
                label: 'Volume',
                data: volumesData,
                backgroundColor: 'rgba(54, 162, 235, 0.6)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false, // CRITICAL for responsive charts in flexbox
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            if(value >= 1e9) return (value / 1e9).toFixed(1) + 'B';
                            if(value >= 1e6) return (value / 1e6).toFixed(1) + 'M';
                            return value;
                        }
                    }
                },
                x: {
                    autoSkip: false,
                    maxRotation: 45,
                    minRotation: 45
                }
            },
            plugins: {
                legend: { display: true }
            }
        }
    });
</script>

</body>
</html>