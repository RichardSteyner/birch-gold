public with sharing class PTC_Transfer_PDF_Controller {
    public IRA_Queue__c PrimaryObject {get;set;}

    public Boolean Errors {get; set;}

    public PTC_Transfer_PDF_Controller(ApexPages.StandardController sc) {
        try {
            Errors = false;
            PrimaryObject = (IRA_Queue__c) sc.getRecord();
            System.debug(PrimaryObject);

        
            PrimaryObject = [SELECT 
                Id,Name,Contact__c,Contact__r.LastName,Contact__r.FirstName,Contact__r.MiddleName,Contact__r.SSN__c,Contact__r.D_O_B__c,Contact__r.Email,Contact__r.Phone,Contact__r.MobilePhone,Contact__r.MailingStreet,Contact__r.MailingCity,Contact__r.MailingState,Contact__r.MailingPostalCode,Account_Type__c,Custodian_name__c,Custodian_Client_Account_Number__c,Custodian_name__r.Name,Custodian_name__r.Account.BillingStreet,Custodian_name__r.Account.BillingCity,Custodian_name__r.Account.BillingState,Custodian_name__r.Account.BillingPostalCode,Custodian_name__r.Phone,Transfer__c,Other_Transfer__c,Conversion__c,Required_Minimum_Distribution_has__c,Required_Minimum_Distribution_has_not__c,Cash_transfer__c,Portion_of_cash_balance_Total__c,Investments__c,Investment_Name_1__c,Investment_Name_2__c,Investment_Name_3__c,Investment_Name_4__c,Investment_Name_5__c,Investment_Name_6__c,Delivery_information__c,Withholding__c,I_want_the_following_additional_amount__c,Or_additional_withheld_from_each_IRA_d__c,I_elect_to_have__c,Or_state_income_tax_withheld_from_my_I__c	
            FROM  IRA_Queue__c WHERE Id = :PrimaryObject.Id];
            System.debug(PrimaryObject);

            if(PrimaryObject.Contact__c == null || PrimaryObject.Custodian_name__c == null){
                Errors = True;
                ApexPages.addMessage(new 
                    ApexPages.Message(ApexPages.Severity.ERROR, 
                'Verify that the \'Contact\' and \'Custodian name\' fields are not empty'));
            }

            Apexpages.currentPage().getHeaders().put('content-disposition', 'inline; filename= '+PrimaryObject.Name+'.pdf');
        } catch (Exception e) {
            Errors = True;
            ApexPages.addMessage(new 
                ApexPages.Message(ApexPages.Severity.ERROR, 
               'Ah an error occurred'));
            System.debug('Line: ' + e.getLineNumber() + ' - Message: ' + e.getMessage());
        }
        

    }

}