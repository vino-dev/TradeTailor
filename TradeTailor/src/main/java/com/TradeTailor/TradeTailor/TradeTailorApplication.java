package com.TradeTailor.TradeTailor;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan(basePackages = {"com.TradeTailor.TradeTailor.config", "com.TradeTailor.TradeTailor.controller",
		"com.TradeTailor.TradeTailor.model","com.TradeTailor.TradeTailor.service"})

public class TradeTailorApplication {

	public static void main(String[] args) {
		SpringApplication.run(TradeTailorApplication.class, args);
	}

}
