package com.TradeTailor.TradeTailor.api;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.time.Instant;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.LinkedHashMap;

@Component
public class FinnhubApiClient {

    private final String apiKey = "d0ukvd9r01qn5fk61mp0d0ukvd9r01qn5fk61mpg"; // Replace with your real Finnhub API key
    private final String baseUrl = "https://finnhub.io/api/v1/";
    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper mapper = new ObjectMapper();

    public LinkedHashMap<String, Double> fetchHistoricalClosePrices(String symbol) {
        LinkedHashMap<String, Double> closePrices = new LinkedHashMap<>();
        String url = buildUrl(symbol);

        try {
            String response = restTemplate.getForObject(url, String.class);
            JsonNode root = mapper.readTree(response);

            JsonNode timestamps = root.get("t");
            JsonNode closes = root.get("c");

            for (int i = 0; i < timestamps.size(); i++) {
                long ts = timestamps.get(i).asLong();
                String date = Instant.ofEpochSecond(ts).atZone(ZoneOffset.UTC).toLocalDate().toString();
                double close = closes.get(i).asDouble();
                closePrices.put(date, close);
            }
        } catch (Exception e) {
            e.printStackTrace(); // Log better in production
        }

        return closePrices;
    }

    public LinkedHashMap<String, Long> fetchHistoricalVolumes(String symbol) {
        LinkedHashMap<String, Long> volumes = new LinkedHashMap<>();
        String url = buildUrl(symbol);

        try {
            String response = restTemplate.getForObject(url, String.class);
            JsonNode root = mapper.readTree(response);

            JsonNode timestamps = root.get("t");
            JsonNode volumeNodes = root.get("v");

            for (int i = 0; i < timestamps.size(); i++) {
                long ts = timestamps.get(i).asLong();
                String date = Instant.ofEpochSecond(ts).atZone(ZoneOffset.UTC).toLocalDate().toString();
                long volume = volumeNodes.get(i).asLong();
                volumes.put(date, volume);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return volumes;
    }

    private String buildUrl(String symbol) {
        LocalDate now = LocalDate.now();
        LocalDate from = now.minusYears(5);

        long fromEpoch = from.atStartOfDay(ZoneOffset.UTC).toEpochSecond();
        long toEpoch = now.atStartOfDay(ZoneOffset.UTC).toEpochSecond();

        return baseUrl + "stock/candle?symbol=" + symbol + "&resolution=D&from=" + fromEpoch + "&to=" + toEpoch + "&token=" + apiKey;
    }
}