trigger PurchaseTrigger on Purchase_Order__c (after insert, after update) {
    Set<Id> poIds = new Set<Id>(); //post currency_purchases
    Set<Id> poXigniteIds = new Set<Id>(); //get MetalQuotes
    //Map<Id, Purchase_Order__c> purchases = new Map<Id, Purchase_Order__c>();
    if(Trigger.IsInsert) {
    	for(Purchase_Order__c purchase : Trigger.New){
    		if(purchase.Status__c!=null && purchase.Status__c=='Submitted'){
				//purchases.put(purchase.Id, purchase.clone(true));
                poIds.add(purchase.Id);
				System.debug('PurchaseTrigger BitIRA->' + purchase.Id);
            }
            System.debug('PurchaseTrigger Xignite->' + purchase.Id);
            poXigniteIds.add(purchase.Id);
        }
    }else{
        for(Purchase_Order__c purchase : Trigger.New){
    		if(purchase.Status__c!=null && purchase.Status__c=='Submitted' && purchase.Status__c != trigger.oldMap.get(purchase.Id).Status__c){
				//purchases.put(purchase.Id, purchase.clone(true));
                poIds.add(purchase.Id);
				System.debug('PurchaseTrigger BitIRA->' + purchase.Id);
            }
        }
    }
    
    if(!poXigniteIds.IsEmpty()) XigniteGetMetalQuote.showMetalQuoteForPurchaseOrder(poXigniteIds);
    if(!poIds.IsEmpty()) BitIRAConnection.postCurrencyPurchasesFuture(poIds);

}