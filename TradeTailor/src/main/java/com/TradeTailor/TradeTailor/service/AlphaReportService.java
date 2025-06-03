package com.TradeTailor.TradeTailor.service;



import com.TradeTailor.TradeTailor.model.CompanyInfo;
import com.TradeTailor.TradeTailor.model.FinancialStatementsQuarter;
import com.TradeTailor.TradeTailor.model.TechnicalIndicators;
import com.TradeTailor.TradeTailor.model.financialStatementsAnnual;
import com.TradeTailor.TradeTailor.model.ohlvc_report;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Service
public class AlphaReportService {
    private final String apiKey = "04BSF0OLF6VJH96G";
    private final String baseUrl = "https://www.alphavantage.co/query";
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    public AlphaReportService() {
        this.restTemplate = new RestTemplate();
        this.objectMapper = new ObjectMapper();
    }

    public CompanyInfo getCompanyInfo(String symbol) {
        String url = String.format("%s?function=OVERVIEW&symbol=%s&apikey=%s", baseUrl, symbol, apiKey);
        String jsonResponse = restTemplate.getForObject(url, String.class);

        try {
            ObjectMapper mapper = new ObjectMapper();
            JsonNode overview = mapper.readTree(jsonResponse);
            
            CompanyInfo company = new CompanyInfo();
            company.setName(overview.path("Name").asText(""));
            company.setSector(overview.path("Sector").asText(""));
            company.setMarketCapitalization(overview.path("MarketCapitalization").asText(""));
            company.setDescription(overview.path("Description").asText(""));           
            return company;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    public List<ohlvc_report> getOhlcvData(String symbol) {
        String url = String.format("%s?function=TIME_SERIES_DAILY_ADJUSTED&symbol=%s&apikey=%s", baseUrl, symbol, apiKey);
        String jsonResponse = restTemplate.getForObject(url, String.class);
        List<ohlvc_report> ohlcvList = new ArrayList<>();

        try {
            JsonNode root = objectMapper.readTree(jsonResponse);
            JsonNode timeSeries = root.path("Time Series (Daily)");

            if (timeSeries.isMissingNode()) {
                return Collections.emptyList();
            }

            Iterator<String> dates = timeSeries.fieldNames();
            int count = 0;

            while (dates.hasNext() && count < 30) { // ✅ limit to latest 30 days
                String date = dates.next();
                JsonNode dayData = timeSeries.get(date);

                ohlvc_report ohlcv = new ohlvc_report();
                ohlcv.setDate(date);
                ohlcv.setOpen(dayData.path("1. open").asText());
                ohlcv.setHigh(dayData.path("2. high").asText());
                ohlcv.setLow(dayData.path("3. low").asText());
                ohlcv.setClose(dayData.path("4. close").asText());
                ohlcv.setVolume(dayData.path("6. volume").asText());

                ohlcvList.add(ohlcv);
                count++;
            }

            // Sort descending by date (latest first)
            ohlcvList.sort((o1, o2) -> o2.getDate().compareTo(o1.getDate()));
            return ohlcvList;

        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public TechnicalIndicators getTechnicalIndicators(String symbol) {
        TechnicalIndicators ti = new TechnicalIndicators();

        ti.setSma(fetchIndicator(symbol, "SMA"));
        ti.setEma(fetchIndicator(symbol, "EMA"));
        ti.setRsi(fetchIndicator(symbol, "RSI"));
        ti.setMacd(fetchIndicator(symbol, "MACD"));
        ti.setBollinger(fetchIndicator(symbol, "BBANDS"));
        ti.setAtr(fetchIndicator(symbol, "ATR"));

        return ti;
    }

    private Map<String, String> fetchIndicator(String symbol, String indicator) {
        String url = String.format("%s?function=%s&symbol=%s&interval=daily&time_period=10&series_type=close&apikey=%s", baseUrl, indicator, symbol, apiKey);
        String jsonResponse = restTemplate.getForObject(url, String.class);
        Map<String, String> resultMap = new HashMap<>();

        try {
            JsonNode root = objectMapper.readTree(jsonResponse);
            // Try to find "Technical Analysis: INDICATOR_NAME" node
            String key = "Technical Analysis: " + indicator;
            JsonNode technicalNode = root.path(key);
            if (technicalNode.isMissingNode()) return resultMap;

            Iterator<String> dates = technicalNode.fieldNames();
            while (dates.hasNext()) {
                String date = dates.next();
                String value = technicalNode.path(date).fields().next().getValue().asText();
                resultMap.put(date, value);
            }
            return resultMap;

        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyMap();
        }
    }

    public financialStatementsAnnual getAnnualStatements(String symbol) {
        financialStatementsAnnual annual = new financialStatementsAnnual();
        annual.setIncome(fetchFinancialStatementList(symbol, "INCOME_STATEMENT", true));
        annual.setBalanceSheet(fetchFinancialStatementList(symbol, "BALANCE_SHEET", true));
        annual.setCashFlow(fetchFinancialStatementList(symbol, "CASH_FLOW", true));
        return annual;
    }

    public FinancialStatementsQuarter getQuarterStatements(String symbol) {
        FinancialStatementsQuarter quarter = new FinancialStatementsQuarter();
        quarter.setIncome(fetchFinancialStatementList(symbol, "INCOME_STATEMENT", false));
        quarter.setBalanceSheet(fetchFinancialStatementList(symbol, "BALANCE_SHEET", false));
        quarter.setCashFlow(fetchFinancialStatementList(symbol, "CASH_FLOW", false));
        return quarter;
    }

    private List<Map<String, String>> fetchFinancialStatementList(String symbol, String function, boolean annual) {
        String url = String.format("%s?function=%s&symbol=%s&apikey=%s", baseUrl, function, symbol, apiKey);
        String jsonResponse = restTemplate.getForObject(url, String.class);

        try {
            JsonNode root = objectMapper.readTree(jsonResponse);
            String key = annual ? "annualReports" : "quarterlyReports";
            JsonNode reportsNode = root.path(key);

            if (!reportsNode.isArray()) return Collections.emptyList();

            List<Map<String, String>> list = new ArrayList<>();
            for (JsonNode report : reportsNode) {
                Iterator<Map.Entry<String, JsonNode>> fields = report.fields();
                Map<String, String> map = new HashMap<>();
                while (fields.hasNext()) {
                    Map.Entry<String, JsonNode> entry = fields.next();
                    map.put(entry.getKey(), entry.getValue().asText(""));
                }
                list.add(map);
            }
            return list;

        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }
}
