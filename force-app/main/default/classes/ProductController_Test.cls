@isTest
private class ProductController_Test {

    @TestSetup
    static void setup(){
        Product__c prod = new Product__c(Name = 'Standard');
        insert prod;
        Costs_Per_Product__c cost = new Costs_Per_Product__c(Country__c = 'DE', Cost_per_Calendar_Month__c = 5.0, ATM_Fee__c = 1, Card_Replacement_Cost__c = 10.0);
        insert cost;
    }

    @isTest
    static void getProductInfoTest() {
        Map<String, String> output;
        Product__c prod = [SELECT Id FROM Product__c LIMIT 1];
        Costs_Per_Product__c cost = [SELECT Id,Country__c FROM Costs_Per_Product__c LIMIT 1];
        Test.startTest();
            output = ProductController.getProductInfo(prod.Id, cost.Country__c);
        Test.stopTest();
        Assert.areEqual('Standard', output.get('prodName'), 'Product names dont match');
    }
}
