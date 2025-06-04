<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.fasterxml.jackson.databind.ObjectMapper" %>
<%
    Map<String, Double> stockData = new java.util.HashMap<>();
    stockData.put("GOOGL", 180.50);
    stockData.put("MSFT", 430.75);
    stockData.put("AAPL", 210.25);
    stockData.put("TSLA", 190.00);
    stockData.put("AMZN", 185.90);
    stockData.put("META", 500.10);
    stockData.put("NFLX", 650.40);
    stockData.put("NVDA", 1100.80);
    stockData.put("BABA", 75.30);
    stockData.put("INTC", 30.90);
    stockData.put("AMD", 165.70);
    stockData.put("PYPL", 62.15);
    stockData.put("UBER", 70.80);
    stockData.put("BA", 170.00);
    stockData.put("DIS", 108.50);
    stockData.put("SBUX", 90.60);


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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
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
            --section-bg: #2d3748;
            --section-heading-color: #90cdf4;
            --sub-heading-color: #a0aec0;
            --card-bg: #1a202c;
            --card-shadow: rgba(0, 0, 0, 0.3);
            --border-color: #63b3ed;
            --orbit-stock-bg: #4299e1;
            --orbit-stock-hover-bg: #3182ce;
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
            --section-bg: #ffffff;
            --section-heading-color: #3182ce;
            --sub-heading-color: #63b3ed;
            --card-bg: #edf2f7;
            --card-shadow: rgba(0, 0, 0, 0.1);
            --border-color: #a0aec0;
            --orbit-stock-bg: #63b3ed;
            --orbit-stock-hover-bg: #4299e1;
        }

        body {
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background-color);
            text-align: center;
            color: var(--text-color);
            transition: background-color 0.3s ease, color 0.3s ease; /* Smooth transition */
        }

        h1, h2 {
            margin-top: 30px;
            font-size: 2.2rem; /* Slightly larger heading */
            color: var(--heading-color);
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3); /* Subtle text shadow */
            transition: color 0.3s ease;
        }

        p {
            color: var(--paragraph-color);
            transition: color 0.3s ease;
        }

        .orbit-container {
            position: relative;
            width: 360px;
            height: 360px;
            margin: 40px auto; /* Increased margin */
            border-radius: 50%;
            border: 3px dashed var(--border-color); /* Brighter dashed border */
            animation: spin 40s linear infinite; /* Animation for constant spinning */
            box-shadow: 0 0 15px rgba(99, 179, 237, 0.5); /* Subtle glow effect */
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        .orbit-stock {
            position: absolute;
            width: 65px; /* Slightly larger stock circles */
            height: 65px;
            line-height: 30px; /* Adjust line height for multiline text */
            padding-top: 10px; /* Add some padding for better text alignment */
            border-radius: 50%;
            background-color: var(--orbit-stock-bg);
            color: white; /* Keep text white for contrast on stock circles */
            font-weight: bold;
            font-size: 0.9em; /* Adjusted font size */
            text-align: center;
            cursor: pointer;
            transition: transform 0.3s ease, background-color 0.3s ease; /* Added background-color to transition */
            white-space: pre-line;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3); /* Subtle shadow for depth */
        }

        .orbit-stock:hover {
            transform: scale(1.2); /* Slightly increased hover scale */
            background-color: var(--orbit-stock-hover-bg);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.4); /* Enhanced shadow on hover */
        }

        @keyframes spin {
            100% {
                transform: rotate(360deg);
            }
        }

        @media (max-width: 500px) {
            .orbit-container {
                width: 280px;
                height: 280px;
            }

            .orbit-stock {
                width: 55px; /* Adjusted for smaller screens */
                height: 55px;
                line-height: 28px; /* Adjusted line height */
                font-size: 11px; /* Adjusted font size */
            }
        }

        .navbar {
            background-color: var(--navbar-bg);
            color: var(--navbar-link-color);
            padding: 14px 25px; /* Increased padding */
            display: flex;
            align-items: center;
            justify-content: space-between;
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 999;
            height: 65px; /* Slightly taller navbar */
            box-sizing: border-box;
            box-shadow: 0 2px 8px var(--card-shadow); /* Stronger shadow for navbar */
            transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
        }

        .navbar .left {
            display: flex;
            align-items: center;
            gap: 25px; /* Increased gap */
        }

        .navbar .hamburger {
            font-size: 26px; /* Larger hamburger icon */
            cursor: pointer;
            color: var(--navbar-icon-color);
            transition: color 0.3s ease;
        }

        .navbar .title {
            font-size: 22px; /* Larger title */
            font-weight: bold;
            color: var(--navbar-icon-color);
            transition: color 0.3s ease;
        }

        .navbar .right {
            display: flex;
            gap: 20px; /* Increased gap */
            font-size: 17px;
            align-items: center;
        }

        .navbar a, .nav-link-button {
            color: var(--navbar-link-color);
            text-decoration: none;
            cursor: pointer;
            padding: 8px 15px; /* Increased padding */
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
            color: var(--text-color); /* Maintain readability on hover */
            box-shadow: 0 2px 5px var(--card-shadow);
        }
        
        /* Theme toggle button specific styles */
        .theme-toggle-btn {
            background-color: var(--navbar-link-hover-bg); /* Use hover color for contrast */
            color: var(--text-color); /* Use text color for contrast */
            padding: 8px 15px;
            border-radius: 5px;
            border: 1px solid var(--border-color); /* Subtle border */
            cursor: pointer;
            font-size: 16px;
            transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease;
        }

        .theme-toggle-btn:hover {
            background-color: var(--heading-color); /* Brighter on hover */
            color: white;
            box-shadow: 0 2px 5px var(--card-shadow);
        }


        .sidebar-left, .sidebar-account {
            position: fixed;
            top: 65px; /* Adjust top to match navbar height */
            height: calc(100% - 65px); /* Full height minus navbar */
            background-color: var(--sidebar-bg);
            color: var(--sidebar-link-color);
            padding: 20px 0; /* Padding for top/bottom */
            width: 240px; /* Slightly wider sidebar */
            transition: transform 0.3s ease, box-shadow 0.3s ease, background-color 0.3s ease, color 0.3s ease;
            z-index: 1000;
            box-sizing: border-box;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.4);
            overflow-y: auto; /* Enable scrolling for longer content */
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
            padding-left: 20px; /* Adjust internal padding for account info */
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
            padding: 14px 20px; /* Increased padding for sidebar links */
            color: var(--sidebar-link-color);
            text-decoration: none;
            border-radius: 0; /* Remove border-radius for full width hover */
            margin-bottom: 5px; /* Reduced margin for closer links */
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .sidebar-left a:hover {
            background-color: var(--sidebar-link-hover-bg);
            color: white;
        }

        .content {
            padding: 100px 20px 20px 20px; /* Adjust top padding for navbar */
            color: var(--text-color);
            transition: color 0.3s ease;
        }

        .signout-btn {
            margin-top: 30px; /* Increased margin */
            padding: 12px 25px; /* Larger button */
            background-color: var(--signout-btn-bg);
            color: white;
            border: none;
            cursor: pointer;
            border-radius: 8px; /* More rounded corners */
            font-size: 16px;
            transition: background-color 0.3s ease, transform 0.2s ease, box-shadow 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
        }

        .signout-btn:hover {
            background-color: var(--signout-btn-hover-bg);
            transform: translateY(-2px);
        }

        h3 {
            color: var(--section-heading-color); /* Light blue for sidebar headings and section headings */
            margin-bottom: 15px;
            transition: color 0.3s ease;
        }

        .sidebar-account p {
            margin-bottom: 8px; /* Spacing for account info */
            color: var(--paragraph-color);
            transition: color 0.3s ease;
        }

        /* Dancing Bot Styles */
        #dancing-bot {
            position: fixed;
            bottom: 25px; /* Slightly higher */
            left: 25px; /* Slightly further from the edge */
            width: 70px; /* Slightly larger bot */
            height: 70px;
            font-size: 55px; /* Larger icon */
            cursor: pointer;
            user-select: none;
            animation: dance 1s ease-in-out infinite alternate;
            z-index: 1100;
            text-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5); /* Stronger shadow for bot */
        }

        @keyframes dance {
            0% {
                transform: translateY(0) rotate(0deg);
            }
            50% {
                transform: translateY(-12px) rotate(18deg); /* More pronounced dance */
            }
            100% {
                transform: translateY(0) rotate(-18deg);
            }
        }

        /* New styles for Video Sessions Section */
        .video-sessions-section {
            background-color: var(--section-bg); /* Darker background, similar to chart/sidebar */
            padding: 30px;
            margin: 40px auto; /* Margin top/bottom, auto left/right for centering */
            max-width: 1000px; /* Max width to contain content */
            border-radius: 12px;
            box-shadow: 0 8px 20px var(--card-shadow); /* Stronger shadow */
            text-align: left; /* Align text within this section */
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .video-sessions-section h3 {
            text-align: center;
            color: var(--section-heading-color);
            font-size: 2rem;
            margin-bottom: 25px;
            text-shadow: 1px 1px 2px rgba(0, 0, 0, 0.3);
            transition: color 0.3s ease;
        }

        .video-sessions-section h4 {
            color: var(--sub-heading-color); /* A lighter grey for secondary headings */
            text-align: center;
            margin-bottom: 20px;
            transition: color 0.3s ease;
        }

        .session-banner-image-container {
            margin: 20px auto 30px auto; /* Centered, spacing above and below */
            max-width: 800px; /* Limit width to look good */
            border-radius: 10px;
            overflow: hidden; /* Ensures image corners respect border-radius */
            box-shadow: 0 6px 15px var(--card-shadow);
            display: block; /* Ensures container behaves like a block element */
            transition: box-shadow 0.3s ease;
        }

        .session-banner-image {
            width: 100%; /* Make image responsive within its container */
            height: auto;
            display: block; /* Remove extra space below image */
        }

        @media (max-width: 768px) {
            .session-banner-image-container {
                margin-left: 10px;
                margin-right: 10px;
            }
        }

        .video-content-wrapper {
            display: flex;
            flex-wrap: wrap; /* Allow wrapping on smaller screens */
            gap: 30px; /* Space between video and schedule */
            justify-content: center; /* Center content when wrapped */
        }

        .video-player-container {
            flex: 2; /* Takes more space */
            min-width: 300px; /* Minimum width for video player */
            max-width: 600px; /* Max width for video player */
            background-color: var(--card-bg); /* Background for video container */
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 4px 10px var(--card-shadow);
            display: flex; /* Use flex for internal layout */
            flex-direction: column;
            justify-content: space-between; /* Push description to bottom if needed */
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .video-responsive {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
            overflow: hidden;
        }

        .video-responsive iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            border-radius: 6px;
        }

        .video-description {
            margin-top: 15px;
            font-size: 0.95rem;
            color: var(--paragraph-color);
            line-height: 1.5;
            transition: color 0.3s ease;
        }

        .session-schedule {
            flex: 1; /* Takes remaining space */
            min-width: 300px; /* Minimum width for schedule */
            background-color: var(--card-bg);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 10px var(--card-shadow);
            display: flex; /* Use flex for internal layout */
            flex-direction: column;
            transition: background-color 0.3s ease, box-shadow 0.3s ease;
        }

        .schedule-grid {
            display: grid;
            grid-template-columns: 1fr; /* Single column by default */
            gap: 15px; /* Space between schedule items */
            flex-grow: 1; /* Allows it to take available space */
        }

        .schedule-grid div {
            background-color: var(--sidebar-bg); /* Item background, similar to sidebar */
            padding: 12px;
            border-radius: 6px;
            color: var(--text-color);
            font-size: 0.9rem;
            line-height: 1.4;
            box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.2); /* Inner shadow for depth */
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        .schedule-grid div strong {
            color: var(--heading-color); /* Highlight day of the week */
            transition: color 0.3s ease;
        }

        /* Responsive adjustments for schedule grid */
        @media (min-width: 768px) {
            .schedule-grid {
                grid-template-columns: 1fr 1fr; /* Two columns on larger screens */
            }
        }

        @media (min-width: 1024px) {
            .video-content-wrapper {
                flex-direction: row; /* Stack horizontally on larger screens */
                align-items: flex-start; /* Align items to the top */
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
        <a href="home">Home</a>
        <a href="watchlist">Watchlist</a>
        <button type="button" class="nav-link-button" onclick="toggleSidebar('account')">Account</button>
        <button type="button" class="theme-toggle-btn" id="themeToggle">Dark Theme</button> <%-- Added theme toggle button --%>
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

<div class="content">
    <h2>Welcome, Santhoshi!</h2>
    <p>This is your Trade Tailor dashboard.</p>
</div>

<div class="orbit-container" id="orbit"></div>

<div class="video-sessions-section">
    <h3>StockEdge Live Sessions</h3>
    <div class="session-banner-image-container">
        <img src="images/home_url_youtube.jpg" alt="Introducing StockEdge Smart Live Sessions" class="session-banner-image">
    </div>
    <div class="video-content-wrapper">
        <div class="video-player-container">
            <div class="video-responsive">
               <iframe width="560" height="315"
  src="https://www.youtube.com/embed/ecrJn3g7gZY"
  frameborder="0"
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
  allowfullscreen>
</iframe>
            </div>
            <p class="video-description">Learn about StockEdge offerings and how it can be leveraged to Identify Opportunities in Trading and Investing.</p>
        </div>
        <div class="session-schedule">
            <h4>Every Monday to Saturday, from 6:00 PM to 7:00 PM</h4>
            <div class="schedule-grid">
                <div><strong>Monday:</strong> Track smart money and understand markets with StockEdge</div>
                <div><strong>Tuesday:</strong> Learn how to invest wisely with StockEdge</div>
                <div><strong>Wednesday:</strong> Find the best stocks with StockEdge scans</div>
                <div><strong>Thursday:</strong> Select stocks using sector rotation</div>
                <div><strong>Friday:</strong> Dive into post-market analysis</div>
                <div><strong>Saturday:</strong> Pick accurate stocks with pre-defined strategies</div>
            </div>
        </div>
    </div>
</div>

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

    // Theme Toggle Logic
    const themeToggleBtn = document.getElementById('themeToggle');
    const body = document.body;

    // Function to set theme
    function setTheme(theme) {
        if (theme === 'light') {
            body.classList.add('light-mode');
            localStorage.setItem('theme', 'light');
        } else {
            body.classList.remove('light-mode');
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
            setTheme('dark');
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

    // Orbit stocks data
    const stockSymbols = <%= labels %>;
    const stockPrices = <%= prices %>;

    // Orbit positions and creation logic - Refined for even display
    const orbitContainer = document.getElementById('orbit');
    if (orbitContainer) {
        setTimeout(() => {
            const centerX = orbitContainer.offsetWidth / 2;
            const centerY = orbitContainer.offsetHeight / 2;
            const radius = 140; // This radius is relative to the center of the orbit-container

            const tempStockDiv = document.createElement('div');
            tempStockDiv.className = 'orbit-stock';
            document.body.appendChild(tempStockDiv);
            const stockDivWidth = tempStockDiv.offsetWidth;
            const stockDivHeight = tempStockDiv.offsetHeight;
            document.body.removeChild(tempStockDiv);

            for (let i = 0; i < stockSymbols.length; i++) {
                const angle = (2 * Math.PI / stockSymbols.length) * i;
                const x = centerX + radius * Math.cos(angle) - (stockDivWidth / 2);
                const y = centerY + radius * Math.sin(angle) - (stockDivHeight / 2);

                const stockDiv = document.createElement('div');
                stockDiv.className = 'orbit-stock';
                stockDiv.style.left = x + 'px';
                stockDiv.style.top = y + 'px';
                stockDiv.innerHTML = stockSymbols[i] + '<br>$' + stockPrices[i].toFixed(2);
                stockDiv.title = stockSymbols[i] + " Price: $" + stockPrices[i].toFixed(2);

                orbitContainer.appendChild(stockDiv);
            }
        }, 0);
    }
</script>
</body>
</html>