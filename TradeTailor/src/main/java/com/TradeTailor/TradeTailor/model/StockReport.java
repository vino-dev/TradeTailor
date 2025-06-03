package com.TradeTailor.TradeTailor.model;

import java.util.List;

public class StockReport {
    private CompanyInfo companyInfo;
    private List<ohlvc_report> ohlcvData; // Assuming Ohlcv_report is the correct type
    private TechnicalIndicators technicalIndicators;
    private financialStatementsAnnual annualStatements; // Corrected class name
    private FinancialStatementsQuarter quarterStatements;

    public StockReport() {
        super();
    }

    public CompanyInfo getCompanyInfo() {
        return companyInfo;
    }

    public void setCompanyInfo(CompanyInfo companyInfo) {
        this.companyInfo = companyInfo;
    }

    // --- FIX START ---
    // Changed parameter type from List<Ohlcv> to List<Ohlcv_report>
    public List<ohlvc_report> getOhlcvData() {
        return ohlcvData;
    }

    public void setOhlcvData(List<ohlvc_report> ohlcvData) { // Corrected parameter type
        this.ohlcvData = ohlcvData;
    }
    // --- FIX END ---

    public TechnicalIndicators getTechnicalIndicators() {
        return technicalIndicators;
    }

    public void setTechnicalIndicators(TechnicalIndicators technicalIndicators) {
        this.technicalIndicators = technicalIndicators;
    }

    public financialStatementsAnnual getAnnualStatements() { // Corrected getter name
        return annualStatements;
    }

    public void setAnnualStatements(financialStatementsAnnual annualStatements) { // Corrected parameter type
        this.annualStatements = annualStatements;
    }

    public FinancialStatementsQuarter getQuarterStatements() {
        return quarterStatements;
    }

    public void setQuarterStatements(FinancialStatementsQuarter quarterStatements) {
        this.quarterStatements = quarterStatements;
    }

    public StockReport(CompanyInfo companyInfo, List<ohlvc_report> ohlcvData, TechnicalIndicators technicalIndicators,
                       financialStatementsAnnual annualStatements, FinancialStatementsQuarter quarterStatements) { // Corrected parameter type
        super();
        this.companyInfo = companyInfo;
        this.ohlcvData = ohlcvData;
        this.technicalIndicators = technicalIndicators;
        this.annualStatements = annualStatements;
        this.quarterStatements = quarterStatements;
    }
}