package com.TradeTailor.TradeTailor.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.TradeTailor.TradeTailor.model.Watchlist;
import com.TradeTailor.TradeTailor.service.WatchlistService;

import java.util.List;

@Controller 
public class WatchListController {

    @Autowired 
    private WatchlistService quoteService;

    @GetMapping("/watchlist")
    public String showWatchlist(Model model) {
        List<Watchlist> quotes = quoteService.getTop20Quotes();
        model.addAttribute("quotes", quotes);
        return "watchlist";  
    }
}
