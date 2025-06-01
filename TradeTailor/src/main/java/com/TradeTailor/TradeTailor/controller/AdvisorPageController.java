package com.TradeTailor.TradeTailor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller 
public class AdvisorPageController {

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
    
    @GetMapping("/homepage")
	public String homepage() {
		return "homepage";	
	}
    
   
    
   
    
}
