@isTest
private class ContactUpdateTriggerTest {

    @TestSetup
    private static void setupData(){

        List<Contact> contactsList = new List<Contact>();

        insert new List<Account> {
            new Account(
                Name = 'Alter',
                Summary__c = 0
            ),
            new Account(
                Name = 'Acme',
                Summary__c = 0
            )
        };

        List<Account> accountAlterList = [SELECT Id, Name FROM Account WHERE Name = 'Alter'];
        List<Account> accountAcmeList = [SELECT Id, Name FROM Account WHERE Name = 'Acme'];

        for (Integer i = 0; i < 5; i++) {
            contactsList.add(
                new Contact(
                    AccountId = accountAlterList[0].Id,
                    LastName = 'Contact' + i,
                    Amount__c = 5
                )
            );
        }

        for (Integer i = 5; i < 10; i++) {
            contactsList.add(
                new Contact(
                    AccountId = accountAcmeList[0].Id,
                    LastName = 'Contact' + i,
                    Amount__c = 10
                )
            );
        }

        insert contactsList;
    }

    @isTest
    private static void testAmountUpdate() {

        List<Account> accountList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];

        List<Contact> contactList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accountList[0].Id];

        for (Contact contact : contactList) {
            contact.Amount__c = 20;
        }

        Test.startTest();
        update contactList;
        Test.stopTest();

        List<Account> accountSumlList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        System.assertEquals(100, accountSumlList[0].Summary__c, 'Account Summary is wrong');
    }

    @isTest
    private static void testDiffAmountUpdate() {

        List<Account> accAcmeList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        List<Contact> contAcmeList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accAcmeList[0].Id];
        List<Contact> contAltertList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accAlterList[0].Id];

        for (Contact contact : contAcmeList) {
            contact.Amount__c = 20;
        }

        for (Contact contact : contAltertList) {
            contact.Amount__c = 30;
        }

        Test.startTest();
        update contAcmeList;
        update contAltertList;
        Test.stopTest();

        List<Account> accAcmeSumlList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterSumlList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];
        System.assertEquals(100, accAcmeSumlList[0].Summary__c, 'Account Summary is wrong');
        System.assertEquals(150, accAlterSumlList[0].Summary__c, 'Account Summary is wrong');
    }

    @isTest
    private static void testAccountIdUpdate() {
        List<Account> accAcmeList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        List<Contact> contAcmeList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accAcmeList[0].Id];

        for (Contact contact : contAcmeList) {
            contact.AccountId = accAlterList[0].Id;
        }

        Test.startTest();
        update contAcmeList;
        Test.stopTest();

        List<Account> accAcmeResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        System.assertEquals(0, accAcmeResultList[0].Summary__c, 'Account Summary is wrong');
        System.assertEquals(75, accAlterResultList[0].Summary__c, 'Account Summary is wrong');
    }

    @isTest
    private static void testDiffAccountIdUpdate() {

        List<Account> accAcmeList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        List<Contact> contAcmeList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accAcmeList[0].Id];
        List<Contact> contAlterList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accAlterList[0].Id];

        for (Contact contact : contAcmeList) {
            contact.AccountId = accAlterList[0].Id;
        }

        for (Contact contact : contAlterList) {
            contact.AccountId = accAcmeList[0].Id;
        }

        Test.startTest();
        update contAcmeList;
        update contAlterList;
        Test.stopTest();

        List<Account> accAcmeResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        System.assertEquals(25, accAcmeResultList[0].Summary__c, 'Account Summary is wrong');
        System.assertEquals(50, accAlterResultList[0].Summary__c, 'Account Summary is wrong');
    }

    @isTest
    private static void testAccountIdAndAmountUpdate() {

        List<Account> accAcmeList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        List<Contact> contAcmeList = [SELECT Id, LastName, Amount__c, AccountId FROM Contact WHERE AccountId = :accAcmeList[0].Id];

        for (Contact contact : contAcmeList) {
            contact.AccountId = accAlterList[0].Id;
            contact.Amount__c = 25;
        }

        Test.startTest();
        update contAcmeList;
        Test.stopTest();

        List<Account> accAcmeResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Acme'];
        List<Account> accAlterResultList = [SELECT Id, Name, Summary__c FROM Account WHERE Name = 'Alter'];

        System.assertEquals(0, accAcmeResultList[0].Summary__c, 'Account Summary is wrong');
        System.assertEquals(150, accAlterResultList[0].Summary__c, 'Account Summary is wrong');
    }
}