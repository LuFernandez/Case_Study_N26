@RestResource(urlMapping='/contactproduct/*')
global with sharing class ContactAPI{
    @HttpGet
    global static void getContactProduct(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String contactUUID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        try{
            Map<String, Object> ret = ContactController.getProductbyContactUUID(contactUUID);
            if(ret != null){  //if we have contact info, product info etc
                //return message
                Map<String, Object> response = new Map<String, Object>();
                response.put('contactInfo', ret.get('contactInfo'));    //return map of contact information
                response.put('productInfo', ret.get('productInfo'));        //return map of product information
                res.responseBody = Blob.valueOf(JSON.serialize(response));
                res.statusCode = 200;
        
            }else{
                res.statusCode = 400;
            }
        }catch(Exception e){
            res.statusCode = 400;
        }
   }
}