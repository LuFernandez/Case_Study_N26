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
                this.caseInfo = false;
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
            this.productData = data;
            if (error){
                console.log(error);
            }
        }
    }

    get isCostPerMonthFree(){
        let isFree = false;
        if(this.productData){
            if(this.productData.hasOwnProperty('costPerCalendarMonth')){
                if(this.productData.costPerCalendarMonth == '0.00'){
                    isFree = true;
                }else{
                    isFree = false;
                }
            }
        }
        return isFree;
    }

    get isCostPerMonthNA(){
        let na = false;
        if(this.productData){
            if(!this.productData.hasOwnProperty('costPerCalendarMonth')){
                na = true;
            }
        }
        return na;
    }

    get noAtmFee(){
        let isFree = false;
        if(this.productData){
            console.log('this.productData.atmFee = ' + this.productData.atmFee);
            if(this.productData.hasOwnProperty('atmFee')){
                if(this.productData.atmFee == '0.00'){
                    isFree = true;
                }else{
                    isFree = false;
                }
            }
        }
        return isFree;
    }
}
