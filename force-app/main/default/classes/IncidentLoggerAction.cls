public with sharing class IncidentLoggerAction {

    // =====================================================================
    // 1. THE INPUT CONTRACT (What the AI must gather from the citizen)
    // =====================================================================
    public class IncidentRequest {
        @InvocableVariable(required=true description='The category of the issue. Valid values: Pothole, Broken Streetlight, Graffiti, Fallen Tree, Water Leak.')
        public String incidentType;

        @InvocableVariable(required=true description='A detailed description of what the citizen is reporting.')
        public String description;

        @InvocableVariable(required=true description='The zip code where the incident occurred.')
        public String zipCode;
    }

    // =====================================================================
    // 2. THE OUTPUT CONTRACT (What Apex sends back to the AI)
    // =====================================================================
    public class IncidentResult {
        @InvocableVariable(description='The Salesforce Record ID of the newly created incident.')
        public Id incidentId;
        
        @InvocableVariable(description='A status message indicating success or failure.')
        public String statusMessage;
    }

    // =====================================================================
    // 3. THE EXECUTABLE ENGINE (The actual logic the AI runs)
    // =====================================================================
    @InvocableMethod(label='Log New City Incident' description='Creates a new Incident record in the database using details provided by a citizen.')
    public static List<IncidentResult> createIncident(List<IncidentRequest> requests) {
        
        List<IncidentResult> results = new List<IncidentResult>();
        List<Incident_Report__c> reportsToInsert = new List<Incident_Report__c>();

        // Loop through the requests (Bulkification standard, even though AI usually sends one at a time)
        for (IncidentRequest req : requests) {
            Incident_Report__c newReport = new Incident_Report__c();
            newReport.Incident_Type__c = req.incidentType;
            newReport.Description__c = req.description;
            newReport.Location_Zip_Code__c = String.isBlank(req.zipCode) ? '3000' : req.zipCode;
            newReport.Location_Latitude__c = -37.818;
            newReport.Location_Longitude__c = 144.966;

            reportsToInsert.add(newReport);
        }

        try {
            insert reportsToInsert;
            
            // Prepare the success response for the AI
            for (Incident_Report__c report : reportsToInsert) {
                IncidentResult res = new IncidentResult();
                res.incidentId = report.Id;
                res.statusMessage = 'Successfully created incident in zip code ' + report.Location_Zip_Code__c;
                results.add(res);
            }
        } catch (Exception e) {
            // Prepare the failure response for the AI so it can apologize to the user
            IncidentResult failRes = new IncidentResult();
            failRes.statusMessage = 'Failed to create incident: ' + e.getMessage();
            results.add(failRes);
        }

        return results;
    }
}