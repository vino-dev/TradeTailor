// File: EarningsService.java
package com.TradeTailor.TradeTailor.service;

import com.TradeTailor.TradeTailor.model.EarningsReport;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import org.json.JSONArray;
import org.json.JSONObject;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Service
public class EarningsService {

    private static final String API_KEY = "is-d0ukvd9r01qn5fk61mp0d0ukvd9r01qn5fk61mpg";
    private static final String BASE_URL = "https://finnhub.io/api/v1/calendar/earnings";

    public List<EarningsReport> getUpcomingEarnings() {
        List<EarningsReport> reports = new ArrayList<>();
        RestTemplate restTemplate = new RestTemplate();

        LocalDate fromDate = LocalDate.now();
        LocalDate toDate = fromDate.plusDays(5);

        String url = UriComponentsBuilder.fromHttpUrl(BASE_URL)
                .queryParam("from", fromDate)
                .queryParam("to", toDate)
                .queryParam("token", API_KEY)
                .toUriString();

        try {
            String jsonResponse = restTemplate.getForObject(url, String.class);
            JSONObject root = new JSONObject(jsonResponse);
            JSONArray earningsArray = root.getJSONArray("earningsCalendar");

            for (int i = 0; i < earningsArray.length(); i++) {
                JSONObject earning = earningsArray.getJSONObject(i);

                String symbol = earning.optString("symbol", "N/A");
                String date = earning.optString("date", "N/A");
                String epsEstimate = earning.opt("epsEstimate") != JSONObject.NULL
                        ? String.valueOf(earning.getDouble("epsEstimate")) : "N/A";
                String epsActual = earning.opt("epsActual") != JSONObject.NULL
                        ? String.valueOf(earning.getDouble("epsActual")) : "N/A";
                String revenueEstimate = earning.opt("revenueEstimate") != JSONObject.NULL
                        ? String.valueOf(earning.getDouble("revenueEstimate")) : "N/A";
                String revenueActual = earning.opt("revenueActual") != JSONObject.NULL
                        ? String.valueOf(earning.getDouble("revenueActual")) : "N/A";

                reports.add(new EarningsReport(symbol, date, epsEstimate, epsActual, revenueEstimate, revenueActual));
            }

        } catch (Exception e) {
            System.err.println("Failed to fetch earnings from Finnhub: " + e.getMessage());
        }

        return reports;
    }
}
