-- 05_triggers.sql

USE crm_system;

-- Audit trail table
CREATE TABLE audit_log (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100),
    action_type ENUM('INSERT', 'UPDATE', 'DELETE'),
    record_id INT,
    changed_by INT,
    change_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    change_summary TEXT
);

-- Lead INSERT
DELIMITER $$
CREATE TRIGGER trg_lead_insert
AFTER INSERT ON leads
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('leads', 'INSERT', NEW.lead_id, NEW.assigned_to, CONCAT('Lead inserted: ', NEW.first_name, ' ', NEW.last_name));
END$$
DELIMITER ;

-- Lead UPDATE
DELIMITER $$
CREATE TRIGGER trg_lead_update
AFTER UPDATE ON leads
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('leads', 'UPDATE', NEW.lead_id, NEW.assigned_to, CONCAT('Lead updated: ', NEW.first_name, ' ', NEW.last_name));
END$$
DELIMITER ;

-- Lead DELETE
DELIMITER $$
CREATE TRIGGER trg_lead_delete
AFTER DELETE ON leads
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('leads', 'DELETE', OLD.lead_id, OLD.assigned_to, CONCAT('Lead deleted: ', OLD.first_name, ' ', OLD.last_name));
END$$
DELIMITER ;
-- Customer INSERT
DELIMITER $$
CREATE TRIGGER trg_customer_insert
AFTER INSERT ON customers
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('customers', 'INSERT', NEW.customer_id, NEW.assigned_to, CONCAT('Customer created: ', NEW.contact_name));
END$$
DELIMITER ;

-- Customer UPDATE
DELIMITER $$
CREATE TRIGGER trg_customer_update
AFTER UPDATE ON customers
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('customers', 'UPDATE', NEW.customer_id, NEW.assigned_to, CONCAT('Customer updated: ', NEW.contact_name));
END$$
DELIMITER ;
-- Task INSERT
DELIMITER $$
CREATE TRIGGER trg_task_insert
AFTER INSERT ON tasks
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('tasks', 'INSERT', NEW.task_id, NEW.assigned_to, CONCAT('Task created: ', NEW.title));
END$$
DELIMITER ;

-- Task UPDATE
DELIMITER $$
CREATE TRIGGER trg_task_update
AFTER UPDATE ON tasks
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (table_name, action_type, record_id, changed_by, change_summary)
    VALUES ('tasks', 'UPDATE', NEW.task_id, NEW.assigned_to, CONCAT('Task updated: ', NEW.title));
END$$
DELIMITER ;



SET SQL_SAFE_UPDATES = 0;

-- Insert new lead to test INSERT trigger
-- Insert a new lead with source
INSERT INTO leads (first_name, last_name, email, phone, company_name, source, stage_id, assigned_to)
VALUES ('Audit', 'Test', 'audit@example.com', '7777777777', 'Audit Co', 'Webinar', 1, 1);


-- Update a lead to test UPDATE trigger
UPDATE leads SET phone = '9999999999' WHERE first_name = 'Audit';

-- Delete a lead to test DELETE trigger
DELETE FROM leads WHERE first_name = 'Audit';

-- Check audit log table
SELECT * FROM audit_log ORDER BY change_time DESC;

-- Test trg_customer_insert

INSERT INTO customers (lead_id, contact_name, email, phone, company_name, assigned_to)
VALUES (11, 'Converted Lead', 'converted@example.com', '1112223333', 'Converted Co', 1);
 -- Test trg_customer_update
UPDATE customers
SET phone = '0009998888'
WHERE contact_name = 'Converted Lead';
-- Test trg_task_insert
INSERT INTO tasks (title, description, due_date, status, related_lead_id, assigned_to)
VALUES ('Initial Meeting', 'Setup first discussion', '2025-07-05', 'Pending', 1, 1);
-- Test trg_task_update
UPDATE tasks
SET status = 'Completed'
WHERE title = 'Initial Meeting';


