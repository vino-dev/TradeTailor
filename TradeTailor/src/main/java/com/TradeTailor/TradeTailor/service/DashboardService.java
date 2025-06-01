package com.TradeTailor.TradeTailor.service;

import com.TradeTailor.TradeTailor.model.CalendarEvent;
import com.TradeTailor.TradeTailor.model.OHLVC;
import com.TradeTailor.TradeTailor.model.StockNews;
import com.TradeTailor.TradeTailor.model.Watchlist;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.*;

@Service
public class DashboardService {

    @Autowired
    private RestTemplate restTemplate;
    private final ObjectMapper mapper = new ObjectMapper();

    private static final String API_KEY = "d0qq7ahr01qg1llb9br0d0qq7ahr01qg1llb9brg";
    private static final String[] TOP_SYMBOLS = {
            "AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "NVDA", "JPM", "NFLX", "V",
            "BAC", "DIS", "ADBE", "PYPL", "INTC", "CSCO", "CMCSA", "PEP", "KO", "XOM"
        };
    private static final String GENERAL_NEWS_URL = "https://finnhub.io/api/v1/news?category=general&token=" + API_KEY;
    

    public Map<String, Object> getUSMarketStatus() {
        Map<String, Object> status = new LinkedHashMap<>();
       

        try {
            String url = "https://finnhub.io/api/v1/stock/market-status?exchange=US&token=" + API_KEY;
            ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, null, String.class);
            JsonNode json = mapper.readTree(response.getBody());

            boolean isOpen = json.path("isOpen").asBoolean(false);
            String holiday = json.path("holiday").isNull() ? "No Holiday" : json.path("holiday").asText();

            status.put("isOpen", isOpen);
            status.put("holiday", holiday);

        } catch (Exception e) {
            e.printStackTrace();
            status.put("isOpen", false);
            status.put("holiday", "Unavailable");
        }

        return status;
    }


    
    
    @Cacheable(value = "topClosePrices", key = "'top20ClosePrices'", unless = "#result == null || #result.isEmpty()")
    public Map<String, Double> getTop20ClosePrices() {
        Map<String, Double> closePrices = new LinkedHashMap<>(); // Keeps insertion order

        for (String symbol : TOP_SYMBOLS) {
            try {
                String quoteUrl = "https://finnhub.io/api/v1/quote?symbol=" + symbol + "&token=" + API_KEY;
                ResponseEntity<String> quoteResponse = restTemplate.exchange(quoteUrl, HttpMethod.GET, null, String.class);
                JsonNode quoteJson = mapper.readTree(quoteResponse.getBody());

                double close = quoteJson.path("c").asDouble();
                closePrices.put(symbol, close);

            } catch (Exception e) {
                System.err.println("Error fetching close price for symbol " + symbol);
                e.printStackTrace();
            }
        }

        return closePrices;
    }
    
    
    @Cacheable(value = "generalNews", unless = "#result == null || #result.isEmpty()")
    public List<StockNews> fetchGeneralNews() {
        List<StockNews> newsList = new ArrayList<>();

        try {
            ResponseEntity<String> response = restTemplate.exchange(GENERAL_NEWS_URL, HttpMethod.GET, null, String.class);
            JsonNode root = mapper.readTree(response.getBody());

            for (JsonNode node : root) {
                String headline = node.path("headline").asText();
                String source = node.path("source").asText();
                String url = node.path("url").asText();
                long timestamp = node.path("datetime").asLong(0);
                String datetime = new Date(timestamp * 1000).toString();

                newsList.add(new StockNews(headline, source, url, datetime));
            }

        } catch (Exception e) {
            System.err.println("Error fetching general news");
            e.printStackTrace();
        }

        return newsList;
    }
    
    private String[] getFromToDates(int daysAhead) {
        LocalDate today = LocalDate.now();
        LocalDate futureDate = today.plusDays(daysAhead);
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return new String[]{today.format(formatter), futureDate.format(formatter)};
    }

    public List<CalendarEvent> fetchCombinedCalendar() {
        List<CalendarEvent> combinedEvents = new ArrayList<>();

        String[] dates = getFromToDates(30);
        String fromDate = dates[0];
        String toDate = dates[1];

        // Fetch earnings
        try {
            String earningsUrl = "https://finnhub.io/api/v1/calendar/earnings?from=" + fromDate + "&to=" + toDate + "&token=" + API_KEY;
            String response = restTemplate.getForObject(earningsUrl, String.class);
            JsonNode root = mapper.readTree(response).path("earningsCalendar");

            if (root.isArray()) {
                for (JsonNode node : root) {
                    CalendarEvent event = new CalendarEvent();
                    event.setDate(node.path("date").asText());
                    event.setType("Earnings");
                    event.setTitle(node.path("company").asText() + " (" + node.path("symbol").asText() + ")");
                    event.setDetails("EPS Estimate: " + node.path("epsEstimate").asText());
                    combinedEvents.add(event);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Fetch IPOs
        try {
            String ipoUrl = "https://finnhub.io/api/v1/calendar/ipo?from=" + fromDate + "&to=" + toDate + "&token=" + API_KEY;
            String response = restTemplate.getForObject(ipoUrl, String.class);
            JsonNode root = mapper.readTree(response).path("ipoCalendar");

            if (root.isArray()) {
                for (JsonNode node : root) {
                    CalendarEvent event = new CalendarEvent();
                    event.setDate(node.path("date").asText());
                    event.setType("IPO");
                    event.setTitle(node.path("name").asText());
                    event.setDetails("Exchange: " + node.path("exchange").asText() + ", Shares: " + node.path("shares").asText());
                    combinedEvents.add(event);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        Collections.sort(combinedEvents);

        return combinedEvents;
    }
  
}
    
    

