package com.TradeTailor.TradeTailor.controller;

import java.util.*;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.TradeTailor.TradeTailor.Entity.Advisor;
import com.TradeTailor.TradeTailor.service.AdvisorService;
import com.TradeTailor.TradeTailor.service.StockServiceInterface;
import com.fasterxml.jackson.databind.ObjectMapper;

@RestController
@RequestMapping("/api")
public class AdvisorController {
 
	@Autowired
	private AdvisorService adser;
    @Autowired
    private StockServiceInterface stockService;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody Advisor advisor) {
        String result = adser.registerAdvisor(advisor);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<String> verifyOtp(@RequestBody Map<String, String> body) {
        boolean success = adser.verifyOtp(body.get("email"), body.get("otp"));
        return success ? ResponseEntity.ok("OTP verified") : ResponseEntity.status(400).body("Invalid OTP");
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody Map<String, String> body) {
        boolean success = adser.login(body.get("username"), body.get("password"));
        return success ? ResponseEntity.ok("Login successful") : ResponseEntity.status(401).body("Login failed");
    }
    
   
    }


    
    
