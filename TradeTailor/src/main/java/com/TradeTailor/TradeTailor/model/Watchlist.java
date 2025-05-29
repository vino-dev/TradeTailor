package com.TradeTailor.TradeTailor.model;

public class Watchlist {
    private String symbol;
    private String companyName;
    private double open;
    private double high;
    private double low;
    private double close;
    private long volume;
    private double change;
    private String logoUrl;

    public Watchlist(String symbol, String companyName, double open, double high, double low,
                     double close, long volume, double change, String logoUrl) {
        this.symbol = symbol;
        this.companyName = companyName;
        this.open = open;
        this.high = high;
        this.low = low;
        this.close = close;
        this.volume = volume;
        this.change = change;
        this.logoUrl = logoUrl;
    }

    public String getSymbol() {
        return symbol;
    }

    public String getCompanyName() {
        return companyName;
    }

    public double getOpen() {
        return open;
    }

    public double getHigh() {
        return high;
    }

    public double getLow() {
        return low;
    }

    public double getClose() {
        return close;
    }

    public long getVolume() {
        return volume;
    }

    public double getChange() {
        return change;
    }

    public String getLogoUrl() {
        return logoUrl;
    }
}
