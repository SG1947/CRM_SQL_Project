-- 02_insert_sample_data.sql

USE crm_system;

-- Insert roles
INSERT INTO roles (role_name) VALUES
('Sales Rep'), ('Manager'), ('Admin');

-- Insert users
INSERT INTO users (username, password_hash, email, role_id) VALUES
('alice', 'hashed_pass1', 'alice@example.com', 1),
('bob', 'hashed_pass2', 'bob@example.com', 1),
('carol', 'hashed_pass3', 'carol@example.com', 2),
('dave', 'hashed_pass4', 'dave@example.com', 1),
('eve', 'hashed_pass5', 'eve@example.com', 1),
('frank', 'hashed_pass6', 'frank@example.com', 2),
('grace', 'hashed_pass7', 'grace@example.com', 1),
('heidi', 'hashed_pass8', 'heidi@example.com', 1),
('ivan', 'hashed_pass9', 'ivan@example.com', 3),
('judy', 'hashed_pass10', 'judy@example.com', 1);

-- Insert lead sources
INSERT INTO lead_sources (source_name) VALUES
('Website'), ('Referral'), ('Trade Show'), ('LinkedIn'),
('Facebook Ads'), ('Cold Call'), ('Google Ads'), 
('Inbound Email'), ('Partner Program'), ('Newsletter');

-- Insert sales stages
INSERT INTO sales_stages (stage_name, stage_order) VALUES
('New', 1), ('Contacted', 2), ('Qualified', 3),
('Proposal Sent', 4), ('Negotiation', 5),
('Won', 6), ('Lost', 7);

-- Insert leads
INSERT INTO leads (first_name, last_name, email, phone, company_name, source_id, stage_id, assigned_to) VALUES
('Tom', 'Brown', 'tom.brown@example.com', '1234567890', 'Brown Ltd', 1, 1, 1),
('Linda', 'Smith', 'linda.smith@example.com', '2234567890', 'Smith Inc', 2, 2, 2),
('John', 'Doe', 'john.doe@example.com', '3234567890', 'Doe Corp', 3, 3, 3),
('Jane', 'Wilson', 'jane.w@example.com', '4234567890', 'Wilson LLC', 4, 4, 4),
('Mike', 'Lee', 'mike.lee@example.com', '5234567890', 'Lee Co', 5, 1, 5),
('Sara', 'Kim', 'sara.kim@example.com', '6234567890', 'Kim & Partners', 6, 2, 6),
('Anna', 'Zhou', 'anna.zhou@example.com', '7234567890', 'Zhou Ventures', 7, 3, 7),
('Robert', 'King', 'robert.king@example.com', '8234567890', 'King Inc', 8, 4, 8),
('Emily', 'Clark', 'emily.clark@example.com', '9234567890', 'Clark LLC', 9, 5, 9),
('Nathan', 'Hall', 'nathan.hall@example.com', '1034567890', 'Hall Agency', 10, 1, 10);
UPDATE leads SET source = 'Website' WHERE lead_id = 1;
UPDATE leads SET source = 'Referral' WHERE lead_id = 2;
UPDATE leads SET source = 'LinkedIn' WHERE lead_id = 3;
UPDATE leads SET source = 'Email Campaign' WHERE lead_id = 4;
UPDATE leads SET source = 'Phone Call' WHERE lead_id = 5;
UPDATE leads SET source = 'Facebook Ad' WHERE lead_id = 6;
UPDATE leads SET source = 'Event' WHERE lead_id = 7;
UPDATE leads SET source = 'Google Ads' WHERE lead_id = 8;
UPDATE leads SET source = 'Walk-in' WHERE lead_id = 9;
UPDATE leads SET source = 'Instagram' WHERE lead_id = 10;

-- Insert customers (converted from leads)
INSERT INTO customers (lead_id, company_name, contact_name, email, phone, assigned_to) VALUES
(3, 'Doe Corp', 'John Doe', 'john.doe@example.com', '3234567890', 3),
(4, 'Wilson LLC', 'Jane Wilson', 'jane.w@example.com', '4234567890', 4),
(7, 'Zhou Ventures', 'Anna Zhou', 'anna.zhou@example.com', '7234567890', 7),
(8, 'King Inc', 'Robert King', 'robert.king@example.com', '8234567890', 8),
(9, 'Clark LLC', 'Emily Clark', 'emily.clark@example.com', '9234567890', 9),
(10, 'Hall Agency', 'Nathan Hall', 'nathan.hall@example.com', '1034567890', 10),
(2, 'Smith Inc', 'Linda Smith', 'linda.smith@example.com', '2234567890', 2),
(1, 'Brown Ltd', 'Tom Brown', 'tom.brown@example.com', '1234567890', 1),
(5, 'Lee Co', 'Mike Lee', 'mike.lee@example.com', '5234567890', 5),
(6, 'Kim & Partners', 'Sara Kim', 'sara.kim@example.com', '6234567890', 6);

-- Insert tasks
INSERT INTO tasks (title, description, due_date, status, related_lead_id, related_customer_id, assigned_to) VALUES
('Follow up with Tom', 'Email Tom about our proposal', '2025-06-25', 'Pending', 1, NULL, 1),
('Call Linda', 'Discuss feature requests', '2025-06-26', 'In Progress', 2, NULL, 2),
('Schedule meeting with John', 'Quarterly review', '2025-06-28', 'Pending', NULL, 1, 3),
('Send contract to Jane', 'Draft and send agreement', '2025-06-27', 'Completed', NULL, 2, 4),
('Call Mike', 'Re-engage Mike on opportunity', '2025-06-30', 'Pending', 5, NULL, 5),
('Prepare pitch for Sara', 'Customize pitch deck', '2025-06-29', 'Pending', 6, NULL, 6),
('Email Anna', 'Send product pricing', '2025-06-26', 'Pending', NULL, 3, 7),
('Meeting with Robert', 'Negotiate final price', '2025-06-25', 'In Progress', NULL, 4, 8),
('Follow up with Emily', 'Request feedback', '2025-06-30', 'Pending', NULL, 5, 9),
('Onboard Nathan', 'Send welcome package', '2025-07-01', 'Pending', NULL, 6, 10);

-- Insert communications
INSERT INTO communications (comm_type, comm_date, summary, related_lead_id, related_customer_id, user_id) VALUES
('Call', '2025-06-20 10:00:00', 'Initial contact with Tom', 1, NULL, 1),
('Email', '2025-06-21 11:30:00', 'Sent brochure to Linda', 2, NULL, 2),
('Meeting', '2025-06-22 14:00:00', 'Project kickoff with John', NULL, 1, 3),
('Call', '2025-06-22 16:00:00', 'Jane confirmed requirements', NULL, 2, 4),
('Email', '2025-06-23 09:00:00', 'Mike requested new quote', 5, NULL, 5),
('Call', '2025-06-23 15:00:00', 'Discussed timeline with Sara', 6, NULL, 6),
('Email', '2025-06-24 10:00:00', 'Pricing email to Anna', NULL, 3, 7),
('Meeting', '2025-06-24 13:00:00', 'Negotiation with Robert', NULL, 4, 8),
('Email', '2025-06-24 16:00:00', 'Follow-up with Emily', NULL, 5, 9),
('Call', '2025-06-25 09:30:00', 'Welcome call with Nathan', NULL, 6, 10);

-- Insert notes
INSERT INTO notes (note_text, related_lead_id, related_customer_id, related_task_id, created_by) VALUES
('Tom is interested in premium plan.', 1, NULL, 1, 1),
('Linda asked for testimonials.', 2, NULL, 2, 2),
('John signed the NDA.', NULL, 1, 3, 3),
('Jane prefers Zoom meetings.', NULL, 2, 4, 4),
('Mike responded positively.', 5, NULL, 5, 5),
('Sara needs more time.', 6, NULL, 6, 6),
('Anna liked our product.', NULL, 3, 7, 7),
('Robert wants faster delivery.', NULL, 4, 8, 8),
('Emily mentioned competitors.', NULL, 5, 9, 9),
('Nathan appreciated our support.', NULL, 6, 10, 10);

-- Insert attachments
INSERT INTO attachments (file_name, file_url, related_lead_id, related_customer_id, related_task_id, uploaded_by) VALUES
('proposal_tom.pdf', 'http://files.crm/proposal_tom.pdf', 1, NULL, 1, 1),
('testimonials.pdf', 'http://files.crm/testimonials.pdf', 2, NULL, 2, 2),
('nda_signed.pdf', 'http://files.crm/nda_signed.pdf', NULL, 1, 3, 3),
('agreement_jane.pdf', 'http://files.crm/agreement_jane.pdf', NULL, 2, 4, 4),
('quote_mike.pdf', 'http://files.crm/quote_mike.pdf', 5, NULL, 5, 5),
('pitch_sara.pptx', 'http://files.crm/pitch_sara.pptx', 6, NULL, 6, 6),
('pricing_anna.pdf', 'http://files.crm/pricing_anna.pdf', NULL, 3, 7, 7),
('negotiation_notes_robert.docx', 'http://files.crm/notes_robert.docx', NULL, 4, 8, 8),
('competitor_analysis.pdf', 'http://files.crm/competitors.pdf', NULL, 5, 9, 9),
('onboarding_kit_nathan.zip', 'http://files.crm/onboarding_nathan.zip', NULL, 6, 10, 10);
