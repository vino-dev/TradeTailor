package com.TradeTailor.TradeTailor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class GenerateReportController {

    @GetMapping("/generateReport")
    public String showGenerateReport() {
        return "generateReport";
    }
}
