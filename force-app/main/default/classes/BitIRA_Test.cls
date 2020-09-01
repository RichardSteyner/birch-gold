@isTest
public class BitIRA_Test {
	
    private static BitIRAAPI__c authentication = BitIRAAPI__c.getOrgDefaults();
    
    static {
        authentication.Base_URL__c = 'test';
        authentication.Key__c = 'test';
        insert authentication;
    }
    
    @isTest static void testTrigger01(){
        Product2 objPro = new Product2(Name = 'Test', StockKeepingUnit = 'test', IsActive = true);
        insert objPro;
        Account objAcc = new Account(Name = 'Cloud Creations');
        insert objAcc;
        Purchase_Order__c objPurchase = new Purchase_Order__c(Account_Type__c = 'Roth', Client__c = objAcc.Id);
        insert objPurchase;
        Purchase_Order_Line_Item__c objItem = new Purchase_Order_Line_Item__c(Purchase_Order__c = objPurchase.Id, Quantity__c = 10,
                                                                              Total_Price__c = 100, Coin__c = objPro.Id);
        insert objItem;
        
        Test.startTest();
        objPurchase.Status__c = 'Submitted';
        update objPurchase;
        Test.stopTest();
    }
    
    @isTest static void testTrigger02(){
        Product2 objPro = new Product2(Name = 'Test', StockKeepingUnit = 'test', IsActive = true);
        insert objPro;
        Purchase_Order__c objPurchase = new Purchase_Order__c(Account_Type__c = 'Roth');
        insert objPurchase;
        Purchase_Order_Line_Item__c objItem = new Purchase_Order_Line_Item__c(Purchase_Order__c = objPurchase.Id, Quantity__c = 10,
                                                                              Total_Price__c = 100, Coin__c = objPro.Id);
        insert objItem;
        
        Test.startTest();
        objPurchase.Status__c = 'Submitted';
        update objPurchase;
        Test.stopTest();
    }
    
}