public with sharing class IncidentTriggerHandler extends TriggerHandler {

    public override void afterInsert() {
        Set<Id> incidentsNeedingWeather = new Set<Id>();

        for (Incident__c inc : (List<Incident__c>) Trigger.new) {
            if (inc.Location_Latitude__c != null && inc.Location_Longitude__c != null) {
                incidentsNeedingWeather.add(inc.Id);
            }
        }

        if (!incidentsNeedingWeather.isEmpty()) {
            System.enqueueJob(new WeatherQueueable(incidentsNeedingWeather));
        }
    }
}