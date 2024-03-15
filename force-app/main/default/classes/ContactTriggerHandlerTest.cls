@isTest
private class ContactTriggerHandlerTest {

    @TestSetup
    private static void setupData(){

        insert new List<Account> {
            new Account(
                Name = 'Acme',
                Summary__c = 0
            )
        };

        List<Account> accountsList = [SELECT Id, Name FROM Account WHERE Name = 'Acme'  LIMIT 1];
        List<Contact> contactsList = new List<Contact>();

        for (Integer i = 0; i < 10; i++) {
            contactsList.add(
                new Contact(
                    AccountId = accountsList[0].Id,
                    LastName = 'Contact' + i,
                    Amount__c = 10
                )
            );
        }

        insert contactsList;
    }

    @isTest
    private static void testGettingAccounts() {
        List<Account> accountsList = [SELECT Id, Name FROM Account WHERE Name = 'Acme'  LIMIT 1];
        List<Contact> contactsList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accountsList[0].Id];

        Test.startTest();
        Map<Id, Decimal> resultMap = ContactTriggerHandler.getAccountsWithAmountMap(contactsList);
        Test.stopTest();

        System.assertEquals(1, resultMap.size(), 'Map size is wrong');

        for (Id accId : resultMap.keySet()) {
            System.assertEquals(accountsList[0].Id, accId, 'Map key is wrong');
            System.assertEquals(100, resultMap.get(accId), 'Map value is wrong');
        }
    }

    @isTest
    private static void testUpdateAccWithSubstr() {
        List<Account> accountsList = [SELECT Id, Name FROM Account WHERE Name = 'Acme'  LIMIT 1];

        Map<Id, Decimal> accountIdToSumMap = new Map<Id, Decimal>();
        accountIdToSumMap.put(accountsList[0].Id, 30);

        Test.startTest();
        ContactTriggerHandler.updateAccountSummarySubtraction(accountIdToSumMap);
        Test.stopTest();

        List<Account> accountsResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'  LIMIT 1];
        System.assertEquals(70, accountsResultList[0].Summary__c, 'Substraction is not working correctly');
    }

    @isTest
    private static void testUpdateAccWithNullSubstr() {
        List<Account> accountsList = [SELECT Id, Name FROM Account WHERE Name = 'Acme'  LIMIT 1];

        Map<Id, Decimal> accountIdToSumMap = new Map<Id, Decimal>();
        accountIdToSumMap.put(accountsList[0].Id, 120);

        Test.startTest();
        ContactTriggerHandler.updateAccountSummarySubtraction(accountIdToSumMap);
        Test.stopTest();

        List<Account> accountsResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'  LIMIT 1];
        System.assertEquals(0, accountsResultList[0].Summary__c, 'Substraction is not working correctly');
    }

    @isTest
    private static void testUpdateAccWithAddition() {
        List<Account> accountsList = [SELECT Id, Name FROM Account WHERE Name = 'Acme'  LIMIT 1];

        Map<Id, Decimal> accountIdToSumMap = new Map<Id, Decimal>();
        accountIdToSumMap.put(accountsList[0].Id, 30);

        Test.startTest();
        ContactTriggerHandler.updateAccountSummaryAddition(accountIdToSumMap);
        Test.stopTest();

        List<Account> accountsResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'  LIMIT 1];
        System.assertEquals(130, accountsResultList[0].Summary__c, 'Addition is not working correctly');
    }
}