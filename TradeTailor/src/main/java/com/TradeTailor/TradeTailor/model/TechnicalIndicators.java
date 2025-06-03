package com.TradeTailor.TradeTailor.model;

import java.util.Map;

public class TechnicalIndicators {
	  private Map<String, String> sma;
	    private Map<String, String> ema;
	    private Map<String, String> rsi;
	    private Map<String, String> macd;
	    private Map<String, String> bollinger;
	    private Map<String, String> atr;
		public Map<String, String> getSma() {
			return sma;
		}
		public void setSma(Map<String, String> sma) {
			this.sma = sma;
		}
		public Map<String, String> getEma() {
			return ema;
		}
		public void setEma(Map<String, String> ema) {
			this.ema = ema;
		}
		public Map<String, String> getRsi() {
			return rsi;
		}
		public void setRsi(Map<String, String> rsi) {
			this.rsi = rsi;
		}
		public Map<String, String> getMacd() {
			return macd;
		}
		public void setMacd(Map<String, String> macd) {
			this.macd = macd;
		}
		public Map<String, String> getBollinger() {
			return bollinger;
		}
		public void setBollinger(Map<String, String> bollinger) {
			this.bollinger = bollinger;
		}
		public Map<String, String> getAtr() {
			return atr;
		}
		public void setAtr(Map<String, String> atr) {
			this.atr = atr;
		}
		public TechnicalIndicators(Map<String, String> sma, Map<String, String> ema, Map<String, String> rsi,
				Map<String, String> macd, Map<String, String> bollinger, Map<String, String> atr) {
			super();
			this.sma = sma;
			this.ema = ema;
			this.rsi = rsi;
			this.macd = macd;
			this.bollinger = bollinger;
			this.atr = atr;
		}
		public TechnicalIndicators() {
			super();
		}
	    
}
