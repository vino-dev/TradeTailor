package com.TradeTailor.TradeTailor.service;

import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.List;
@Service
public class ExportService {
	 

		    public byte[] exportToExcel(List<String> stocks) throws IOException {
		        Workbook workbook = new XSSFWorkbook();
		        Sheet sheet = workbook.createSheet("Top Stocks");
		        Row header = sheet.createRow(0);
		        header.createCell(0).setCellValue("Stock Symbol");

		        for (int i = 0; i < stocks.size(); i++) {
		            Row row = sheet.createRow(i + 1);
		            row.createCell(0).setCellValue(stocks.get(i));
		        }

		        ByteArrayOutputStream baos = new ByteArrayOutputStream();
		        workbook.write(baos);
		        workbook.close();
		        return baos.toByteArray();
		    }

		    public byte[] exportToPDF(List<String> stocks) throws IOException {
		        ByteArrayOutputStream baos = new ByteArrayOutputStream();
		        PdfWriter writer = new PdfWriter(baos);
		        PdfDocument pdfDoc = new PdfDocument(writer);
		        Document document = new Document(pdfDoc);

		        document.add(new Paragraph("Top Moving Stocks").setBold().setFontSize(14));
		        for (String stock : stocks) {
		            document.add(new Paragraph(stock));
		        }

		        document.close();
		        return baos.toByteArray();
		    }
		}