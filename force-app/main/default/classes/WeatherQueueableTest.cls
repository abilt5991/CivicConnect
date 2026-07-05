@isTest
private class WeatherQueueableTest {

    @TestSetup
    static void setupData() {
        insert new Department__c(Name = 'Public Works', Is_Active__c = true, Department_Email__c = 'publicworks@test.civicconnect.com');
        insert new Department__c(Name = 'Sanitation', Is_Active__c = true, Department_Email__c = 'sanitation@test.civicconnect.com');
    }

    @isTest
    static void testWeatherIntegrationEndToEnd() {
        
        // 1. Tell the Salesforce test engine to use our fake API response
        Test.setMock(HttpCalloutMock.class, new WeatherCalloutMock());
        
        // 2. Prepare the Data
        Incident__c testIncident = new Incident__c();
        testIncident.Incident_Type__c = 'Pothole';
        testIncident.Status__c = 'New';
        testIncident.Incident_Description__c = 'Testing Queueable';
        testIncident.Location_Latitude__c = -37.818;
        testIncident.Location_Longitude__c = 144.966;
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