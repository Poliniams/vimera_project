@isTest
private class ContactDeleteTriggerTest {

    @testSetup
    private static void setupData() {

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
    private static void testContactDelete() {

        List<Account> accountsList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'  LIMIT 1];
        System.assertEquals(100, accountsList[0].Summary__c, 'After insert Contact Trigger is not working correctly');

        List<Contact> contactList = [SELECT Id, LastName FROM Contact WHERE Amount__c = 10];

        Test.startTest();
        delete contactList;
        Test.stopTest();

        List<Account> accNullSumList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'  LIMIT 1];

        System.assertEquals(0, accNullSumList[0].Summary__c, 'Account summary is wrong');
    }
}