<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Stock Watchlist</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        table {
            border-collapse: collapse;
            width: 90%;
            margin: 20px auto;
            max-height: 500px;
            display: block;
            overflow-y: auto;
        }
        th, td {
            border: 1px solid #aaa;
            padding: 8px 12px;
            text-align: center;
            white-space: nowrap;
        }
        th {
            background-color: #f2f2f2;
            position: sticky;
            top: 0;
        }
        .container {
            width: 95%;
            margin: 0 auto;
        }
        canvas {
            max-width: 900px;
            margin: 30px auto;
            display: block;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 style="text-align:center;">Stock Watchlist (Top 20 Stocks)</h2>

    <table>
        <thead>
            <tr>
                <th>Symbol</th>
                <th>Company Name</th>
                <th>Open</th>
                <th>High</th>
                <th>Low</th>
                <th>Close</th>
                <th>Change</th>
                <th>Volume</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="quote" items="${quotes}">
                <tr>
                    <td>${quote.symbol}</td>
                    <td>${quote.companyName}</td>
                    <td>${quote.open}</td>
                    <td>${quote.high}</td>
                    <td>${quote.low}</td>
                    <td>${quote.close}</td>
                    <td style="color:${quote.change >= 0 ? 'green' : 'red'};">
                        ${quote.change}
                    </td>
                    <td>${quote.volume}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <canvas id="closePriceChart"></canvas>
</div>

<script>
    const ctx = document.getElementById('closePriceChart').getContext('2d');
    const symbols = [
        <c:forEach var="quote" items="${quotes}" varStatus="status">
            '${quote.symbol}'<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];
    const closePrices = [
        <c:forEach var="quote" items="${quotes}" varStatus="status">
            ${quote.close}<c:if test="${!status.last}">,</c:if>
        </c:forEach>
    ];

    const chart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: symbols,
            datasets: [{
                label: 'Close Price',
                data: closePrices,
                borderColor: 'blue',
                backgroundColor: 'rgba(0, 0, 255, 0.2)',
                fill: true,
                tension: 0.2,
                pointRadius: 4,
                pointHoverRadius: 6,
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: { display: true },
                title: {
                    display: true,
                    text: 'Closing Prices of Top 20 Stocks'
                }
            },
            scales: {
                y: { beginAtZero: false }
            }
        }
    });
</script>

</body>
</html>