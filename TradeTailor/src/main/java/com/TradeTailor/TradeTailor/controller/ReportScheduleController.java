package com.TradeTailor.TradeTailor.controller;

import com.TradeTailor.TradeTailor.service.EmailSchedulerService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ReportScheduleController {

    @Autowired
    private EmailSchedulerService schedulerService;

    @PostMapping("/scheduleReportEmail")
    public String scheduleEmail(@RequestParam("email") String email) {
        schedulerService.addEmail(email);
        return "confirmation";
    }
    
   

}