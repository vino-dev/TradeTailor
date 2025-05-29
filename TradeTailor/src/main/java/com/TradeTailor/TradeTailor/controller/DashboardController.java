package com.TradeTailor.TradeTailor.controller;

import com.TradeTailor.TradeTailor.model.OHLVC;
import com.TradeTailor.TradeTailor.model.Watchlist;
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
        List<Map<String, String>> indexData = service.getMarketIndices();
        List<OHLVC> topQuotes = service.getTop20Quotes();

        model.addAttribute("indices", indexData);
        model.addAttribute("topQuotes", topQuotes);

        return "dashboard";
    }
}
