import {LightningElement, api, wire} from 'lwc';
import getPricebookEntries from '@salesforce/apex/AvailableProductsController.getPricebookEntries';
import pubsub from 'c/pubsub';

const PRICEBOOK_ENTRY_COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'List Price', fieldName: 'UnitPrice', type: 'currency' },
    {
        type: 'button',
        initialWidth: 75,
        typeAttributes: {
            label: 'Add',
            title: 'Add',
            variant: 'brand'
        }
    }
];

export default class AvailableProducts extends LightningElement {
    @api recordId;
    pricebookEntryColumns = PRICEBOOK_ENTRY_COLUMNS;

    @wire(getPricebookEntries, {orderId: '$recordId'})
    pricebookEntries;

    handleRowAction(event) {
        const product = event.detail.row;
        let message = {
            "message" : JSON.stringify(product)
        }
        pubsub.fire('productAdded', message );
    }
}