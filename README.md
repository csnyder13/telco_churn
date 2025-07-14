# telco_churn

I analyzed the [IBM Telco Customer Churn dataset](https://www.kaggle.com/datasets/blastchar/telco-customer-churn), a widely-used sample dataset from IBM Cognos Analytics that tracks customer churn patterns for a fictional telecommunications company. The dataset serves as an excellent foundation for analyzing customer retention patterns and identifying factors that influence customer churn in the telecommunications industry. My analysis focused on understanding the relationship between service usage patterns, customer tenure, and churn rates to uncover actionable insights for customer retention strategies.

## Executive Summary

**Service Adoption Paradox**: Customers with 3 services face the highest churn risk (42.50%) and shortest tenure (17.3 months), creating a critical "danger zone" that must be navigated to reach high-value segments.

**Early Tenure Vulnerability**: All customer segments experience 25-45% higher churn rates in their first 32 months, with high-service customers (5+) showing extreme early vulnerability (45-50% churn) before becoming virtually churn-proof.

**Strategic Imperative**: Success requires bypassing the 3-service tier through accelerated progression and providing intensive early-tenure support, as 8-service customers generate 13.7x more revenue but only after surviving the initial high-risk period.

(Note: this README is a work in progress and will be updated as soon as I can with all the details.)

## Business Problem


## Dataset Overview

The dataset contains 7,043 customer records with 21 features covering:

**Customer Demographics:**
- Customer ID, gender, senior citizen status
- Partner and dependent information

**Service Information:**
- Phone service and multiple lines
- Internet service type (DSL, Fiber optic, or None)
- Add-on services: online security, online backup, device protection, tech support
- Entertainment services: streaming TV and movies

**Account Information:**
- Contract type (month-to-month, one year, two year)
- Payment method and paperless billing preferences
- Monthly charges and total charges
- Tenure (months as customer)

**Target Variable:**
- Churn: Whether the customer left the company within the last month (Yes/No)

## Key Findings

## Methodology



## Technical Skills Demonstrated

### Data Validation & Quality Assurance
- **Multi-layered validation approach**: Systematic comparison between original table and view using row counts, structure verification, sample data checks, and aggregate comparisons
- **Comprehensive NULL detection**: Single-query approach using COALESCE to check all columns simultaneously
- **Data profiling**: Statistical analysis using COUNT, AVG, MIN, MAX functions to understand dataset characteristics

### Advanced SQL Functions & Expressions
- **Complex conditional logic**: Multi-level CASE statements for data transformation and business rule implementation
- **Mathematical calculations**: Percentage calculations, multiplication operations, and statistical computations
- **Data presentation**: ROUND function for clean numeric output and professional reporting

### Analytical Query Design
- **Hypothesis-driven analysis**: Structured approach to testing business hypotheses with comparative queries
- **Dynamic calculations**: Additive CASE expressions to count services across multiple boolean columns
- **Segmentation analysis**: Customer grouping and filtering with complex WHERE conditions

### Performance Optimization
- **Query efficiency**: Single-query solutions to minimize database communications (e.g., consolidated NULL checking)
- **Derived tables**: Strategic use of subqueries to avoid repetitive calculations across multiple analyses
- **Safe schema modifications**: VIEW implementation to handle naming conventions without breaking existing applications

### Business Logic Implementation
- **Service definition logic**: Translation of business rules into SQL expressions (defining what constitutes a "service")
- **Comparative frameworks**: Building reusable analytical patterns for different customer segments
- **Churn rate analysis**: Implementation of percentage-based metrics for customer retention insights

## Business Recommendations
