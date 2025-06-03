package com.TradeTailor.TradeTailor.model;

import java.util.List;
import java.util.Map;

public class financialStatementsAnnual {
	 private List<Map<String, String>> income;
	    private List<Map<String, String>> balanceSheet;
	    private List<Map<String, String>> cashFlow;
		public List<Map<String, String>> getIncome() {
			return income;
		}
		
		public financialStatementsAnnual() {
			
		}

		public financialStatementsAnnual(List<Map<String, String>> income, List<Map<String, String>> balanceSheet,
				List<Map<String, String>> cashFlow) {
			super();
			this.income = income;
			this.balanceSheet = balanceSheet;
			this.cashFlow = cashFlow;
		}

		public void setIncome(List<Map<String, String>> income) {
			this.income = income;
		}
		public List<Map<String, String>> getBalanceSheet() {
			return balanceSheet;
		}
		public void setBalanceSheet(List<Map<String, String>> balanceSheet) {
			this.balanceSheet = balanceSheet;
		}
		public List<Map<String, String>> getCashFlow() {
			return cashFlow;
		}
		public void setCashFlow(List<Map<String, String>> cashFlow) {
			this.cashFlow = cashFlow;
		}
	    
}
