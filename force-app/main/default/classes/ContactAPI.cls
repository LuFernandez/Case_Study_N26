@RestResource(urlMapping='/contactproduct/*')
global with sharing class ContactAPI{
    @HttpGet
    global static void getContactProduct(){
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        String contactUUID = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        try{
            Map<String, Object> resp = ContactController.getProductbyContactUUID(contactUUID);
            if(resp.get('result') != 'error'){  //si tengo info de contacto, info de producto etc
                //return message
            }else{
                
            }
        }catch(Exception e){
            res.statusCode = 400;
        }
        

        
        // return res;
   }
}

