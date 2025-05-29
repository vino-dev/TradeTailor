package com.TradeTailor.TradeTailor.model;

public class CompanyProfile {
    private String name;
    private String logo;

    public CompanyProfile(String name, String logo) {
        this.name = name;
        this.logo = logo;
    }

    public String getName() {
        return name;
    }

    public String getLogo() {
        return logo;
    }
}
