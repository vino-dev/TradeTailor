package com.TradeTailor.TradeTailor.service;

import com.TradeTailor.TradeTailor.model.CompanyProfile;
import com.TradeTailor.TradeTailor.model.Watchlist;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.ArrayList;
import java.util.List;

@Service
public class WatchlistService {

    private static final String API_KEY = "d0qq7ahr01qg1llb9br0d0qq7ahr01qg1llb9brg";
    private static final String[] TOP_SYMBOLS = {
        "AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "NVDA", "JPM", "NFLX", "V",
        "BAC", "DIS", "ADBE", "PYPL", "INTC", "CSCO", "CMCSA", "PEP", "KO", "XOM"
    };

    @Autowired
    private RestTemplate restTemplate;

    private final ObjectMapper mapper = new ObjectMapper();

    @Cacheable(value = "companyProfiles", key = "#symbol")
    public CompanyProfile getCompanyProfile(String symbol) throws Exception {
        String url = "https://finnhub.io/api/v1/stock/profile2?symbol=" + symbol + "&token=" + API_KEY;
        ResponseEntity<String> response = restTemplate.exchange(url, HttpMethod.GET, null, String.class);
        JsonNode json = mapper.readTree(response.getBody());

        String name = json.path("name").asText(symbol);
        String logo = json.path("logo").asText("");
        return new CompanyProfile(name, logo);
    }

    @Cacheable(value = "topQuotes", key = "'top20'", unless = "#result == null || #result.isEmpty()")
    public List<Watchlist> getTop20Quotes() {
        List<Watchlist> quotes = new ArrayList<>();

        for (String symbol : TOP_SYMBOLS) {
            try {
                String quoteUrl = "https://finnhub.io/api/v1/quote?symbol=" + symbol + "&token=" + API_KEY;
                ResponseEntity<String> quoteResponse = restTemplate.exchange(quoteUrl, HttpMethod.GET, null, String.class);
                JsonNode quoteJson = mapper.readTree(quoteResponse.getBody());

                CompanyProfile profile = getCompanyProfile(symbol);
                double open = quoteJson.path("o").asDouble();
                double high = quoteJson.path("h").asDouble();
                double low = quoteJson.path("l").asDouble();
                double close = quoteJson.path("c").asDouble();
                double change = quoteJson.path("d").asDouble();
                long volume = (long) quoteJson.path("v").asDouble();

                quotes.add(new Watchlist(symbol, profile.getName(), open, high, low, close, volume, change, profile.getLogo()));
            } catch (Exception e) {
                System.err.println("Error fetching data for symbol " + symbol);
                e.printStackTrace();
            }
        }

        return quotes;
    }
}
