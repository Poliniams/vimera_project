trigger ContactTrigger on Contact (before insert) {

    TriggerDispatcher.run(ContactTriggerHandler.getInstance(), Trigger.operationType, AssetTriggerHandler.class.getName());
}