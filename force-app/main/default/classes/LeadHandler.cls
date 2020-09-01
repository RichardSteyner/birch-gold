public class LeadHandler implements Queueable, Database.AllowsCallouts {
    
    Set<Id> LeadIdSet = new Set<Id>(); 
    public LeadHandler(Set<Id> LeadIdSet) { 
        this.LeadIdSet.addAll(LeadIdSet);          
    } 
    
    public void execute(QueueableContext context) {
        
        LeadStatus convertStatus = [SELECT Id, MasterLabel, IsConverted FROM LeadStatus WHERE IsConverted=true limit 1];
        List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
        Map<Id, Lead> leadMap = new Map<Id, Lead> ([Select Id, Name, Email, isConverted, subid__c from Lead Where Id IN: LeadIdSet AND isConverted=:false]);
        for(Lead leadObj: leadMap.values()){
            
            Database.LeadConvert lc = new Database.LeadConvert();
            lc.setLeadId(leadObj.Id);
            lc.setDoNotCreateOpportunity(true);
            lc.setConvertedStatus(convertStatus.MasterLabel);
            leadsToConvert.add(lc);
        }
        List<Database.LeadConvertResult> results = Database.convertLead(leadsToConvert);
        List<Id> accountIds = new List<Id>();
        for(Database.LeadConvertResult result: results) {
            if(result.isSuccess()) {
                accountIds.add(result.getAccountId());
            }
        }
        LeadHandler.postMessages(accountIds);
    }
    
    @future(callout=true)
    public static void postMessages(List<Id> accountIds) {
        
        Map<Id, Account> accountMap = new Map<Id, Account> ([Select Id, subid__c, External_Message_Status__c, Message_Posted__c from Account Where Id IN: accountIds AND Message_Posted__c =:false]);
        List<Account> toUpdate = new List<Account>();
        for(Account acc : accountMap.values()) {
            Http http = new Http(); 
            HttpRequest request = new HttpRequest();
            String endpointURL = 'http://bitira.go2cloud.org/aff_goal?a=lsr&goal_id=5&aff_id='+acc.subid__c;
            request.setEndpoint(endpointURL);
            request.setMethod('POST');
            HttpResponse response = http.send(request);
            if(response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            } 
            else {
                acc.External_Message_Status__c = 'Message Posted';
                acc.Message_Posted__c = true;
                toUpdate.add(acc);
            }    
        }
        
        update toUpdate;
    }
}