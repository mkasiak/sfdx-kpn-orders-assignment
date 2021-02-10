/**
 * @author: miroslav.kasiak@example.com
 * @date: 10/02/2021
 * @description: A controller class of LWC component orderProducts
*/

public with sharing class OrderProductsController {

    /**
    * @description The method retrieves order products for an order specified by Id. The data are sent to LWC component
    *                orderProducts.
    * @param       orderId - Id of an order for which the method retrieves order products
    * @return      List of order products related to the order
    */
    @AuraEnabled(Cacheable=true)
    public static List<OrderItem> getOrderProducts(Id orderId) {
        return [
                SELECT Id, Product2Id, Product_Name__c, UnitPrice, Quantity, TotalPrice
                FROM OrderItem
                WHERE OrderId = :orderId
                WITH SECURITY_ENFORCED
                ORDER BY CreatedDate
        ];
    }
}