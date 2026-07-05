public class IncidentReportTriggerHandler extends TriggerHandler {
    List<Incident_Report__c> actionableReports = new List<Incident_Report__c>();
    public override void beforeInsert() {
        // 1. Initialize sets to hold unique factors to avoid querying duplicates
        actionableReports = new List<Incident_Report__c>();
        Set<String> zipCodes = new Set<String>();
        Set<String> incidentTypes = new Set<String>();

        for (Incident_Report__c report : (List<Incident_Report__c>)Trigger.new) {
            if (report.Location_Zip_Code__c != null && report.Incident_Type__c != null) {
                zipCodes.add(report.Location_Zip_Code__c);
                incidentTypes.add(report.Incident_Type__c);
                actionableReports.add(report);
            }
        }

        if (actionableReports.isEmpty()) return;

        // Step 2: Query and Map logic
        Map<String, Incident__c> existingIncidentMap = new Map<String, Incident__c>();

        for (Incident__c inc : [
            SELECT Id, Location_Zip_Code__c, Incident_Type__c 
            FROM Incident__c 
            WHERE Location_Zip_Code__c IN :zipCodes 
            AND Incident_Type__c IN :incidentTypes
            AND Status__c != 'Resolved'
        ]) {
            String mapKey = inc.Location_Zip_Code__c + '_' + inc.Incident_Type__c;
            existingIncidentMap.put(mapKey, inc);
        }

        // Link reports to existing incidents
        for (Incident_Report__c report : actionableReports) {
            String reportKey = report.Location_Zip_Code__c + '_' + report.Incident_Type__c;
            if (existingIncidentMap.containsKey(reportKey)) {
                report.Incident__c = existingIncidentMap.get(reportKey).Id;
            }
        }
        
        // Step 3: Identify orphan reports (those without an associated incident)
        List<Incident_Report__c> orphanReports = new List<Incident_Report__c>();
        for (Incident_Report__c report : actionableReports) {
            if (report.Incident__c == null) {
                orphanReports.add(report);
            }
        }

        if (!orphanReports.isEmpty()) {
            List<Incident__c> newIncidents = new List<Incident__c>();
    
            // Prepare new parents
            for (Incident_Report__c report : orphanReports) {
                    newIncidents.add(new Incident__c(
                        Location_Zip_Code__c = report.Location_Zip_Code__c,
                        Incident_Type__c = report.Incident_Type__c,
                        Incident_Description__c = report.Description__c,
                        Status__c = 'New',
                        Location_Latitude__c = report.Location_Latitude__c != null ? report.Location_Latitude__c : -37.818,
                        Location_Longitude__c = report.Location_Longitude__c != null ? report.Location_Longitude__c : 144.966
                    ));
                }
                
                // Insert new parents in bulk
                insert newIncidents;
                
                // Map the new IDs back to the orphan reports
                for (Integer i = 0; i < orphanReports.size(); i++) {
                    orphanReports[i].Incident__c = newIncidents[i].Id;
                }
            }
    }
    public override void afterInsert() {
        // Count how many reports in this transaction point to each parent
        Map<Id, Integer> reportCountByParent = new Map<Id, Integer>();
        for (Incident_Report__c report : (List<Incident_Report__c>)Trigger.new) {
            if (report.Incident__c != null) {
                Integer current = reportCountByParent.containsKey(report.Incident__c)
                    ? reportCountByParent.get(report.Incident__c) : 0;
                reportCountByParent.put(report.Incident__c, current + 1);
            }
        }

        if (reportCountByParent.isEmpty()) return;

        List<Incident__c> parentsToUpdate = [SELECT Id, Escalation_Count__c FROM Incident__c WHERE Id IN :reportCountByParent.keySet()];

        for (Incident__c parent : parentsToUpdate) {
            Decimal count = (parent.Escalation_Count__c == null) ? 0 : parent.Escalation_Count__c;
            parent.Escalation_Count__c = count + reportCountByParent.get(parent.Id);
        }

        update parentsToUpdate;
    }
}