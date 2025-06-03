package com.TradeTailor.TradeTailor.model;

public class CompanyInfo {
	   private String name;
	    private String sector;
	    private String marketCapitalization;
	    private String description;
	    public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getSector() {
			return sector;
		}

		public void setSector(String sector) {
			this.sector = sector;
		}

		public String getMarketCapitalization() {
			return marketCapitalization;
		}

		public void setMarketCapitalization(String marketCapitalization) {
			this.marketCapitalization = marketCapitalization;
		}

		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		public String getLogoUrl() {
			return logoUrl;
		}

		public void setLogoUrl(String logoUrl) {
			this.logoUrl = logoUrl;
		}

		private String logoUrl;
	    
		public CompanyInfo() {
			super();
		}

		public CompanyInfo(String name, String sector, String marketCapitalization, String description,
				String logoUrl) {
			super();
			this.name = name;
			this.sector = sector;
			this.marketCapitalization = marketCapitalization;
			this.description = description;
			this.logoUrl = logoUrl;
		}
}
