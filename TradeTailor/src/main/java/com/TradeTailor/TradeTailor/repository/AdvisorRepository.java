package com.TradeTailor.TradeTailor.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.TradeTailor.TradeTailor.Entity.Advisor;

public interface AdvisorRepository extends JpaRepository<Advisor, Long> {
    Optional<Advisor> findByEmail(String email);
    Optional<Advisor> findByUsername(String username);
}
