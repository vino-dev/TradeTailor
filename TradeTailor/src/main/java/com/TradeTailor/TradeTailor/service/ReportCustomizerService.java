package com.TradeTailor.TradeTailor.service;

import com.itextpdf.io.image.ImageDataFactory;
import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.*;

import jakarta.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.InputStreamSource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import java.io.ByteArrayOutputStream;
import java.util.Base64;
import java.util.List;
import java.util.Map;

@Service
public class ReportCustomizerService {

	  @Autowired
	    private JavaMailSender mailSender;

	    public void sendCustomReportEmail(String recipientEmail, String reportType, String timeRange,
	                                      List<Map<String, String>> dataForReport, String base64ChartImage) throws Exception {

	        ByteArrayOutputStream baos = new ByteArrayOutputStream();
	        PdfWriter writer = new PdfWriter(baos);
	        PdfDocument pdfDoc = new PdfDocument(writer);
	        Document document = new Document(pdfDoc);

	        document.add(new Paragraph("Trade Tailor Daily Stock Report").setBold().setFontSize(18));
	        document.add(new Paragraph("Report Type: " + reportType));
	        document.add(new Paragraph("Time Range: " + timeRange));
	        document.add(new Paragraph(" "));

	        if (base64ChartImage != null && !base64ChartImage.isEmpty()) {
	            try {
	                String base64 = base64ChartImage.split(",", 2)[1];
	                byte[] imageBytes = Base64.getDecoder().decode(base64);
	                Image chart = new Image(ImageDataFactory.create(imageBytes)).scaleToFit(500, 300);
	                document.add(chart);
	            } catch (Exception e) {
	                document.add(new Paragraph("[Chart Image Unavailable or Invalid]"));
	            }
	        }

	        if (dataForReport != null && !dataForReport.isEmpty()) {
	            Map<String, String> sample = dataForReport.get(0);
	            Table table = new Table(sample.keySet().size());

	            for (String key : sample.keySet()) {
	                table.addHeaderCell(new Cell().add(new Paragraph(key).setBold()));
	            }

	            for (Map<String, String> row : dataForReport) {
	                for (String key : sample.keySet()) {
	                    table.addCell(row.getOrDefault(key, ""));
	                }
	            }

	            document.add(table);
	        } else {
	            document.add(new Paragraph("No data available for the selected time range."));
	        }

	        document.close();

	        MimeMessage message = mailSender.createMimeMessage();
	        MimeMessageHelper helper = new MimeMessageHelper(message, true);
	        helper.setTo(recipientEmail);
	        helper.setSubject("Your Trade Tailor Daily Report");
	        helper.setText("Hi,\n\nPlease find attached your customized stock report.\n\nRegards,\nTrade Tailor Team");

	        InputStreamSource attachment = new ByteArrayResource(baos.toByteArray());
	        helper.addAttachment("TradeTailor_Report.pdf", attachment);

	        mailSender.send(message);
	    }

	    public List<Map<String, String>> fetchRealEarningsData() {
	        // Replace this logic with actual Finnhub API integration
	        return List.of(
	            Map.of("Symbol", "AAPL", "Date", "2025-06-04", "EPS Estimate", "1.23"),
	            Map.of("Symbol", "MSFT", "Date", "2025-06-04", "EPS Estimate", "2.01")
	        );
	    }

	    public String generateChartImageBase64(List<Map<String, String>> data) {
	        // Integrate chart generation logic here or accept from frontend
	        return "data:image/png;base64,...";
	    }
	}
