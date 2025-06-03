package com.TradeTailor.TradeTailor.service;

import jakarta.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.TradeTailor.TradeTailor.api.FinnhubApiClient;
import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.json.JSONObject;

import java.io.OutputStream;
import java.util.*;
import java.util.List;
import java.util.logging.Logger;

@Service
public class StockService implements StockServiceInterface {

    private static final String API_KEY = "cee9ab9ea88b4f4ca71e711324c94785";
    private static final Logger LOGGER = Logger.getLogger(StockService.class.getName());
    private final RestTemplate restTemplate = new RestTemplate();
    

    @Autowired
    private FinnhubApiClient finnhubClient;

    public LinkedHashMap<String, Double> getClosePriceHistory(String symbol) {
        // Return 5 years of daily prices as LinkedHashMap<Date, ClosePrice>
        return finnhubClient.fetchHistoricalClosePrices(symbol);
    }

    public LinkedHashMap<String, Long> getVolumeHistory(String symbol) {
        // Return 5 years of daily volume as LinkedHashMap<Date, Volume>
        return finnhubClient.fetchHistoricalVolumes(symbol);
    }

    // 1. Get 5-year daily prices for a stock
    @Override
    public Map<String, Double> get5YearHistoricalPrices(String symbol) throws Exception {
        String url = String.format(
                "https://api.twelvedata.com/time_series?symbol=%s&interval=1day&outputsize=5000&apikey=%s",
                symbol, API_KEY);

        JSONObject response = new JSONObject(restTemplate.getForObject(url, String.class));
        Map<String, Double> stockData = new LinkedHashMap<>();

        if (response.has("values")) {
            for (int i = response.getJSONArray("values").length() - 1; i >= 0; i--) {
                JSONObject obj = response.getJSONArray("values").getJSONObject(i);
                String date = obj.getString("datetime");
                double close = obj.getDouble("close");
                stockData.put(date, close);
            }
        } else {
            throw new Exception("Invalid response from API: " + response.toString());
        }

        return stockData;
    }

    // 2. Export 5-year data to PDF
    @Override
    public void exportToPdf(String symbol, HttpServletResponse response) {
        try {
            Map<String, Double> data = get5YearHistoricalPrices(symbol);

            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=" + symbol + "_report.pdf");

            Document document = new Document();
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            document.add(new Paragraph("Stock Report: " + symbol));
            document.add(Chunk.NEWLINE);

            PdfPTable table = new PdfPTable(2);
            table.addCell("Date");
            table.addCell("Price");

            for (Map.Entry<String, Double> entry : data.entrySet()) {
                table.addCell(entry.getKey());
                table.addCell(String.valueOf(entry.getValue()));
            }

            document.add(table);
            document.close();
        } catch (Exception e) {
            LOGGER.severe("Error exporting to PDF: " + e.getMessage());
        }
    }

    // 3. Export 5-year data to Excel
    @Override
    public void exportToExcel(String symbol, HttpServletResponse response) {
        try {
            Map<String, Double> data = get5YearHistoricalPrices(symbol);

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=" + symbol + "_report.xlsx");

            try (Workbook workbook = new XSSFWorkbook()) {
                Sheet sheet = workbook.createSheet("Stock Data");
                Row header = sheet.createRow(0);
                header.createCell(0).setCellValue("Date");
                header.createCell(1).setCellValue("Price");

                int rowIdx = 1;
                for (Map.Entry<String, Double> entry : data.entrySet()) {
                    Row row = sheet.createRow(rowIdx++);
                    row.createCell(0).setCellValue(entry.getKey());
                    row.createCell(1).setCellValue(entry.getValue());
                }

                try (OutputStream out = response.getOutputStream()) {
                    workbook.write(out);
                }
            }
        } catch (Exception e) {
            LOGGER.severe("Error exporting to Excel: " + e.getMessage());
        }
    }

    // 4. Static top 15 moving stocks
    @Override
    public List<String> getTopMovingStocks() {
        return Arrays.asList("AAPL", "MSFT", "GOOGL", "AMZN", "TSLA",
                "META", "NFLX", "NVDA", "BABA", "INTC",
                "AMD", "UBER", "PYPL", "BA", "DIS");
    }

    // 5. Get % change for multiple stocks
    @Override
    public List<Double> getPercentageChanges(List<String> symbols) {
        List<Double> changes = new ArrayList<>();
        for (String symbol : symbols) {
            try {
                String url = String.format("https://api.twelvedata.com/quote?symbol=%s&apikey=%s", symbol, API_KEY);
                JSONObject response = new JSONObject(restTemplate.getForObject(url, String.class));

                if (response.has("percent_change") && !response.isNull("percent_change")) {
                    changes.add(Double.parseDouble(response.getString("percent_change")));
                } else {
                    LOGGER.warning("Missing 'percent_change' for " + symbol);
                    changes.add(0.0);
                }
            } catch (Exception e) {
                LOGGER.warning("Error fetching % change for " + symbol + ": " + e.getMessage());
                changes.add(0.0);
            }
        }
        return changes;
    }

    // 6. Get performance data (symbol -> % change)
    @Override
    public Map<String, Double> getStockPerformanceData() {
        Map<String, Double> performance = new LinkedHashMap<>();
        for (String symbol : getTopMovingStocks()) {
            try {
                String url = String.format("https://api.twelvedata.com/quote?symbol=%s&apikey=%s", symbol, API_KEY);
                JSONObject response = new JSONObject(restTemplate.getForObject(url, String.class));

                if (response.has("percent_change") && !response.isNull("percent_change")) {
                    performance.put(symbol, Double.parseDouble(response.getString("percent_change")));
                } else {
                    LOGGER.warning("Missing 'percent_change' for " + symbol);
                    performance.put(symbol, 0.0);
                }
            } catch (Exception e) {
                LOGGER.warning("Error fetching performance data for " + symbol + ": " + e.getMessage());
                performance.put(symbol, 0.0);
            }
        }
        return performance;
    }

    // 7. Export performance data to Excel as byte[]
    @Override
    public byte[] exportToExcel(Map<String, Double> stockPerformanceData) {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Top Stock Performance");

            Row header = sheet.createRow(0);
            header.createCell(0).setCellValue("Symbol");
            header.createCell(1).setCellValue("Change (%)");

            int rowNum = 1;
            for (Map.Entry<String, Double> entry : stockPerformanceData.entrySet()) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(entry.getKey());
                row.createCell(1).setCellValue(entry.getValue());
            }

            try (java.io.ByteArrayOutputStream out = new java.io.ByteArrayOutputStream()) {
                workbook.write(out);
                return out.toByteArray();
            }
        } catch (Exception e) {
            LOGGER.severe("Error exporting stock performance to Excel: " + e.getMessage());
            return null;
        }
    }
    @Override
    public Map<String, Long> get5YearVolumeData(String symbol) throws Exception {
        String url = String.format(
            "https://api.twelvedata.com/time_series?symbol=%s&interval=1day&outputsize=5000&apikey=%s",
            symbol, API_KEY);

        JSONObject response = new JSONObject(restTemplate.getForObject(url, String.class));
        Map<String, Long> volumeData = new LinkedHashMap<>();

        if (response.has("values")) {
            for (int i = response.getJSONArray("values").length() - 1; i >= 0; i--) {
                JSONObject obj = response.getJSONArray("values").getJSONObject(i);
                String date = obj.getString("datetime");
                long volume = obj.has("volume") ? obj.getLong("volume") : 0;
                volumeData.put(date, volume);
            }
        } else {
            throw new Exception("Invalid response from API");
        }

        return volumeData;
    }

}