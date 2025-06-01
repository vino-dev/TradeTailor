<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.TradeTailor.TradeTailor.model.CalendarEvent" %>
<%@ page import="com.TradeTailor.TradeTailor.model.StockNews" %>
<%@ page import="java.util.*" %>

<%
    Map<String, Object> usStatus = (Map<String, Object>) request.getAttribute("usStatus");
    List<StockNews> newsList = (List<StockNews>) request.getAttribute("newsList");
    List<CalendarEvent> calendarEvents = (List<CalendarEvent>) request.getAttribute("calendarEvents");
    Map<String, Double> topQuotes = (Map<String, Double>) request.getAttribute("topQuotes");
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
            height: 100%;
            padding: 1rem;
            transition: transform 0.3s ease-in-out;
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
        }

        .section {
            background-color: white;
            padding: 1rem;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
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
    </style>
</head>
<body>

<div class="navbar">
    <div class="left">
        <div class="hamburger" onclick="toggleSidebar('left')"><i class="fas fa-bars"></i></div>
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

<div class="container">
    <div class="search-chart-container">
        <form action="reportgenerate" method="post">
            <input type="text" class="search-box" name="query" placeholder="Search by company">
            <button type="submit" class="search-button">Enter</button>
        </form>
    </div>

    <div class="content-flexbox">
        <div class="left-column">
            <!-- US Market Status -->
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
                    <p><span class="label">Time:</span> <%= usStatus.get("marketTime") %></p>
                <% } else { %>
                    <p>Status not available.</p>
                <% } %>
            </div>

            <!-- News Section -->
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

            <!-- Event Calendar -->
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

        <!-- Chart Section -->
        <div class="right-column">
            <div class="section">
                <h3>Stock Price Chart</h3>
                <canvas id="stockChart" width="600" height="300"></canvas>
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

    // Render Chart
    const ctx = document.getElementById('stockChart').getContext('2d');
    const stockChart = new Chart(ctx, {
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
                borderWidth: 2
            }]
        },
        options: {
            responsive: true,
            scales: {
                y: {
                    beginAtZero: false
                }
            }
        }
    });
</script>

</body>
</html>
