/**
 * @author: miroslav.kasiak@example.com
 * @date: 10/02/2021
 * @description: A test data factory for OrderProductsControllerTest and AvailableProductsControllerTest
*/

@IsTest
public class OrderTestDataFactory {
    public static final Id STANDARD_PRICEBOOK_ID = Test.getStandardPricebookId();
    public static final String TEST_CUSTOMER = 'Test Customer';

    public static void createTestData(){
        Product2 activeProductOne = new Product2(
                Name = 'Active Product One',
                IsActive = true
        );
        Product2 activeProductTwo = new Product2(
                Name = 'Active Product Two',
                IsActive = true
        );
        Product2 activeProductThree = new Product2(
                Name = 'Active Product Three',
                IsActive = true
        );
        insert new List<Product2>{activeProductOne, activeProductTwo, activeProductThree};

        PricebookEntry pricebookEntryOne = new PricebookEntry(
                Pricebook2Id = STANDARD_PRICEBOOK_ID,
                Product2Id = activeProductOne.Id,
                UnitPrice = 1,
                IsActive = true
        );
        PricebookEntry pricebookEntryTwo = new PricebookEntry(
                Pricebook2Id = STANDARD_PRICEBOOK_ID,
                Product2Id = activeProductTwo.Id,
                UnitPrice = 2,
                IsActive = true
        );
        PricebookEntry inactivePricebookEntryThree = new PricebookEntry(
                Pricebook2Id = STANDARD_PRICEBOOK_ID,
                Product2Id = activeProductThree.Id,
                UnitPrice = 3,
                IsActive = false
        );
        insert new List<PricebookEntry>{pricebookEntryOne, pricebookEntryTwo, inactivePricebookEntryThree};

        Account account = new Account(
                Name = TEST_CUSTOMER
        );
        insert account;

        Contract contract = new Contract(
                AccountId = account.Id,
                Status = 'Draft',
                StartDate = Date.today(),
                ContractTerm = 12
        );
        insert contract;
        contract.Status = 'Activated';
        update contract;

        Order order = new Order(
                ContractId = contract.Id,
                Status = 'Draft',
                AccountId = account.Id,
                EffectiveDate = Date.today(),
                Pricebook2Id = STANDARD_PRICEBOOK_ID
        );
        insert order;

        OrderItem orderItemOne = new OrderItem(
                OrderId = order.Id,
                UnitPrice = 2,
                Quantity = 5,
                Product2Id = activeProductOne.Id,
                PricebookEntryId = pricebookEntryOne.Id
        );
        insert orderItemOne;
    }
}