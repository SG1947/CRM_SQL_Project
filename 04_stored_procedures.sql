-- 04_stored_procedures.sql

USE crm_system;

-- Procedure: Convert a lead to a customer
DELIMITER $$

CREATE PROCEDURE sp_convert_lead_to_customer(IN p_lead_id INT, IN p_user_id INT)
BEGIN
    DECLARE v_exists INT;

    -- Check if customer already exists
    SELECT COUNT(*) INTO v_exists
    FROM customers
    WHERE lead_id = p_lead_id;

    IF v_exists > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'This lead has already been converted to a customer.';
    END IF;

    -- Insert into customers from lead
    INSERT INTO customers (lead_id, company_name, contact_name, email, phone, assigned_to)
    SELECT
        l.lead_id,
        l.company_name,
        CONCAT(l.first_name, ' ', l.last_name),
        l.email,
        l.phone,
        p_user_id
    FROM leads l
    WHERE l.lead_id = p_lead_id;
    
    -- Optionally update lead stage to "Won"
    UPDATE leads
    SET stage_id = (
        SELECT stage_id FROM sales_stages WHERE stage_name = 'Won' LIMIT 1
    )
    WHERE lead_id = p_lead_id;
END $$

DELIMITER ;

-- Procedure: Assign a task to a user for a lead or customer
DELIMITER $$

CREATE PROCEDURE sp_create_task (
    IN p_title VARCHAR(255),
    IN p_description TEXT,
    IN p_due_date DATE,
    IN p_status ENUM('Pending', 'In Progress', 'Completed'),
    IN p_related_lead_id INT,
    IN p_related_customer_id INT,
    IN p_assigned_to INT
)
BEGIN
    INSERT INTO tasks (title, description, due_date, status, related_lead_id, related_customer_id, assigned_to)
    VALUES (p_title, p_description, p_due_date, p_status, p_related_lead_id, p_related_customer_id, p_assigned_to);
END $$

DELIMITER ;



-- Convert lead with ID 2 and assign the customer to user ID 1
CALL sp_convert_lead_to_customer(2, 1);

-- Now re-check lead conversion status
SELECT * FROM view_lead_conversion_status WHERE lead_id = 2;



-- Assign a task to user 2 for lead 3
CALL sp_create_task(
    'Schedule follow-up call',
    'Lead seems interested, book a meeting',
    '2025-07-01',
    'Pending',
    3,
    NULL,
    2
);

-- Confirm the task has been created
SELECT * FROM tasks WHERE related_lead_id = 3;

