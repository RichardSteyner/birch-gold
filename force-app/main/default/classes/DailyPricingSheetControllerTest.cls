/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class contains the unit test methods for the Apex code DailyPricingSheetController.
** ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Alsinan Nazim   	<alsinan.naz@gmail.com>
* @modifiedBy     Alsinan Nazim   	<alsinan.naz@gmail.com>
* @maintainedBy   Alsinan Nazim   	<alsinan.naz@gmail.com>
* @version        1.0
* @created        2020-03-20
* @modified       YYYY-MM-DD
* @systemLayer    Invocation | Service | Utility | Selector | Domain | Test
* @see			  DailyPricingSheetController.apxc
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
@isTest
public class DailyPricingSheetControllerTest {
    
    public static testmethod void retrievePricingDataTest() { 
        
        HttpRequest request = new HttpRequest();
        DailyPricingSheetMock dummyResponse = new DailyPricingSheetMock(request);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, dummyResponse);
        DailyPricingSheetController getPriceData = new DailyPricingSheetController();
        System.assert(getPriceData.lastUpdated != null);
        Test.stopTest();
    }
    
    public static testmethod void exportToExcelTest() {
        
        Test.startTest();
        PageReference currentPage = page.BirchGoldDailyPricingSheet;
        currentPage.getParameters().put('index', '3');
        currentPage.getParameters().put('markup', '4.5');
        Test.setCurrentPageReference(currentPage);
        HttpRequest request = new HttpRequest();
        DailyPricingSheetMock dummyResponse = new DailyPricingSheetMock(request);
        Test.setMock(HttpCalloutMock.class, dummyResponse);
        DailyPricingSheetController getPriceData = new DailyPricingSheetController();
        getPriceData.exportToExcel();
        Test.stopTest();
    }
    
    public static testmethod void calculateBuyBackCostTest() {
        
        Test.startTest();
        PageReference currentPage = page.BirchGoldDailyPricingSheet;
        currentPage.getParameters().put('index', '3');
        currentPage.getParameters().put('markup', '4.5');
        Test.setCurrentPageReference(currentPage);
        HttpRequest request = new HttpRequest();
        DailyPricingSheetMock dummyResponse = new DailyPricingSheetMock(request);
        Test.setMock(HttpCalloutMock.class, dummyResponse);
        DailyPricingSheetController getPriceData = new DailyPricingSheetController();
        getPriceData.calculateBuyBackCost();
        Test.stopTest();
    }
    
    public static testmethod void calculateCostTest() {
        
        Test.startTest();
        PageReference currentPage = page.BirchGoldDailyPricingSheet;
        currentPage.getParameters().put('index', '3');
        currentPage.getParameters().put('markup', '4.5');
        Test.setCurrentPageReference(currentPage);
        HttpRequest request = new HttpRequest();
        DailyPricingSheetMock dummyResponse = new DailyPricingSheetMock(request);
        Test.setMock(HttpCalloutMock.class, dummyResponse);
        DailyPricingSheetController getPriceData = new DailyPricingSheetController();
        getPriceData.calculateCost();
        Test.stopTest();
    }
}