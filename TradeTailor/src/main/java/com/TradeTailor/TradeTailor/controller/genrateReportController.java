package com.TradeTailor.TradeTailor.controller;

import java.text.DecimalFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Random;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class genrateReportController {

	  @PostMapping("/generateReport")
	    public String generateReport(@RequestParam String symbol, Model model) {
	        // Generate dummy data for 30 days
	        Map<String, Double> stockData = new LinkedHashMap<>();
	        Map<String, Integer> volumeData = new LinkedHashMap<>();
	        Map<String, Double> forecastData = new LinkedHashMap<>();

	        List<String> labels = new ArrayList<>();
	        List<Double> prices = new ArrayList<>();
	        List<Integer> volumes = new ArrayList<>();
	        List<Double> forecasts = new ArrayList<>();

	        LocalDate today = LocalDate.now();
	        Random random = new Random();
	        double price = 100.0;

	        DecimalFormat df = new DecimalFormat("#.##");

	        for (int i = 29; i >= 0; i--) {
	            LocalDate date = today.minusDays(i);
	            price += random.nextDouble() * 4 - 2; // ±2 fluctuation
	            price = Double.parseDouble(df.format(price));
	            int volume = 1000 + random.nextInt(5000);
	            double forecast = price + random.nextDouble() * 4 - 2;

	            String dateStr = date.toString();
	            stockData.put(dateStr, price);
	            volumeData.put(dateStr, volume);
	            forecastData.put(dateStr, Double.parseDouble(df.format(forecast)));

	            labels.add("\"" + dateStr + "\"");
	            prices.add(price);
	            volumes.add(volume);
	            forecasts.add(Double.parseDouble(df.format(forecast)));
	        }

	        // Inject model attributes for JSP
	        model.addAttribute("symbol", symbol);
	        model.addAttribute("stockData", stockData);
	        model.addAttribute("volumeData", volumeData);
	        model.addAttribute("forecastData", forecastData);

	        model.addAttribute("labels", labels.toString());
	        model.addAttribute("prices", prices.toString());
	        model.addAttribute("volumes", volumes.toString());
	        model.addAttribute("forecasts", forecasts.toString());
	        return "generateReport"; // maps to generatereport.jsp
	    }

	    @GetMapping("/generateReport") // Changed to /generateReport for consistency with JSP form action
	    public String showInitialReportPage(Model model) {
	        return "generateReport"; // This maps to generateReport.jsp
	    }
}
