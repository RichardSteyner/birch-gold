public class XigniteConnection {
    
    public static XigniteAPI__c authentication = XigniteAPI__c.getOrgDefaults();

	public static String getXigniteEntity(String entity, String filters, String fields){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(authentication.Base_URL__c + entity + '?' + authentication.Token__c + (String.isNotEmpty(filters) ? '&' + filters : filters) + (String.isNotEmpty(fields) ? '&_fields=' + fields : ''));
		//System.debug(endpoint);
        request.setHeader('Accept','application/json');
        request.setHeader('Content-type', 'application/json');
        request.setMethod('GET');
        request.setTimeout(120000);
        Http http = new Http();
        HTTPResponse response;
        try{
            if(!Test.isRunningTest()){
                response = http.send(request);
                System.debug('->XigniteConnection= ' + authentication.Base_URL__c + ', entity = ' +  entity + ', filters = ' +  filters + ') => \nResponse Status Code: ' + response.getStatusCode() + ', Response Body: ' + (String.isNotEmpty(response.getBody()) ? response.getBody().left(255) : ''));
            }else{
                response = new HTTPResponse();
                response.setStatusCode(200);
                if(entity.equalsIgnoreCase('GetRealTimeMetalQuotes')) response.setBody('[{"Spread":1.29,"Ask":1727.24,"Mid":1726.595,"Bid":1725.95,"Delay":0.0090014,"Outcome":"Success","Source":"SwissQuote","Time":"4:58:20 PM","Date":"04/23/2020","Currency":"USD","QuoteType":"Spot","Unit":"1 troy ounce","Symbol":"XAU","Name":"Gold 1 Oz","Identity":"Request","Message":null},{"Spread":0.0246,"Ask":15.2003,"Mid":15.188,"Bid":15.1757,"Delay":0,"Outcome":"Success","Source":"SwissQuote","Time":"4:58:19 PM","Date":"04/23/2020","Currency":"USD","QuoteType":"Spot","Unit":"1 troy ounce","Symbol":"XAG","Name":"Silver 1 Oz","Identity":null,"Message":null}]');
                else if(entity.equalsIgnoreCase('GetRealTimeMetalQuote')) response.setBody('{"Spread":0.0246,"Ask":15.2003,"Mid":15.188,"Bid":15.1757,"Delay":0,"Outcome":"Success","Source":"SwissQuote","Time":"4:58:19 PM","Date":"04/23/2020","Currency":"USD","QuoteType":"Spot","Unit":"1 troy ounce","Symbol":"XAG","Name":"Silver 1 Oz","Identity":null,"Message":null}');
           	}
        }
        catch(Exception e){
            response = new HTTPResponse();
            response.setStatusCode(500);
            response.setBody(e.getMessage() + '->' + e.getLineNumber());
            System.debug('-->XigniteConnection= ' + authentication.Base_URL__c + ', entity = ' +  entity + ', filters = ' +  filters + ') - \nCallout Exception: ' + e.getMessage());
        }
        return response.getBody();
    }
                                                                            
}