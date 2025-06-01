package com.TradeTailor.TradeTailor.model;

public class CalendarEvent implements Comparable<CalendarEvent> {
    private String date;   // yyyy-MM-dd
    private String type;
    private String title;
    private String details;

    public CalendarEvent() {}

    public CalendarEvent(String date, String type, String title, String details) {
        this.date = date;
        this.type = type;
        this.title = title;
        this.details = details;
    }

    // Getters and setters
    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    @Override
    public int compareTo(CalendarEvent other) {
        // Simple string compare works for yyyy-MM-dd date format
        return this.date.compareTo(other.getDate());
    }
}
