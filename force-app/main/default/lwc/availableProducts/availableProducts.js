import {LightningElement, api, wire} from 'lwc';
import getProducts from '@salesforce/apex/AvailableProductsController.getProducts';

const PRODUCT_COLUMNS = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'List Price', fieldName: 'UnitPrice' },
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
    productColumns = PRODUCT_COLUMNS;

    @wire(getProducts, {orderId: '$recordId'})
    products;

    handleRowAction(event) {
        const productId = event.detail.row.Id;
        const productAdded = new CustomEvent('productAdded', {
            detail: {productId}
        });
        this.dispatchEvent(productAdded);
    }
}