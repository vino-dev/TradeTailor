// File: EarningsReport.java
package com.TradeTailor.TradeTailor.model;

public class EarningsReport {
    private String symbol;
    private String date;
    private String epsEstimate;
    private String epsActual;
    private String revenueEstimate;
    private String revenueActual;

    public EarningsReport() {}

    public EarningsReport(String symbol, String date, String epsEstimate, String epsActual,
                          String revenueEstimate, String revenueActual) {
        this.symbol = symbol;
        this.date = date;
        this.epsEstimate = epsEstimate;
        this.epsActual = epsActual;
        this.revenueEstimate = revenueEstimate;
        this.revenueActual = revenueActual;
    }

    // Getters and Setters for all fields
    public String getSymbol() { return symbol; }
    public void setSymbol(String symbol) { this.symbol = symbol; }

    public String getDate() { return date; }
    public void setDate(String date) { this.date = date; }

    public String getEpsEstimate() { return epsEstimate; }
    public void setEpsEstimate(String epsEstimate) { this.epsEstimate = epsEstimate; }

    public String getEpsActual() { return epsActual; }
    public void setEpsActual(String epsActual) { this.epsActual = epsActual; }

    public String getRevenueEstimate() { return revenueEstimate; }
    public void setRevenueEstimate(String revenueEstimate) { this.revenueEstimate = revenueEstimate; }

    public String getRevenueActual() { return revenueActual; }
    public void setRevenueActual(String revenueActual) { this.revenueActual = revenueActual; }
}
