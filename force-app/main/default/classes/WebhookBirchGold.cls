@RestResource(urlMapping='/WebhookBirchGold/*')
global without sharing class WebhookBirchGold {
    
    global class ResponseWrapper {
        Boolean success;
        String message;
    }
    
    global class RequestWrapper {
        public List<String> zip_code {get; set;}
		public List<String> time_submitted {get; set;}
        public List<String> page_uuid {get; set;}
        public List<String> company {get; set;}
        public List<String> lead_source {get; set;}
        public List<String> placement {get; set;}
        public List<String> email {get; set;}
        public List<String> page_name {get; set;}
        public List<String> uid {get; set;}
        public List<String> date_submitted {get; set;}
        public List<String> lp_pagevariant {get; set;}
        public List<String> subid {get; set;}
        public List<String> utm_content {get; set;}
        public List<String> utm_source {get; set;}
        public List<String> last_name {get; set;}
        public List<String> utm_medium {get; set;}
        public List<String> first_name {get; set;}
        public List<String> phone {get; set;}
        public List<String> utm_campaign {get; set;}
        public List<String> msid {get; set;}
        public List<String> lp_pageid {get; set;}
        public List<String> ip_address {get; set;}
        public List<String> page_url {get; set;}
        public List<String> tid {get; set;}
        public List<String> variant {get; set;}
    }
    
    @HTTPPost
    global static ResponseWrapper doPostRecord() {
        ResponseWrapper responseWrapper = new ResponseWrapper();
        if(RestContext.request.requestBody != null && String.isNotBlank(RestContext.request.requestBody.toString())){
            System.debug(RestContext.request.requestBody.toString());
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rurupeque@cloudcreations.com'}); mail.setSubject('Birch Gold Integration'); mail.setHtmlBody('<strong>Body</strong><br/><strong>X-ANET-Signature: </strong>' + RestContext.request.headers.get('X-ANET-Signature') + '<br/><strong>Body: </strong>' + RestContext.request.requestBody.ToString()); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
            responseWrapper.success = true;
            responseWrapper.message = 'Request body.!';
        }else{
            if(RestContext.request.params!=null){
                if(RestContext.request.params.get('data.json')!=null){
                    try{
                        //Map<String, List<String>> dataJson = (Map<String, List<String>>) JSON.deserializeUntyped(RestContext.request.params.get('data.json'));
                        RequestWrapper rw = (RequestWrapper) json.deserialize(RestContext.request.params.get('data.json'), RequestWrapper.class);
                        String recordTypeLead = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('BirchGold') != null ? Schema.SObjectType.Lead.getRecordTypeInfosByName().get('BirchGold').getRecordTypeId() : null;
                        Lead l = new Lead();
                        l.LastName = rw.last_name!=null && rw.last_name.size()>0 ? rw.last_name[0] : null;
                        l.FirstName = rw.first_name!=null && rw.first_name.size()>0 ? rw.first_name[0] : null; 
                        l.Email = rw.email!=null && rw.email.size()>0 ? rw.email[0] : null;
                        l.Phone = rw.phone!=null && rw.phone.size()>0 ? rw.phone[0] : null; 
                        l.PostalCode = rw.zip_code!=null && rw.zip_code.size()>0 ? rw.zip_code[0] : null;
                        l.Company = rw.company!=null && rw.company.size()>0 ? rw.company[0] : 'BirchGold'; 
                        l.RecordTypeId = recordTypeLead;
                        insert l;
                        responseWrapper.success = true;
                        responseWrapper.message = 'Lead Inserted.!';
                    }catch(Exception e){
                        responseWrapper.success = false;
                		responseWrapper.message = e.getLineNumber() + '-' + e.getMessage();
                    }
                }else{
                    responseWrapper.success = false;
                	responseWrapper.message = 'Param data.json null.!';
                }
            }else{
                responseWrapper.success = false;
                responseWrapper.message = 'Params null.!';
            }
            System.debug('Request body null or blank.!');
            //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rurupeque@cloudcreations.com'}); mail.setSubject('Birch Gold Integration'); mail.setHtmlBody('<strong>Body</strong><br/><strong>X-ANET-Signature: </strong>' + RestContext.request.headers.get('X-ANET-Signature') + '<br/><strong>Body: </strong>' + RestContext.request.params.get('data.json')); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        }
        return responseWrapper;
    }

}