public class WeatherQueueable implements Queueable, Database.AllowsCallouts {
    
    // Variable to store the IDs of the records that need weather updates
    private Set<Id> incidentIds;
    
    // Constructor: This catches the IDs passed from your Trigger Handler
    public WeatherQueueable(Set<Id> recordIds) {
        this.incidentIds = recordIds;
    }

    // This is the mandatory method that runs asynchronously in the background
    public void execute(QueueableContext context) {
        // We will build out the actual HTTP REST callout logic here next
        System.debug('WeatherQueueable executing for ' + incidentIds.size() + ' records.');

        // Step 1: Query the Incident records we need to update
        // We only want records that actually have a Zip Code to look up
        List<Incident__c> incidentsToUpdate = [
            SELECT Id, Location_Latitude__c, Location_Longitude__c 
            FROM Incident__c 
            WHERE Id IN :incidentIds 
            AND Location_Latitude__c != null 
            AND Location_Longitude__c != null
        ];

        // If there are no valid incidents, exit early to save processing power
        if (incidentsToUpdate.isEmpty()) {
            return; 
        }

        // Step 2: Prepare the HTTP Request
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        // Dynamically inject the coordinates from the record into the URL
        Decimal lat = incidentsToUpdate[0].Location_Latitude__c;
        Decimal lon = incidentsToUpdate[0].Location_Longitude__c;

        // We use the Named Credential (e.g., 'Weather_API') so we don't hardcode API keys or URLs.
        // Note: For simplicity in this project, we are assuming a single callout for the first record. 
        // In a true bulkified scenario with 200 different zip codes, you would batch these callouts.
        String endpoint = 'callout:Weather_API/v1/forecast?latitude=' + lat + '&longitude=' + lon + '&current=temperature_2m,apparent_temperature';
        // request.setEndpoint('callout:Weather_API/weather?zip=' + zipCode);
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                WeatherResponseWrapper weatherData = (WeatherResponseWrapper) JSON.deserialize(
                    response.getBody(), 
                    WeatherResponseWrapper.class
                );

                for (Incident__c inc : incidentsToUpdate) {
                    inc.Current_Temperature__c = weatherData.current_weather.temperature;
                }

                update incidentsToUpdate;
                System.debug('Dynamic weather update applied successfully!');
                
            } else {
                System.debug('Weather API Callout failed. Status Code: ' + response.getStatusCode());
            }
            
        } catch (Exception e) {
            System.debug('Exception during HTTP Callout: ' + e.getMessage());
        }

    }
}