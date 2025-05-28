package com.TradeTailor.TradeTailor.service;

import com.TradeTailor.TradeTailor.model.Watchlist;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

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
    private static final Map<String, String> indices = Map.of(
    	    "NIFTY 50", "NSEI",
    	    "SENSEX", "BSESN",
    	    "NASDAQ", "IXIC",
    	    "S&P 500", "SPX",
    	    "DOW JONES", "DJI"
    	);

    public List<Map<String, String>> getMarketIndices() {
        List<Map<String, String>> indexDataList = new ArrayList<>();
        ObjectMapper mapper = new ObjectMapper();

        for (Map.Entry<String, String> entry : indices.entrySet()) {
            String url = "https://finnhub.io/api/v1/quote?symbol=" + entry.getValue() + "&token=" + API_KEY;

            try {
                String response = restTemplate.getForObject(url, String.class);
                if (response == null) continue;

                JsonNode root = mapper.readTree(response);
                double current = root.path("c").asDouble(0);
                double previous = root.path("pc").asDouble(0);

                double changePercent = previous != 0 ? ((current - previous) / previous) * 100 : 0;

                Map<String, String> indexMap = new HashMap<>();
                indexMap.put("name", entry.getKey());
                indexMap.put("value", String.format("%.2f", current));
                indexMap.put("change", String.format("%.2f%%", changePercent));

                indexDataList.add(indexMap);

            } catch (Exception e) {
                e.printStackTrace(); 
            }
        }

        return indexDataList;
    }
    
    @Cacheable(value = "stockProfiles", key = "#symbol")
    public String getCompanyName(String symbol) throws Exception {
        String profileUrl = "https://finnhub.io/api/v1/stock/profile2?symbol=" + symbol + "&token=" + API_KEY;
        ResponseEntity<String> profileResponse = restTemplate.exchange(profileUrl, HttpMethod.GET, null, String.class);
        JsonNode profileJson = mapper.readTree(profileResponse.getBody());
        return profileJson.path("name").asText(symbol);
    }
    
    @Cacheable(value = "topQuotes", key = "'top20'", unless = "#result == null || #result.isEmpty()")
    public List<Watchlist> getTop20Quotes() {
        List<Watchlist> quotes = new ArrayList<>();

        for (String symbol : TOP_SYMBOLS) {
            try {
                // Fetch quote data
                String quoteUrl = "https://finnhub.io/api/v1/quote?symbol=" + symbol + "&token=" + API_KEY;
                ResponseEntity<String> quoteResponse = restTemplate.exchange(quoteUrl, HttpMethod.GET, null, String.class);
                JsonNode quoteJson = mapper.readTree(quoteResponse.getBody());

                // Fetch company name using cached method
                String companyName = getCompanyName(symbol);
                double open = quoteJson.path("o").asDouble();
                double high = quoteJson.path("h").asDouble();
                double low = quoteJson.path("l").asDouble();
                double close = quoteJson.path("c").asDouble();
                double change = quoteJson.path("d").asDouble();
                long volume = (long) quoteJson.path("v").asDouble();
                quotes.add(new Watchlist(symbol, companyName, open, high, low, close,volume,change));

            } catch (Exception e) {
                System.err.println("Error fetching data for symbol " + symbol);
                e.printStackTrace();
            }
        }

        return quotes;
    }
}
