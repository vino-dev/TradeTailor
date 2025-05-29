package com.TradeTailor.TradeTailor.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import com.TradeTailor.TradeTailor.Entity.Advisor;
import com.TradeTailor.TradeTailor.service.AdvisorService;

@RestController
@RequestMapping("/api")
public class AdvisorController {

    @Autowired
    private AdvisorService service;

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody Advisor advisor) {
        String result = service.registerAdvisor(advisor);
        return ResponseEntity.ok(result);
    }

    @PostMapping("/verify-otp")
    public ResponseEntity<String> verifyOtp(@RequestBody Map<String, String> body) {
        boolean success = service.verifyOtp(body.get("email"), body.get("otp"));
        return success ? ResponseEntity.ok("OTP verified") : ResponseEntity.status(400).body("Invalid OTP");
    }

    @PostMapping("/login")
    public ResponseEntity<String> login(@RequestBody Map<String, String> body) {
        boolean success = service.login(body.get("username"), body.get("password"));
        return success ? ResponseEntity.ok("Login successful") : ResponseEntity.status(401).body("Login failed");
    }
    
    
}
