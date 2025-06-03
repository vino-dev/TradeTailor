package com.TradeTailor.TradeTailor.service;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfPTable;
import com.itextpdf.text.pdf.PdfWriter;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.util.Map;

@Service
public class Export {
    public byte[] exportToPDF(Map<String, Double> stockData) throws Exception {
        Document document = new Document();
        ByteArrayOutputStream out = new ByteArrayOutputStream();

        PdfWriter.getInstance(document, out);
        document.open();

        PdfPTable table = new PdfPTable(2);
        table.addCell("Symbol");
        table.addCell("Price");

        for (Map.Entry<String, Double> entry : stockData.entrySet()) {
            table.addCell(entry.getKey());
            table.addCell(String.valueOf(entry.getValue()));
        }

        document.add(table);
        document.close();

        return out.toByteArray();
    }
}