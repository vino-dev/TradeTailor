<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.TradeTailor.TradeTailor.model.Watchlist" %>

<!DOCTYPE html>
<html>
<head>
    <title>Trade Tailor Watchlist</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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
            --section-bg: #2d3748; /* Used for table background in this context */
            --section-heading-color: #90cdf4;
            --sub-heading-color: #a0aec0;
            --card-shadow: rgba(0, 0, 0, 0.3);
            --border-color: #63b3ed; /* Used for table borders */
            --table-header-bg: #2d3748; /* Darker header for dark mode table */
            --table-row-hover-bg: #3a4a5a; /* Hover for table rows */
            --positive-change-color: green; /* Specific for stock change */
            --negative-change-color: red;   /* Specific for stock change */
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
            --section-bg: #ffffff; /* Used for table background in this context */
            --section-heading-color: #3182ce;
            --sub-heading-color: #63b3ed;
            --card-shadow: rgba(0, 0, 0, 0.1);
            --border-color: #a0aec0; /* Used for table borders */
            --table-header-bg: #edf2f7; /* Lighter header for light mode table */
            --table-row-hover-bg: #f0f4f7; /* Hover for table rows */
            --positive-change-color: green; /* Specific for stock change */
            --negative-change-color: red;   /* Specific for stock change */
        }

        body {
            font-family: 'Segoe UI', sans-serif; /* Consistent font with Home JSP */
            margin: 0;
            padding: 0;
            background-color: var(--background-color);
            text-align: center;
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

        /* Watchlist Specific Styles */
        .container {
            width: 95%;
            margin: 0 auto;
            padding-top: 80px; /* Adjust for fixed navbar */
            text-align: center; /* Center content within the container */
        }

        .watchlist-section {
            background-color: var(--section-bg); /* Use section background variable */
            padding: 30px;
            margin: 40px auto; /* Center the section */
            max-width: 1200px;
            border-radius: 12px;
            box-shadow: 0 8px 20px var(--card-shadow);
            text-align: center;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .watchlist-section h2 {
            font-size: 2.2rem;
            color: var(--heading-color);
            margin-bottom: 25px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            transition: color 0.3s ease;
        }

        .watchlist-section p {
            font-size: 1.1rem;
            color: var(--paragraph-color);
            margin-bottom: 30px;
            transition: color 0.3s ease;
        }

        table {
            border-collapse: collapse;
            margin: 20px auto;
            width: 100%;
            max-width: 100%;
            table-layout: auto;
            background-color: var(--section-bg);
            color: var(--text-color);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px var(--card-shadow);
            transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        th, td {
            border: 1px solid var(--border-color);
            padding: 12px 15px;
            text-align: center;
            white-space: nowrap;
            transition: border-color 0.3s ease, color 0.3s ease;
        }

        th {
            background-color: var(--table-header-bg);
            position: sticky;
            top: 0;
            z-index: 1;
            font-weight: bold;
            color: var(--heading-color);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        tbody tr:nth-child(even) {
            background-color: rgba(0, 0, 0, 0.05); /* Slightly different background for even rows */
            transition: background-color 0.3s ease;
        }

        body.light-mode tbody tr:nth-child(even) {
             background-color: rgba(0, 0, 0, 0.02);
        }

        tbody tr:hover {
            background-color: var(--table-row-hover-bg);
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        img.logo {
            width: 30px;
            height: auto;
            vertical-align: middle;
            border-radius: 50%;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
        }

        td a {
            color: var(--heading-color);
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        td a:hover {
            text-decoration: underline;
        }

        /* Specific colors for stock change */
        .positive-change {
            color: var(--positive-change-color) !important;
            font-weight: bold;
        }

        .negative-change {
            color: var(--negative-change-color) !important;
            font-weight: bold;
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

<%
    // This assumes that the 'quotes' attribute is being set in a Java Servlet
    // or another JSP that forwards to this page.
    List<Watchlist> quotes = (List<Watchlist>) request.getAttribute("quotes");
%>
<div class="container">
    <div class="watchlist-section">
        <table>
            <thead>
            <tr>
                <th>Logo</th>
                <th>Symbol</th>
                <th>Company Name</th>
                <th>Open</th>
                <th>High</th>
                <th>Low</th>
                <th>Close</th>
                <th>Change</th>
            </tr>
            </thead>
            <tbody>
            <%
                if (quotes != null && !quotes.isEmpty()) {
                    for (Watchlist quote : quotes) {
            %>
            <tr>
                <td><img src="<%= quote.getLogoUrl() %>" alt="Logo" class="logo"/></td>
                <td>
  <form id="form_<%= quote.getSymbol() %>" action="generateReport" method="post" style="display:none;">
    <input type="hidden" name="symbol" value="<%= quote.getSymbol() %>" />
  </form>

  <a href="#" onclick="document.getElementById('form_<%= quote.getSymbol() %>').submit(); return false;">
    <%= quote.getSymbol() %>
  </a>
</td>
                
                <td><%= quote.getCompanyName() %></td>
                <td><%= String.format("%.2f", quote.getOpen()) %></td>
                <td><%= String.format("%.2f", quote.getHigh()) %></td>
                <td><%= String.format("%.2f", quote.getLow()) %></td>
                <td><%= String.format("%.2f", quote.getClose()) %></td>
                <td class="<%= quote.getChange() >= 0 ? "positive-change" : "negative-change" %>">
                    <%= String.format("%.2f", quote.getChange()) %>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="8" style="padding: 20px;">No stocks in your watchlist. Please add some items to monitor.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
    // Sidebar toggle functions
    function toggleSidebar(side) {
        const leftSidebar = document.getElementById('leftSidebar');
        const accountSidebar = document.getElementById('accountSidebar');

        if (side === 'left') {
            leftSidebar.classList.toggle('active');
            // Close the other sidebar if it's open
            if (accountSidebar.classList.contains('active')) {
                accountSidebar.classList.remove('active');
            }
        } else if (side === 'account') {
            accountSidebar.classList.toggle('active');
            // Close the other sidebar if it's open
            if (leftSidebar.classList.contains('active')) {
                leftSidebar.classList.remove('active');
            }
        }
    }

    // Theme Toggle Logic - Copied from your Home JSP
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
</script>

</body>
</html>