package com.TradeTailor.TradeTailor.model;

public class StockNews {
    private String headline;
    private String source;
    private String url;
    private String datetime;

    // Constructors
    public StockNews() {}

    public StockNews(String headline, String source, String url, String datetime) {
        this.headline = headline;
        this.source = source;
        this.url = url;
        this.datetime = datetime;
    }

    // Getters & Setters
    public String getHeadline() { return headline; }
    public void setHeadline(String headline) { this.headline = headline; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    public String getUrl() { return url; }
    public void setUrl(String url) { this.url = url; }

    public String getDatetime() { return datetime; }
    public void setDatetime(String datetime) { this.datetime = datetime; }
}
