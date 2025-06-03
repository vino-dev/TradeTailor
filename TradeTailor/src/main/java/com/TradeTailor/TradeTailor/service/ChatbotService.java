package com.TradeTailor.TradeTailor.service;

import org.json.JSONObject;
import org.springframework.stereotype.Service;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

@Service
public class ChatbotService {

    public String fetchLiveStock(String symbol) {
        try {
            String apiKey = "d0uj08hr01qn5fk5mmcgd0uj08hr01qn5fk5mmd0"; // Replace with real key
            String url = "https://finnhub.io/api/v1/quote?symbol=" + symbol + "&token=" + apiKey;

            HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(url))
                    .build();

            HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

            // Parse JSON
            JSONObject json = new JSONObject(response.body());
            double currentPrice = json.getDouble("c");
            double open = json.getDouble("o");
            double high = json.getDouble("h");
            double low = json.getDouble("l");

            return String.format("Live Stock for %s: Price: $%.2f | Open: $%.2f | High: $%.2f | Low: $%.2f",
                    symbol, currentPrice, open, high, low);

        } catch (Exception e) {
            e.printStackTrace();
            return "Sorry, failed to fetch stock data right now.";
        }
    }
}
