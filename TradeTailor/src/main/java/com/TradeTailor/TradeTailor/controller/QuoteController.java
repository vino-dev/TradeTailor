package com.TradeTailor.TradeTailor.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.TradeTailor.TradeTailor.model.QuoteDTO;
import com.TradeTailor.TradeTailor.service.QuoteService;

import java.util.List;

@Controller
public class QuoteController {

    @Autowired
    private QuoteService quoteService;

    @GetMapping("/watchlist")
    public String showWatchlist(Model model) {
        List<QuoteDTO> quotes = quoteService.getTop20Quotes();
        model.addAttribute("quotes", quotes);
        return "watchlist";  // returns watchlist.jsp
    }
}