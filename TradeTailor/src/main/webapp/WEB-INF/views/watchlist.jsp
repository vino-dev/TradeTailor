<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.TradeTailor.TradeTailor.model.Watchlist" %> <!-- Adjust package as needed -->

<!DOCTYPE html>
<html>
<head>
    <title>Stock Watchlist</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .container {
            width: 95%;
            margin: 0 auto;
            text-align: center; /* center children */
        }

        table {
            border-collapse: collapse;
            margin: 20px auto; /* center table */
            width: auto; /* adjust width to content */
            min-width: 800px; /* optional: ensure minimum width */
            max-width: 100%; /* don't overflow container */
            table-layout: auto; /* auto column widths */
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
            z-index: 1;
        }

        canvas {
            max-width: 900px;
            margin: 30px auto;
            display: block;
        }
    </style>
</head>
<body>

<%
List<Watchlist> quotes = (List<Watchlist>) request.getAttribute("quotes");
%>

<div class="container">
    <h2>Stock Watchlist (Top 20 Stocks)</h2>

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
        <%
        if (quotes != null) {
                        for (Watchlist quote : quotes) {
        %>
        <tr>
            <td><%= quote.getSymbol() %></td>
            <td><%= quote.getCompanyName() %></td>
            <td><%= quote.getOpen() %></td>
            <td><%= quote.getHigh() %></td>
            <td><%= quote.getLow() %></td>
            <td><%= quote.getClose() %></td>
            <td style="color:<%= quote.getChange() >= 0 ? "green" : "red" %>;">
                <%= quote.getChange() %>
            </td>
            <td><%= quote.getVolume() %></td>
        </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

   
</div>



</body>
</html>
