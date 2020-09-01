trigger TaskTrigger on Task (after insert) {
    
    Trigger_Settings__c triggerSettings = Trigger_Settings__c.getValues('Trigger Settings');
    if(triggerSettings.Disable_TaskTrigger__c) {
        // trigger turned off
        return;
    }
    
    // Execute after actions
    if(trigger.isAfter) {
        // Execute insert actions
        if(trigger.isInsert) {
            Set<Id> leadIds = new Set<Id>();
            Map<String, String> metadataMapping = new Map<String, String>();
            String SobjectApiName = 'Lead_Conversion_Settings__mdt';
            Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
            Map<String, Schema.SObjectField> fieldMap = schemaMap.get(SobjectApiName).getDescribe().fields.getMap();
            String commaSepratedFields = '';
            for(String fieldName : fieldMap.keyset()) {
                metadataMapping.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
                if(commaSepratedFields == null || commaSepratedFields == '') {
                    commaSepratedFields = fieldName;
                }
                else {
                    commaSepratedFields = commaSepratedFields + ', ' + fieldName;
                }
            } 
            String query = 'SELECT ' + commaSepratedFields + ' FROM ' + SobjectApiName + ' LIMIT 1';
            Lead_Conversion_Settings__mdt leadSettings = Database.query(query);
            
            Map<String, Boolean> fieldLabelMapping = new Map<String, Boolean>();
            for(String fieldName : metadataMapping.keyset()) {
                if(leadSettings.get(fieldName) == true) {
                    fieldLabelMapping.put(metadataMapping.get(fieldName), true);
                }
            }
            for(Task task : trigger.new) {
                if(fieldLabelMapping.containsKey(task.Subject)) {
                    leadIds.add(task.whoId);
                }
            }
            if(!leadIds.isEmpty()) {
                Id enqueueJobId = System.enqueueJob(new LeadHandler(leadIds));
            }
        }
    }
}