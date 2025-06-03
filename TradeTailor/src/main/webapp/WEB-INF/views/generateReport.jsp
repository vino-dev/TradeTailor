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
        top: 60px; /* Below navbar */
        height: calc(100% - 60px); /* Fill remaining height */
        background-color: #333;
        color: white;
        padding: 20px;
        width: 220px;
        transition: transform 0.3s ease;
        z-index: 1000;
        box-sizing: border-box;
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

    /* Heading centering */
    h2 {
        color: #333;
        text-align: center; /* Ensure this is centered */
    }
    h3 {
        text-align: center; /* Keep h3 centered for "Stock Data Table" */
    }

    .content {
        padding: 70px 20px 20px 20px;
    }

    /* Search box and button alignment */
    .search-chart-container {
        margin-top: 0;
        margin-bottom: 2rem;
        display: flex;
        justify-content: center; /* Center the form horizontally */
        flex-direction: column; /* Keep overall container column */
        align-items: center; /* Align items within the column */
    }

    .search-chart-container form {
        display: flex; /* Make form a flex container */
        flex-direction: row; /* Arrange items in a row (input and button side-by-side) */
        align-items: center; /* Vertically align input and button */
        /* Removed gap here as we want them touching */
    }

    .search-box {
        padding: 0.5rem;
        width: 300px;
        border: 1px solid #ccc;
        border-radius: 5px 0 0 5px; /* Rounded on left, flat on right to connect with button */
    }

    .search-button{
        padding: 0.5rem 1rem;
        background-color: #2563eb;
        color: white;
        border: none;
        border-radius: 0 5px 5px 0; /* Flat on left, rounded on right */
        cursor: pointer;
        margin-left: -1px; /* Pull button left slightly to overlap border */
    }
    .search-button:hover {
        background-color: #0056b3;
    }
    /* End of search box and button adjustments */

    .export-buttons, .range-buttons {
        display: flex;
        justify-content: center;
        gap: 10px;
        margin: 15px 0;
    }

    button, label {
        padding: 6px 12px;
        border: 1px solid #007BFF;
        background: #007BFF;
        color: white;
        border-radius: 4px;
        cursor: pointer;
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
        background-color: white;
    }

    th, td {
        padding: 10px;
        border: 1px solid #ddd;
        text-align: center;
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
                <h2>Stock Report for ${symbol}</h2> <%-- This heading is now inside the conditional block --%>

                <div class="export-buttons">
                    <button onclick="exportCSVClient()">Export CSV</button>
                    <button onclick="exportExcelClient()">Export Excel</button>
                    <button onclick="exportPDFClient()">Export PDF</button>

                    <button onclick="exportCSVServer()">Export CSV (Server)</button>
                    <button onclick="exportExcelServer()">Export Excel (Server)</button>
                    <button onclick="exportPDFServer()">Export PDF (Server)</button>

                    <label><input type="checkbox" id="forecastToggle" onchange="toggleForecast()"> Show Forecast</label>
                </div>

                <div class="range-buttons">
                    <button onclick="filterRange('1D')">1D</button>
                    <button onclick="filterRange('1W')">1W</button>
                    <button onclick="filterRange('1M')">1M</button>
                    <button onclick="filterRange('6M')">6M</button>
                    <button onclick="filterRange('1Y')">1Y</button>
                    <button onclick="filterRange('5Y')">5Y</button>
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
                        y: { position: 'left', title: { display: true, text: 'Price' }},
                        y1: { position: 'right', grid: { drawOnChartArea: false }, title: { display: true, text: 'Volume' }}
                    }
                }
            });
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
            // Note: This URL might need to be adjusted if your server-side PDF export is at a different path
            window.location.href = "/export/pdf?symbol=${symbol}";
        }

        // New functions for server-side exports
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