package com.TradeTailor.TradeTailor.service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Service;

import com.TradeTailor.TradeTailor.Entity.Advisor;
import com.TradeTailor.TradeTailor.Entity.OtpEntry;
import com.TradeTailor.TradeTailor.repository.AdvisorRepository;
import com.TradeTailor.TradeTailor.repository.OtpRepository;

import org.springframework.security.crypto.password.PasswordEncoder;
@Service
public class AdvisorService {

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private AdvisorRepository advisorRepository;

    @Autowired
    private OtpRepository otpRepository;

    public String registerAdvisor(Advisor advisor) {
        if (advisor.getUsername() == null || advisor.getUsername().isEmpty()) {
            String name = advisor.getName().replaceAll("\\s+", "");
            advisor.setUsername(name.toLowerCase());
        }

        advisor.setPassword(passwordEncoder.encode(advisor.getPassword()));
        advisor.setVerified(false);

        advisorRepository.save(advisor);

        String otp = generateOtp();
        LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);
        otpRepository.save(new OtpEntry(advisor.getEmail(), otp, expiry));
        sendOtpEmail(advisor.getEmail(), otp);

        return "OTP sent to " + advisor.getEmail();
    }

    public boolean verifyOtp(String email, String otp) {
        OtpEntry entry = otpRepository.findById(email).orElse(null);
        if (entry == null || !entry.getOtp().equals(otp) || entry.getExpiry().isBefore(LocalDateTime.now())) {
            return false;
        }

        Advisor advisor = advisorRepository.findByEmail(email).orElse(null);
        if (advisor != null) {
            advisor.setVerified(true);
            advisorRepository.save(advisor);
        }

        otpRepository.delete(entry);
        return true;
    }


    public boolean login(String username, String rawPassword) {
        Optional<Advisor> optionalAdvisor = advisorRepository.findByUsername(username);
        if (optionalAdvisor.isPresent()) {
            Advisor advisor = optionalAdvisor.get();
            boolean isMatch = passwordEncoder.matches(rawPassword, advisor.getPassword());
            System.out.println("Login attempt: username=" + username + ", verified=" + advisor.isVerified() + ", passwordMatch=" + isMatch);
            return advisor.isVerified() && isMatch;
        }
        System.out.println("Login failed: Username not found -> " + username);
        return false;
    }


    private String generateOtp() {
        return String.format("%06d", new Random().nextInt(999999));
    }

    private void sendOtpEmail(String toEmail, String otp) {
        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(toEmail);
        message.setSubject("OTP Verification - TradeTailor");
        message.setText("Dear Advisor,\n\nYour OTP is: " + otp + "\nThis OTP will expire in 5 minutes.\n\nThanks,\nTradeTailor Team");
        mailSender.send(message);
    }
    
    public Advisor validateLogin(String username, String rawPassword) {
        Optional<Advisor> optionalAdvisor = advisorRepository.findByUsername(username);

        if (optionalAdvisor.isPresent()) {
            Advisor advisor = optionalAdvisor.get();
            if (passwordEncoder.matches(rawPassword, advisor.getPassword())) {
                return advisor;
            }
        }

        return null;
    }
}
