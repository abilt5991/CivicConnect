@isTest
private class IncidentLoggerActionTest {

    @TestSetup
    static void setupData() {
        insert new Department__c(Name = 'Public Works', Is_Active__c = true, Department_Email__c = 'publicworks@test.civicconnect.com');
        insert new Department__c(Name = 'Sanitation', Is_Active__c = true, Department_Email__c = 'sanitation@test.civicconnect.com');
    }

    @isTest
    static void testAgentIncidentCreation() {
        // 1. Prepare the mock input exactly as the AI Agent would send it
        IncidentLoggerAction.IncidentRequest mockRequest = new IncidentLoggerAction.IncidentRequest();
        mockRequest.incidentType = 'Pothole';
        mockRequest.description = 'Massive crater in the middle of the intersection.';
        mockRequest.zipCode = '3000';

        List<IncidentLoggerAction.IncidentRequest> requestList = new List<IncidentLoggerAction.IncidentRequest>{ mockRequest };

        // 2. Execute the Invocable Method
        Test.startTest();
        List<IncidentLoggerAction.IncidentResult> results = IncidentLoggerAction.createIncident(requestList);
        Test.stopTest();

        // 3. Verify the AI gets a successful response and a Record ID back
        System.assertEquals(1, results.size(), 'The system should return exactly one result object.');
        System.assertNotEquals(null, results[0].incidentId, 'The Incident ID should not be null; the record must be inserted.');
        System.assert(results[0].statusMessage.contains('Successfully'), 'The status message should indicate success.');

        // 4. Verify the database holds the record with default coordinates stamped
        Incident_Report__c saved = [SELECT Id, Location_Zip_Code__c, Location_Latitude__c, Location_Longitude__c FROM Incident_Report__c WHERE Id = :results[0].incidentId];
        System.assertEquals('3000', saved.Location_Zip_Code__c, 'Default zip code should be 3000.');
        System.assertEquals(-37.818, saved.Location_Latitude__c, 'Default latitude should be -37.818.');
        System.assertEquals(144.966, saved.Location_Longitude__c, 'Default longitude should be 144.966.');
    }
}