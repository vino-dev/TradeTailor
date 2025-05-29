package com.TradeTailor.TradeTailor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class AdvisorPageController {

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";  // shows register.jsp
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";  
    }
    
    @GetMapping("/verify-otp")
    public String showOtpPage() {
        return "verify-otp"; // loads verify-otp.jsp
    }
    
    @GetMapping("/homepage")
	public String homepage() {
		return "homepage";	
	}
    @GetMapping("/test") 
public String getd() {
    	return "work";
    }
}
