# CivicConnect

## 1. Overview
CivicConnect is a modern, Salesforce-based civic engagement platform designed to empower citizens to easily report non-emergency local incidents—such as potholes, fallen trees, graffiti, water leaks, and broken streetlights—directly to their local government. 

By leveraging an intuitive public-facing portal (Experience Cloud) and an intelligent AI chatbot (Agentforce), CivicConnect streamlines the reporting process. Behind the scenes, intelligent routing automation ensures that every incident is instantly directed to the appropriate city department for rapid resolution.

## 2. Technical Skills Used
This project incorporates a full-stack Salesforce architecture, demonstrating expertise in the following areas:

*   **Lightning Web Components (LWC):** Built a responsive, modern, and accessible user interface (`incidentReportForm`) with advanced CSS (floating labels, dynamic UI feedback, balanced layouts).
*   **Agentforce & Omnichannel:** Configured an autonomous AI agent (`CivicConnect_Assistant`), Web Messaging Channels, and Embedded Service Deployments with guest user access to allow citizens to report incidents via conversational AI.
*   **Apex Development:** 
    *   **Invocable Actions:** Built bulkified `@InvocableMethod` classes (`IncidentLoggerAction`) to bridge the AI agent with backend DML operations.
    *   **Apex Triggers:** Implemented a robust Trigger Framework (`IncidentReportTriggerHandler`) for complex parent-child record generation and escalation counting.
    *   **Asynchronous Apex:** Used `Queueable` interfaces and HTTP Callouts (`WeatherQueueable`) to enrich incidents with external API data.
    *   **Testing:** Wrote comprehensive unit tests (`IncidentLoggerActionTest`, `WeatherQueueableTest`, `IncidentReportTriggerTest`) achieving 100% code coverage.
*   **Salesforce Flow Automation:** Designed Record-Triggered flows (`Assign_Incident_to_Department`) to automate email notifications and data updates.
*   **Data Modeling & Architecture:** Designed complex data relationships using Custom Objects (`Incident__c`, `Incident_Report__c`, `Department__c`).
*   **Custom Metadata Types (CMDT):** Built scalable, hardcode-free routing rules (`Incident_Routing_Rule__mdt`) to dynamically assign incidents to departments based on the incident type.
*   **Security & Access Control:** Configured Permission Sets (`Incident_Manager`), Guest User profiles, external credentials, and object/field-level security.
*   **Salesforce CLI & Source Control:** Managed metadata extraction, deployments, and version control using SFDX and Git.

## 3. Implementation Phases
The project was systematically built across the following phases:

### Phase 1: Foundational Architecture & Security
*   Designed the core data model (Incidents, Incident Reports, and Departments).
*   Configured Custom Metadata Types for scalable incident routing.
*   Established security protocols, including the `Incident_Manager` Permission Set and Profile-based access controls.

### Phase 2: Web Portal & User Experience (UX)
*   Developed the custom `incidentReportForm` Lightning Web Component for Experience Cloud.
*   Refined UI/UX with modern design aesthetics, including floating labels, custom dropdown highlights, and balanced visual structures without standard Salesforce borders.

### Phase 3: Automation & Backend Logic
*   Implemented Apex Trigger handlers to seamlessly link citizen reports to centralized Incident records.
*   Built asynchronous HTTP callouts to fetch real-time weather data during incident creation.
*   Created Record-Triggered Flows to automatically notify Department Heads when new incidents are routed or escalated.

### Phase 4: AI & Chatbot Integration
*   Deployed Agentforce to the Experience Cloud site via a Web Messaging Channel.
*   Developed Apex Invocable actions allowing the chatbot to interpret citizen input, extract details (Incident Type, Description, Zip Code), and log records autonomously.
*   Resolved complex Guest User and metadata permissions to ensure seamless AI operation for unauthenticated visitors.

## 4. Future Enhancements
*   **Geolocation & Maps Integration:** Automatically detect and map user coordinates using the Google Maps or Salesforce Maps API.
*   **Multimedia Uploads:** Allow citizens to upload photos of incidents directly to the LWC or chatbot, potentially utilizing Einstein Vision to automatically categorize the issue.
*   **Community Upvoting:** Introduce a feature where citizens can view existing incidents in their zip code and "upvote" them to increase priority, rather than logging duplicate reports.
*   **Proactive Case Deflection:** Enhance the Agentforce bot with a Knowledge Base so it can answer common city inquiries (e.g., "When is trash day?") in addition to logging incidents.
