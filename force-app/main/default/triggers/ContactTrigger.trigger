trigger ContactTrigger on Contact (after insert, after update, after delete, after undelete) {

    TriggerDispatcher.run(ContactTriggerHandler.getInstance(), Trigger.operationType, ContactTriggerHandler.class.getName());
}