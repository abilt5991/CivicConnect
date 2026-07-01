trigger IncidentTrigger on Incident__c (after insert) {
    
    // Check the trigger context and route to the correct handler method
    if (Trigger.isAfter && Trigger.isInsert) {
        IncidentTriggerHandler.handleAfterInsert(Trigger.new);
    }
    
}