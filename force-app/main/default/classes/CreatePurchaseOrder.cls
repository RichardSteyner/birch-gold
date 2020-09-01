public with sharing class CreatePurchaseOrder
{
    private ApexPages.StandardController controller;

    public CreatePurchaseOrder(ApexPages.StandardController controller)
    {
        this.controller = controller;
    }

    public PageReference createPurchaseOrder()
    {
        IRA_queue__c ira = [SELECT Id, (SELECT Id FROM Opportunities__r), RecordType.Name, Client__c, Contact__c, Type_of_account__c, Contact__r.MailingStreet,Contact__r.MailingCity, Contact__r.MailingState, Contact__r.MailingPostalCode
                            FROM IRA_queue__c WHERE Id =:((IRA_queue__c) controller.getRecord()).Id];
        Purchase_Order__c po = New Purchase_Order__c(
            IRA_Queue__c=ira.Id,
            Client__c=ira.Client__c,
            Contact__c=ira.Contact__c,
            Account_Type__c= ira.Type_of_account__c,
            Billing_Street__c=ira.Contact__r.MailingStreet,
            Billing_City__c=ira.Contact__r.MailingCity,
            Billing_State__c=ira.Contact__r.MailingState,
            Billing_Zip__c=ira.Contact__r.MailingPostalCode            
        );
        if (ira.Opportunities__r.size() > 0){
            po.Opportunity__c=ira.Opportunities__r[0].Id;
        }
        
        if (ira.RecordType.Name == 'BitIRA'){
            po.RecordTypeId = '0120v000000hFZyAAM';
        }
        if (ira.RecordType.Name == 'BirchGold'){
            po.RecordTypeId = '0120v000000hFa3AAE';
        }
        insert po;
        PageReference pRef =  (new ApexPages.StandardController (po)).view();               
        pRef.setRedirect(true); 
        return pRef;
    }
}