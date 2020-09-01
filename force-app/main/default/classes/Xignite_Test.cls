@isTest
public class Xignite_Test {
    
    private static XigniteAPI__c authentication = XigniteAPI__c.getOrgDefaults();
    
    static {
        authentication.Base_URL__c = 'test';
        authentication.Token__c = 'test';
        insert authentication;
    }
    
    @isTest static void testMetalQuoteForLead(){
        //Product2 objPro = new Product2(Name='Test', StockKeepingUnit='test', IsActive=true);
        //insert objPro;
        Lead objLead = new Lead(FirstName = 'Richard', MiddleName='Steyner', LastName='Urupeque', 
                               	RecordTypeId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('BirchGold') != null ? Schema.SObjectType.Lead.getRecordTypeInfosByName().get('BirchGold').getRecordTypeId() : null,
                                Company = 'Cloud Creations'/*, Product__c = objPro.Id*/);
        insert objLead;
        
        Test.startTest();
        XigniteGetMetalQuote.showMetalQuoteForLead(objLead.Id);
        Test.stopTest();
    }
    
    @isTest static void testMetalQuoteForOpportunity(){
        Product2 objPro = new Product2(Name='Test', StockKeepingUnit='test', IsActive=true);
        insert objPro;
        Account objAcc = new Account(Name = 'Cloud Creations');
        insert objAcc;
        Opportunity objOpp = new Opportunity(Name = 'Test Opp', AccountId = objAcc.Id, CloseDate = Datetime.now().date(),
                               	RecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BirchGold') != null ? Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('BirchGold').getRecordTypeId() : null,
                                StageName = 'Closed Won', Product__c = objPro.Id);
        insert objOpp;
        
        Test.startTest();
        XigniteGetMetalQuote.showMetalQuoteForOpportunity(objOpp.Id);
        Test.stopTest();
    }
    
    @isTest static void testMetalQuoteForPurchase(){
        Purchase_Order__c objPurchase1 = new Purchase_Order__c();
        Purchase_Order__c objPurchase2 = new Purchase_Order__c();
        List<Purchase_Order__c> purchases = new List<Purchase_Order__c>();
        purchases.add(objPurchase1);
        purchases.add(objPurchase2);
        
        Test.startTest();
        insert purchases;
        Test.stopTest();
    }

}