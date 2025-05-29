package com.TradeTailor.TradeTailor.repository;

import org.springframework.data.jpa.repository.JpaRepository;

import com.TradeTailor.TradeTailor.Entity.OtpEntry;

public interface OtpRepository extends JpaRepository<OtpEntry, String> {
	
}
