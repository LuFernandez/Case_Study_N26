public with sharing class ContactController {
    static final String CONTROLLER_ERROR = 'ERROR';
    static final String CONTROLLER_SUCCESS = 'SUCCESS';

    @AuraEnabled
    public static Map<String, Object> getContactProductInfo(String uuid){
        Map<String, Object> res = new Map<String, Object>();

        try{
            if(uuid != null && String.isNotBlank(uuid)){
                Contact c = [SELECT Id, Name, Home_Country__c, Product__c FROM Contact WHERE UUID__c = :uuid LIMIT 1];
                if(c != null){
                    res.put('result', CONTROLLER_SUCCESS);
                    res.put('contact', (Object) c);    //return contact information
                    if(c.Product__c != null){
                        String country = c.Home_Country__c;
                        String prodId = c.Product__c;
                        List<Costs_Per_Product__c> costs = [SELECT Id, Custom_Product__r.Name, Country__c, Currency_Iso_Code__c, Cost_per_Calendar_Month__c, ATM_Fee__c, Card_Replacement_Cost__c from Costs_Per_Product__c where Custom_Product__c =: c.Product__c];

                    }else{
                        res.put('result', CONTROLLER_ERROR);
                        res.put('message', 'No product found for contactId ' + c.id);
                    }

                }else {
                    res.put('result', CONTROLLER_ERROR);
                    res.put('message', 'No contact found for UUID');
                }
            }
          
        }catch(Exception e){
            System.debug('An exception occurred: ' + e.getMessage());
        }

        return res;
    }
}