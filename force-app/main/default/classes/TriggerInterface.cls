public interface TriggerInterface {

    void beforeInsert(List<SObject> newRecordsList);

    void afterInsert(List<SObject> newRecordsList , Map<Id, SObject> newRecordsMap);

    void beforeUpdate(Map<Id, SObject> newRecordsMap, Map<Id, SObject> oldRecordsMap);

    void afterUpdate(Map<Id, SObject> newRecordsMap,  Map<Id, SObject> oldRecordsMap);

    void beforeDelete(List<SObject> oldRecordsList , Map<Id, SObject> oldRecordsMap);

    void afterDelete(Map<Id, SObject> oldRecordsMap);

    void afterUnDelete(List<SObject> newRecordsList , Map<Id, SObject> newRecordsMap);
}