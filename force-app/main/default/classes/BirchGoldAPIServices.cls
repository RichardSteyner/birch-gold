@RestResource(urlMapping='/leadservices/*')
global with sharing class BirchGoldAPIServices {
    
    // Creating a response wrapper class
    global class ResponseWrapper {
        Boolean success;
        String message;
        Lead lead;
    }
    
    /* HTTP Get Method | This method supplies Salesforce Lead data to external system */
    @HttpGet
    global static ResponseWrapper doGetLead() {
        
        ResponseWrapper payload = new ResponseWrapper();
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String leadId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        if(leadId != null) {
            String whereClaus = 'Id =\''+leadId+'\'';
            Lead leadRecord = (Lead)BirchGoldAPIServices.getListWAllFields('Lead', whereClaus, 1);
            payload.success = true;
            payload.lead = leadRecord;
            payload.message = 'success';
        }
        else {
            payload.success = false;
            payload.message = 'error. Invalid Id or Id not provided.';
        }
        return payload;
    }
    
    /* HTTP Patch Method | This method updates a Salesforce Lead data from external system */
    @HTTPPatch
    global static ResponseWrapper doPatchLead() {
        
        // Initializing the response wrapper
        ResponseWrapper responseWrapper = new ResponseWrapper();
        // Initializing the request parameter with the incoming request
        RestRequest leadRequest = RestContext.request;
        // Getting the request body from the request
        String requestBody = leadRequest.requestBody.toString();
        System.debug('******* requestBody >>>> '+requestBody);
        // Deserializing the JSON request body
        Lead leadToUpdate = (Lead) JSON.deserialize(requestBody, Lead.class);
        System.debug('******* Request To Update Lead >>>> '+leadToUpdate);
        try {
            Database.SaveResult updateResult = Database.update(leadToUpdate);
            // Checking the result of update operation
            if(updateResult.isSuccess()) {
                // Update successful, setting up the appropriate message in response wrapper
                responseWrapper.success = true;
                responseWrapper.message = 'Lead data updated successfully';
            }
            else { 
                // Update failed, getting errors and setting up the error message in response wrapper
                responseWrapper.success = false;
                for(Database.Error error : updateResult.getErrors()) {
                    responseWrapper.message = 'The following error has occurred for contact with Id: ' + updateResult.getId() + '. ';
                    responseWrapper.message += error.getStatusCode() + ': ' + error.getMessage() + '. ';
                    responseWrapper.message += 'Contact fields that affected this error: ' + error.getFields();
                }
            }
        }
        catch(Exception ex) {
            System.debug(LoggingLevel.ERROR, '\n\n --- doPatchLead --- '
                         +'\n - action: lead update '
                         +'\n - ex: ' + ex.getMessage()
                         +'\n - ex.getLineNumber: ' + ex.getLineNumber()
                         +'\n - ex.getStackTraceString: ' + ex.getStackTraceString()
                         +'\n'
                        );
        }
        // Returning the response wrapper
        return responseWrapper;
    }
    
    /* HTTP Patch Method | This method updates a Salesforce Lead data from external system */
    @HTTPPost
    global static ResponseWrapper doPostLead() {
        
        // Initializing the response wrapper
        ResponseWrapper responseWrapper = new ResponseWrapper();
        // Initializing the request parameter with the incoming request
        RestRequest leadRequest = RestContext.request;
        // Getting the request body from the request
        Map<String, Object> requestMap = (Map<String, Object>) JSON.deserializeUntyped(RestContext.request.requestBody.toString());
        System.debug('XXXXX'+requestMap);
        Boolean submissionSuccess = requestMap.get('isSuccess') == true ? true : false;
        String leadId = (String)requestMap.get('leadId');

        if(submissionSuccess) {
            try {
                // Convert lead to Account and return Account Id
                LeadStatus convertStatus = [SELECT Id, MasterLabel, IsConverted FROM LeadStatus WHERE IsConverted=true limit 1];
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(leadId);
                lc.setDoNotCreateOpportunity(true);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcr = Database.convertLead(lc);
                if(lcr.isSuccess()) {
                    responseWrapper.success = true;
                    responseWrapper.message = lcr.accountid;
                    List<Id> accIdList = new List<Id>();
                    accIdList.add(lcr.accountid);
                    // Callout to Post Message API
                    LeadHandler.postMessages(accIdList);
                }             
            }
            catch(Exception ex) {
                responseWrapper.success = false;
                responseWrapper.message = ex.getMessage();
                System.debug(LoggingLevel.ERROR, '\n\n --- doPatchLead --- '
                             +'\n - action: lead update '
                             +'\n - ex: ' + ex.getMessage()
                             +'\n - ex.getLineNumber: ' + ex.getLineNumber()
                             +'\n - ex.getStackTraceString: ' + ex.getStackTraceString()
                             +'\n'
                            );
            }
        }
        // Returning the response wrapper
        return responseWrapper;
    }
    
    /* This method supplies any sObject data with all fields */
    public static sObject getListWAllFields(string objectName, string whereClaus, integer limitNumber) {
        
        // Initialize setup variables
        String query = ' SELECT ';
        Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        
        // Grab the fields from the describe method and append them to the queryString one by one.
        for(String s : objectFields.keySet()) {
            query += ' ' + s + ', ';
        }
        query = query.subString(0,query.Length()-2);
        // Add FROM statement
        query += ' FROM ' + objectName;
        // Add on a WHERE statement as needed
        if (String.isNotBlank(whereClaus)) {
            query += ' WHERE ' + whereClaus;
        }
        // Add on a LIMIT statement as needed
        if (String.isNotBlank(whereClaus)) {
            query += ' LIMIT ' + String.valueOf(limitNumber);
        }
        try {
            return database.query(query);
        } 
        catch(QueryException qe) {
            System.debug(LoggingLevel.ERROR, '\n\n --- getListWAllFields --- '
                         +'\n - objectName: ' + objectName
                         +'\n - whereClaus: ' + whereClaus
                         +'\n - query: ' + query
                         +'\n - qe: ' + qe
                         +'\n - qe: ' + qe.getMessage()
                         +'\n - qe.getLineNumber: ' + qe.getLineNumber()
                         +'\n - qe.getStackTraceString: ' + qe.getStackTraceString()
                         +'\n'
                        );
            return null;
        }
    }
}