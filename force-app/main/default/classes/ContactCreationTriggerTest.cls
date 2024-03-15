@isTest
private class ContactCreationTriggerTest {

    @testSetup
    private static void setupData() {

        insert new List<Account> {
            new Account(
                Name = 'Alter',
                Summary__c = 10
            ),
            new Account(
                Name = 'Acme',
                Summary__c = 0
            )
        };
    }

    @isTest
    private static void testCreationWithoutSum() {

        Test.startTest();
        createContacts('Acme');
        Test.stopTest();

        List<Account> accountsSumList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme' LIMIT 1];

        System.assertEquals(100, accountsSumList[0].Summary__c, 'Account summary is wrong');
    }

    @isTest
    private static void testCreationWithSum() {

        Test.startTest();
        createContacts('Alter');
        Test.stopTest();

        List<Account> accountsSumList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter' LIMIT 1];

        System.assertEquals(110, accountsSumList[0].Summary__c, 'Account summary is wrong');
    }

    @isTest
    private static void testCreationForDiffAccounts() {

        Test.startTest();
        createContacts('Alter');
        createContacts('Acme');
        Test.stopTest();

        List<Account> accountsList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme' LIMIT 1];
        List<Account> accountsSumList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter' LIMIT 1];

        System.assertEquals(110, accountsSumList[0].Summary__c, 'Account summary is wrong');
        System.assertEquals(100, accountsList[0].Summary__c, 'Account summary is wrong');
    }

    private static void createContacts(String accountName) {

        List<Account> accountsList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = :accountName  LIMIT 1];
        List<Contact> contactsList = new List<Contact>();

        for (Integer i = 0; i < 10; i++) {
            contactsList.add(
                new Contact(
                    AccountId = accountsList[0].Id,
                    LastName = 'Contact ' + accountName + ' ' + i,
                    Amount__c = 10
                )
            );
        }

        insert contactsList;
    }
}