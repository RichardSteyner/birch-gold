/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* This class serves the logic for pricing data retrieval and calculation cost for products.
*
* This class uses the BaysideGold REST Service for fetching the products pricings and status.
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Alsinan Nazim   	<alsinan.naz@gmail.com>
* @modifiedBy     Alsinan Nazim   	<alsinan.naz@gmail.com>
* @maintainedBy   Alsinan Nazim   	<alsinan.naz@gmail.com>
* @version        1.0
* @created        2020-03-20
* @modified       YYYY-MM-DD
* @systemLayer    Invocation | Service | Utility | Selector | Domain | Test
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/
public with sharing class DailyPricingSheetController {
    
    public String lastUpdated {get; set;}
    public PricingDataWrapper priceWrapper {get; set;}
    public ProductDataWrapper[] productWrapperList {get; set;}
    public boolean loadedData {get; set;}
    public Map<String, Admin_Fee_Settings__mdt> adminPricingMap {get; set;}
    public Map<String, Pricing_Configuration__mdt> pricingConfigMap {get; set;}
    public Map<String, Product_Specific_Pricing__mdt> specificConfigMap {get; set;}
    public Map<String, List<String>> categoryListingMap {get; set;}
    public String xmlheader {get; set;}
    public Integer productCount {get; set;}
    public List<ExcelDataWrapper> excelDataList {get; set;}
    
    public Final String UnAvailable = 'Unavailable';
    public Final String InStock = 'In Stock';
    public Final String outOfStock = 'Out Of Stock';
    
    public Integer numismaticItemCount {get; set;}
    public Integer proofItemCount {get; set;}
    public Integer bullionGoldItemCount {get; set;}
    public Integer bullionSilverItemCount {get; set;}
    public Integer semiNumismaticSilverItemCount {get; set;}
    public Integer semiNumismaticGoldItemCount {get; set;}
    
    public Integer total_SNGC {get; set;}
    public Integer total_BS {get; set;}
    public Integer total_BG {get; set;}
    public Integer total_PAE {get; set;}
    public Integer total_NG {get; set;}
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Constructor for fetching the custom metadata settings and initialization.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    
    * @param    
    * @return   
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public DailyPricingSheetController() {
        
        xmlheader ='<?xml version="1.0"?><?mso-application progid="Excel.Sheet"?>';
        loadedData = false;
        try {
            List<Pricing_Configuration__mdt> pricingConfigList = [SELECT Id, DeveloperName, MasterLabel, Active__c, Admin_Fee__c, Buy_Back_Admin_Fee__c, SKU__c
                                                                  FROM Pricing_Configuration__mdt WHERE Active__c =: true];
            pricingConfigMap = new Map<String, Pricing_Configuration__mdt>();
            if(!pricingConfigList.isEmpty()) {
                for(Pricing_Configuration__mdt pricingConfig : pricingConfigList) {
                    pricingConfigMap.put(pricingConfig.SKU__c, pricingConfig);
                } 
            }
            
            List<Product_Specific_Pricing__mdt> specificPricingList = [SELECT Id, DeveloperName, MasterLabel, Active__c, Admin_Fee__c, SKU__c, Buy_Back_Admin_Fee__c
                                                                       FROM Product_Specific_Pricing__mdt WHERE Active__c =: true];
            specificConfigMap = new Map<String, Product_Specific_Pricing__mdt>();
            if(!specificPricingList.isEmpty()) {
                for(Product_Specific_Pricing__mdt specificPricing : specificPricingList) {
                    specificConfigMap.put(specificPricing.SKU__c, specificPricing);
                }  
            }
            
            List<Admin_Fee_Settings__mdt> adminPricingList = [SELECT Id, DeveloperName, MasterLabel, Admin_Fee__c, Buy_Back_Admin_Fee__c
                                                              FROM Admin_Fee_Settings__mdt];
            adminPricingMap = new Map<String, Admin_Fee_Settings__mdt>();
            if(!adminPricingList.isEmpty()) {
                for(Admin_Fee_Settings__mdt adminFeeData : adminPricingList) {
                    adminPricingMap.put(adminFeeData.MasterLabel, adminFeeData);
                } 
            }
            retrievePricingData();
        }
        catch(Exception ex) {
            
            System.debug('Exception occured >>> '+ex);
        }
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method for calling out the REST service for Bayside Gold API.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    
    * @param    
    * @return   JSON response.
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public string getPricingDataFromAPI() {
        
        String jsonResponse;
        try {
            
            Http httpInstance = new Http();
            HttpRequest request = new HttpRequest();
            request.setendpoint(System.Label.Baysidegold_Endpoint);
            request.setmethod('GET'); 
            HttpResponse response;
            response = httpInstance.send(request);
            jsonResponse = response.getbody();
            return jsonResponse;
        } 
        catch(CalloutException ex) {
            
            System.debug('Exception occured >>> '+ex);
            return String.valueOf(ex);
        }
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method for setting the pricing data for each of the products based on the settings.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    
    * @param    
    * @return   Wrapper instance with product data.
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public void retrievePricingData() {
        
        try {

            String json = getPricingDataFromAPI();
            priceWrapper = (PricingDataWrapper)System.JSON.deserialize(json, PricingDataWrapper.class);
            lastUpdated = priceWrapper.timestamp;
            productWrapperList = new List<ProductDataWrapper>();
            Integer i = 0;
            categoryListingMap = new Map<String, List<String>>();
            categoryListingMap.put('NUMISMATIC', null);
            categoryListingMap.put('PROOF AMERICAN EAGLES', null);
            categoryListingMap.put('BULLION GOLD', null);
            categoryListingMap.put('BULLION SILVER', null);
            categoryListingMap.put('SEMI NUMISMATIC GOLD CANADIAN', null);
            categoryListingMap.put('SEMI NUMISMATIC SILVER CANADIAN', null);
            
            for(PricingDataWrapper.RetailPrices sellingUnit : priceWrapper.RetailPrices) {
                ProductDataWrapper thisProduct;
                Decimal adminFee = 0;
                Decimal cost = 0;
                Decimal buyBackAdminFee = 0;
                Decimal buyBackCost = 0;
                Boolean isSpecific = false;
                Boolean isSpecificPricing = false;
                Boolean found = false;
                List<String> tempList;
                
                // Numismatic Coins
                if(sellingUnit.category == 'U.S. 90% Silver Coins') {
                    found = true;
                    if(categoryListingMap.get('NUMISMATIC') != null) {
                        tempList = new List<String>();
                        tempList = categoryListingMap.get('NUMISMATIC');
                        tempList.add(sellingUnit.sku);
                        categoryListingMap.put('NUMISMATIC', tempList);
                    }
                    else {
                        tempList = new List<String>();
                        tempList.add(sellingUnit.sku);
                        categoryListingMap.put('NUMISMATIC', tempList);
                        }
                }
                else if(sellingUnit.category == 'Old World Coins' && sellingUnit.metal == 'Gold') {
                    found = true;
                    if(categoryListingMap.get('BULLION GOLD') != null) {
                        tempList = new List<String>();
                        tempList = categoryListingMap.get('BULLION GOLD');
                        tempList.add(sellingUnit.sku);
                        categoryListingMap.put('BULLION GOLD', tempList);
                    }
                    else {
                        tempList = new List<String>();
                        tempList.add(sellingUnit.sku);
                        categoryListingMap.put('BULLION GOLD', tempList);
                    }
                }
                else if(sellingUnit.description.contains('Proof')) {
                    if(sellingUnit.description.contains('Eagle')) {
                        found = true;
                        if(categoryListingMap.get('PROOF AMERICAN EAGLES') != null) {
                            tempList = new List<String>();
                            tempList = categoryListingMap.get('PROOF AMERICAN EAGLES');
                            tempList.add(sellingUnit.sku);
                            categoryListingMap.put('PROOF AMERICAN EAGLES', tempList);
                        }
                        else {
                            tempList = new List<String>();
                            tempList.add(sellingUnit.sku);
                            categoryListingMap.put('PROOF AMERICAN EAGLES', tempList);
                        }
                    }
                }
                else if(sellingUnit.category == 'Modern Coins' || sellingUnit.category == 'Bars' || sellingUnit.category == 'Exclusive Coins' || sellingUnit.category == 'Bars & Rounds') {
                    if(sellingUnit.description.contains('Gold')) {
                        if(sellingUnit.description != 'Gold Canadian 0.25-oz Twin Leaf 2018') {
                            found = true;
                            if(categoryListingMap.get('BULLION GOLD') != null) {
                                tempList = new List<String>();
                                tempList = categoryListingMap.get('BULLION GOLD');
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('BULLION GOLD', tempList);
                            }
                            else {
                                tempList = new List<String>();
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('BULLION GOLD', tempList);
                            }
                        }
                    }
                    if(sellingUnit.description.contains('Silver')) {
                        if(sellingUnit.description != 'Silver Canadian 2-oz Twin Leaf 2018') {
                            found = true;
                            if(categoryListingMap.get('BULLION SILVER') != null) {
                                tempList = new List<String>();
                                tempList = categoryListingMap.get('BULLION SILVER');
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('BULLION SILVER', tempList);
                            }
                            else {
                                tempList = new List<String>();
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('BULLION SILVER', tempList);
                            }
                        }
                    }
                    
                }
                else if(sellingUnit.category == 'Pre 33 U.S. Coins') {
                    found = true;
                    if(categoryListingMap.get('NUMISMATIC') != null) {
                        tempList = new List<String>();
                        tempList = categoryListingMap.get('NUMISMATIC');
                        tempList.add(sellingUnit.sku);
                        categoryListingMap.put('NUMISMATIC', tempList);
                    }
                    else {
                        tempList = new List<String>();
                        tempList.add(sellingUnit.sku);
                        categoryListingMap.put('NUMISMATIC', tempList);
                    }
                }
                if(found == false) {
                    if(sellingUnit.description != 'Gold American Buffalo Proof 1-oz') {
                        if(sellingUnit.description.contains('Gold')) {
                            if(categoryListingMap.get('SEMI NUMISMATIC GOLD CANADIAN') != null) {
                                tempList = new List<String>();
                                tempList = categoryListingMap.get('SEMI NUMISMATIC GOLD CANADIAN');
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('SEMI NUMISMATIC GOLD CANADIAN', tempList);
                            }
                            else {
                                tempList = new List<String>();
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('SEMI NUMISMATIC GOLD CANADIAN', tempList);
                            }
                        }
                        else if(sellingUnit.description.contains('Silver')) {
                            if(categoryListingMap.get('SEMI NUMISMATIC SILVER CANADIAN') != null) {
                                tempList = new List<String>();
                                tempList = categoryListingMap.get('SEMI NUMISMATIC SILVER CANADIAN');
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('SEMI NUMISMATIC SILVER CANADIAN', tempList);
                            }
                            else {
                                tempList = new List<String>();
                                tempList.add(sellingUnit.sku);
                                categoryListingMap.put('SEMI NUMISMATIC SILVER CANADIAN', tempList);
                            }
                        }
                    }
                }
                
                
                if(specificConfigMap.values().size() > 0) {
                    if(specificConfigMap.containsKey(sellingUnit.sku)) {
                        isSpecificPricing = true;
                        adminFee = specificConfigMap.get(sellingUnit.sku).Admin_Fee__c;
                        cost = (sellingUnit.price * adminFee).setScale(2);
                        buyBackAdminFee = specificConfigMap.get(sellingUnit.sku).Buy_Back_Admin_Fee__c;
                        buyBackCost = (sellingUnit.price - (sellingUnit.price * buyBackAdminFee)).setScale(2);
                        // Add logic for specific product with admin fee from metadata
                        if(sellingUnit.availability == UnAvailable || sellingUnit.availability == outOfStock) {
                            thisProduct = new ProductDataWrapper(i, 0, sellingUnit.description, sellingUnit.sku, 0.00, adminFee, 0.00, buyBackAdminFee, buyBackCost);
                        }
                        else {
                            thisProduct = new ProductDataWrapper(i, 0, sellingUnit.description, sellingUnit.sku, sellingUnit.price, adminFee, cost, buyBackAdminFee, buyBackCost);
                        }
                    }
                }
                if(pricingConfigMap.values().size() > 0 && isSpecificPricing == false) {
                    if(pricingConfigMap.containsKey(sellingUnit.sku)) {
                        isSpecific = true;
                        adminFee = pricingConfigMap.get(sellingUnit.sku).Admin_Fee__c;
                        cost = (sellingUnit.price + adminFee).setScale(2);
                        buyBackAdminFee = pricingConfigMap.get(sellingUnit.sku).Buy_Back_Admin_Fee__c;
                        buyBackCost = (sellingUnit.price + buyBackAdminFee).setScale(2);
                        // Add logic for specific product from metadata
                        if(sellingUnit.availability == UnAvailable || sellingUnit.availability == outOfStock) {
                            thisProduct = new ProductDataWrapper(i, 0, sellingUnit.description, sellingUnit.sku, 0.00, adminFee, 0.00, buyBackAdminFee, buyBackCost);
                        }
                        else {
                            thisProduct = new ProductDataWrapper(i, 0, sellingUnit.description, sellingUnit.sku, sellingUnit.price, adminFee, cost, buyBackAdminFee, buyBackCost);
                        }
                    }
                }
                
                if(isSpecific == false && isSpecificPricing == false) {
                    if(sellingUnit.description.contains('Proof')) {
                        adminFee = adminPricingMap.get('Proof').Admin_Fee__c;
                        buyBackAdminFee = adminPricingMap.get('Proof').Buy_Back_Admin_Fee__c;
                    }
                    else if(sellingUnit.category == 'Modern Coins' || sellingUnit.category == 'Bars' || sellingUnit.category == 'Exclusive Coins') {
                        adminFee = adminPricingMap.get('Bullion').Admin_Fee__c;
                        buyBackAdminFee = adminPricingMap.get('Bullion').Buy_Back_Admin_Fee__c;
                    }
                    else if(sellingUnit.category == 'Pre 33 U.S. Coins') {
                        adminFee = adminPricingMap.get('Numismatic').Admin_Fee__c;
                        buyBackAdminFee = adminPricingMap.get('Numismatic').Buy_Back_Admin_Fee__c;
                    }
                    else {
                        adminFee = adminPricingMap.get('SemiNumismatic').Admin_Fee__c;
                        buyBackAdminFee = adminPricingMap.get('SemiNumismatic').Buy_Back_Admin_Fee__c;
                    }
                    cost = (sellingUnit.price * adminFee).setScale(2);
                    buyBackCost = (sellingUnit.price - (sellingUnit.price * buyBackAdminFee)).setScale(2);
                    if(sellingUnit.availability == UnAvailable || sellingUnit.availability == outOfStock) {
                        thisProduct = new ProductDataWrapper(i, 0, sellingUnit.description, sellingUnit.sku, 0.00, adminFee, 0.00, buyBackAdminFee, buyBackCost);
                    }
                    else {
                        thisProduct = new ProductDataWrapper(i, 0, sellingUnit.description, sellingUnit.sku, sellingUnit.price, adminFee, cost, buyBackAdminFee, buyBackCost);
                    }
                }
                productWrapperList.add(thisProduct);
                i++;
            }
            loadedData = true;
            productCount = productWrapperList.size();
        }
        catch(Exception ex) {
            System.debug('Exception occured >>> '+ex);
        }
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method for generating MS Excel file with pricing data.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    
    * @param    
    * @return   MS Excel file.
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public PageReference exportToExcel() {
        try {
            // Prepare data for excel sheet export.
            List<String> numismaticCategoryList = new List<String>();
            numismaticCategoryList.add('Franklin');
            numismaticCategoryList.add('Kennedy');
            numismaticCategoryList.add('Morgan');
            numismaticCategoryList.add('Peace');
            
            excelDataList = new List<ExcelDataWrapper>();
            Integer negativeIndex = -1;
            Integer index = 0;
            for(String categoryName : categoryListingMap.keySet()) {
                Integer prodCounter = 0;
                List<ProductDataWrapper> tempProductList = new List<ProductDataWrapper>();
                List<String> skuList = new List<String>();
                if(categoryListingMap.get(categoryName) != null) {
                    skuList = categoryListingMap.get(categoryName);
                    if(skuList.size() > 0) {
                        if(categoryName == 'NUMISMATIC') {
                            Integer totalProd = 0;
                            List<subCategoryWrapper> subWrapperList = new List<subCategoryWrapper>();
                            for(String section : numismaticCategoryList) {
                                tempProductList = new List<ProductDataWrapper>();
                                for(String productSKU : skuList) { 
                                    for(ProductDataWrapper productInfo : productWrapperList) {
                                        if(productInfo.sku == productSKU && productInfo.productName.contains(section)) {
                                            ProductDataWrapper prodInfo = new ProductDataWrapper(index++, negativeIndex--, productInfo.productName, productInfo.sku, productInfo.unitPrice, productInfo.adminFee, productInfo.totalCost, productInfo.buyBackAdminFee, productInfo.buyBackAdminCost);                                    
                                            tempProductList.add(prodInfo); 
                                            totalProd++;
                                        }
                                    }
                                }
                                subCategoryWrapper subWrapper = new subCategoryWrapper(tempProductList.size(), tempProductList);
                                subWrapperList.add(subWrapper);
                                negativeIndex = -1;
                                totalProd+=1;
                            }
                            ExcelDataWrapper excelWrapper = new ExcelDataWrapper(categoryName, subWrapperList, totalProd);
                            excelDataList.add(excelWrapper); 
                            numismaticItemCount = -totalProd-4;
                        }
                        else {
                            for(String productSKU : skuList) { 
                                for(ProductDataWrapper productInfo : productWrapperList) {
                                    if(productInfo.sku == productSKU) {
                                        ProductDataWrapper prodInfo = new ProductDataWrapper(index++, negativeIndex--, productInfo.productName, productInfo.sku, productInfo.unitPrice, productInfo.adminFee, productInfo.totalCost, productInfo.buyBackAdminFee, productInfo.buyBackAdminCost);                                    
                                        tempProductList.add(prodInfo); 
                                        prodCounter++;
                                    }
                                }
                            }
                            subCategoryWrapper subWrapper = new subCategoryWrapper(tempProductList.size(), tempProductList);
                            List<subCategoryWrapper> subWrapperList = new List<subCategoryWrapper>();
                            subWrapperList.add(subWrapper);
                            ExcelDataWrapper excelWrapper = new ExcelDataWrapper(categoryName, subWrapperList, tempProductList.size());
                            excelDataList.add(excelWrapper); 
                            negativeIndex = -1;
                        }
                    }
                }
                if(categoryName ==  'PROOF AMERICAN EAGLES') {
                    proofItemCount = prodCounter;
                }
                if(categoryName ==  'BULLION GOLD') {
                    bullionGoldItemCount = prodCounter;
                }
                if(categoryName ==  'BULLION SILVER') {
                    bullionSilverItemCount = prodCounter;
                }
                if(categoryName ==  'SEMI NUMISMATIC GOLD CANADIAN') {
                    semiNumismaticGoldItemCount = prodCounter;
                }
                if(categoryName ==  'SEMI NUMISMATIC SILVER CANADIAN') {
                    
                    semiNumismaticSilverItemCount = prodCounter;
                }
            }
            total_SNGC = -semiNumismaticSilverItemCount - 4;
            total_BS = total_SNGC - semiNumismaticGoldItemCount - 3; 
            total_BG = total_BS - bullionSilverItemCount - 3;
            total_PAE = total_BG - bullionGoldItemCount - 3;
            total_NG = total_PAE - proofItemCount - 3;

            PageReference returnExcelFile = new PageReference('/apex/BirchGoldDailyPricingExcel');
            return returnExcelFile;
        }
        catch(Exception ex) {
            System.debug('Exception occured >>> '+ex);
            return null;
        }
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method for calculating cost.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    
    * @param    
    * @return   
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public void calculateCost() { 
        
        try {
            Integer currentIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('index'));
            Decimal currentMarkup = Decimal.valueOf(Apexpages.currentPage().getParameters().get('markup'));
            if(currentIndex != null) {
                for(Integer i=0; i<productWrapperList.size(); i++) {
                    if(productWrapperList[i].index == currentIndex) {
                        String currentSKU = productWrapperList[i].sku;
                        if(pricingConfigMap.values().size() > 0) {
                            if(pricingConfigMap.containsKey(String.valueOf(currentSKU))) {
                                productWrapperList[i].totalCost = (productWrapperList[i].unitPrice + productWrapperList[i].adminFee).setScale(2);
                            }
                            else {
                                productWrapperList[i].totalCost = (productWrapperList[i].unitPrice * productWrapperList[i].adminFee).setScale(2);
                            }
                        }
                        else {
                            productWrapperList[i].totalCost = (productWrapperList[i].unitPrice * productWrapperList[i].adminFee).setScale(2);
                        }
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('Exception occured >>> '+ex);
        }
    }
    
    /**
    * ───────────────────────────────────────────────────────────────────────────────────────────────┐
    * Method for calculating buy back cost.
    * ────────────────────────────────────────────────────────────────────────────────────────────────
    * @param    
    * @param    
    * @return   
    * ───────────────────────────────────────────────────────────────────────────────────────────────┘
    */
    public void calculateBuyBackCost() { 
        
        try {
            Integer currentIndex = Integer.valueOf(Apexpages.currentPage().getParameters().get('index'));
            Decimal currentMarkup = Decimal.valueOf(Apexpages.currentPage().getParameters().get('markup'));
            
            if(currentIndex != null) {
                for(Integer i=0; i<productWrapperList.size(); i++) {
                    if(productWrapperList[i].index == currentIndex) {
                        if(pricingConfigMap.values().size() > 0) {
                            String currentSKU = productWrapperList[i].sku;
                            if(pricingConfigMap.containsKey(String.valueOf(currentSKU))) {
                                productWrapperList[i].buyBackAdminCost = (productWrapperList[i].unitPrice + productWrapperList[i].buyBackAdminFee).setScale(2);
                            }
                            else {
                                productWrapperList[i].buyBackAdminCost = (productWrapperList[i].unitPrice - (productWrapperList[i].unitPrice * productWrapperList[i].buyBackAdminFee)).setScale(2);
                            }
                        }
                        else {
                            productWrapperList[i].buyBackAdminCost = (productWrapperList[i].unitPrice - (productWrapperList[i].unitPrice * productWrapperList[i].buyBackAdminFee)).setScale(2);
                        }
                    }
                }
            }
        }
        catch(Exception ex) {
            System.debug('Exception occured >>> '+ex);
        }
    }    
    
    public class ExcelDataWrapper {
        
        public String categoryName {get; set;}
        public List<subCategoryWrapper> subCategoryList {get; set;}
        public Integer itemCount {get; set;}
        
        public ExcelDataWrapper(String thisCategoryName, List<subCategoryWrapper> thisSubCategoryWrapper, Integer thisItemCount) {
            categoryName = thisCategoryName;
            subCategoryList = thisSubCategoryWrapper;
            itemCount = thisItemCount;
        }
    }
    
    public class subCategoryWrapper {
        
        public Integer itemCount {get; set;}
        public List<ProductDataWrapper> productDetails {get; set;}
        
        public subCategoryWrapper(Integer thisItemCount, List<ProductDataWrapper> thisProductDetails) {
            itemCount = thisItemCount;
            productDetails = thisProductDetails;
        }
    }
    
    public class ProductDataWrapper {
        
        public Integer index {get; set;}
        public Integer negativeIndex {get; set;}
        public String productName {get; set;}
        public String sku {get; set;}
        public Decimal unitPrice {get; set;}
        public Decimal adminFee {get; set;}
        public Decimal totalCost {get; set;}
        public Decimal buyBackAdminFee {get; set;}
        public Decimal buyBackAdminCost {get; set;}
        
        
        public ProductDataWrapper(Integer thisIndex,
                                  Integer thisNegativeIndex,
                                  String thisProductName,
                                  String thisSku,
                                  Decimal thisUnitPrice,
                                  Decimal thisAdminFee,
                                  Decimal thisTotalCost,
                                  Decimal thisBuyBackAdminFee,
                                  Decimal thisBuyBackAdminCost) 
        {
            index = thisIndex;
            negativeIndex = thisNegativeIndex;
            productName = thisProductName;
            sku = thisSku;
            unitPrice = thisUnitPrice;
            adminFee = thisAdminFee;
            totalCost = thisTotalCost;
            buyBackAdminFee = thisBuyBackAdminFee;
            buyBackAdminCost = thisBuyBackAdminCost;
        }
    }
}