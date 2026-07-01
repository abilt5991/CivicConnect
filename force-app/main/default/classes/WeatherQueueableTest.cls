@isTest
private class WeatherQueueableTest {
    
    @isTest
    static void testWeatherIntegrationEndToEnd() {
        
        // 1. Tell the Salesforce test engine to use our fake API response
        Test.setMock(HttpCalloutMock.class, new WeatherCalloutMock());
        
        // 2. Prepare the Data
        Incident__c testIncident = new Incident__c();
        testIncident.Incident_Type__c = 'Pothole';
        testIncident.Status__c = 'New';
        testIncident.Description__c = 'Testing Queueable'; // Assuming this is optional
        testIncident.Location_Latitude__c = 40.7128;
        testIncident.Location_Longitude__c = -74.0060;
        testIncident.Location_Zip_Code__c = '10001'; 
        
        // 3. Start the test context
        Test.startTest();
        
        // 4. Insert the record. 
        insert testIncident; // This will now succeed!
        
        // 5. Stop the test context. 
        Test.stopTest();
        
        // 6. Verify the Results
        Incident__c updatedIncident = [SELECT Id, Current_Temperature__c FROM Incident__c WHERE Id = :testIncident.Id];
        
        System.assertEquals(72.5, updatedIncident.Current_Temperature__c, 'The temperature was not updated correctly by the mock callout.');
    }
}