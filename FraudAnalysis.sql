-- Create a new database for transaction monitoring
CREATE DATABASE IF NOT EXISTS transaction_monitoring;

-- Use the new database
USE transaction_monitoring;

-- Drop tables if they exist
DROP TABLE IF EXISTS purchase_history;
DROP TABLE IF EXISTS payment_methods;
DROP TABLE IF EXISTS account_holders;

-- Table to store customer account information
CREATE TABLE account_holders (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email_address VARCHAR(100) UNIQUE NOT NULL,
    join_date DATE NOT NULL
);

-- Table to store card details associated with accounts
CREATE TABLE payment_methods (
    card_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT NOT NULL,
    card_number_hash VARCHAR(64) UNIQUE NOT NULL, -- Storing a hash for security
    card_type_enum ENUM('Credit', 'Debit') NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    FOREIGN KEY (account_id) REFERENCES account_holders(account_id)
);

-- Table to log all purchase transactions
CREATE TABLE purchase_history (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    card_id INT NOT NULL,
    purchase_amount DECIMAL(10, 2) NOT NULL,
    purchase_location VARCHAR(100),
    purchase_timestamp DATETIME NOT NULL,
    vendor_name VARCHAR(100),
    is_flagged_for_review BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (card_id) REFERENCES payment_methods(card_id)
);

-- Populate with new sample data
INSERT INTO account_holders (first_name, last_name, email_address, join_date) VALUES
('Alex', 'Miller', 'alex.miller@example.com', '2024-05-12'),
('Brenda', 'Chen', 'brenda.chen@example.com', '2024-06-25');

INSERT INTO payment_methods (account_id, card_number_hash, card_type_enum) VALUES
(1, SHA2('hash1234', 256), 'Credit'),
(2, SHA2('hash5678', 256), 'Debit');

INSERT INTO purchase_history (card_id, purchase_amount, purchase_location, purchase_timestamp, vendor_name) VALUES
-- Normal purchases
(1, 45.00, 'San Francisco, USA', '2025-08-10 09:00:00', 'Cafe Java'),
(2, 75.50, 'Chicago, USA', '2025-08-10 11:30:00', 'Grocery Mart'),
-- High-value anomaly
(1, 15000.00, 'Paris, France', '2025-08-10 13:00:00', 'Luxury Goods Store'),
-- Unusual time anomaly
(2, 4500.00, 'Chicago, USA', '2025-08-10 02:00:00', 'Online Retailer'),
-- Geographic anomaly
(1, 60.00, 'Paris, France', '2025-08-10 13:01:00', 'Souvenir Stand');


-- Flag transactions for review based on new query logic

-- Query to find unusual high-value purchases
UPDATE purchase_history
SET is_flagged_for_review = TRUE
WHERE purchase_amount > 10000;

-- Query to find geographic anomalies
UPDATE purchase_history AS t1
JOIN purchase_history AS t2
    ON t1.card_id = t2.card_id
    AND t1.record_id < t2.record_id
SET t1.is_flagged_for_review = TRUE
WHERE
    t2.purchase_timestamp <= t1.purchase_timestamp + INTERVAL 5 MINUTE
    AND t1.purchase_location <> t2.purchase_location;
  
-- Query to find high-value purchases at unusual hours (2 AM - 4 AM)
UPDATE purchase_history
SET is_flagged_for_review = TRUE
WHERE purchase_amount > 2000
  AND TIME(purchase_timestamp) BETWEEN '02:00:00' AND '04:00:00';

-- Final verification query
SELECT * FROM purchase_history WHERE is_flagged_for_review = TRUE;