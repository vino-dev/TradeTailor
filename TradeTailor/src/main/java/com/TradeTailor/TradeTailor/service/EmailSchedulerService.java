// File: EmailSchedulerServiceImpl.java
package com.TradeTailor.TradeTailor.service;

import com.TradeTailor.TradeTailor.model.StockReport;
import com.TradeTailor.TradeTailor.service.EmailSchedulerService;
import com.TradeTailor.TradeTailor.service.ReportCustomizerService;

import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.InputStreamSource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;

	import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Service
public class EmailSchedulerService implements EmailSchedulerServiceInterface {

	private final Set<String> subscribedEmails = new HashSet<>();

	@Autowired
	private ReportCustomizerService reportService;

	@Autowired
    private JavaMailSender mailSender;

	
	@Autowired
	private ReportService reportService2;

	@Override
	public void addEmail(String email) {
		subscribedEmails.add(email);
	}

	@Scheduled(cron = "0 7 15 * * *", zone = "Asia/Kolkata")
	public void sendDailyReports() {
		for (String email : subscribedEmails) {
			try {
				List<Map<String, String>> reportData = reportService.fetchRealEarningsData();

				// Generate chart base64 image
				String chartBase64 = reportService.generateChartImageBase64(reportData);

				// Generate PDF for user's chosen symbol
				StockReport stockReport = reportService2.getReport(chartBase64);
				ByteArrayOutputStream pdfStream = new ByteArrayOutputStream();
				ExportUtils_report.generatePDF(stockReport, pdfStream);

				// Send email with PDF attachment
				sendEmailWithAttachment(email, "Daily Earnings Report for " + chartBase64, reportData, chartBase64,
						pdfStream.toByteArray(), "report_" + chartBase64 + ".pdf");

			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private void sendEmailWithAttachment(String toEmail, String subject, List<Map<String, String>> reportData,
			String chartBase64, byte[] pdfBytes, String pdfFileName) throws MessagingException {

		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

		helper.setTo(toEmail);
		helper.setSubject(subject);

// Email content
		StringBuilder htmlContent = new StringBuilder();
		htmlContent.append("<h2>Trade Tailor Custom Report</h2>");
		htmlContent.append("<p><strong>Report Type:</strong> Earnings</p>");
		htmlContent.append("<p><strong>Time Range:</strong> 1D</p>");
		htmlContent.append("<h3>Upcoming Earnings</h3>");
		htmlContent.append("<table border='1' cellpadding='5' cellspacing='0'>");
		htmlContent.append("<tr><th>Symbol</th><th>Date</th><th>EPS Estimate</th></tr>");
		for (Map<String, String> row : reportData) {
			htmlContent.append("<tr>").append("<td>").append(row.getOrDefault("symbol", "")).append("</td>")
					.append("<td>").append(row.getOrDefault("date", "")).append("</td>").append("<td>")
					.append(row.getOrDefault("epsEstimate", "")).append("</td>").append("</tr>");
		}
		htmlContent.append("</table>");
		htmlContent.append("<p>This report was generated by Trade Tailor.</p>");

		if (chartBase64 != null && !chartBase64.isEmpty()) {
			htmlContent.append("<br/><img src='").append(chartBase64).append("' alt='EPS Chart' width='600'/>");
		}

		helper.setText(htmlContent.toString(), true);

// ✅ Attach the PDF here before sending
		helper.addAttachment(pdfFileName, new ByteArrayResource(pdfBytes));

// ✅ Now send the message
		mailSender.send(message);
	}
}
