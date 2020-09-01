public class XigniteGetMetalQuote {
    
    @AuraEnabled
    public static String showMetalQuoteForLead(String id){
        Lead objLead = [SELECT Id, FirstName, MiddleName, LastName, RecordTypeId/*, Product__c, Product__r.StockKeepingUnit*/
                        FROM Lead 
                        WHERE Id =: id];
        if(objLead==null) return 'Warning: Lead not exist!';
        String recordTypeLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('BirchGold') != null ? Schema.SObjectType.Lead.getRecordTypeInfosByName().get('BirchGold').getRecordTypeId() : null;
      	if(objLead.RecordTypeId!=recordTypeLead) return 'Warning: Record type invalid!';
        //if(objLead.Product__c==null) return 'Warning: The Product field is empty!';
        //if(objLead.Product__r.StockKeepingUnit==null) return 'Warning: The Product SKU field is empty!';
      	
      	List<RealTimeMetalQuotesParser> lista = new List<RealTimeMetalQuotesParser>();
      	//RealTimeMetalQuotesParser realTimeQuote = new RealTimeMetalQuotesParser();
        try{
            String json_x = XigniteConnection.getXigniteEntity('GetRealTimeMetalQuotes', 'Symbols=XAU,XAG&Currency=USD', '');
            //String symbol = EncodingUtil.URLENCODE(objLead.Product__r.StockKeepingUnit, 'UTF-8').replace('+', '%20');
            //String json_x = XigniteConnection.getXigniteEntity('GetRealTimeMetalQuote', 'Symbol=' + symbol + '&Currency=USD', '');
            json_x=json_x.replace('"Currency":', '"Currency_x":').replace('"Date":', '"Date_x":').replace('"Time":', '"Time_x":');
            System.debug(json_x);
            lista = (List<RealTimeMetalQuotesParser>) json.deserialize(json_x, List<RealTimeMetalQuotesParser>.class);
            //realTimeQuote = (RealTimeMetalQuotesParser) json.deserialize(json_x, RealTimeMetalQuotesParser.class);
        }catch(Exception e){
            System.debug(e.getLineNumber() + '->' + e.getMessage());
            return 'Error: Could not successfully connect to Xignite server.';
        }
        
        try{
            Boolean sw = false;
            for(RealTimeMetalQuotesParser realTimeQuote : lista){
            System.debug(realTimeQuote.Name + ' - ' + realTimeQuote.Delay + ' - ' + realTimeQuote.Identity  + ' - ' + realTimeQuote.Date_x + ' - ' + realTimeQuote.Currency_x + ' - ' + realTimeQuote.Time_x);
                if(realTimeQuote.Outcome.contains('Success') && realTimeQuote.Symbol.equalsIgnoreCase('XAU')){
                    sw = true;
                    objLead.Name_Metal_I__c = realTimeQuote.Name;
                    objLead.Symbol_I__c = realTimeQuote.Symbol;
                    objLead.Identity_I__c = realTimeQuote.Identity;
                    objLead.Unit_I__c = realTimeQuote.Unit;
                    objLead.Source_I__c = realTimeQuote.Source;
                    objLead.Spread_I__c = realTimeQuote.Spread;
                    objLead.Ask_I__c = realTimeQuote.Ask;
                    objLead.Mid_I__c = realTimeQuote.Mid;
                    objLead.Bid_I__c = realTimeQuote.Bid;
                    objLead.Delay_I__c = realTimeQuote.Delay;
                }
                if(realTimeQuote.Outcome.contains('Success') && realTimeQuote.Symbol.equalsIgnoreCase('XAG')){
                    sw = true;
                    objLead.Name_Metal_II__c = realTimeQuote.Name;
                    objLead.Symbol_II__c = realTimeQuote.Symbol;
                    objLead.Identity_II__c = realTimeQuote.Identity;
                    objLead.Unit_II__c = realTimeQuote.Unit;
                    objLead.Source_II__c = realTimeQuote.Source;
                    objLead.Spread_II__c = realTimeQuote.Spread;
                    objLead.Ask_II__c = realTimeQuote.Ask;
                    objLead.Mid_II__c = realTimeQuote.Mid;
                    objLead.Bid_II__c = realTimeQuote.Bid;
                    objLead.Delay_II__c = realTimeQuote.Delay;
                }
            }
            if(sw){
                update objLead;
                System.debug(objLead.Id);
                return objLead.Id;
            }else
                return 'Warning: Metal Quote with Symbol XAU or XAG not found.';
        }catch(Exception e){
            System.debug(e.getLineNumber() + '->' + e.getMessage());
            return 'Error: ' + e.getLineNumber() + '->' + e.getMessage();
        }
    }
    
    @AuraEnabled
    public static String showMetalQuoteForOpportunity(String id){
        Opportunity objOpportunity = [SELECT Id, Name, RecordTypeId, Product__c, Product__r.StockKeepingUnit 
                                      FROM Opportunity 
                                      WHERE Id =: id];
        if(objOpportunity==null) return 'Warning: Opportunity not exist!';
        String recordTypeOpportunity = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BirchGold') != null ? Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BirchGold').getRecordTypeId() : null;
      	if(objOpportunity.RecordTypeId!=recordTypeOpportunity) return 'Warning: Record type invalid!';
        if(objOpportunity.Product__c==null) return 'Warning: The Product field is empty!';
        if(objOpportunity.Product__r.StockKeepingUnit==null) return 'Warning: The Product SKU field is empty!';
      	
      	RealTimeMetalQuotesParser realTimeQuote = new RealTimeMetalQuotesParser();
        try{
            String symbol = EncodingUtil.URLENCODE(objOpportunity.Product__r.StockKeepingUnit, 'UTF-8').replace('+', '%20');
            String json_x = XigniteConnection.getXigniteEntity('GetRealTimeMetalQuote', 'Symbol=' + symbol + '&Currency=USD&Name=Silver%201%20Oz', '');
            json_x=json_x.replace('"Currency":', '"Currency_x":').replace('"Date":', '"Date_x":').replace('"Time":', '"Time_x":');
            System.debug(json_x);
            realTimeQuote = (RealTimeMetalQuotesParser) json.deserialize(json_x, RealTimeMetalQuotesParser.class);
        }catch(Exception e){
            System.debug(e.getLineNumber() + '->' + e.getMessage());
            return 'Error: Could not successfully connect to Xignite server.';
        }
        
        try{
            Boolean sw = false;
            System.debug(realTimeQuote.Name + ' - ' + realTimeQuote.Delay + ' - ' + realTimeQuote.Identity  + ' - ' + realTimeQuote.Date_x + ' - ' + realTimeQuote.Currency_x + ' - ' + realTimeQuote.Time_x);
            if(realTimeQuote.Outcome.contains('Success')){
            	sw = true;
                objOpportunity.Name_Metal__c = realTimeQuote.Name;
                objOpportunity.Symbol__c = realTimeQuote.Symbol;
                objOpportunity.Identity__c = realTimeQuote.Identity;
                objOpportunity.Unit__c = realTimeQuote.Unit;
                objOpportunity.Source__c = realTimeQuote.Source;
                objOpportunity.Spread__c = realTimeQuote.Spread;
                objOpportunity.Ask__c = realTimeQuote.Ask;
                objOpportunity.Mid__c = realTimeQuote.Mid;
                objOpportunity.Bid__c = realTimeQuote.Bid;
                objOpportunity.Delay__c = realTimeQuote.Delay;
            }
            if(sw){
                update objOpportunity;
                System.debug(objOpportunity.Id);
                return objOpportunity.Id;
            }else
                return 'Warning: Metal quote with specified filter not found.';
        }catch(Exception e){
            System.debug(e.getLineNumber() + '->' + e.getMessage());
            return 'Error: ' + e.getLineNumber() + '->' + e.getMessage();
        }
    }
    
    @future(callout=true)
    public static void showMetalQuoteForPurchaseOrder(Set<Id> ids){
        List<Purchase_Order__c> purchases = [SELECT Id, Name,RecordTypeId FROM Purchase_Order__c WHERE Id in: ids];
        if(purchases==null || purchases.size()==0) {
            System.debug('Purchases not exists!');
            return;
        }

      	String recordTypePurchaseOrder = Schema.SObjectType.Purchase_Order__c.getRecordTypeInfosByName().get('Birch PO') != null ? Schema.SObjectType.Purchase_Order__c.getRecordTypeInfosByName().get('Birch PO').getRecordTypeId() : null;
        if(recordTypePurchaseOrder==null) { System.debug('The Record Type Birch PO doesn"t exist'); }
      	List<RealTimeMetalQuotesParser> lista = new List<RealTimeMetalQuotesParser>();
      	//RealTimeMetalQuotesParser realTimeQuote = new RealTimeMetalQuotesParser();
        try{
            String json_x = XigniteConnection.getXigniteEntity('GetRealTimeMetalQuotes', 'Symbols=XAU,XAG&Currency=USD', '');
            //String symbol = EncodingUtil.URLENCODE(objLead.Product__r.StockKeepingUnit, 'UTF-8').replace('+', '%20');
            //String json_x = XigniteConnection.getXigniteEntity('GetRealTimeMetalQuote', 'Symbol=' + symbol + '&Currency=USD', '');
            json_x=json_x.replace('"Currency":', '"Currency_x":').replace('"Date":', '"Date_x":').replace('"Time":', '"Time_x":');
            System.debug(json_x);
            lista = (List<RealTimeMetalQuotesParser>) json.deserialize(json_x, List<RealTimeMetalQuotesParser>.class);
            //realTimeQuote = (RealTimeMetalQuotesParser) json.deserialize(json_x, RealTimeMetalQuotesParser.class);
        }catch(Exception e){
            System.debug(e.getLineNumber() + '->' + e.getMessage());
            return;
            //return 'Error: Could not successfully connect to Xignite server.';
        }
        
        try{
            Boolean sw = false;
            for(RealTimeMetalQuotesParser realTimeQuote : lista){
            	System.debug(realTimeQuote.Name + ' - ' + realTimeQuote.Delay + ' - ' + realTimeQuote.Identity  + ' - ' + realTimeQuote.Date_x + ' - ' + realTimeQuote.Currency_x + ' - ' + realTimeQuote.Time_x);
                for(Purchase_Order__c objPurchase : purchases){
                    if(recordTypePurchaseOrder==objPurchase.RecordTypeId){
                        if(realTimeQuote.Outcome.contains('Success') && realTimeQuote.Symbol.equalsIgnoreCase('XAU')){
                            sw = true;
                            objPurchase.Spot_Date__c = System.today();
                            objPurchase.Name_Metal_I__c = realTimeQuote.Name;
                            objPurchase.Symbol_I__c = realTimeQuote.Symbol;
                            objPurchase.Identity_I__c = realTimeQuote.Identity;
                            objPurchase.Unit_I__c = realTimeQuote.Unit;
                            objPurchase.Source_I__c = realTimeQuote.Source;
                            objPurchase.Spread_I__c = realTimeQuote.Spread;
                            objPurchase.Ask_I__c = realTimeQuote.Ask;
                            objPurchase.Mid_I__c = realTimeQuote.Mid;
                            objPurchase.Bid_I__c = realTimeQuote.Bid;
                            objPurchase.Delay_I__c = realTimeQuote.Delay;
                        }
                        if(realTimeQuote.Outcome.contains('Success') && realTimeQuote.Symbol.equalsIgnoreCase('XAG')){
                            sw = true;
                            objPurchase.Spot_Date__c = System.today();
                            objPurchase.Name_Metal_II__c = realTimeQuote.Name;
                            objPurchase.Symbol_II__c = realTimeQuote.Symbol;
                            objPurchase.Identity_II__c = realTimeQuote.Identity;
                            objPurchase.Unit_II__c = realTimeQuote.Unit;
                            objPurchase.Source_II__c = realTimeQuote.Source;
                            objPurchase.Spread_II__c = realTimeQuote.Spread;
                            objPurchase.Ask_II__c = realTimeQuote.Ask;
                            objPurchase.Mid_II__c = realTimeQuote.Mid;
                            objPurchase.Bid_II__c = realTimeQuote.Bid;
                            objPurchase.Delay_II__c = realTimeQuote.Delay;
                        }
                    }
            	}
            }
            if(sw){
                update purchases;
                //System.debug(objPurchase.Id);
                System.debug('Purchases actualizados!');
            }else
                System.debug('Warning: Metal Quote with Symbol XAU or XAG not found.');
        }catch(Exception e){
            System.debug(e.getLineNumber() + '->' + e.getMessage());
            //return 'Error: ' + e.getLineNumber() + '->' + e.getMessage();
        }
    }

}