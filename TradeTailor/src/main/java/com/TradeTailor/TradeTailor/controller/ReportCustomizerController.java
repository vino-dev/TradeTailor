package com.TradeTailor.TradeTailor.controller;

import com.TradeTailor.TradeTailor.model.EarningsReport;
import com.TradeTailor.TradeTailor.service.EarningsService;
import com.TradeTailor.TradeTailor.service.ReportService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDate;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class ReportCustomizerController {

    @Autowired
    private ReportService reportService;

    @Autowired
    private EarningsService earningsService;

    @GetMapping("/reportCustomizer")
    public String showReportCustomizer() {
        return "reportCustomizer";
    }

    @PostMapping("/sendCustomReport")
    public String sendCustomReport(@RequestParam("symbol") String symbol,
                                   @RequestParam("timeRange") String timeRange,
                                   @RequestParam(value = "includeChart", required = false) boolean includeChart,
                                   @RequestParam(value = "includeTable", required = false) boolean includeTable,
                                   @RequestParam("recipientEmail") String recipientEmail,
                                   @RequestParam("chartImage") String chartImageBase64,
                                   Model model) {
        try {
            List<EarningsReport> rawEarnings = earningsService.getUpcomingEarnings();
            List<EarningsReport> filteredEarnings = filterEarningsByTimeRange(rawEarnings, timeRange);

            List<Map<String, String>> dataForReport = filteredEarnings.stream().map(e -> {
                Map<String, String> map = new HashMap<>();
                map.put("symbol", e.getSymbol());
                map.put("date", e.getDate());
                map.put("epsEstimate", e.getEpsEstimate());
                map.put("epsActual", e.getEpsActual());
                map.put("revenueEstimate", e.getRevenueEstimate());
                map.put("revenueActual", e.getRevenueActual());
                return map;
            }).collect(Collectors.toList());

            reportService.sendCustomReportEmail(recipientEmail, "earnings", timeRange, dataForReport, chartImageBase64);

            model.addAttribute("message", "Custom report sent successfully to " + recipientEmail + "!");
            model.addAttribute("messageType", "success");

        } catch (Exception e) {
            model.addAttribute("message", "Failed to send custom report. Please try again.");
            model.addAttribute("messageType", "error");
        }
        return "reportCustomizer";
    }

    private List<EarningsReport> filterEarningsByTimeRange(List<EarningsReport> earnings, String timeRange) {
        LocalDate now = LocalDate.now();
        return earnings.stream().filter(e -> {
            LocalDate earningsDate = LocalDate.parse(e.getDate());
            return switch (timeRange) {
                case "1D" -> earningsDate.isEqual(now);
                case "1W" -> !earningsDate.isBefore(now) && !earningsDate.isAfter(now.plusWeeks(1));
                case "1M" -> !earningsDate.isBefore(now) && !earningsDate.isAfter(now.plusMonths(1));
                case "1Y" -> !earningsDate.isBefore(now) && !earningsDate.isAfter(now.plusYears(1));
                default -> false;
            };
        }).collect(Collectors.toList());
    }
}
