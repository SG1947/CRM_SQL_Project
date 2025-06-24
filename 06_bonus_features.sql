-- 06_bonus_features.sql

USE crm_system;

-- Tags table
CREATE TABLE tags (
    tag_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Mapping tags to leads
CREATE TABLE lead_tags (
    lead_id INT,
    tag_id INT,
    PRIMARY KEY (lead_id, tag_id),
    FOREIGN KEY (lead_id) REFERENCES leads(lead_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- Mapping tags to customers
CREATE TABLE customer_tags (
    customer_id INT,
    tag_id INT,
    PRIMARY KEY (customer_id, tag_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id) REFERENCES tags(tag_id) ON DELETE CASCADE
);

-- Sample Tags
INSERT INTO tags (name) VALUES
('High Priority'),
('Enterprise'),
('Startup'),
('Cold'),
('Hot Lead'),
('International');

-- Assign 2 tags to lead_id = 1
INSERT INTO lead_tags (lead_id, tag_id) VALUES
(1, 1), -- High Priority
(1, 5); -- Hot Lead

-- Assign 1 tag to lead_id = 2
INSERT INTO lead_tags (lead_id, tag_id) VALUES
(2, 3); -- Startup

-- Assign 2 tags to customer_id = 1
INSERT INTO customer_tags (customer_id, tag_id) VALUES
(1, 2), -- Enterprise
(1, 6); -- International


-- Teams
CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

-- Users in Teams
CREATE TABLE user_teams (
    user_id INT,
    team_id INT,
    PRIMARY KEY (user_id, team_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE CASCADE
);

-- Assign leads/customers to teams
ALTER TABLE leads ADD COLUMN team_id INT;
ALTER TABLE customers ADD COLUMN team_id INT;

ALTER TABLE leads ADD FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE SET NULL;
ALTER TABLE customers ADD FOREIGN KEY (team_id) REFERENCES teams(team_id) ON DELETE SET NULL;

-- Sample Teams
INSERT INTO teams (name) VALUES
('North America Sales'),
('Europe Sales'),
('Enterprise Accounts');

-- Assign some users to teams
INSERT INTO user_teams (user_id, team_id) VALUES
(1, 1),
(2, 2),
(3, 1),
(4, 3),
(5, 3);

SELECT * FROM teams;
SELECT * FROM user_teams;
-- View: Tags per lead
CREATE OR REPLACE VIEW view_lead_tags AS
SELECT
    l.lead_id,
    CONCAT(l.first_name, ' ', l.last_name) AS lead_name,
    GROUP_CONCAT(t.name) AS tags
FROM leads l
LEFT JOIN lead_tags lt ON l.lead_id = lt.lead_id
LEFT JOIN tags t ON lt.tag_id = t.tag_id
GROUP BY l.lead_id;

-- View: Team sales pipeline
CREATE OR REPLACE VIEW view_team_pipeline AS
SELECT
    t.name AS team_name,
    ss.stage_name,
    COUNT(l.lead_id) AS leads_in_stage
FROM leads l
JOIN teams t ON l.team_id = t.team_id
JOIN sales_stages ss ON l.stage_id = ss.stage_id
GROUP BY t.name, ss.stage_name
ORDER BY t.name, ss.stage_order;

SELECT * FROM view_lead_tags;

UPDATE leads SET team_id = 1 WHERE lead_id IN (1, 2);
UPDATE leads SET team_id = 2 WHERE lead_id = 3;

UPDATE customers SET team_id = 1 WHERE customer_id = 1;
UPDATE customers SET team_id = 3 WHERE customer_id = 2;

SELECT * FROM view_team_pipeline;



