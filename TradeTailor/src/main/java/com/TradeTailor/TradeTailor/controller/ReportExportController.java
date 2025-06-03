package com.TradeTailor.TradeTailor.controller;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.TradeTailor.TradeTailor.model.StockReport;
import com.TradeTailor.TradeTailor.service.ExportUtils_report;
import com.TradeTailor.TradeTailor.service.ReportService;

import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@Controller
public class ReportExportController {

    @Autowired
    private ReportService  reportService;

    @GetMapping("/export/pdf1")
    public void exportPdf(@RequestParam String symbol, HttpServletResponse response) throws Exception {
        try {
            StockReport report = reportService.getReport(symbol);
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "attachment; filename=report_" + symbol + ".pdf");
            ExportUtils_report.generatePDF(report, response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException e) {
            // Log error and set HTTP 500 error
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/export/excel1")
    public void exportExcel(@RequestParam String symbol, HttpServletResponse response) throws Exception {
        try {
            StockReport report = reportService.getReport(symbol);
            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=report_" + symbol + ".xlsx");
            ExportUtils_report.generateExcel(report, response.getOutputStream());
            response.getOutputStream().flush();
        } catch (IOException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/export/csv1")
    public void exportCsv(@RequestParam String symbol, HttpServletResponse response) throws Exception {
        try {
            StockReport report = reportService.getReport(symbol);
            response.setContentType("text/csv");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=report_" + symbol + ".csv");
            ExportUtils_report.generateCSV(report,response.getOutputStream());
            response.getWriter().flush();
        } catch (IOException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
