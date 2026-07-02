@isTest
private class IncidentLoggerActionTest {
    
    @isTest
    static void testAgentIncidentCreation() {
        // 1. Prepare the mock input exactly as the AI Agent would send it
        IncidentLoggerAction.IncidentRequest mockRequest = new IncidentLoggerAction.IncidentRequest();
        mockRequest.incidentType = 'Pothole';
        mockRequest.description = 'Massive crater in the middle of the intersection.';
        mockRequest.zipCode = '3810';
        
        List<IncidentLoggerAction.IncidentRequest> requestList = new List<IncidentLoggerAction.IncidentRequest>{ mockRequest };
        
        // 2. Execute the Invocable Method
        Test.startTest();
        List<IncidentLoggerAction.IncidentResult> results = IncidentLoggerAction.createIncident(requestList);
        Test.stopTest();
        
        // 3. Verify the AI gets a successful response and a Record ID back
        System.assertEquals(1, results.size(), 'The system should return exactly one result object.');
        System.assertNotEquals(null, results[0].incidentId, 'The Incident ID should not be null; the record must be inserted.');
        System.assert(results[0].statusMessage.contains('Successfully'), 'The status message should indicate success.');
        
        // 4. Verify the database actually holds the record
        Integer recordCount = [SELECT COUNT() FROM Incident_Report__c WHERE Id = :results[0].incidentId];
        System.assertEquals(1, recordCount, 'The incident record should exist in the database.');
    }
}