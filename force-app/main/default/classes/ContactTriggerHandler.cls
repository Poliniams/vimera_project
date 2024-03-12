public with sharing class ContactTriggerHandler implements TriggerInterface{

    private static ContactTriggerHandler instance;

    public static ContactTriggerHandler getInstance() {
        if (instance == null) {
            instance = new ContactTriggerHandler();
        }
        return instance;
    }

    public static void beforeInsert(List<SObject> newRecordsList){}

    public static void afterDelete(Map<Id, SObject> oldRecordsMap) {}

    public static void afterUnDelete(List<SObject> newRecordsList , Map<Id, SObject> newRecordsMap) {}

    public static void beforeDelete(List<SObject> oldRecordsList , Map<Id, SObject> oldRecordsMap){}

    public static void afterUpdate(Map<Id, SObject> newRecordsMap,  Map<Id, SObject> oldRecordsMap){}

    public static void beforeUpdate(Map<Id, SObject> newRecordsMap, Map<Id, SObject> oldRecordsMap){}

    public static void afterInsert(List<SObject> newRecordsList , Map<Id, SObject> newRecordsMap){}
}