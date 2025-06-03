package com.TradeTailor.TradeTailor.service;

import java.util.List;
import java.util.Map;

public interface StockServiceInterface {
    Map<String, Double> get5YearHistoricalPrices(String symbol) throws Exception;
    void exportToPdf(String symbol, jakarta.servlet.http.HttpServletResponse response);
    void exportToExcel(String symbol, jakarta.servlet.http.HttpServletResponse response);
	List<String> getTopMovingStocks();
	List<Double> getPercentageChanges(List<String> symbols);
	Map<String, Double> getStockPerformanceData();
	byte[] exportToExcel(Map<String, Double> stockPerformanceData);
	Map<String, Long> get5YearVolumeData(String symbol) throws Exception;
}