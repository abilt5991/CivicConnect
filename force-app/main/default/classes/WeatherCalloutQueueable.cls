// We must implement Database.AllowsCallouts to get permission to hit the internet!
public class WeatherCalloutQueueable implements Queueable, Database.AllowsCallouts {
    
    // 1. Variables to hold the data passed from the Trigger
    private Id incidentId;
    private Decimal latitude;
    private Decimal longitude;

    // 2. The Constructor: This is how the Trigger hands the data to our background worker
    public WeatherCalloutQueueable(Id incidentId, Decimal latitude, Decimal longitude) {
        this.incidentId = incidentId;
        this.latitude = latitude;
        this.longitude = longitude;
    }

    // 3. The Execute Method: This is what runs in the background
   public void execute(QueueableContext context) {
        System.debug('Background job started for Incident: ' + this.incidentId);
        
        // 1. Prepare the HTTP Request (The Envelope)
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        // THE MAGIC: Instead of typing 'https://api.open-meteo.com', we use 'callout:[NamedCredentialName]'
        // Salesforce automatically intercepts this and securely applies the URL and rules!
        String endpoint = 'callout:Weather_API/v1/forecast?latitude=' + this.latitude + '&longitude=' + this.longitude + '&current_weather=true';
        request.setEndpoint(endpoint);
        request.setMethod('GET'); // GET means we are asking for data, not sending it

        try {
            // 2. Send the request to the internet (The Mail Carrier)
            HttpResponse response = http.send(request);

            // 3. Process the Response (200 is the standard HTTP code for "Success/OK")
            if (response.getStatusCode() == 200) {
                
                // THE TRANSLATOR: Take the raw JSON text (response.getBody()) 
                // and magically pour it into our Apex Wrapper variables.
                WeatherResponseWrapper weatherData = (WeatherResponseWrapper) JSON.deserialize(
                    response.getBody(), 
                    WeatherResponseWrapper.class
                );

                // 4. Update the Salesforce Record with the new data
                Incident__c incidentToUpdate = new Incident__c(
                    Id = this.incidentId,
                    Current_Temperature__c = weatherData.current_weather.temperature
                );
                
                update incidentToUpdate;
                System.debug('Successfully updated temperature to: ' + weatherData.current_weather.temperature);
            } else {
                System.debug('Callout failed with status: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('An error occurred during the callout: ' + e.getMessage());
        }
    }
}