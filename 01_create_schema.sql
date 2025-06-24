-- 01_create_schema.sql

-- Create the CRM database
CREATE DATABASE IF NOT EXISTS crm_system;
USE crm_system;

-- Roles table
CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE -- e.g., Sales Rep, Manager
);

-- Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL, -- store hashed passwords
    email VARCHAR(100) NOT NULL UNIQUE,
    role_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
);

-- Lead sources lookup table
CREATE TABLE lead_sources (
    source_id INT AUTO_INCREMENT PRIMARY KEY,
    source_name VARCHAR(100) NOT NULL UNIQUE -- e.g., Website, Referral
);

-- Sales funnel stages
CREATE TABLE sales_stages (
    stage_id INT AUTO_INCREMENT PRIMARY KEY,
    stage_name VARCHAR(50) NOT NULL UNIQUE, -- New, Contacted, etc.
    stage_order INT NOT NULL -- used to define the order of stages
);

-- Leads table
CREATE TABLE leads (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    company_name VARCHAR(100),
    source_id INT,
    stage_id INT,
    assigned_to INT, -- user_id
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (source_id) REFERENCES lead_sources(source_id),
    FOREIGN KEY (stage_id) REFERENCES sales_stages(stage_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);
ALTER TABLE leads
ADD COLUMN source VARCHAR(100);

-- Customers table
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_id INT UNIQUE, -- the original lead (if converted)
    company_name VARCHAR(100),
    contact_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    assigned_to INT, -- user_id
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- Tasks table
CREATE TABLE tasks (
    task_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    due_date DATE,
    status ENUM('Pending', 'In Progress', 'Completed', 'Overdue') DEFAULT 'Pending',
    related_lead_id INT,
    related_customer_id INT,
    assigned_to INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (related_lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (related_customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (assigned_to) REFERENCES users(user_id)
);

-- Communication logs
CREATE TABLE communications (
    comm_id INT AUTO_INCREMENT PRIMARY KEY,
    comm_type ENUM('Call', 'Email', 'Meeting', 'Other') NOT NULL,
    comm_date DATETIME NOT NULL,
    summary TEXT,
    related_lead_id INT,
    related_customer_id INT,
    user_id INT NOT NULL,
    FOREIGN KEY (related_lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (related_customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Notes table
CREATE TABLE notes (
    note_id INT AUTO_INCREMENT PRIMARY KEY,
    note_text TEXT NOT NULL,
    related_lead_id INT,
    related_customer_id INT,
    related_task_id INT,
    created_by INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (related_lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (related_customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (related_task_id) REFERENCES tasks(task_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id)
);

-- Attachments table (file paths or cloud links)
CREATE TABLE attachments (
    attachment_id INT AUTO_INCREMENT PRIMARY KEY,
    file_name VARCHAR(255),
    file_url VARCHAR(500),
    related_lead_id INT,
    related_customer_id INT,
    related_task_id INT,
    uploaded_by INT,
    uploaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (related_lead_id) REFERENCES leads(lead_id),
    FOREIGN KEY (related_customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (related_task_id) REFERENCES tasks(task_id),
    FOREIGN KEY (uploaded_by) REFERENCES users(user_id)
);

-- Audit trail table
CREATE TABLE audit_trail (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id INT NOT NULL,
    action ENUM('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    changed_by INT,
    change_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    change_description TEXT,
    FOREIGN KEY (changed_by) REFERENCES users(user_id)
);

