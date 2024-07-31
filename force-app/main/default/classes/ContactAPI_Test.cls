@isTest
private class ContactAPI_Test {

    @TestSetup
    static void setup(){ 
        Product__c prod = new Product__c(Name = 'Standard');
        insert prod;
        
        Costs_Per_Product__c cost = new Costs_Per_Product__c(Custom_Product__c=prod.Id, Country__c = 'DE', Cost_per_Calendar_Month__c = 5.0, ATM_Fee__c = 1, Card_Replacement_Cost__c = 10.0);
        insert cost;

        Contact contact = new Contact(FirstName='Jane',LastName='Doe',
                                      Product__c=prod.Id, Home_Country__c='DE', UUID__c='ABC123');
        insert contact;
    }

    @isTest
    static void getContactProductAPITest() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/contactproduct/ABC123';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestContext.response = new RestResponse();
        RestResponse response = RestContext.response;

        Test.startTest();
             ContactAPI.getContactProduct();
        Test.stopTest();

        Assert.areEqual(200, response.statusCode, 'API failed');
    }

    @isTest
    static void getContactProductAPIFailTest() {
        RestRequest req = new RestRequest();
        req.requestURI = '/services/apexrest/contactproduct/12345';
        req.httpMethod = 'GET';
        RestContext.request = req;

        RestContext.response = new RestResponse();
        RestResponse response = RestContext.response;

        Test.startTest();
             ContactAPI.getContactProduct();
        Test.stopTest();

        Assert.areEqual(400, response.statusCode, 'no contact for this uuid');
    }

}