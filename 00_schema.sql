CREATE DATABASE IF NOT EXISTS cardcredit;
USE cardcredit;

DROP TABLE IF EXISTS cc_transaction;

CREATE TABLE cc_transaction (
    transaction_id VARCHAR(20) PRIMARY KEY,
    customer_id VARCHAR(20),
    transaction_date DATE,
    transaction_amount DECIMAL(12,2),
    merchant_name VARCHAR(100),
    category VARCHAR(50),
    card_type VARCHAR(20),
    city VARCHAR(50),
    gender CHAR(1),
    birth_date DATE,
    transaction_status VARCHAR(20),
    decline_reason VARCHAR(100)
);

-- Load the canonical CSV after creating the table.
-- MySQL Workbench may require LOCAL INFILE to be enabled on the client/server.
-- Alternatively, use data/credit_card_dataset_full.sql, which contains the full INSERT statements.
