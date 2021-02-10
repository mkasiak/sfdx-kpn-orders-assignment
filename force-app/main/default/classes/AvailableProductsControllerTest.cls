/**
 * @author: miroslav.kasiak@example.com
 * @date: 10/02/2021
 * @description: A test class for AvailableProductsController class
*/

@IsTest
private class AvailableProductsControllerTest {

    @TestSetup
    static void testSetup() {
        OrderTestDataFactory.createTestData();
    }

    @IsTest
    static void testGetActivePricebookEntries() {
        Order order = [
                SELECT Id
                FROM Order
                WHERE Account.Name = :OrderTestDataFactory.TEST_CUSTOMER
        ];

        Test.startTest();
        List<PricebookEntry> pricebookEntries = AvailableProductsController.getPricebookEntries(order.Id);
        Test.stopTest();

        System.assertEquals(
                2,
                pricebookEntries.size(),
                'Expected number of pricebook entries was not returned.'
        );
        for(PricebookEntry pricebookEntry:pricebookEntries) {
            System.assertEquals(
                    OrderTestDataFactory.STANDARD_PRICEBOOK_ID,
                    pricebookEntry.Pricebook2Id,
                    'Pricebook of a pricebook entry is not correct'
            );
        }
    }
}