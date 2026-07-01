public with sharing class IncidentTriggerHandler {
    
    // This method handles the logic after a new record is successfully inserted
    public static void handleAfterInsert(List<Incident__c> newIncidents) {
        
        Set<Id> incidentsNeedingWeather = new Set<Id>();

        // Loop through the newly created incidents
        for (Incident__c inc : newIncidents) {
            // Only trigger the weather API if they provided coordinates!
            if (inc.Location_Latitude__c != null && inc.Location_Longitude__c != null) {
                incidentsNeedingWeather.add(inc.Id);
            }
        }

        // If we found valid records, hand them off to our background Queueable class
        if (!incidentsNeedingWeather.isEmpty()) {
            System.enqueueJob(new WeatherQueueable(incidentsNeedingWeather));
            System.debug('Trigger successfully queued ' + incidentsNeedingWeather.size() + ' incidents for weather updates.');
        }
    }
}