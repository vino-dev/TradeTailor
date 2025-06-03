package com.TradeTailor.TradeTailor.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.TradeTailor.TradeTailor.model.StockReport;

@Service
public class ReportService {
    @Autowired
    private AlphaReportService alphaService;

    public StockReport getReport(String symbol) {
        StockReport report = new StockReport();
        report.setCompanyInfo(alphaService.getCompanyInfo(symbol));
        report.setOhlcvData(alphaService.getOhlcvData(symbol));
        report.setTechnicalIndicators(alphaService.getTechnicalIndicators(symbol));
        report.setAnnualStatements(alphaService.getAnnualStatements(symbol));
        report.setQuarterStatements(alphaService.getQuarterStatements(symbol));
        return report;
       
    }
}
