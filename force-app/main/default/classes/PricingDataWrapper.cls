/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class serves as the wrapper for deserealising JSON data retrieved from Bayside Gold API.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Alsinan Nazim   	<alsinan.naz@gmail.com>
* @modifiedBy     Alsinan Nazim   	<alsinan.naz@gmail.com>
* @maintainedBy   Alsinan Nazim   	<alsinan.naz@gmail.com>
* @version        1.0
* @created        2020-03-20
* @modified       YYYY-MM-DD
* @systemLayer    Invocation | Service | Utility | Selector | Domain | Test
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public class PricingDataWrapper {
    
    public String timestamp {get; set;}
    public SpotPrices spotPrices {get; set;}
    public String account {get; set;}
    public List<RetailPrices> retailPrices {get; set;}
    
    public class SpotPrices {
        public String platinumAsk {get; set;}
        public String silverAsk {get; set;}
        public String palladiumAsk {get; set;}
        public String goldAsk {get; set;}
    }
    
    public class RetailPrices {
        public String description {get; set;}
        public String metal {get; set;}
        public String category {get; set;}
        public Double price {get; set;}
        public String sku {get; set;}
        public String availability {get; set;}
    }
}