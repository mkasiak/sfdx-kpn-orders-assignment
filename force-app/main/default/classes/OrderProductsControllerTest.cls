/**
 * @author: miroslav.kasiak@example.com
 * @date: 10/02/2021
 * @description: A test class for OrderProductsController class
*/

@IsTest
private class OrderProductsControllerTest {
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
        List<OrderItem> orderItems = OrderProductsController.getOrderProducts(order.Id);
        Test.stopTest();

        System.assertEquals(
                1,
                orderItems.size(),
                'Expected number of order products was not returned.'
        );
    }
}