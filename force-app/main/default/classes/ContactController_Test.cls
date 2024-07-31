@isTest
private class ContactController_Test {

    @TestSetup
    static void makeData(){
        
    }
    @isTest
    static void test() {
        // TO DO: implement unit test
    }
}


@isTest
    static void testGetProductInfoMissingParams() {
        Test.startTest();
        try {
            ProductInfoController.getProductInfo('', 'DE');
            System.assert(false, 'Expected a CustomException to be thrown');
        } catch (ProductInfoController.CustomException e) {
            System.assertEquals('Product or country information is missing.', e.getMessage());
        }
        Test.stopTest();
    }