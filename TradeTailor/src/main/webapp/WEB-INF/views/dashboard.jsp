<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.TradeTailor.TradeTailor.model.Watchlist" %>
<html>
<head>
    <title>TradeTailor | Dashboard</title>
    <style>
        body, html {
            margin: 0; padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #eef2f5;
        }

        .navbar {
            background-color: #007BFF;
            color: white;
            padding: 14px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .navbar h1 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .navbar a {
            color: white;
            font-weight: 600;
            text-decoration: none;
            font-size: 16px;
            padding: 8px 14px;
            border-radius: 6px;
            transition: background-color 0.3s ease;
            border: 2px solid transparent;
        }

        .navbar a:hover {
            background-color: #0056b3;
            border-color: white;
        }

        .container {
            max-width: 960px;
            margin: 30px auto;
            padding: 0 20px;
        }

        .widget-container {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 12px;
            margin-bottom: 30px;
        }

        .widget {
            background-color: #ffffff;
            border-radius: 8px;
            padding: 12px 10px;
            width: 130px;
            text-align: center;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
            font-size: 13px;
        }

        .widget h3 {
            margin-bottom: 6px;
            font-size: 16px;
            color: #2c3e50;
            font-weight: 600;
        }

        .widget p {
            margin: 4px 0;
            font-size: 13px;
            font-weight: 500;
        }

        .positive { color: #28a745; font-weight: 700; }
        .negative { color: #dc3545; font-weight: 700; }

        .search-chart-container {
            display: flex;
            flex-direction: column;  /* stack vertically */
            align-items: center;
            max-width: 800px;
            margin: 0 auto 30px auto;
            gap: 20px;
        }

        form {
            width: 100%; /* full width */
            display: flex;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            border-radius: 30px;
            overflow: hidden;
            background-color: white;
        }

        .search-box {
            flex: 1;
            padding: 14px 20px;
            font-size: 17px;
            border: none;
            border-radius: 30px 0 0 30px;
        }

        .search-button {
            padding: 14px 26px;
            font-size: 17px;
            border: none;
            background-color: #007BFF;
            color: white;
            font-weight: 600;
            border-radius: 0 30px 30px 0;
            cursor: pointer;
        }

        .search-button:hover {
            background-color: #0056b3;
        }

        .chart-wrapper {
            width: 600px;    /* bigger width */
            height: 300px;   /* bigger height */
            background-color: white;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            border-radius: 12px;
            padding: 10px;
        }
    </style>
</head>
<body>

<div class="navbar">
    <h1>Trade Tailor</h1>
    <a href="watchlist">Watchlist</a>
</div>

<div class="container">
    <div class="widget-container">
        <%
            List<Map<String, String>> indices = (List<Map<String, String>>) request.getAttribute("indices");
            if (indices != null && !indices.isEmpty()) {
                for (Map<String, String> index : indices) {
                    String name = index.get("name");
                    String value = index.get("value");
                    String change = index.get("change");
                    boolean isPositive = !change.startsWith("-");
        %>
        <div class="widget">
            <h3><%= name %></h3>
            <p><strong><%= value %></strong></p>
            <p class="<%= isPositive ? "positive" : "negative" %>"><strong><%= change %></strong></p>
        </div>
        <%
                }
            } else {
        %>
        <p style="text-align:center; color: #888;">No market data available at the moment.</p>
        <%
            }
        %>
    </div>

    <div class="search-chart-container">
        <form action="reportgenerate" method="get">
            <input type="text" class="search-box" name="query" placeholder="Search by company">
            <button type="submit" class="search-button">Enter</button>
        </form>

        <div class="chart-wrapper">
            <canvas id="top20Chart"></canvas>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script>
    // Prepare data for chart from topQuotes attribute
    const topQuotes = <%= 
        new com.fasterxml.jackson.databind.ObjectMapper()
        .writeValueAsString(request.getAttribute("topQuotes"))
    %>;

    // Extract labels and data
    const labels = topQuotes.map(q => q.symbol);
    const closingPrices = topQuotes.map(q => q.close);

    const ctx = document.getElementById('top20Chart').getContext('2d');
    const top20Chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Closing Price',
                data: closingPrices,
                borderColor: '#007BFF',
                backgroundColor: 'rgba(0, 123, 255, 0.2)',
                fill: true,
                tension: 0.3,
                pointRadius: 3,
                pointHoverRadius: 6,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                x: {
                    ticks: {
                        maxRotation: 90,
                        minRotation: 45,
                        autoSkip: false,
                        maxTicksLimit: 10
                    }
                },
                y: {
                    beginAtZero: false
                }
            },
            plugins: {
                legend: {
                    display: false
                },
                tooltip: {
                    enabled: true
                }
            },
            elements: {
                line: {
                    borderWidth: 2
                }
            }
        }
    });
</script>

</body>
</html>
