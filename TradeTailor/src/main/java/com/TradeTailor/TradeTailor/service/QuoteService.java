package com.TradeTailor.TradeTailor.service;
import com.TradeTailor.TradeTailor.model.QuoteDTO;
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
public class QuoteService {

    private static final String API_KEY = "d0qq7ahr01qg1llb9br0d0qq7ahr01qg1llb9brg";
    private static final String[] TOP_SYMBOLS = {
        "AAPL", "MSFT", "GOOGL", "AMZN", "META", "TSLA", "NVDA", "JPM", "NFLX", "V",
        "BAC", "DIS", "ADBE", "PYPL", "INTC", "CSCO", "CMCSA", "PEP", "KO", "XOM"
    };

    @Autowired
    private RestTemplate restTemplate;

    private final ObjectMapper mapper = new ObjectMapper();

    // Cache company profile for 24h
    @Cacheable(value = "stockProfiles", key = "#symbol")
    public String getCompanyName(String symbol) throws Exception {
        String profileUrl = "https://finnhub.io/api/v1/stock/profile2?symbol=" + symbol + "&token=" + API_KEY;
        ResponseEntity<String> profileResponse = restTemplate.exchange(profileUrl, HttpMethod.GET, null, String.class);
        JsonNode profileJson = mapper.readTree(profileResponse.getBody());
        return profileJson.path("name").asText(symbol);
    }

    // Cache the entire quotes list for 5 minutes
    @Cacheable(value = "topQuotes", key = "'top20'", unless = "#result == null || #result.isEmpty()")
    public List<QuoteDTO> getTop20Quotes() {
        List<QuoteDTO> quotes = new ArrayList<>();

        for (String symbol : TOP_SYMBOLS) {
            try {
                // Fetch quote data
                String quoteUrl = "https://finnhub.io/api/v1/quote?symbol=" + symbol + "&token=" + API_KEY;
                ResponseEntity<String> quoteResponse = restTemplate.exchange(quoteUrl, HttpMethod.GET, null, String.class);
                JsonNode quoteJson = mapper.readTree(quoteResponse.getBody());

                // Fetch company name from cached profile method
                String companyName = getCompanyName(symbol);

                QuoteDTO dto = new QuoteDTO();
                dto.setSymbol(symbol);
                dto.setCompanyName(companyName);
                dto.setOpen(quoteJson.path("o").asDouble());
                dto.setHigh(quoteJson.path("h").asDouble());
                dto.setLow(quoteJson.path("l").asDouble());
                dto.setClose(quoteJson.path("c").asDouble());
                dto.setChange(quoteJson.path("d").asDouble());
                dto.setVolume((long) quoteJson.path("v").asDouble());

                quotes.add(dto);

            } catch (Exception e) {
                System.err.println("Error fetching data for symbol " + symbol);
                e.printStackTrace();
            }
        }

        return quotes;
    }
}