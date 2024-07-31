import { LightningElement, api, wire } from 'lwc';
import getContactInfo from '@salesforce/apex/ContactController.getCaseRelatedContact';
import getProductInfo from '@salesforce/apex/ProductController.getProductInfo';

export default class ContactProducts extends LightningElement {
    @api recordId;
    caseInfo;
    productData;
    prodMap;
    error;

    @wire(getContactInfo, { caseId: '$recordId' })      //apex method to obtain contactid, contact.name, contact.product__c and contact.home_country__c from case recordid
    wiredCase({ error, data }) {
        if (data) {
            if(!data.hasOwnProperty('ContactId')){      //to show message if there is no contact associated with case
                this.caseInfo = false;
                this.error = true;  //to show message in html
            }else{
                this.caseInfo = data;
            }
        } else if (error) {
            this.error = error;
            this.caseInfo = undefined;
        }
        console.log(this.caseInfo);
    }

    @wire(getProductInfo, {productId: '$caseInfo.Contact.Product__c', country: '$caseInfo.Contact.Home_Country__c'}) //apex method to obtain the costs associated to the productId
    wiredProductData({ error, data }) {         
        if(data){
            console.log(data);
            this.productData = data;
            if (error){
                console.log(error);
            }
        }
    }

    get isCostPerMonthFree(){       //variable to show a 'Free' text if the cost per month = 0
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

    get isCostPerMonthNA(){     //variable to show a 'N/a' if the cost per month is not defined (for example: UK scenario)
        let na = false;
        if(this.productData){
            if(!this.productData.hasOwnProperty('costPerCalendarMonth')){
                na = true;
            }
        }
        return na;
    }

    get noAtmFee(){         //variable to show a 'Free' text if the atm fee = 0
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
