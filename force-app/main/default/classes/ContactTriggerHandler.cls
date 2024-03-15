public without sharing class ContactTriggerHandler implements TriggerInterface{

    private static ContactTriggerHandler instance;

    public static ContactTriggerHandler getInstance() {
        if (instance == null) {
            instance = new ContactTriggerHandler();
        }
        return instance;
    }

    public static void beforeInsert(List<SObject> newRecordsList){}

    public static void afterDelete(Map<Id, SObject> oldRecordsMap) {

        Map<Id, Decimal> accountIdToIntMap = getAccountsWithAmountMap((List<Contact>)oldRecordsMap.values());
        updateAccountSummarySubtraction(accountIdToIntMap);
    }

    public static void afterUnDelete(List<SObject> newRecordsList , Map<Id, SObject> newRecordsMap) {

        Map<Id, Decimal> accountIdToIntMap = getAccountsWithAmountMap((List<Contact>)newRecordsList);
        updateAccountSummaryAddition(accountIdToIntMap);
    }

    public static void beforeDelete(List<SObject> oldRecordsList , Map<Id, SObject> oldRecordsMap){}

    public static void afterUpdate(Map<Id, SObject> newRecordsMap,  Map<Id, SObject> oldRecordsMap){
        Map<Id, Decimal> accountsMapSubtr = new Map<Id, Decimal>();
        Map<Id, Decimal> accountsMapAdd = new Map<Id, Decimal>();

        Map<Id, Contact> newContactsMap = (Map<Id, Contact>)newRecordsMap;
        Map<Id, Contact> oldContactsMap = (Map<Id, Contact>)oldRecordsMap;

        if (!newContactsMap.isEmpty()) {

            for (Contact contact : newContactsMap.values()) {

                if (contact.AccountId != null) {

                    Boolean ifAmountUpdated = (newContactsMap.get(contact.Id).Amount__c != oldContactsMap.get(contact.Id).Amount__c);
                    Boolean ifAccountUpdated = (contact.AccountId != oldContactsMap.get(contact.Id).AccountId);

                    if ((ifAccountUpdated && !ifAmountUpdated) || (ifAccountUpdated && ifAmountUpdated)) {
                        if (accountsMapAdd.containsKey(contact.AccountId)) {
                            Decimal oldValue = accountsMapAdd.get(contact.AccountId);
                            accountsMapAdd.put(contact.AccountId, oldValue + contact.Amount__c);
                        } else {
                            accountsMapAdd.put(contact.AccountId, contact.Amount__c);
                        }
                        if (accountsMapSubtr.containsKey(oldContactsMap.get(contact.Id).AccountId)) {
                            Decimal oldValue = accountsMapSubtr.get(oldContactsMap.get(contact.Id).AccountId);
                            accountsMapSubtr.put(oldContactsMap.get(contact.Id).AccountId, oldValue + contact.Amount__c);
                        } else {
                            accountsMapSubtr.put(oldContactsMap.get(contact.Id).AccountId, contact.Amount__c);
                        }
                    } else if (ifAmountUpdated && !ifAccountUpdated) {
                        Decimal newAmount = newContactsMap.get(contact.Id).Amount__c - oldContactsMap.get(contact.Id).Amount__c;
                        if (accountsMapAdd.containsKey(contact.AccountId)) {
                            Decimal oldValue = accountsMapAdd.get(contact.AccountId);
                            accountsMapAdd.put(contact.AccountId, oldValue + newAmount);
                        } else {
                            accountsMapAdd.put(contact.AccountId, newAmount);
                        }
                    }
                }
            }
            updateAccountSummarySubtraction(accountsMapSubtr);
            updateAccountSummaryAddition(accountsMapAdd);
        }
    }

    public static void beforeUpdate(Map<Id, SObject> newRecordsMap, Map<Id, SObject> oldRecordsMap){}

    public static void afterInsert(List<SObject> newRecordsList , Map<Id, SObject> newRecordsMap){

        Map<Id, Decimal> accountIdToIntMap = getAccountsWithAmountMap((List<Contact>)newRecordsList);
        updateAccountSummaryAddition(accountIdToIntMap);
    }

    @TestVisible
    private static Map<Id, Decimal> getAccountsWithAmountMap(List<Contact> contactsList) {

        Map<Id, Decimal> accountIdToTotalAmountMap = new Map<Id, Decimal>();

        for (Contact contact : contactsList) {
            if (contact.AccountId != null) {
                if (accountIdToTotalAmountMap.containsKey(contact.AccountId)) {
                    accountIdToTotalAmountMap.put(contact.AccountId, accountIdToTotalAmountMap.get(contact.AccountId) + contact.Amount__c);
                } else {
                    accountIdToTotalAmountMap.put(contact.AccountId, contact.Amount__c);
                }
            }
        }
        return accountIdToTotalAmountMap;
    }

    @TestVisible
    private static void updateAccountSummarySubtraction(Map<Id, Decimal> accountIdToIntMap) {

        List<Account> accountListToUpdate = new List<Account>();

        if (!accountIdToIntMap.isEmpty()) {

            for (Account account : [SELECT Id, Summary__c FROM Account WHERE Id IN : accountIdToIntMap.keySet()]) {
                account.Summary__c -= accountIdToIntMap.get(account.Id);
                account.Summary__c = (account.Summary__c < 0) ? 0 : account.Summary__c;
                accountListToUpdate.add(account);
            }

            if (!accountListToUpdate.isEmpty()) {
                update accountListToUpdate;
            }
        }
    }

    @TestVisible
    private static void updateAccountSummaryAddition(Map<Id, Decimal> accountIdToIntMap) {

        List<Account> accountListToUpdate = new List<Account>();

        if (!accountIdToIntMap.isEmpty()) {

            for (Account account : [SELECT Id, Summary__c FROM Account WHERE Id IN : accountIdToIntMap.keySet()]) {
                if (account.Summary__c == null) {
                    account.Summary__c = accountIdToIntMap.get(account.Id);
                } else {
                    account.Summary__c += accountIdToIntMap.get(account.Id);
                }
                accountListToUpdate.add(account);
            }

            if (!accountListToUpdate.isEmpty()) {
                update accountListToUpdate;
            }
        }
    }
}