package com.TradeTailor.TradeTailor.controller;

import com.TradeTailor.TradeTailor.model.CalendarEvent;
import com.TradeTailor.TradeTailor.model.StockNews;
import com.TradeTailor.TradeTailor.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import java.util.List;
import java.util.Map;

@Controller
public class DashboardController {

    @Autowired
    private DashboardService service;

    @GetMapping("/dashboard")
    public String showMarketDashboard(Model model) {
        Map<String, Object> usStatus = service.getUSMarketStatus();
        model.addAttribute("usStatus", usStatus);
    	Map<String, Double> closePrices = service.getTop20ClosePrices();
        model.addAttribute("topQuotes",closePrices);
        List<StockNews> newsList = service.fetchGeneralNews();
        model.addAttribute("newsList", newsList);
        List<CalendarEvent> events = service.fetchCombinedCalendar();
        model.addAttribute("events", events);
        Map<String, String[]> indices =service.getTopIndicesData();
        Map<String, Long> volumes = service.getTopSymbolsVolumeData();

        model.addAttribute("indices", indices);
        model.addAttribute("volumes", volumes);
        return "dashboard";
    }
}
