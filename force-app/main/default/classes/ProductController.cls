public with sharing class ProductController {
    
    @AuraEnabled(cacheable=true)
    public static Map<String, String> getProductInfo(String productId, String country){
        Map<String, String> productData = new Map<String, String>();
        
        /*  Costs_Per_Product__c: custom object that relates cost of a product based on a country.
            Has different custom fields based on the differents types of costs: Cost_per_Calendar_Month__c, ATM_Fee__c, Card_Replacement_Cost__c    */
        Costs_Per_Product__c cost;

        if(!String.isEmpty(productId) || !String.isEmpty(country)){
             cost = [SELECT Id, Custom_Product__r.Name, Country__c, Currency_Iso_Code__c, Cost_per_Calendar_Month__c, ATM_Fee__c, Card_Replacement_Cost__c 
                                                FROM Costs_Per_Product__c where Custom_Product__c =: productId and Country__c =: country LIMIT 1];
        }
        if(cost != null){   //map product cost
            productData.put('prodName', cost.Custom_Product__r.Name);
            productData.put('currencyIsoCode', cost.Currency_Iso_Code__c);
            productData.put('costPerCalendarMonth', String.valueOf(cost.Cost_per_Calendar_Month__c));
            productData.put('atmFee', cost.ATM_Fee__c == null ? '' : String.valueOf(cost.ATM_Fee__c/100)); //coudl be undefined
            productData.put('cardReplacementCost', String.valueOf(cost.Card_Replacement_Cost__c));
        }else{
            throw new ProductControllerException('Product or country information costs is not available.');
        }

        return productData;
    }

    // Custom exception class used for ProductController exceptions
    public class ProductControllerException extends Exception {}
}