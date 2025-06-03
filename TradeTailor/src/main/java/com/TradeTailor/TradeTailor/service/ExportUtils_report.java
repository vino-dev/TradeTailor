package com.TradeTailor.TradeTailor.service;

import java.io.BufferedWriter;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.util.List;
import java.util.Map;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Element;
import com.itextpdf.text.Font;
import com.itextpdf.text.Font.FontFamily;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.Phrase;
import com.itextpdf.text.pdf.PdfPCell;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;

import com.TradeTailor.TradeTailor.model.StockReport;
import com.TradeTailor.TradeTailor.model.ohlvc_report;
import com.TradeTailor.TradeTailor.model.TechnicalIndicators;

public class ExportUtils_report {

    public static void generatePDF(StockReport report, OutputStream out) throws Exception {
        Document document = new Document();
        PdfWriter.getInstance(document, out);
        document.open();

        Font titleFont = new Font(FontFamily.HELVETICA, 16, Font.BOLD);
        Font sectionFont = new Font(FontFamily.HELVETICA, 14, Font.BOLD);
        Font contentFont = new Font(FontFamily.HELVETICA, 12);

        Paragraph title = new Paragraph("Stock Report - " + report.getCompanyInfo().getName(), titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        document.add(title);
        document.add(new Paragraph("\n"));

        document.add(new Paragraph("Company Description: " + report.getCompanyInfo().getDescription(), contentFont));
        document.add(new Paragraph("Sector: " + report.getCompanyInfo().getSector(), contentFont));
        document.add(new Paragraph("Market Cap: " + report.getCompanyInfo().getMarketCapitalization(), contentFont));
        document.add(new Paragraph("\n"));

        document.add(new Paragraph("30-Day OHLCV Data", sectionFont));
        PdfPTable table = new PdfPTable(6);
        table.setWidthPercentage(100);
        table.setSpacingBefore(10f);
        String[] headers = {"Date", "Open", "High", "Low", "Close", "Volume"};
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header));
            table.addCell(cell);
        }
        for (ohlvc_report ohlcv : report.getOhlcvData()) {
            table.addCell(ohlcv.getDate());
            table.addCell(ohlcv.getOpen());
            table.addCell(ohlcv.getHigh());
            table.addCell(ohlcv.getLow());
            table.addCell(ohlcv.getClose());
            table.addCell(ohlcv.getVolume());
        }
        document.add(table);
        document.add(new Paragraph("\n"));

        document.add(new Paragraph("Technical Indicators", sectionFont));
        TechnicalIndicators ti = report.getTechnicalIndicators();
        addIndicatorTable(document, "SMA", ti.getSma());
        addIndicatorTable(document, "EMA", ti.getEma());
        addIndicatorTable(document, "RSI", ti.getRsi());
        addIndicatorTable(document, "MACD", ti.getMacd());
        addIndicatorTable(document, "Bollinger Bands", ti.getBollinger());
        addIndicatorTable(document, "ATR", ti.getAtr());

        document.add(new Paragraph("\n"));
        document.add(new Paragraph("Annual Financial Statements", sectionFont));
        addStatementSection(document, "Income Statement", report.getAnnualStatements().getIncome());
        addStatementSection(document, "Balance Sheet", report.getAnnualStatements().getBalanceSheet());
        addStatementSection(document, "Cash Flow", report.getAnnualStatements().getCashFlow());

        document.add(new Paragraph("Quarterly Financial Statements", sectionFont));
        addStatementSection(document, "Income Statement", report.getQuarterStatements().getIncome());
        addStatementSection(document, "Balance Sheet", report.getQuarterStatements().getBalanceSheet());
        addStatementSection(document, "Cash Flow", report.getQuarterStatements().getCashFlow());

        document.close();
    }

    private static void addIndicatorTable(Document doc, String title, Map<String, String> data) throws DocumentException {
        if (data == null || data.isEmpty()) return;

        doc.add(new Paragraph(title, new Font(FontFamily.HELVETICA, 13, Font.BOLD)));
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(80);
        table.addCell("Date");
        table.addCell(title + " Value");

        int count = 0;
        for (Map.Entry<String, String> entry : data.entrySet()) {
            if (count++ >= 5) break;
            table.addCell(entry.getKey());
            table.addCell(entry.getValue());
        }
        doc.add(table);
        doc.add(new Paragraph("\n"));
    }

    private static void addStatementSection(Document doc, String title, List<Map<String, String>> statements) throws DocumentException {
        if (statements == null || statements.isEmpty()) return;

        doc.add(new Paragraph(title, new Font(FontFamily.HELVETICA, 13, Font.BOLD)));
        Map<String, String> latest = statements.get(0);
        PdfPTable table = new PdfPTable(2);
        table.setWidthPercentage(100);
        table.setSpacingBefore(5f);

        for (Map.Entry<String, String> entry : latest.entrySet()) {
            table.addCell(new PdfPCell(new Phrase(entry.getKey())));
            table.addCell(new PdfPCell(new Phrase(entry.getValue())));
        }
        doc.add(table);
        doc.add(new Paragraph("\n"));
    }

    public static void generateExcel(StockReport report, OutputStream out) throws Exception {
        Workbook workbook = new XSSFWorkbook();

        CellStyle headerStyle = workbook.createCellStyle();
        org.apache.poi.ss.usermodel.Font headerFont = workbook.createFont();
        headerFont.setBold(true);
        headerStyle.setFont(headerFont);

        // Company Info
        Sheet companySheet = workbook.createSheet("Company Info");
        int rowIdx = 0;
        Row row = companySheet.createRow(rowIdx++);
        row.createCell(0).setCellValue("Company Name");
        row.createCell(1).setCellValue(report.getCompanyInfo().getName());

        row = companySheet.createRow(rowIdx++);
        row.createCell(0).setCellValue("Description");
        row.createCell(1).setCellValue(report.getCompanyInfo().getDescription());

        row = companySheet.createRow(rowIdx++);
        row.createCell(0).setCellValue("Sector");
        row.createCell(1).setCellValue(report.getCompanyInfo().getSector());

        row = companySheet.createRow(rowIdx++);
        row.createCell(0).setCellValue("Market Cap");
        row.createCell(1).setCellValue(report.getCompanyInfo().getMarketCapitalization());

        // OHLCV
        Sheet ohlcvSheet = workbook.createSheet("30-Day OHLCV Data");
        String[] headers = {"Date", "Open", "High", "Low", "Close", "Volume"};
        row = ohlcvSheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            Cell cell = row.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }
        int ohlcvRowIdx = 1;
        for (ohlvc_report ohlcv : report.getOhlcvData()) {
            row = ohlcvSheet.createRow(ohlcvRowIdx++);
            row.createCell(0).setCellValue(ohlcv.getDate());
            row.createCell(1).setCellValue(ohlcv.getOpen());
            row.createCell(2).setCellValue(ohlcv.getHigh());
            row.createCell(3).setCellValue(ohlcv.getLow());
            row.createCell(4).setCellValue(ohlcv.getClose());
            row.createCell(5).setCellValue(ohlcv.getVolume());
        }

        // Technical Indicators
        Sheet techSheet = workbook.createSheet("Technical Indicators");
        int techRowIdx = 0;
        techRowIdx = addIndicatorSheet(techSheet, "SMA", report.getTechnicalIndicators().getSma(), techRowIdx, headerStyle);
        techRowIdx = addIndicatorSheet(techSheet, "EMA", report.getTechnicalIndicators().getEma(), techRowIdx, headerStyle);
        techRowIdx = addIndicatorSheet(techSheet, "RSI", report.getTechnicalIndicators().getRsi(), techRowIdx, headerStyle);
        techRowIdx = addIndicatorSheet(techSheet, "MACD", report.getTechnicalIndicators().getMacd(), techRowIdx, headerStyle);
        techRowIdx = addIndicatorSheet(techSheet, "Bollinger Bands", report.getTechnicalIndicators().getBollinger(), techRowIdx, headerStyle);
        techRowIdx = addIndicatorSheet(techSheet, "ATR", report.getTechnicalIndicators().getAtr(), techRowIdx, headerStyle);

        // Financial Statements
        Sheet annualSheet = workbook.createSheet("Annual Financial Statements");
        int annualRowIdx = 0;
        annualRowIdx = addStatementSheet(annualSheet, "Income Statement", report.getAnnualStatements().getIncome(), annualRowIdx, headerStyle);
        annualRowIdx = addStatementSheet(annualSheet, "Balance Sheet", report.getAnnualStatements().getBalanceSheet(), annualRowIdx, headerStyle);
        annualRowIdx = addStatementSheet(annualSheet, "Cash Flow", report.getAnnualStatements().getCashFlow(), annualRowIdx, headerStyle);

        Sheet quarterlySheet = workbook.createSheet("Quarterly Financial Statements");
        int quarterlyRowIdx = 0;
        quarterlyRowIdx = addStatementSheet(quarterlySheet, "Income Statement", report.getQuarterStatements().getIncome(), quarterlyRowIdx, headerStyle);
        quarterlyRowIdx = addStatementSheet(quarterlySheet, "Balance Sheet", report.getQuarterStatements().getBalanceSheet(), quarterlyRowIdx, headerStyle);
        quarterlyRowIdx = addStatementSheet(quarterlySheet, "Cash Flow", report.getQuarterStatements().getCashFlow(), quarterlyRowIdx, headerStyle);

        workbook.write(out);
        workbook.close();
    }

    private static int addIndicatorSheet(Sheet sheet, String title, Map<String, String> data, int startRow, CellStyle headerStyle) {
        if (data == null || data.isEmpty()) return startRow;

        Row titleRow = sheet.createRow(startRow++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue(title);
        titleCell.setCellStyle(headerStyle);

        Row headerRow = sheet.createRow(startRow++);
        headerRow.createCell(0).setCellValue("Date");
        headerRow.createCell(1).setCellValue("Value");

        int count = 0;
        for (Map.Entry<String, String> entry : data.entrySet()) {
            if (count++ >= 5) break;
            Row row = sheet.createRow(startRow++);
            row.createCell(0).setCellValue(entry.getKey());
            row.createCell(1).setCellValue(entry.getValue());
        }
        return startRow + 1;
    }

    private static int addStatementSheet(Sheet sheet, String title, List<Map<String, String>> statements, int startRow, CellStyle headerStyle) {
        if (statements == null || statements.isEmpty()) return startRow;

        Row titleRow = sheet.createRow(startRow++);
        Cell titleCell = titleRow.createCell(0);
        titleCell.setCellValue(title);
        titleCell.setCellStyle(headerStyle);

        Map<String, String> latest = statements.get(0);
        for (Map.Entry<String, String> entry : latest.entrySet()) {
            Row row = sheet.createRow(startRow++);
            row.createCell(0).setCellValue(entry.getKey());
            row.createCell(1).setCellValue(entry.getValue());
        }
        return startRow + 1;
    }
    
    public static void generateCSV(StockReport report, OutputStream out) throws Exception {
        try (BufferedWriter writer = new BufferedWriter(new OutputStreamWriter(out))) {
            
            // Write Company Info
            writer.write("Company Name," + escapeCSV(report.getCompanyInfo().getName()));
            writer.newLine();
            writer.write("Description," + escapeCSV(report.getCompanyInfo().getDescription()));
            writer.newLine();
            writer.write("Sector," + escapeCSV(report.getCompanyInfo().getSector()));
            writer.newLine();
            writer.write("Market Cap," + escapeCSV(report.getCompanyInfo().getMarketCapitalization()));
            writer.newLine();
            writer.newLine();

            // Write OHLCV Data
            writer.write("30-Day OHLCV Data");
            writer.newLine();
            writer.write("Date,Open,High,Low,Close,Volume");
            writer.newLine();
            for (ohlvc_report ohlcv : report.getOhlcvData()) {
                writer.write(escapeCSV(ohlcv.getDate()) + "," +
                             escapeCSV(ohlcv.getOpen()) + "," +
                             escapeCSV(ohlcv.getHigh()) + "," +
                             escapeCSV(ohlcv.getLow()) + "," +
                             escapeCSV(ohlcv.getClose()) + "," +
                             escapeCSV(ohlcv.getVolume()));
                writer.newLine();
            }
            writer.newLine();

            // Write Technical Indicators
            TechnicalIndicators ti = report.getTechnicalIndicators();
            writeIndicatorCSV(writer, "SMA", ti.getSma());
            writeIndicatorCSV(writer, "EMA", ti.getEma());
            writeIndicatorCSV(writer, "RSI", ti.getRsi());
            writeIndicatorCSV(writer, "MACD", ti.getMacd());
            writeIndicatorCSV(writer, "Bollinger Bands", ti.getBollinger());
            writeIndicatorCSV(writer, "ATR", ti.getAtr());

            // Write Annual Financial Statements
            writer.write("Annual Financial Statements");
            writer.newLine();
            writeStatementCSV(writer, "Income Statement", report.getAnnualStatements().getIncome());
            writeStatementCSV(writer, "Balance Sheet", report.getAnnualStatements().getBalanceSheet());
            writeStatementCSV(writer, "Cash Flow", report.getAnnualStatements().getCashFlow());

            // Write Quarterly Financial Statements
            writer.write("Quarterly Financial Statements");
            writer.newLine();
            writeStatementCSV(writer, "Income Statement", report.getQuarterStatements().getIncome());
            writeStatementCSV(writer, "Balance Sheet", report.getQuarterStatements().getBalanceSheet());
            writeStatementCSV(writer, "Cash Flow", report.getQuarterStatements().getCashFlow());
        }
    }

    private static void writeIndicatorCSV(BufferedWriter writer, String title, Map<String, String> data) throws Exception {
        if (data == null || data.isEmpty()) return;

        writer.write(title);
        writer.newLine();
        writer.write("Date," + title + " Value");
        writer.newLine();

        int count = 0;
        for (Map.Entry<String, String> entry : data.entrySet()) {
            if (count++ >= 5) break;
            writer.write(escapeCSV(entry.getKey()) + "," + escapeCSV(entry.getValue()));
            writer.newLine();
        }
        writer.newLine();
    }

    private static void writeStatementCSV(BufferedWriter writer, String title, List<Map<String, String>> statements) throws Exception {
        if (statements == null || statements.isEmpty()) return;

        writer.write(title);
        writer.newLine();
        Map<String, String> latest = statements.get(0);
        for (Map.Entry<String, String> entry : latest.entrySet()) {
            writer.write(escapeCSV(entry.getKey()) + "," + escapeCSV(entry.getValue()));
            writer.newLine();
        }
        writer.newLine();
    }

    /**
     * Escapes CSV special characters by enclosing in double quotes if needed.
     */
    private static String escapeCSV(String input) {
        if (input == null) return "";
        if (input.contains(",") || input.contains("\"") || input.contains("\n") || input.contains("\r")) {
            input = input.replace("\"", "\"\"");
            return "\"" + input + "\"";
        }
        return input;
    }

}
