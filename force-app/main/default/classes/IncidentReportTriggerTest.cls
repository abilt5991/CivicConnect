@isTest
private class IncidentReportTriggerTest {

    @isTest
    static void testIncidentReportTriggerLogic() {
        // 1. Arrange
    Incident__c parent = new Incident__c(Location_Zip_Code__c = '90210', Incident_Type__c = 'Pothole', Status__c = 'New');
    insert parent;

    // 2. Act
    List<Incident_Report__c> new_reports = new List<Incident_Report__c>();
    Incident_Report__c testReport = new Incident_Report__c(Location_Zip_Code__c = '90210', Incident_Type__c = 'Pothole', Description__c = 'Large pothole');
    new_reports.add(testReport);
    Incident_Report__c testReport2 = new Incident_Report__c(Location_Zip_Code__c = '90210', Incident_Type__c = 'Pothole', Description__c = 'Large pothole in front of my house');
    new_reports.add(testReport2);

    Test.startTest();
    insert new_reports;
    Test.stopTest(); 

    // 3. Debug and Assert
    Incident__c updatedParent = [SELECT Id, Escalation_Count__c FROM Incident__c WHERE Id = :parent.Id];
    System.debug('Updated Parent Count: ' + updatedParent.Escalation_Count__c);
    
    System.assertEquals(2, updatedParent.Escalation_Count__c, 'Escalation count should match the number of related Incident Report records (2)');
    }
}