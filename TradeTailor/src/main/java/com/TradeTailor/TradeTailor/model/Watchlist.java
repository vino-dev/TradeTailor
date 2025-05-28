package com.TradeTailor.TradeTailor.model;

public class QuoteDTO {
	 private String symbol;
	    private String companyName;
	    private double open;
	    private double high;
	    private double low;
	    private double close;
	    private long volume;
	    private double change;

	    // Getters and setters
	    public String getSymbol() { return symbol; }
	    public void setSymbol(String symbol) { this.symbol = symbol; }

	    public String getCompanyName() { return companyName; }
	    public void setCompanyName(String companyName) { this.companyName = companyName; }

	    public double getOpen() { return open; }
	    public void setOpen(double open) { this.open = open; }

	    public double getHigh() { return high; }
	    public void setHigh(double high) { this.high = high; }

	    public double getLow() { return low; }
	    public void setLow(double low) { this.low = low; }

	    public double getClose() { return close; }
	    public void setClose(double close) { this.close = close; }

	    public long getVolume() { return volume; }
	    public void setVolume(long volume) { this.volume = volume; }

	    public double getChange() { return change; }
	    public void setChange(double change) { this.change = change; }
	}