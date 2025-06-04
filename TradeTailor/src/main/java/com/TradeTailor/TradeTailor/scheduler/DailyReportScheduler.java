package com.TradeTailor.TradeTailor.scheduler;

import com.TradeTailor.TradeTailor.service.DailyReportService;
import com.TradeTailor.TradeTailor.service.ReportCustomizerService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
public class DailyReportScheduler {

    @Autowired
    private ReportCustomizerService dailyReportService;

    // Schedule to run every day at 11:00 AM
    @Scheduled(cron = "0 0 11 * * ?",zone = "Asia/Kolkata")
    public void sendDailyMarketReport() throws Exception {
    	 String recipient = "vinosekar210@gmail.com";
         String timeRange = "1W"; // Default
         dailyReportService.sendCustomReportEmail(recipient, "earnings", timeRange, null, null); // Fetch data inside service
         System.out.println("Daily report sent at 11:00 AM");
     }
} 