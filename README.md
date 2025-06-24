📇 MySQL-Only CRM System
==========================

A fully functional Customer Relationship Management (CRM) system implemented entirely in MySQL 8+ using DDL, DML, views, triggers, stored procedures, and normalized relational design. No frontend/backend code — database only.

📦 Contents
-----------
- 01_schema.sql – Core schema (users, leads, customers, tasks, etc.)
- 02_sample_data.sql – Sample data (≥10 entries per core table)
- 03_views.sql – Analytical SQL views (pipeline, conversions, summaries)
- 04_procedures.sql – Stored procedures (lead conversion, etc.)
- 05_triggers.sql – Audit trail via triggers
- 06_bonus_features.sql – Tagging, teams, team views
- README.txt – Documentation (this file)
- ER_diagram.png/pdf – Entity-Relationship Diagram (optional)

🧱 Core Features
----------------
- Leads Management: Track potential customers, contact info, and source
- Sales Funnel: Move leads through defined sales stages (New → Contacted → Won/Lost)
- Tasks & Activities: Assign tasks with due dates, statuses, and lead linkage
- Communication Logs: Record emails, calls, and meetings tied to leads/customers
- Users and Roles: Users table with roles like Sales Rep, Manager
- Customer Accounts: Convert leads to customers; manage customer contact info
- Notes & Attachments: Add text notes and file links to leads/customers/tasks
- Audit Trail: Auto-logging via triggers on inserts, updates, and deletes

💡 Bonus Features
-----------------
- Tagging System: Assign tags (e.g., "Hot Lead", "Enterprise") to leads/customers
- Teams & Users: Organize users and leads/customers by sales team
- Analytical Views: Prebuilt views for lead status, team pipeline, and user performance
- Stored Procedures: Includes sp_convert_lead_to_customer workflow automation
- Triggers: 8 fully operational triggers writing to the audit_log table

🛠️ Setup Instructions
----------------------
1. Create the Database
   CREATE DATABASE crm_system;
   USE crm_system;

2. Run the Scripts in Order
   - 01_schema.sql → defines all tables
   - 02_sample_data.sql → inserts sample records
   - 03_views.sql → defines views
   - 04_procedures.sql → creates stored procedures
   - 05_triggers.sql → sets up audit triggers
   - 06_bonus_features.sql → tags, teams, views

3. Verify Installation
   USE crm_system;
   SHOW TABLES;
   SELECT * FROM leads LIMIT 10;
   SELECT * FROM view_sales_pipeline;

🔍 How to Test Functionality
-----------------------------
View the Sales Funnel:
   SELECT * FROM view_sales_pipeline;

Convert a Lead to Customer:
   CALL sp_convert_lead_to_customer(1, 1);

Trigger Audit:
   INSERT INTO leads (first_name, last_name, email, phone, company_name, stage_id, assigned_to)
   VALUES ('Test', 'Lead', 'test@example.com', '1234567890', 'Test Co', 1, 1);
   SELECT * FROM audit_log ORDER BY change_time DESC;

View Tags:
   SELECT * FROM view_lead_tags;

🔗 ER Diagram
--------------
See ER_diagram.png (provided separately) for full relationship mapping.

📋 Requirements
---------------
- MySQL 8.0 or higher
- MySQL Workbench recommended for visualization
- No external dependencies or code required

