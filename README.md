# CivicConnect: Smart City Solutions

## Description
CivicConnect is a modern, Salesforce-based civic engagement platform designed to help citizens easily report non-emergency local incidents—such as potholes, fallen trees, graffiti, water leaks, and broken streetlights—directly to their local government. By bridging the gap between citizens and city departments, CivicConnect solves the problem of slow reporting times and misrouted city requests. The platform targets both everyday citizens (via a public-facing Experience Cloud portal and an intelligent Agentforce AI chatbot) and city officials (who benefit from automated Custom Metadata routing and robust Apex trigger frameworks to resolve incidents quickly).

## Visuals
<img width="1470" height="802" alt="Civic Connect Portal" src="https://github.com/user-attachments/assets/084e6985-fb8f-4250-8653-d2dcc2c3d60d" />

## Prerequisites
To deploy and develop on the CivicConnect Salesforce project, you will need:
*   [Salesforce CLI (`sf`)](https://developer.salesforce.com/tools/salesforcecli) installed on your machine.
*   A Salesforce Developer Edition Org or Scratch Org with **Agentforce** and **Experience Cloud** enabled.
*   Basic understanding of Salesforce DX (SFDX) project structures.

## Usage
Once deployed, citizens and internal users can interact with the system in several ways:

**1. Citizen Reporting via Web Portal (LWC):**
Navigate to the active Experience Cloud Site URL. Citizens can use the modern, responsive `incidentReportForm` Lightning Web Component to submit issues. The component features floating labels, dynamic CSS feedback, and asynchronous weather data retrieval via Apex Queueables.
<img width="1470" height="802" alt="Form with location coords" src="https://github.com/user-attachments/assets/b8025133-fce4-4da6-a113-3eef410c0eb7" />


Confirmation of form submission:
<img width="1470" height="800" alt="Report Submitted" src="https://github.com/user-attachments/assets/d742b70d-1a39-402d-b7fc-7fc527fa309e" />


**2. Conversational Reporting via AI Agent:**
Citizens can open the chat widget on the site to talk to the **CivicConnect Assistant**. The AI uses Invocable Actions (`IncidentLoggerAction`) to extract details like Zip Code and Incident Type from the conversation and autonomously log the record.
<img width="1470" height="804" alt="CivicConnect AI Assistant" src="https://github.com/user-attachments/assets/dc80d1e0-93a0-43fa-8efb-282938578046" />


The Agenforce Service Agent asks relevant questions to collect data necessary to create records in the system:
<img width="365" height="508" alt="Agent created records" src="https://github.com/user-attachments/assets/c1ff5524-aa58-4549-bde5-eb61392968ff" />


Incident Created via Agent chat:
<img width="1470" height="394" alt="Incident Report Created via Agent chat" src="https://github.com/user-attachments/assets/f28eb104-c36f-4a90-a1be-5c11058fd441" />



**3. Automated Department Routing:**
When an incident is logged, Salesforce Record-Triggered Flows (`Assign_Incident_to_Department`) automatically route the record to the correct department (e.g., Public Works) based on Custom Metadata Type (`Incident_Routing_Rule__mdt`) rules and trigger email notifications.
<img width="1163" height="195" alt="Escalated Incident Notification" src="https://github.com/user-attachments/assets/3dd1c4b5-33ae-4594-946a-834b90a5380c" />


**4. Home Page Dashboards:**
Internal city officials can use Salesforce Home Page dashboards to track reported incidents, monitor their current status in real-time, and oversee department actions to ensure timely resolution.
<img width="1470" height="782" alt="CivicConnect Incidents Dashboard" src="https://github.com/user-attachments/assets/f43a083d-f7cc-4981-8dec-ae0ee28fd1b3" />


## Roadmap
**Completed Phases (Technical Implementations):**
*   **Data Model & UI:** Core Data Model (Custom Objects, Fields, Profiles) alongside an Experience Cloud Web Portal featuring custom LWC UI components with Geolocation capabilities.
*   **Backend Logic:** Apex classes, SOQL, and robust Apex Trigger Automation to manage incident relationships and escalation logic.
*   **External Integrations:** External API Callouts to a Weather API utilizing Named and External Credentials.
*   **AI & Automation:** Agentforce Service Agent integrated via Web Messaging (OmniChannel), coupled with Omni-channel flow for automated incident creating, department routing and escalation.
*   **DevOps:** Full project lifecycle management using VS Code, SFDX, SF CLI, and automated Metadata deployment.

**Future Enhancements:**
*   **Multimedia Uploads:** Allow citizens to upload incident photos directly to the LWC or chatbot (with Einstein Vision categorization).
*   **Community Voting:** Enable citizens to view and upvote existing incidents to increase urgency.
*   **Proactive Case Deflection:** Enhance Agentforce with a Knowledge Base to answer common civic inquiries.
