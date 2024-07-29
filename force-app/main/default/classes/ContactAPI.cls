@RestResource(urlMapping='/contactproduct/*')
global with sharing class ContactAPI
{
    @HttpGet
    global static void getContactProduct(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String contactUUID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        Map<String, Object> resp = ContactController.getContactProductInfo(contactUUID);

        res.responseBody = Blob.valueOf(JSON.serialize(resp));
        res.statusCode = 200;
        // return res;
   }
}

