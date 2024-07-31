@isTest
private class ContactController_Test {

    @TestSetup
    static void setup(){
        Product__c prod = new Product__c(Name = 'Standard');
        insert prod;
        Costs_Per_Product__c cost = new Costs_Per_Product__c(Custom_Product__c=prod.Id, Country__c = 'DE', Cost_per_Calendar_Month__c = 5.0, ATM_Fee__c = 1, Card_Replacement_Cost__c = 10.0);
        insert cost;

        Contact cont = new Contact(FirstName='Jane', LastName='Doe', Home_Country__c='DE', Product__c=prod.Id, UUID__c='ABC123');
        insert cont;

        Case cs = new Case(Subject = 'test', ContactId=cont.Id);
        insert cs;
    }
    
    @isTest
    static void getCaseRelatedContactTest() {
        Case testCase = [SELECT Id, Contact.Name FROM Case LIMIT 1];
        String name = testCase.Contact.Name;
        Case returnCase;
        Test.startTest();
            returnCase = ContactController.getCaseRelatedContact(testCase.Id);
        Test.stopTest();

        Assert.areEqual(name, returnCase.Contact.Name, 'Names dont match');
    }
    
    @isTest
    static void getProductbyContactUUIDTest() {
        Contact cont = [SELECT Id, UUID__c FROM Contact LIMIT 1];       
        Map<String, Object> output;
        Test.startTest();
            output = ContactController.getProductbyContactUUID(cont.UUID__c);
        Test.stopTest();
        Map<String, Object> prodMap = (Map<String, Object>) output.get('productInfo');
            
        Costs_Per_Product__c cost = [SELECT Cost_per_Calendar_Month__c FROM Costs_Per_Product__c LIMIT 1];
        Assert.areEqual(String.valueOf(cost.Cost_per_Calendar_Month__c), prodMap.get('costPerCalendarMonth'), 'cost per calendar month do not match');
    }
}