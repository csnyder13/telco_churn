/* CREATE VIEW: The original dataset has naming conventions that are inconsistent with SQL standards (CamelCase instead of snake_case).
If this was a real-world database, renaming the columns could break existing applications that retreive data from this table,
so using a view to rename is safer. */

CREATE VIEW telco_churn_corrected AS
SELECT
	customerID AS customer_id,
	gender,
    SeniorCitizen AS senior_citizen,
    Partner AS partner,
    Dependents AS dependents,
    tenure,
    PhoneService AS phone_service,
    MultipleLines AS multiple_lines,
    InternetService AS internet_service,
    OnlineSecurity AS online_security,
    OnlineBackup AS online_backup,
    DeviceProtection AS device_protection,
    TechSupport AS tech_support,
    StreamingTV AS streaming_tv,
    StreamingMovies AS streaming_movies,
    Contract AS contract,
    PaperlessBilling AS paperless_billing,
    PaymentMethod AS payment_method,
    MonthlyCharges AS monthly_charges,
    TotalCharges AS total_charges,
    Churn AS churn
FROM telco_churn_analysis;

/* DATA QUALITY: Validating internet_service column values
Checking for unexpected values, typos, or inconsistent formatting */
SELECT DISTINCT internet_service 
FROM telco_churn_corrected;

-- DATA VALIDATION: Making sure the data from the created view matches the data in the original table.

SELECT COUNT(*) FROM telco_churn_analysis;
SELECT COUNT(*) FROM telco_churn_corrected;

DESCRIBE telco_churn_analysis;
DESCRIBE telco_churn_corrected;

SELECT * FROM telco_churn_analysis LIMIT 10;
SELECT * FROM telco_churn_corrected LIMIT 10;

SELECT customerID, MonthlyCharges, Churn FROM telco_churn_analysis ORDER BY customerID LIMIT 10;
SELECT customer_id, monthly_charges, churn FROM telco_churn_corrected ORDER BY customer_id LIMIT 10;

SELECT COUNT(*), AVG(MonthlyCharges), SUM(tenure) FROM telco_churn_analysis;
SELECT COUNT(*), AVG(monthly_charges), SUM(tenure) FROM telco_churn_corrected;

-- Checking for NULLs: done in one query to reduce the number of communications with the database

SELECT *
FROM telco_churn_corrected
WHERE COALESCE(
	customer_id,
	gender,
    senior_citizen,
    partner,
    dependents,
    tenure,
    phone_service,
    multiple_lines,
    internet_service,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies,
    contract,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges,
    churn) IS NULL;

/* CHURN RATE: This is the overall percentage of customers in this dataset who churned.
It will be the benchmark against which other churn rate comparisons will be made
(e.g., do customers who paid for 5 or more services churn at a higher rate?). */

SELECT SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate_pct
FROM telco_churn_corrected;


/* DESCRIPTIVE STATISTICS: DATA PROFILING
Purpose: Understand the basic characteristics of the dataset
This provides the foundation for deeper churn analysis */

SELECT 
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS unique_customers, 
    ROUND(AVG(tenure), 1) AS avg_tenure_months,
    MIN(tenure) AS min_tenure_months, 
    MAX(tenure) AS max_tenure_months,
	ROUND(AVG(monthly_charges), 2) AS avg_monthly_charges,
    MIN(monthly_charges) AS min_monthly_charges, 
    MAX(monthly_charges) AS max_monthly_charges,
    ROUND(AVG(total_charges), 2) AS avg_total_charges,
    MIN(total_charges) AS min_total_charges, 
    MAX(total_charges) AS max_total_charges
FROM telco_churn_corrected;

/* HYPOTHESIS: customers who paid for 5 or more services and who have a tenure of less than the average of 32 months
have a higher churn rate*/

SELECT 
    total_services,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate_high_svc
FROM (
    SELECT 
        (CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN internet_service IN ('DSL', 'Fiber optic') THEN 1 ELSE 0 END +
         CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS total_services,
        churn,
        tenure
    FROM telco_churn_corrected
) AS service_counts
WHERE tenure < 32 AND total_services >= 5
GROUP BY total_services;

/* COMPARISON ANALYSIS: Churn rates for customers with fewer than 5 services
Testing whether tenure impacts churn differently for low-service customers */

SELECT 
    total_services,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate_low_svc
FROM (
    SELECT 
        (CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN internet_service IN ('DSL', 'Fiber optic') THEN 1 ELSE 0 END +
         CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS total_services,
        churn,
        tenure
    FROM telco_churn_corrected
) AS service_counts
WHERE tenure < 32 AND total_services < 5
GROUP BY total_services;

/* BROADER ANALYSIS: Churn rates for all customers with fewer than 5 services
Removing tenure filter to see overall pattern for low-service customers */

SELECT 
    total_services,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate_low_svc
FROM (
    SELECT 
        (CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN internet_service IN ('DSL', 'Fiber optic') THEN 1 ELSE 0 END +
         CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS total_services,
        churn,
        tenure
    FROM telco_churn_corrected
) AS service_counts
WHERE total_services < 5
GROUP BY total_services;

/* COMPARATIVE BASELINE: Churn rates for customers with 5+ services
Testing whether high-service customers have different churn patterns regardless of tenure */

SELECT 
    total_services,
    SUM(CASE WHEN churn = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100 AS churn_rate_high_svc
FROM (
    SELECT 
        (CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN internet_service IN ('DSL', 'Fiber optic') THEN 1 ELSE 0 END +
         CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS total_services,
        churn,
        tenure
    FROM telco_churn_corrected
) AS service_counts
WHERE total_services >= 5
GROUP BY total_services;

SELECT
    total_services,
    ROUND(AVG(tenure), 1) AS avg_tenure,
    ROUND(AVG(monthly_charges), 2) AS avg_monthly_rate,
    ROUND(AVG(monthly_charges * tenure), 2) AS avg_total_revenue,
    ROUND(AVG(total_charges), 2) AS avg_total_charges_dataset
FROM (
    SELECT 
        (CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN multiple_lines = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN internet_service IN ('DSL', 'Fiber optic') THEN 1 ELSE 0 END +
         CASE WHEN online_security = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN online_backup = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN device_protection = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_tv = 'Yes' THEN 1 ELSE 0 END +
         CASE WHEN streaming_movies = 'Yes' THEN 1 ELSE 0 END) AS total_services,
         tenure,
         monthly_charges,
         total_charges
    FROM telco_churn_corrected
) AS service_counts
GROUP BY total_services
ORDER BY total_services;
