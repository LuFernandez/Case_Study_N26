import { LightningElement, wire } from 'lwc';
import getData from '@salesforce/apex/ContactController.getContactProductInfo';


export default class ContactProducts extends LightningElement {
    @wire(getData) data;
}

