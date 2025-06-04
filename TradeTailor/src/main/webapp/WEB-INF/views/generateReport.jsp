<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Trade Tailor Generate Report</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/FileSaver.js/2.0.5/FileSaver.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/xlsx/0.17.3/xlsx.full.min.js"></script>
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
        --table-header-bg: #2d3748; /* Darker header for dark mode table */
        --table-row-hover-bg: #3a4a5a; /* Hover for table rows */
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
        --table-header-bg: #edf2f7; /* Lighter header for light mode table */
        --table-row-hover-bg: #f0f4f7; /* Hover for table rows */
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
        padding: 70px 20px 20px 20px;
        background-color: var(--background-color);
        transition: background-color 0.3s ease;
    }

    .search-chart-container {
        margin-top: 0;
        margin-bottom: 2rem;
        display: flex;
        justify-content: center;
        flex-direction: column;
        align-items: center;
    }

    .search-chart-container form {
        display: flex;
        flex-direction: row;
        align-items: center;
    }

    .search-box {
        padding: 0.5rem;
        width: 300px;
        border: 1px solid var(--input-border-color);
        border-radius: 5px 0 0 5px;
        background-color: var(--input-bg-color);
        color: var(--input-text-color);
        transition: border-color 0.3s ease, background-color 0.3s ease, color 0.3s ease;
    }

    .search-button{
        padding: 0.5rem 1rem;
        background-color: var(--button-bg-color);
        color: white;
        border: none;
        border-radius: 0 5px 5px 0;
        cursor: pointer;
        margin-left: -1px;
        transition: background-color 0.3s ease;
    }
    .search-button:hover {
        background-color: var(--button-hover-bg-color);
    }

    /* Combined container for both left and right export sections */
    .export-sections-container {
        display: flex;
        justify-content: space-between; /* Pushes content to opposite ends */
        align-items: flex-start; /* Align items to the top if they have different heights */
        margin-bottom: 15px; /* Space below the export buttons sections */
        flex-wrap: wrap; /* Allows wrapping on smaller screens */
    }

    .export-data-section, .export-report-company-section {
        display: flex;
        flex-direction: column;
        gap: 10px; /* Space between heading and buttons */
    }

    .export-buttons-container, .export-buttons-container-right {
        display: flex;
        gap: 10px; /* Space between buttons */
    }

    .export-data-section {
        align-items: flex-start; /* Align content to the left */
        margin-left: 20px; /* Adjust as needed for spacing from the left edge */
    }

    /* Updated CSS for centering the right section's heading */
    .export-report-company-section {
        align-items: center; /* Change from flex-end to center to center the group */
        margin-right: 20px; /* Adjust as needed for spacing from the right edge */
    }

    button, label {
        padding: 6px 12px;
        border: 1px solid var(--button-bg-color);
        background: var(--button-bg-color);
        color: white;
        border-radius: 4px;
        cursor: pointer;
        transition: background-color 0.3s ease, border-color 0.3s ease;
    }

    button:hover {
        background: var(--button-hover-bg-color);
        border-color: var(--button-hover-bg-color);
    }

    label input { margin-right: 5px;}

    #chart-container{
        width: 95%;
        max-width: 1000px;
        margin: auto;
    }

    table {
        width: 100%;
        margin-top: 20px;
        border-collapse: collapse;
        background-color: var(--section-bg);
        color: var(--text-color);
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 5px var(--card-shadow);
        transition: background-color 0.3s ease, color 0.3s ease, box-shadow 0.3s ease;
    }

    th, td {
        padding: 10px;
        border: 1px solid var(--border-color);
        text-align: center;
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

    /* Chart.js specific styles */
    .chartjs-render-monitor {
        background-color: var(--section-bg);
        border-radius: 8px;
        padding: 10px;
        box-shadow: 0 2px 5px var(--card-shadow);
    }
    .section-heading-left, .section-heading-right {
      color: var(--heading-color);
       text-align:left; /* Default alignment */
        transition: color 0.3s ease;
    }
    .section-heading-right {
     text-align:center; /* Overrides default for right-aligned heading */
     width: 100%; /* Make the heading take full width of its container to center text within it */
    }

    .range-buttons {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin: 15px 0;
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
        <p><strong>Name:</strong>${name}</p>
        <p><strong>Email:</strong>${email}</p>
        <p><strong>Phone:</strong>${mobile}</p>
        <form action="logout" method="post">
            <button type="submit" class="signout-btn">Sign Out</button>
        </form>
    </div>

    <div class="content">
        <div class="search-chart-container">
            <form action="generateReport" method="post">
                <input type="text" class="search-box" name="symbol" placeholder="Search by company" required>
                <button type="submit" class="search-button">Enter</button>
            </form>
        </div>

        <%-- This scriptlet block conditionally renders the report section --%> 
        <%
            Map<String, Double> stockDataCheck = (Map<String, Double>) request.getAttribute("stockData");
            if (stockDataCheck != null && !stockDataCheck.isEmpty()) {
        %>
                <h2>Stock Report for ${symbol}</h2>

                <div class="export-sections-container">
                    <div class="export-data-section">
                        <h3 class="section-heading-left">Export Data(Date,price) for 5 years</h3>
                        <div class="export-buttons-container">
                            <button class="export-button" onclick="exportCSVClient()">Export CSV</button>
                            <button class="export-button" onclick="exportExcelClient()">Export Excel</button>
                            <button class="export-button" onclick="exportPDFClient()">Export PDF</button>
                        </div>
                    </div>

                    <div class="export-report-company-section">
                        <h3 class="section-heading-right">Export Report for Company</h3>
                        <div class="export-buttons-container-right">
                            <button onclick="exportCSVServer()">Export CSV</button>
                            <button onclick="exportExcelServer()">Export Excel</button>
                            <button onclick="exportPDFServer()">Export PDF</button>
                        </div>
                    </div>
                </div>

                <div class="range-buttons">
                    <button onclick="filterRange('1D')">1D</button>
                    <button onclick="filterRange('1W')">1W</button>
                    <button onclick="filterRange('1M')">1M</button>
                      <label><input type="checkbox" id="forecastToggle" onchange="toggleForecast()"> Show Forecast</label>
                </div>

                <div id="chart-container">
                    <canvas id="stockChart"></canvas>
                </div>

                <h3>Stock Data Table</h3>
                <table>
                    <thead>
                        <tr><th>Date</th><th>Close Price</th><th>Volume</th><th>Forecast</th></tr>
                    </thead>
                    <tbody>
                        <%
                            // These variables are guaranteed to be non-null and non-empty here
                            Map<String, Double> stockData = (Map<String, Double>) request.getAttribute("stockData");
                            Map<String, Integer> volumeData = (Map<String, Integer>) request.getAttribute("volumeData");
                            Map<String, Double> forecastData = (Map<String, Double>) request.getAttribute("forecastData");

                            for (String date : stockData.keySet()) {
                        %>
                                <tr>
                                    <td><%= date %></td>
                                    <td><%= String.format("%.2f", stockData.get(date)) %></td>
                                    <td><%= volumeData.get(date) != null ? volumeData.get(date) : "N/A" %></td>
                                    <td><%= forecastData.get(date) != null ? String.format("%.2f", forecastData.get(date)) : "N/A" %></td>
                                </tr>
                        <%
                            }
                        %>
                    </tbody>
                </table>
        <%
            } else {
        %>
            <%-- The space below the search box is now handled by .search-chart-container's margin-bottom --%>
        <%
            }
        %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        // Initialize with empty arrays to prevent JavaScript errors if no data is present initially
        const labels = ${labels != null ? labels : "[]"};
        const prices = ${prices != null ? prices : "[]"};
        const volumes = ${volumes != null ? volumes : "[]"};
        const forecasts = ${forecasts != null ? forecasts : "[]"};

        let allLabels = [...labels];
        let allPrices = [...prices];
        let allVolumes = [...volumes];
        let allForecasts = [...forecasts];

        const ctx = document.getElementById('stockChart') ? document.getElementById('stockChart').getContext('2d') : null;
        let stockChart;

        // Function to update chart colors based on theme
        function updateChartColors() {
            if (stockChart) {
                const chartLabelColor = getComputedStyle(document.documentElement).getPropertyValue('--chart-label-color').trim();
                stockChart.options.scales.y.ticks.color = chartLabelColor;
                stockChart.options.scales.y.title.color = chartLabelColor;
                stockChart.options.scales.y1.ticks.color = chartLabelColor;
                stockChart.options.scales.y1.title.color = chartLabelColor;
                stockChart.options.scales.x.ticks.color = chartLabelColor; // Update x-axis labels as well
                stockChart.update();
            }
        }

        // Only initialize Chart.js if the canvas element exists (i.e., data is present)
        if (ctx) {
            stockChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: 'Close Price',
                            data: prices,
                            borderColor: 'blue',
                            backgroundColor: 'transparent',
                            tension: 0.1,
                            yAxisID: 'y',
                        },
                        {
                            label: 'Forecast Price',
                            data: forecasts,
                            borderColor: 'orange',
                            backgroundColor: 'transparent',
                            tension: 0.1,
                            yAxisID: 'y',
                            hidden: true // Hidden by default
                        },
                        {
                            label: 'Volume',
                            data: volumes,
                            type: 'bar',
                            backgroundColor: 'rgba(150,150,150,0.5)',
                            borderColor: 'gray',
                            yAxisID: 'y1'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    interaction: { mode: 'index', intersect: false },
                    stacked: false,
                    scales: {
                        y: {
                            position: 'left',
                            title: { display: true, text: 'Price' },
                            ticks: { color: 'var(--chart-label-color)' }, // Use CSS variable
                            title: { display: true, text: 'Price', color: 'var(--chart-label-color)' }, // Use CSS variable
                            grid: {
                                color: 'rgba(128, 128, 128, 0.3)' // Keep grid lines slightly visible
                            }
                        },
                        y1: {
                            position: 'right',
                            grid: { drawOnChartArea: false },
                            title: { display: true, text: 'Volume' },
                            ticks: { color: 'var(--chart-label-color)' }, // Use CSS variable
                            title: { display: true, text: 'Volume', color: 'var(--chart-label-color)' }, // Use CSS variable
                        },
                        x: {
                            ticks: { color: 'var(--chart-label-color)' }, // Use CSS variable for x-axis
                            grid: {
                                color: 'rgba(128, 128, 128, 0.3)' // Keep grid lines slightly visible
                            }
                        }
                    },
                    plugins: {
                        legend: {
                            labels: {
                                color: 'var(--chart-label-color)' // Use CSS variable for legend labels
                            }
                        }
                    }
                }
            });
            updateChartColors(); // Initial chart color update
        }

        function toggleForecast() {
            if (stockChart) {
                stockChart.data.datasets[1].hidden = !document.getElementById('forecastToggle').checked;
                stockChart.update();
            }
        }

        function exportCSVClient() {
            let csv = "Date,Close Price,Volume,Forecast\n";
            for (let i = 0; i < allLabels.length; i++) {
                const date = (allLabels[i] || "").replace(/"/g, '');
                const price = allPrices[i] != null ? allPrices[i] : "";
                const volume = allVolumes[i] != null ? allVolumes[i] : "";
                const forecast = allForecasts[i] != null ? allForecasts[i] : "";
                csv += `${date},${price},${volume},${forecast}\n`;
            }
            const blob = new Blob([csv], {type: 'text/csv;charset=utf-8;'});
            saveAs(blob, 'stock_report.csv');
        }

        function exportExcelClient() {
            const wb = XLSX.utils.book_new();
            const wsData = [["Date", "Close Price", "Volume", "Forecast"]];
            for (let i = 0; i < allLabels.length; i++) {
                const date = (allLabels[i] || "").replace(/"/g, '');
                const price = allPrices[i] != null ? allPrices[i] : "";
                const volume = allVolumes[i] != null ? allVolumes[i] : "";
                const forecast = allForecasts[i] != null ? allForecasts[i] : "";
                wsData.push([date, price, volume, forecast]);
            }
            const ws = XLSX.utils.aoa_to_sheet(wsData);
            XLSX.utils.book_append_sheet(wb, ws, "Stock Report");
            XLSX.writeFile(wb, "stock_report.xlsx");
        }

        function exportPDFClient() {
            // Note: This URL might need to be adjusted if your server-side PDF export logic changes
            // For client-side PDF, you'd need a library like jsPDF.
             window.location.href = "/export/pdf?symbol=${symbol}";
         //   alert('Client-side PDF export requires a dedicated library (e.g., jsPDF) and is not implemented in this example.');
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
        });

        // Event listener for theme toggle button
        themeToggleBtn.addEventListener('click', () => {
            if (body.classList.contains('light-mode')) {
                setTheme('dark');
            } else {
                setTheme('light');
            }
        });

        function exportCSVServer() {
            window.location.href = "/export/csv1?symbol=${symbol}";
        }

        function exportExcelServer() {
            window.location.href = "/export/excel1?symbol=${symbol}";
        }
        function exportPDFServer() {
            window.location.href = "/export/pdf1?symbol=${symbol}";
        }

        function filterRange(range) {
            let days;
            switch (range) {
                case "1D": days = 1; break;
                case "1W": days = 7; break;
                case "1M": days = 30; break;
                case "6M": days = 180; break;
                case "1Y": days = 365; break;
                case "5Y": days = 1825; break;
                default: days = allLabels.length;
            }

            const filteredLabels = allLabels.slice(-days);
            const filteredPrices = allPrices.slice(-days);
            const filteredVolumes = allVolumes.slice(-days);
            const filteredForecasts = allForecasts.slice(-days);

            if (stockChart) {
                stockChart.data.labels = filteredLabels;
                stockChart.data.datasets[0].data = filteredPrices;
                stockChart.data.datasets[1].data = filteredForecasts;
                stockChart.data.datasets[2].data = filteredVolumes;
                stockChart.update();
            }

            updateTable(filteredLabels, filteredPrices, filteredVolumes, filteredForecasts);
        }

        function updateTable(dates, prices, volumes, forecasts) {
            const tbody = document.querySelector("table tbody");
            if (!tbody) return;

            tbody.innerHTML = "";
            for (let i = 0; i < dates.length; i++) {
                const date = (dates[i] || "").replace(/"/g, '');
                const price = prices[i] != null ? prices[i].toFixed(2) : "N/A";
                const volume = volumes[i] != null ? volumes[i] : "N/A";
                const forecast = forecasts[i] != null ? forecasts[i].toFixed(2) : "N/A";

                tbody.innerHTML += `<tr>
                    <td>${date}</td>
                    <td>${price}</td>
                    <td>${volume}</td>
                    <td>${forecast}</td>
                </tr>`;
            }
        }
    </script>
</body>
</html>