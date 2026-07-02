public class WeatherQueueable implements Queueable, Database.AllowsCallouts {

    private List<Incident__c> incidents;
    private Integer currentIndex;

    public WeatherQueueable(Set<Id> recordIds) {
        this.incidents = [
            SELECT Id, Location_Latitude__c, Location_Longitude__c
            FROM Incident__c
            WHERE Id IN :recordIds
            AND Location_Latitude__c != null
            AND Location_Longitude__c != null
        ];
        this.currentIndex = 0;
    }

    private WeatherQueueable(List<Incident__c> incidents, Integer startIndex) {
        this.incidents = incidents;
        this.currentIndex = startIndex;
    }

    public void execute(QueueableContext context) {
        if (currentIndex >= incidents.size()) return;

        Incident__c inc = incidents[currentIndex];
        String endpoint = 'callout:Weather_API/v1/forecast?latitude=' + inc.Location_Latitude__c
            + '&longitude=' + inc.Location_Longitude__c
            + '&current=temperature_2m,apparent_temperature';

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');

        try {
            HttpResponse response = http.send(request);

            if (response.getStatusCode() == 200) {
                WeatherResponseWrapper weatherData = (WeatherResponseWrapper) JSON.deserialize(
                    response.getBody(),
                    WeatherResponseWrapper.class
                );
                inc.Current_Temperature__c = weatherData.current.temperature_2m;
                update inc;
            } else {
                System.debug('Weather API Callout failed. Status Code: ' + response.getStatusCode());
            }
        } catch (Exception e) {
            System.debug('Exception during HTTP Callout: ' + e.getMessage());
        }

        if (currentIndex + 1 < incidents.size()) {
            System.enqueueJob(new WeatherQueueable(incidents, currentIndex + 1));
        }
    }
}