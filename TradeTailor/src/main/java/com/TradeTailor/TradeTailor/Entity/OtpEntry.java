package com.TradeTailor.TradeTailor.Entity;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import java.time.LocalDateTime;

@Entity
public class OtpEntry {

    @Id
    private String email;
    private String otp;
    private LocalDateTime expiry;

    public OtpEntry() {}

    public OtpEntry(String email, String otp, LocalDateTime expiry) {
        this.email = email;
        this.otp = otp;
        this.expiry = expiry;
    }

    // Getters
    public String getEmail() {
        return email;
    }

    public String getOtp() {
        return otp;
    }

    public LocalDateTime getExpiry() {
        return expiry;
    }

    // Setters
    public void setEmail(String email) {
        this.email = email;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public void setExpiry(LocalDateTime expiry) {
        this.expiry = expiry;
    }

    @Override
    public String toString() {
        return "OtpEntry [email=" + email + ", otp=" + otp + ", expiry=" + expiry + "]";
    }
}
