package com.TradeTailor.TradeTailor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
@Controller
public class HomeController {
	 @GetMapping("/dashboard")
	    public String welcomePage() {
	        return "<h1>Welcome to Advisor Dashboard!</h1>";
	    }
}
