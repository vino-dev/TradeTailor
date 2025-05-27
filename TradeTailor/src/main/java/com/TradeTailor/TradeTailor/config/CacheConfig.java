package com.TradeTailor.TradeTailor.config;

import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Configuration;

@Configuration
@EnableCaching
public class CacheConfig {
    // Spring Boot auto-configures RedisCacheManager if spring-boot-starter-data-redis is on the classpath.
}