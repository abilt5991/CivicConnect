trigger IncidentTrigger on Incident__c (after insert) {
    new IncidentTriggerHandler().run();
}