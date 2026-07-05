# CivicConnect: Empowering Citizens with Smart Government Solutions

## Description
CivicConnect is a modern, Salesforce-based civic engagement platform designed to help citizens easily report non-emergency local incidents—such as potholes, fallen trees, graffiti, water leaks, and broken streetlights—directly to their local government. By bridging the gap between citizens and city departments, CivicConnect solves the problem of slow reporting times and misrouted city requests. The platform targets both everyday citizens (via a public-facing Experience Cloud portal and an intelligent Agentforce AI chatbot) and city officials (who benefit from automated Custom Metadata routing and robust Apex trigger frameworks to resolve incidents quickly).

## Visuals
*(Note: Add a screenshot or animated GIF of the CivicConnect Experience Cloud portal and the Agentforce chatbot in action here)*
![CivicConnect Portal Placeholder](https://via.placeholder.com/800x400.png?text=CivicConnect+Portal+Screenshot)

## Prerequisites
To deploy and develop on the CivicConnect Salesforce project, you will need:
*   [Salesforce CLI (`sf`)](https://developer.salesforce.com/tools/salesforcecli) installed on your machine.
*   A Salesforce Developer Edition Org or Scratch Org with **Agentforce** and **Experience Cloud** enabled.
*   Git installed for version control.
*   Basic understanding of Salesforce DX (SFDX) project structures.

## Installation
Follow these steps to set up your local development environment and push the code to your Salesforce org:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/abilt5991/CivicConnect.git
   cd CivicConnect
   ```

2. **Authorize your Salesforce Org:**
   ```bash
   sf org login web --set-default
   ```

3. **Deploy the source code to your org:**
   ```bash
   sf project deploy start
   ```

4. **Assign the necessary Permission Set to yourself and the Agentforce Integration User:**
   ```bash
   sf org assign permset --name Incident_Manager
   ```

## Usage
Once deployed, citizens and internal users can interact with the system in several ways:

**1. Citizen Reporting via Web Portal (LWC):**
Navigate to the active Experience Cloud Site URL. Citizens can use the modern, responsive `incidentReportForm` Lightning Web Component to submit issues. The component features floating labels, dynamic CSS feedback, and asynchronous weather data retrieval via Apex Queueables.

**2. Conversational Reporting via AI Agent:**
Citizens can open the chat widget on the site to talk to the **CivicConnect Assistant**. The AI uses Invocable Actions (`IncidentLoggerAction`) to extract details like Zip Code and Incident Type from the conversation and autonomously log the record.

**3. Automated Department Routing:**
When an incident is logged, Salesforce Record-Triggered Flows (`Assign_Incident_to_Department`) automatically route the record to the correct department (e.g., Public Works) based on Custom Metadata Type (`Incident_Routing_Rule__mdt`) rules and trigger email notifications.

## Roadmap
**Completed Phases (Technical Implementations):**
*   [x] Core Data Model (Custom Objects, Fields, Profiles)
*   [x] Experience Cloud Web Portal & LWC UI
*   [x] Apex Trigger Automation & External API Callouts
*   [x] Agentforce Chatbot & Web Messaging Integration

**Future Enhancements:**
*   **Geolocation Integration:** Automatically pull user coordinates via Maps API.
*   **Multimedia Uploads:** Allow citizens to upload incident photos directly to the LWC or chatbot (with Einstein Vision categorization).
*   **Community Voting:** Enable citizens to view and upvote existing incidents to increase urgency.
*   **Proactive Case Deflection:** Enhance Agentforce with a Knowledge Base to answer common civic inquiries.

## Contributing
We welcome contributions to make CivicConnect even better! 
1. Fork the repository.
2. Create a new branch for your feature or bug fix (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request for review.

Please ensure all new Apex code is accompanied by unit tests with 100% coverage, matching the existing standard.

## License
Distributed under the MIT License. See `LICENSE` for more information.
