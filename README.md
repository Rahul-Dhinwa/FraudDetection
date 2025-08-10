SQL Fraud Analysis Project
This repository contains a simple yet effective SQL script for a fraud detection system. The project was created to demonstrate my proficiency in database design, data manipulation (DML), and writing complex queries to identify suspicious patterns in transaction data.

Key Features
Database Schema Creation: Establishes a relational database with three interconnected tables: Customers, Cards, and Transactions.

Sample Data Population: Inserts a mix of normal and pre-defined fraudulent transactions to simulate real-world data.

Fraud Detection Logic: Employs a series of custom SQL queries to detect common fraud anomalies, including:

High-value transactions over a specific threshold.

Geographic anomalies (transactions in different countries within a short time frame).

Transactions occurring at unusual hours.

Rapid-fire transactions from a single card.

Status Updates: The script concludes by using UPDATE statements to flag all identified fraudulent transactions for review.

Technologies Used
SQL (MySQL): For database creation, data manipulation, and query execution.

How to Run the Project
Open a MySQL client (e.g., MySQL Workbench, DBeaver, or the command line).

Copy the entire contents of the SQL script from this repository.

Paste the script into your MySQL client and execute it.

The script will automatically create the database, insert the sample data, and run the queries, producing a final table showing all the transactions that have been flagged as fraudulent.

Summary of Results
The script successfully identifies and flags transactions that meet the criteria for fraudulent activity, as demonstrated by the final SELECT query. This project serves as a foundational example of how SQL can be used for data analysis and proactive security measures.
