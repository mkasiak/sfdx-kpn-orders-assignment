public with sharing class AvailableProductsController {

    @AuraEnabled(Cacheable=true)
    public static List<PricebookEntry> getProducts(Id orderId) {
        Id priceBookId = getPriceBookId(orderId);
        List<PricebookEntry> pricebookEntries = getPricebookEntries(priceBookId);
        return pricebookEntries;
    }

    //Theoretically we could avoid this query obtaining the Pricebook Id from SF cache
    private static Id getPriceBookId(Id orderId) {
        Order order = [SELECT Pricebook2Id FROM Order WHERE Id = :orderId];
        return order.Pricebook2Id;
    }

    private static List<PricebookEntry> getPricebookEntries(Id priceBookId) {
        return [
                SELECT Id, Name, UnitPrice
                FROM PricebookEntry
                WHERE Pricebook2Id = :priceBookId
                AND IsActive = TRUE
        ];
    }
}