trigger POLITrigger on Purchase_Order_Line_Item__c (before insert, before update, after insert) {

    if(Trigger.isBefore){
        if(Trigger.isInsert){
            /*
            for(Account account:trigger.new){
            if(!ApexUtil.isAdvancedMDAccountTriggerInvoked && Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null && account.recordtypeId.equals(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId())){account.AdvancedMD_To_Sync__c = true;account.AdvancedMD_Sync_Status__c = 'Processing';account.AdvancedMD_Sync_Error__c = '';}
            if(!ApexUtil.isAuthorizeAccountTriggerInvoked && Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null && account.recordtypeId.equals(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId())) account.Authorize_To_Sync__c = true;
        }
			*/
            
        }else{
            /*
                     for(Account account:trigger.new){
            if(!ApexUtil.isAdvancedMDAccountTriggerInvoked && Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null && account.recordtypeId.equals(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId()) && (account.Provider__c != trigger.oldMap.get(account.Id).Provider__c || account.Responsible_Party__c != trigger.oldMap.get(account.Id).Responsible_Party__c || account.FirstName != trigger.oldMap.get(account.Id).FirstName || account.MiddleName != trigger.oldMap.get(account.Id).MiddleName || account.LastName != trigger.oldMap.get(account.Id).LastName || account.PersonBirthdate != trigger.oldMap.get(account.Id).PersonBirthdate || account.As_of_Date__c != trigger.oldMap.get(account.Id).As_of_Date__c || account.Sex__c != trigger.oldMap.get(account.Id).Sex__c || account.SSN__c != trigger.oldMap.get(account.Id).SSN__c || account.GI__c != trigger.oldMap.get(account.Id).GI__c || account.SO__c != trigger.oldMap.get(account.Id).SO__c || account.Chart_Number__c != trigger.oldMap.get(account.Id).Chart_Number__c || account.Marital_Status__c != trigger.oldMap.get(account.Id).Marital_Status__c || account.Employer__c != trigger.oldMap.get(account.Id).Employer__c || account.PersonTitle != trigger.oldMap.get(account.Id).PersonTitle || account.Relationship__c != trigger.oldMap.get(account.Id).Relationship__c || account.Race__c != trigger.oldMap.get(account.Id).Race__c || account.Ethnicity__c != trigger.oldMap.get(account.Id).Ethnicity__c || account.Additional_MRN__c != trigger.oldMap.get(account.Id).Additional_MRN__c || account.PersonEmail != trigger.oldMap.get(account.Id).PersonEmail || account.BillingStreet != trigger.oldMap.get(account.Id).BillingStreet || account.BillingPostalCode != trigger.oldMap.get(account.Id).BillingPostalCode || account.BillingCity != trigger.oldMap.get(account.Id).BillingCity || account.BillingState != trigger.oldMap.get(account.Id).BillingState || account.BillingCountry != trigger.oldMap.get(account.Id).BillingCountry || account.PersonHomePhone != trigger.oldMap.get(account.Id).PersonHomePhone || account.Work_Phone__c != trigger.oldMap.get(account.Id).Work_Phone__c || account.PersonMobilePhone != trigger.oldMap.get(account.Id).PersonMobilePhone || account.Fax != trigger.oldMap.get(account.Id).Fax || account.PersonOtherphone != trigger.oldMap.get(account.Id).PersonOtherphone || account.Phone != trigger.oldMap.get(account.Id).Phone || account.Confidential__c != trigger.oldMap.get(account.Id).Confidential__c || account.Description != trigger.oldMap.get(account.Id).Description)){account.AdvancedMD_To_Sync__c = true;account.AdvancedMD_Sync_Status__c = 'Processing';account.AdvancedMD_Sync_Error__c = '';}
            if(!ApexUtil.isAuthorizeAccountTriggerInvoked && Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient') != null && account.recordtypeId.equals(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Patient').getRecordTypeId()) && (account.LastName != trigger.oldMap.get(account.Id).LastName || account.PersonEmail != trigger.oldMap.get(account.Id).PersonEmail)) account.Authorize_To_Sync__c = true;
        } 
			*/
        }
    }else{
        if(Trigger.isInsert){
            /*Set<Id> poliIds = new Set<Id>();
            Integer i = 0;
            for(Purchase_Order_Line_Item__c poli : Trigger.New){
 				i++;
                if(i<10) poliIds.add(poli.Id);
            }
            if(!poliIds.IsEmpty()) BitIRAConnection.postCurrencyPurchasesFuture(poliIds);*/
        }else{
            
        }
    }
    
}