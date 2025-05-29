package com.TradeTailor.TradeTailor.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdvisorPageController {

    @GetMapping("/register")
    public String showRegisterPage() {
        return "register";  // shows register.jsp
    }

    @GetMapping("/login")
    public String showLoginPage() {
        return "login";  // shows login.jsp
    }

    @GetMapping("/home")
    public String showHomePage() {
        return "home";  // shows home.jsp after successful login
    }
    
    @GetMapping("/verify-otp")
    public String showOtpPage() {
        return "verify-otp"; // loads verify-otp.jsp
    }

}
