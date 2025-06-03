package com.TradeTailor.TradeTailor.service;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartUtils;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Map;
@Service
public class ChartService {

    public byte[] generateStockPerformanceChart(Map<String, Double> stockData) throws IOException {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (Map.Entry<String, Double> entry : stockData.entrySet()) {
            dataset.addValue(entry.getValue(), "Price", entry.getKey());
        }

        JFreeChart chart = ChartFactory.createBarChart(
                "Stock Performance",
                "Stock",
                "Price",
                dataset,
                PlotOrientation.VERTICAL,
                false, true, false);

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ChartUtils.writeChartAsPNG(baos, chart, 800, 600);
        return baos.toByteArray();
    }
}