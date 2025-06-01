package com.TradeTailor.TradeTailor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ReportCustomizerController {

    @GetMapping("/reportCustomizer")
    public String showGenerateReport() {
        return "reportCustomizer";
    }
}
