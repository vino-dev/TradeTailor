package com.TradeTailor.TradeTailor.controller;

import com.TradeTailor.TradeTailor.service.StockServiceInterface;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.TradeTailor.TradeTailor.Entity.Advisor;
import com.TradeTailor.TradeTailor.service.*;

import java.text.DecimalFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.stream.Collectors;

@Controller 
public class AdvisorPageController {

    @Autowired
    private StockServiceInterface stockServiceInter;
    @Autowired
    private StockService stockservice;

    @Autowired
    private ObjectMapper objectMapper;

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";  
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "login"; 
    }

    @GetMapping("/verify-otp")
    public String showOtpPage() {
        return "verify-otp"; 
    }

    @GetMapping("/home")
    public String home(HttpSession session, Model model) {
        Advisor advisor = (Advisor) session.getAttribute("loggedInAdvisor");
        if (advisor == null) {
            return "login";
        }

        // Stock performance data
        Map<String, Double> stockData = stockServiceInter.getStockPerformanceData();
        model.addAttribute("stockData", stockData);

        // Add advisor details to model
        model.addAttribute("name", advisor.getName());
        model.addAttribute("email", advisor.getEmail());
        model.addAttribute("mobile", advisor.getMobile());

        return "homepage"; // JSP will use ${name}, ${email}, etc.
    }
    //dsfghsdavdvafgds
    //dfgh

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate(); 
        return "login"; // redirect user to login page after logout
    }
    
    @GetMapping("/export/pdf")
    public void exportToPdf(@RequestParam("symbol") String symbol, HttpServletResponse response) {
        stockServiceInter.exportToPdf(symbol, response);
    }

    @GetMapping("/export/excel")
    public void exportToExcel(@RequestParam("symbol") String symbol, HttpServletResponse response) {
        stockServiceInter.exportToExcel(symbol, response);
    }

}