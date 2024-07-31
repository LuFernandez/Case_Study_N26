import { LightningElement, api, wire } from 'lwc';
import getContactInfo from '@salesforce/apex/ContactController.getCaseRelatedContact';
import getProductInfo from '@salesforce/apex/ProductController.getProductInfo';

export default class ContactProducts extends LightningElement {
    @api recordId;
    caseInfo;
    productData;
    prodMap;
    error;

    @wire(getContactInfo, { caseId: '$recordId' })
    wiredCase({ error, data }) {
        if (data) {
            if(!data.hasOwnProperty('ContactId')){
                this.caseInfo = undefined;
                this.error = true;
            }else{
                this.caseInfo = data;
            }
        } else if (error) {
            this.error = error;
            this.caseInfo = undefined;
        }
        console.log(this.caseInfo);
    }

    @wire(getProductInfo, {productId: '$caseInfo.Contact.Product__c', country: '$caseInfo.Contact.Home_Country__c'})
    wiredProductData({ error, data }) {
        if(data){
            console.log(data);
            console.log(data.prodName);
            this.productData = data;
            // this.productData.atmFee = data.atmFee/100;
            if (error){
                console.log(error);
            }
        }
    }
}
