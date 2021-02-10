/**
 * @author: miroslav.kasiak@example.com
 * @date: 10/02/2021
 * @description: A controller class of LWC component availableProducts
*/

public with sharing class AvailableProductsController {

    /**
    * @description The method retrieves pricebook entries related to an order specified by id. The data are sent to LWC
     *              component availableProducts.
    * @param       orderId - Id of an order for which the method checks a pricebook
    * @return      List of pricebook entries from a pricebook related to the order
    */
    @AuraEnabled(Cacheable=true)
    public static List<PricebookEntry> getPricebookEntries(Id orderId) {
        Id priceBookId = getPriceBookId(orderId);
        List<PricebookEntry> pricebookEntries = queryPricebookEntries(priceBookId);
        return pricebookEntries;
    }

    private static Id getPriceBookId(Id orderId) {
        Order order = [SELECT Pricebook2Id FROM Order WHERE Id = :orderId];
        return order.Pricebook2Id;
    }

    private static List<PricebookEntry> queryPricebookEntries(Id priceBookId) {
        return [
                SELECT Name, UnitPrice, Product2Id
                FROM PricebookEntry
                WHERE Pricebook2Id = :priceBookId
                AND IsActive = TRUE
                WITH SECURITY_ENFORCED
                ORDER BY Name
        ];
    }
}