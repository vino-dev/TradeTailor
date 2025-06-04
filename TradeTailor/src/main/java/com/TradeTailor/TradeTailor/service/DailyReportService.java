package com.TradeTailor.TradeTailor.service;

import com.itextpdf.kernel.pdf.PdfDocument;
import com.itextpdf.kernel.pdf.PdfWriter;
import com.itextpdf.layout.Document;
import com.itextpdf.layout.element.Paragraph;
import com.itextpdf.layout.element.Table;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.List;

@Service
public class DailyReportService {

    @Autowired
    private JavaMailSender mailSender;

    public void generateAndSendFullDailyReport() {
        try {
            ByteArrayOutputStream baos = new ByteArrayOutputStream();
            PdfWriter writer = new PdfWriter(baos);
            PdfDocument pdf = new PdfDocument(writer);
            Document doc = new Document(pdf);

            doc.add(new Paragraph("Daily Market Summary Report - TradeTailor").setBold().setFontSize(18));

            // 1. Market Summary (Dummy for now)
            doc.add(new Paragraph("\n1. Market Summary:"));
            doc.add(new Paragraph("Nifty 50: 22,340.45 (+0.52%)\nSensex: 74,890.20 (+0.48%)"));

            // 2. Top Gainers/Losers (Example)
            doc.add(new Paragraph("\n2. Top Gainers:")).setBold();
            Table gainers = new Table(3).useAllAvailableWidth();
            gainers.addCell("Symbol").addCell("Price").addCell("% Change");
            gainers.addCell("TCS").addCell("3800").addCell("+2.5%");
            gainers.addCell("INFY").addCell("1450").addCell("+2.2%");
            doc.add(gainers);

            doc.add(new Paragraph("\nTop Losers:")).setBold();
            Table losers = new Table(3).useAllAvailableWidth();
            losers.addCell("Symbol").addCell("Price").addCell("% Change");
            losers.addCell("ADANIENT").addCell("2150").addCell("-3.1%");
            losers.addCell("JSWSTEEL").addCell("890").addCell("-2.8%");
            doc.add(losers);

            // 3. FII/DII
            doc.add(new Paragraph("\n3. FII/DII Activity:"));
            doc.add(new Paragraph("FII Net Buy: ₹1,234 Cr\nDII Net Sell: ₹789 Cr"));

            // 4. Volume Shockers (Example)
            doc.add(new Paragraph("\n4. Volume Shockers:"));
            Table shockers = new Table(3).useAllAvailableWidth();
            shockers.addCell("Symbol").addCell("Volume").addCell("% Surge");
            shockers.addCell("HDFC" ).addCell("1.2M").addCell("+400%");
            shockers.addCell("IOC"   ).addCell("950K").addCell("+350%");
            doc.add(shockers);

            // 5. Upcoming Earnings
            doc.add(new Paragraph("\n5. Earnings Calendar (Next 3 Days):"));
            Table earnings = new Table(3).useAllAvailableWidth();
            earnings.addCell("Symbol").addCell("Date").addCell("EPS Estimate");
            earnings.addCell("MSFT").addCell("2025-06-04").addCell("2.45");
            earnings.addCell("AAPL").addCell("2025-06-04").addCell("1.35");
            doc.add(earnings);

            // 6. Technical Signals (Example)
            doc.add(new Paragraph("\n6. Technical Signals (RSI/Breakouts):"));
            doc.add(new Paragraph("RSI < 30: WIPRO, TECHM\nRSI > 70: LT, COFORGE"));

            // 7. Watchlist Changes (Example)
            doc.add(new Paragraph("\n7. Watchlist Movers:"));
            doc.add(new Paragraph("Your stock TCS moved +2.5%, INFY moved +2.2%"));

            doc.close();

            // Email to fixed recipient list
            List<String> recipients = Arrays.asList("advisor1@example.com", "advisor2@example.com");

            for (String email : recipients) {
                sendEmailWithAttachment(email, baos.toByteArray());
            }

        } catch (Exception e) {
            System.err.println("Error generating daily report: " + e.getMessage());
        }
    }

    private void sendEmailWithAttachment(String to, byte[] pdfBytes) throws Exception {
        jakarta.mail.internet.MimeMessage message = mailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, true);
        helper.setTo(to);
        helper.setSubject("Daily TradeTailor Report");
        helper.setText("Hi,\n\nPlease find attached your daily market report.\n\n- TradeTailor Team");
        helper.addAttachment("Daily_Report.pdf", new ByteArrayResource(pdfBytes));
        mailSender.send(message);
    }

} 
