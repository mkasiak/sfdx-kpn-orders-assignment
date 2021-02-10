import {LightningElement, api, wire} from 'lwc';
import pubsub from 'c/pubsub';
import getOrderProducts from '@salesforce/apex/OrderProductsController.getOrderProducts';
import {refreshApex} from '@salesforce/apex';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {
    createRecord,
    updateRecord
} from 'lightning/uiRecordApi';
import ID_FIELD from '@salesforce/schema/OrderItem.Id';
import ORDER_ID_FIELD from '@salesforce/schema/OrderItem.OrderId';
import PRODUCT_FIELD from '@salesforce/schema/OrderItem.Product2Id';
import UNIT_PRICE_FIELD from '@salesforce/schema/OrderItem.UnitPrice';
import QUANTITY_FIELD from '@salesforce/schema/OrderItem.Quantity';

const PRODUCT_COLUMNS = [
    {label: 'Name', fieldName: 'Product_Name__c', type: 'text'},
    {label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency'},
    {label: 'Quantity', fieldName: 'Quantity', type: 'number'},
    {label: 'Total Price', fieldName: 'TotalPrice', type: 'currency'}
];

export default class OrderProducts extends LightningElement {
    @api recordId;
    orderProductColumns = PRODUCT_COLUMNS;

    @wire(getOrderProducts, {orderId: '$recordId'})
    orderProducts;

    connectedCallback() {
        this.register();
    }

    register() {
        pubsub.register('productAdded', this.handleProductAdded.bind(this));
    }

    handleProductAdded(event) {
        const addedProduct = JSON.parse(event.message);
        this.processAddition(addedProduct);
    }

    processAddition(addedProduct) {
        for (let i = 0; i < this.orderProducts.data.length; i++) {
            let currentProduct = this.orderProducts.data[i];
            if (currentProduct.Product2Id === addedProduct.Product2Id) {
                this.increaseQuantityByOne(currentProduct);
                return;
            }
        }
        this.addOrderProduct(addedProduct);
    }

    increaseQuantityByOne(currentProduct) {
        const recordInput = {
            'fields': this.prepareFieldsForUpdate(currentProduct)
        };
        updateRecord(recordInput)
            .then(() => {
                this.displaySuccessToast();
                return refreshApex(this.orderProducts).then(() => {
                });
            }).catch(error => {
            this.displayErrorToast(error);
        });
    }

    prepareFieldsForUpdate(orderProduct) {
        const fields = {};
        fields[ID_FIELD.fieldApiName] = orderProduct.Id;
        fields[QUANTITY_FIELD.fieldApiName] = orderProduct.Quantity + 1;
        return fields;
    }

    addOrderProduct(addedProduct) {
        const recordInput = {
            'apiName': 'OrderItem',
            'fields': this.prepareFieldsForCreate(addedProduct)
        };
        createRecord(recordInput)
            .then(() => {
                this.displaySuccessToast();
                return refreshApex(this.orderProducts).then(() => {
                });
            }).catch(error => {
            this.displayErrorToast(error);
        });
    }

    prepareFieldsForCreate(addedProduct) {
        const fields = {};
        fields[ORDER_ID_FIELD.fieldApiName] = this.recordId;
        fields[PRODUCT_FIELD.fieldApiName] = addedProduct.Id;
        fields[UNIT_PRICE_FIELD.fieldApiName] = addedProduct.UnitPrice;
        fields[QUANTITY_FIELD.fieldApiName] = 1;
        return fields;
    }

    displaySuccessToast() {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: 'Order is updated',
                variant: 'success'
            })
        );
    }

    displayErrorToast(error) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error updating or reloading record',
                message: error.body.message,
                variant: 'error'
            })
        );
    }
}
