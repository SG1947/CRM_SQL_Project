-- 03_views.sql

USE crm_system;

-- View: Sales pipeline overview (grouped by stage)
CREATE OR REPLACE VIEW view_sales_pipeline AS
SELECT
    ss.stage_name,
    COUNT(l.lead_id) AS total_leads
FROM leads l
JOIN sales_stages ss ON l.stage_id = ss.stage_id
GROUP BY ss.stage_name
ORDER BY ss.stage_order;

-- View: Converted vs unconverted leads
CREATE OR REPLACE VIEW view_lead_conversion_status AS
SELECT
    l.lead_id,
    CONCAT(l.first_name, ' ', l.last_name) AS lead_name,
    l.email,
    l.phone,
    c.customer_id IS NOT NULL AS is_converted
FROM leads l
LEFT JOIN customers c ON l.lead_id = c.lead_id;

-- View: Tasks per user with completion status
CREATE OR REPLACE VIEW view_user_task_summary AS
SELECT
    u.user_id,
    u.username,
    COUNT(t.task_id) AS total_tasks,
    SUM(t.status = 'Completed') AS completed_tasks,
    SUM(t.status = 'Pending') AS pending_tasks
FROM users u
LEFT JOIN tasks t ON u.user_id = t.assigned_to
GROUP BY u.user_id, u.username;

-- View: Customer communication summary (count by type)
CREATE OR REPLACE VIEW view_customer_communications AS
SELECT
    c.customer_id,
    c.contact_name,
    COUNT(comm.comm_id) AS total_communications,
    SUM(comm.comm_type = 'Email') AS email_count,
    SUM(comm.comm_type = 'Call') AS call_count,
    SUM(comm.comm_type = 'Meeting') AS meeting_count
FROM customers c
LEFT JOIN communications comm ON c.customer_id = comm.related_customer_id
GROUP BY c.customer_id, c.contact_name;


-- 1. View: Sales pipeline overview
SELECT * FROM view_sales_pipeline;

-- 2. View: Converted vs unconverted leads
SELECT * FROM view_lead_conversion_status;

-- 3. View: Tasks per user with status counts
SELECT * FROM view_user_task_summary;

-- 4. View: Customer communication summary
SELECT * FROM view_customer_communications;
