package com.TradeTailor.TradeTailor.controller;

import com.TradeTailor.TradeTailor.service.StockServiceInterface;
import com.TradeTailor.TradeTailor.service.Export;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/stocks")
public class StockController {

    @Autowired
    private StockServiceInterface stockService;

    @Autowired
    private Export exportService;

    @GetMapping("/top")
    public List<String> getTopStocks() {
        return stockService.getTopMovingStocks();
    }

    @GetMapping("/changes")
    public List<Double> getStockChanges(@RequestParam List<String> symbols) {
        return stockService.getPercentageChanges(symbols);
    }

    @GetMapping("/performance")
    public Map<String, Double> getStockPerformance() {
        return stockService.getStockPerformanceData();
    }

    @GetMapping("/export/excel")
    public ResponseEntity<byte[]> exportExcel() throws Exception {
        byte[] data = stockService.exportToExcel(stockService.getStockPerformanceData());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=stocks.xlsx")
                .contentType(MediaType.APPLICATION_OCTET_STREAM)
                .body(data);
    }

    @GetMapping("/export/pdf")
    public ResponseEntity<byte[]> exportStocksToPDF() throws Exception {
        byte[] pdfBytes = exportService.exportToPDF(stockService.getStockPerformanceData());
        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=top_stocks.pdf")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }
}