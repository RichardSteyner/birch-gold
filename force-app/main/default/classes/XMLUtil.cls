public class XMLUtil {
    
    public static String openingCode = '&lt;';
    public static String closingCode = '&gt;';
    
    public static String opening = '<';
    public static String closing = '>';
    
    public static String openingXML(String etiqueta, Map<String, String> mapParams){
        String params = '';
        if(mapParams!=null){
            for(String key : mapParams.keySet()){
                params = params + ' ' + key + '=\'' + mapParams.get(key) + '\'';
            }
        }
        return opening + etiqueta + params + closing;
    }
    
    public static String closingXML(String etiqueta){
        return opening + '/' + etiqueta + closing;
    }
    
    public static String openingXMLCode(String etiqueta, Map<String, String> mapParams){
        String params = '';
        if(mapParams!=null){
            for(String key : mapParams.keySet()){
                params = params + ' ' + key + '=\'' + mapParams.get(key) + '\'';
            }
        }
        return openingCode + etiqueta + params + closingCode;
    }
    
    public static String closingXMLCode(String etiqueta){
        return openingCode + '/' + etiqueta + closingCode;
    }
                                                                            
	public static String getXMLCurrencyPurchases(Purchase_Order_Line_Item__c poli, String key){
        String xmlBody = '';
        xmlBody = openingXML('soap:Envelope', new Map<String, String>{'xmlns:soap'=>'http://schemas.xmlsoap.org/soap/envelope/', 'xmlns:xsi'=>'http://www.w3.org/2001/XMLSchema-instance', 'xmlns:xsd'=>'http://www.w3.org/2001/XMLSchema'}) +
            	openingXML('soap:Body',null) + openingXML('ExecuteTransaction',new Map<String, String>{'xmlns'=>'http://localhost/Intellect/ExternalWebService'}) +
                openingXML('Request',null) +
            	openingXMLCode('UpdateBitIRAV', new Map<String, String>{'ID'=>'4000023426', 'Key'=>key}) + 
            	openingXMLCode('VelocifyID', null) + /*poli.Purchase_Order__c*/'964990' + closingXMLCode('VelocifyID')  + 
            	openingXMLCode('RequestID', null) + poli.Purchase_Order__r.Client__c + closingXMLCode('RequestID')  + 
            	openingXMLCode('Quantity', null) + poli.Quantity__c + closingXMLCode('Quantity')  + 
            	openingXMLCode('Coin', null) + poli.Coin__r.Name + closingXMLCode('Coin')  + 
            	openingXMLCode('Price', null) + poli.Total_Price__c + closingXMLCode('Price')  + 
            	openingXMLCode('Account', null) + poli.Purchase_Order__r.Account_Type__c + closingXMLCode('Account')  + 
            	openingXMLCode('SubmittedDate', null) + System.today().format() + closingXMLCode('SubmittedDate')  + 
            	openingXMLCode('ResponseTemplate', null) + 'ResponseUpdateBitIRAV' + closingXMLCode('ResponseTemplate')  + 
            	openingXMLCode('Sendtoportal', null) + '' + closingXMLCode('Sendtoportal')  + 
            	closingXMLCode('UpdateBitIRAV') +
                closingXML('Request') + closingXML('ExecuteTransaction') + closingXML('soap:Body') + closingXML('soap:Envelope');
        return xmlBody;
    }

}