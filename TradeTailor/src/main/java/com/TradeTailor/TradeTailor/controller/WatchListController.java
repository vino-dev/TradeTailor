package com.TradeTailor.TradeTailor.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.TradeTailor.TradeTailor.Entity.Advisor;
import com.TradeTailor.TradeTailor.model.Watchlist;
import com.TradeTailor.TradeTailor.service.WatchlistService;

import jakarta.servlet.http.HttpSession;

import java.util.List;

@Controller 
public class WatchListController {

    @Autowired 
    private WatchlistService quoteService;

    @GetMapping("/watchlist")
    public String showWatchlist(HttpSession session,Model model) {
    	 Advisor advisor = (Advisor) session.getAttribute("loggedInAdvisor");
         if (advisor == null) {
             return "login";
         }
         model.addAttribute("name", advisor.getName());
         model.addAttribute("email", advisor.getEmail());
         model.addAttribute("mobile", advisor.getMobile());
        List<Watchlist> quotes = quoteService.getTop20Quotes();
        model.addAttribute("quotes", quotes);
        return "watchlist";  
    }
}
