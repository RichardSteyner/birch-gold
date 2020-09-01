public class BitIRAConnection {
    
    public static BitIRAAPI__c authentication = BitIRAAPI__c.getOrgDefaults();
    
    public static String postBitIRAEntity(String entity, String filters, String xmlBody){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.Base_URL__c + entity);
		//System.debug(endpoint);
        request.setHeader('Content-type', 'application/xml');
        request.setMethod('POST');
        request.setTimeout(120000);
        System.debug(xmlBody);
        request.setBody(xmlBody);
        Http http = new Http();
        HTTPResponse response;
        try{
            if(!Test.isRunningTest()){
                response = http.send(request);
                //System.debug('->BitIRAConnection= ' + authentication.Base_URL__c + ', entity = ' +  entity + ') => Response Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody().left(255) : ''));
            }else{
                response = new HTTPResponse();
                response.setStatusCode(200);
                if(entity.equalsIgnoreCase('currency_purchases/action')) response.setBody('<?xml version="1.0" encoding="UTF-8"?><soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:tns="http://localhost/Intellect/ExternalWebService"><soap:Body><tns:ExecuteTransactionResponse><ResponseUpdateBitIRAV xsi:type="xsd:string">success</ResponseUpdateBitIRAV></tns:ExecuteTransactionResponse></soap:Body></soap:Envelope>');
                else if(entity.equalsIgnoreCase('products')) response.setBody('{"products": [{"id": 4625235247239,"title": "BioFit 360 Gift Set","body_html": "<p>This full-size gift set includes our Calm Sleep Tincture (500mg Hemp Oil), Relax GO-PAK Gummies (300mg Hemp Oil), and Relief Cream (500mg Hemp Oil) in a cinched natural fiber, easy to carry sack. Give yourself and loved ones the BEST gift! </p>","vendor": "BioFit 360","product_type": "Bundle","created_at": "2020-02-17T15:57:15-08:00","handle": "gift-set","updated_at": "2020-04-13T16:42:57-07:00","published_at": "2020-02-17T16:58:06-08:00","template_suffix": "details","published_scope": "global","tags": "Gummies, Tincture, Topicals","admin_graphql_api_id": "gid://shopify/Product/4625235247239","variants": [{"id": 32660152320135,"product_id": 4625235247239,"title": "Default Title","price": "150.00","sku": "BF-VTDB-0001","position": 1,"inventory_policy": "deny","compare_at_price": "166.00","fulfillment_service": "manual","inventory_management": null,"option1": "Default Title","option2": null,"option3": null,"created_at": "2020-02-17T15:57:16-08:00","updated_at": "2020-04-06T16:58:28-07:00","taxable": true,"barcode": "","grams": 227,"image_id": null,"weight": 0.5,"weight_unit": "lb","inventory_item_id": 34303050612871,"inventory_quantity": 0,"old_inventory_quantity": 0,"requires_shipping": true,"admin_graphql_api_id": "gid://shopify/ProductVariant/32660152320135"}],"options":[{"id": 5972776484999,"product_id": 4625235247239,"name": "Title","position": 1,"values": ["Default Title"]}],"images": [{"id": 14704883695751,"product_id": 4625235247239,"position": 1,"created_at": "2020-02-17T15:57:38-08:00","updated_at": "2020-03-19T07:25:38-07:00","alt": "BioFit 360 Gift Set - BioFit 360","width": 720,"height": 720,"src":"https://cdn.shopify.com/s/files/1/0327/6904/8711/products/bag-with-three.png?v=1584627938","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704883695751"},{"id": 14704885858439,"product_id": 4625235247239,"position": 2,"created_at": "2020-02-17T15:57:43-08:00","updated_at": "2020-03-19T07:25:38-07:00","alt": "BioFit 360 Gift Set - BioFit 360","width": 1167,"height": 1167,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/6-2_de1b6a60-eac4-4e5c-b863-bd36dd6d1eeb.jpg?v=1584627938","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704885858439"},{"id": 14704884744327,"product_id": 4625235247239,"position": 3,"created_at": "2020-02-17T15:57:40-08:00","updated_at": "2020-03-19T07:25:38-07:00","alt": "BioFit 360 Gift Set - BioFit 360","width": 1191,"height": 1191,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/14.jpg?v=1584627938","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704884744327"},{"id": 14704885301383,"product_id": 4625235247239,"position": 4,"created_at": "2020-02-17T15:57:42-08:00","updated_at": "2020-03-19T07:25:38-07:00","alt": "BioFit 360 Gift Set - BioFit 360","width": 1171,"height": 1171,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/19.jpg?v=1584627938","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704885301383"}],"image": {"id": 14704883695751,"product_id": 4625235247239,"position": 1,"created_at": "2020-02-17T15:57:38-08:00","updated_at": "2020-03-19T07:25:38-07:00","alt": "BioFit 360 Gift Set - BioFit 360","width": 720,"height": 720,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/bag-with-three.png?v=1584627938","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704883695751"}},{"id": 4625234854023,"title": "BioFit Sample Pak","body_html": "<p>Not sure what to try? or know you need it all?<br></p>\n<meta charset=\"utf-8\">\n<ul>\n<li>6 Gummies (30 mg Hemp Oil per gummy)</li>\n<li>4 Relief Cream mylar packets (10 mg Hemp Oil per packet)</li>\n<li>1 sample bottle of Relief Tincture (.05mL with 60mg Hemp Oil per bottle)</li>\n<li>1 sample bottle of Revive Tincture (.05mL with 60mg Hemp Oil per bottle)</li>\n<li>1 sample bottle of BioPet Tincture (.05mL with 32mg Hemp Oil per bottle)</li>\n</ul>\n<span>Each SAMPLE PAK comes with a sample guide to help you know how to use each product. </span>","vendor": "BioFit 360","product_type": "Bundle","created_at": "2020-02-17T15:57:11-08:00","handle": "biofit-hemp-oil-sample-pak","updated_at": "2020-04-13T16:42:57-07:00","published_at": "2020-02-19T12:30:47-08:00","template_suffix": "","published_scope": "global","tags": "CBD Oil, gummies, Self Care, tincture, topicals","admin_graphql_api_id": "gid://shopify/Product/4625234854023","variants": [{"id": 32660151795847,"product_id": 4625234854023,"title": "Default Title","price": "43.00","sku": "BF-SAMPK-0001","position": 1,"inventory_policy": "deny","compare_at_price": null,"fulfillment_service": "manual","inventory_management": null,"option1": "Default Title","option2": null,"option3": null,"created_at": "2020-02-17T15:57:11-08:00","updated_at": "2020-04-06T16:43:47-07:00","taxable": true,"barcode": "","grams": 312,"image_id": null,"weight": 11,"weight_unit": "oz","inventory_item_id": 34303049793671,"inventory_quantity": 0,"old_inventory_quantity": 0,"requires_shipping": true,"admin_graphql_api_id": "gid://shopify/ProductVariant/32660151795847"}],"options": [{"id": 5972776026247,"product_id": 4625234854023,"name": "Title","position": 1,"values": ["Default Title"]}],"images": [{"id": 14704877305991,"product_id": 4625234854023,"position": 1,"created_at": "2020-02-17T15:57:22-08:00","updated_at": "2020-03-19T07:25:39-07:00","alt": "BioFit Sample Pak - BioFit 360","width": 2122,"height": 2560,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/biofit-box.png?v=1584627939","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704877305991"},{"id": 14704877797511,"product_id": 4625234854023,"position": 2,"created_at": "2020-02-17T15:57:24-08:00","updated_at": "2020-03-19T07:25:39-07:00","alt": "BioFit Sample Pak - BioFit 360","width": 1701,"height": 1701,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/box3.jpg?v=1584627939","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704877797511"},{"id": 14704878649479,"product_id": 4625234854023,"position": 3,"created_at": "2020-02-17T15:57:26-08:00","updated_at": "2020-03-19T07:25:39-07:00","alt": "BioFit Sample Pak - BioFit 360","width": 1676,"height": 1676,"src": "https://cdn.shopify.com/s/files/1/0327/6904/8711/products/box5.jpg?v=1584627939","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704878649479"}],"image": {"id": 14704877305991,"product_id": 4625234854023,"position": 1,"created_at": "2020-02-17T15:57:22-08:00","updated_at": "2020-03-19T07:25:39-07:00","alt": "BioFit Sample Pak - BioFit 360","width":2122,"height":2560,"src":"https://cdn.shopify.com/s/files/1/0327/6904/8711/products/biofit-box.png?v=1584627939","variant_ids": [],"admin_graphql_api_id": "gid://shopify/ProductImage/14704877305991"}}]}');
        	}
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            response.setBody(e.getMessage() + '->' + e.getLineNumber());
            System.debug('-->BitIRAConnection= ' + authentication.Base_URL__c + ', entity = ' +  entity + ') - Callout Exception: ' + e.getMessage());
        }                                                                   
        return response.getBody();
    }
    
	@future(callout=true)
	public static void postCurrencyPurchasesFuture(Set<Id> purchaseIds){
        String response = '', xmlBody='', responseBody='', mensaje='';
    	List<Purchase_Order_Line_Item__c> polis = [Select id, Purchase_Order__c, Purchase_Order__r.Client__c,
                                                            	Quantity__c, Coin__r.Name, Total_Price__c, BitIRA_Sync_Error__c,
                                                            	Purchase_Order__r.Account_Type__c, BitIRA_Sync_Status__c
                                                            from Purchase_Order_Line_Item__c 
                                                   	where Purchase_Order__c in:purchaseIds and BitIRA_Sync_Status__c != 'Synced'];
        for(Purchase_Order_Line_Item__c poli : polis){
            mensaje='';
            poli.BitIRA_Sync_Status__c = 'Error';
            if(poli.Purchase_Order__r.Client__c!=null && poli.Purchase_Order__r.Account_Type__c!=null && poli.Quantity__c!=null && poli.Quantity__c>0){
                xmlBody = XMLUtil.getXMLCurrencyPurchases(poli, authentication.Key__c);
                responseBody = postBitIRAEntity('currency_purchases/action', '', xmlBody);
                if(responseBody.contains('<ResponseUpdateBitIRAV xsi:type="xsd:string">success</ResponseUpdateBitIRAV>')) poli.BitIRA_Sync_Status__c = 'Synced';
                else if(responseBody.contains('We\'re sorry, but something went wrong (500)')) mensaje = 'Error code 500, if possible product no found';
                else if(responseBody.contains('<ResponseUpdateBitIRAV xsi:type="xsd:string">User not found</ResponseUpdateBitIRAV>'))  mensaje = 'User not found';
				else mensaje = responseBody.left(255);
                response = response + '\n' + poli.Id + ' - ' + mensaje;
            }else{
                mensaje = 'Este poli no tiene los campos requeridos';
                response = response + '\n' + poli.Id + ' - Este poli no tiene los campos requeridos';
            }
            poli.BitIRA_Sync_Error__c = mensaje;
        }
        if(polis.size()>0) update polis;
        System.debug(xmlBody);
        System.debug(response);
        System.debug('Entry approval process');
        try{
            for(ProcessInstance pi : [select TargetObjectId from ProcessInstance WHERE TargetObjectId in:purchaseIds AND Status='Pending']){
                purchaseIds.remove(pi.TargetObjectId);
                System.debug('Record have process pending: ' + pi.TargetObjectId);
            }
            List<Purchase_Order__c> pos = [Select id, OwnerId from Purchase_Order__c where Id in:purchaseIds];
            for(Purchase_Order__c auxPO : pos){
                Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                req.setProcessDefinitionNameOrId('Approval_Process_for_Purchase_Order');
                req.setComments('Submitting approval Trigger');
                req.setObjectId(auxPO.Id);
                req.setSubmitterId(auxPO.OwnerId);
                Approval.ProcessResult result = Approval.process(req);
                system.debug('Send approval:' + result);
            }
        }catch(Exception e){
            System.debug('Entry approval process -> ' + e.getMessage());
        }
    }
                                                                            
	/*public static void postCurrencyPurchases(Set<Id> poliIds){
        String response = '', xmlBody='', responseBody='', mensaje='';
    	List<Purchase_Order_Line_Item__c> polis = [Select id, Purchase_Order__c, Purchase_Order__r.Client__c,
                                                            	Quantity__c, Coin__r.Name, Total_Price__c, 
                                                            	Purchase_Order__r.Account_Type__c
                                                            from Purchase_Order_Line_Item__c where id in:poliIds];
        for(Purchase_Order_Line_Item__c poli : polis){
            if(poli.Purchase_Order__r.Client__c!=null && poli.Purchase_Order__r.Account_Type__c!=null && poli.Quantity__c!=null && poli.Quantity__c>0){
                xmlBody = XMLUtil.getXMLCurrencyPurchases(poli, authentication.Key__c);
                responseBody = postBitIRAEntity('currency_purchases/action', '', xmlBody);
                if(responseBody.contains('<ResponseUpdateBitIRAV xsi:type="xsd:string">User not found</ResponseUpdateBitIRAV>'))  mensaje = 'User not found';
                else if(responseBody.contains('We\'re sorry, but something went wrong (500)')) mensaje = 'Error code 500, if possible product no found';
                else if(responseBody.contains('<ResponseUpdateBitIRAV xsi:type="xsd:string">success</ResponseUpdateBitIRAV>')) mensaje = 'Post success!';
               	else mensaje = responseBody;
                response = response + '\n' + poli.Id + ' - ' + mensaje;
            }else{
                response = response + '\n' + poli.Id + ' - Este poli no tiene los campos requeridos';
            }
        }
        //Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); mail.setToAddresses(new String[] {'rurupeque@cloudcreations.com'}); mail.setSubject('Birch'); mail.setPlainTextBody(xmlBody); Messaging.sendEmail(new Messaging.SingleEmailMessage[]{ mail });
        System.debug(xmlBody);
        System.debug(response);
        System.debug('Chau');
    } */                                                                               

}