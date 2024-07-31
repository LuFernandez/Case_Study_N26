public with sharing class ContactController{

    @AuraEnabled(cacheable=true)
    public static Case getCaseRelatedContact(Id caseId){
        Map<String, Object> contactInfo = new Map<String, Object>();
        
        return [SELECT Id, ContactId, Contact.Name, Contact.Home_Country__c, Contact.Product__c FROM Case where Id=:caseId LIMIT 1];

        // contactInfo.put('name', caseRec.Contact.Name);
        // contactInfo.put('productId', caseRec.Contact.Product__c);
        // contactInfo.put('country', caseRec.Contact.Home_Country__c);
        // return caseRec;
    }

    public static Map<String, Object> getProductbyContactUUID(String uuid){  
        Map<String, Object> response = new Map<String, Object>();
        Map<String, Object>  contactMap = new Map<String, Object>();

        if(uuid != null && String.isNotBlank(uuid)){
            Contact c = [SELECT Id, Name, Home_Country__c, Product__c FROM Contact WHERE UUID__c = :uuid LIMIT 1];

            if(c != null){  //add contact information
                contactMap.put('name', c.Name);
                contactMap.put('country', c.Home_Country__c);
                contactMap.put('productId', c.Product__c);
                response.put('contactInfo', contactMap);
                if(c.Product__c != null){       //get product information
                    Map<String, Object> prodMap = ProductController.getProductInfo(c.Product__c, c.Home_Country__c);
                    response.put('productInfo', prodMap);    //add product information
                }
            }else{
                throw new ContactControllerException('No contact found for ' + uuid);
            }
        }
        return response;

    }

    // Custom exception class used for ContactController exceptions
    public class ContactControllerException extends Exception {}

}