trigger IncidentReportTrigger on Incident_Report__c (before insert, after insert) {
    new IncidentReportTriggerHandler().run();
}