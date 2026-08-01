-- =========================================================
-- ORDERS TABLE PROFILING
-- =========================================================

-- 1. Total Rows
SELECT COUNT(*) AS total_rows 
FROM OLIST_DW.STAGING.ORDERS;

-- Results = 99441 Rows

-- 2. Distinct Orders
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM OLIST_DW.STAGING.ORDERS;

-- Results = 99441 Distinct Orders

-- 3. Distinct Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM OLIST_DW.STAGING.ORDERS;

-- Results = 99441 Distinct Customers

-- 4. Duplicate Order Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) - COUNT(DISTINCT order_id) AS duplicate_orders
FROM OLIST_DW.STAGING.ORDERS;

-- Results = 0 Duplicate Orders

-- 5. NULL Value Analysis
SELECT
    COUNT_IF(order_id IS NULL) AS null_order_id,
    COUNT_IF(customer_id IS NULL) AS null_customer_id,
    COUNT_IF(order_status IS NULL) AS null_order_status,
    COUNT_IF(order_purchase_timestamp IS NULL) AS null_purchase_timestamp,
    COUNT_IF(order_approved_at IS NULL) AS null_approved_at,
    COUNT_IF(_order_delivered_carrier_date IS NULL) AS null_delivered_carrier_date,
    COUNT_IF(order_delivered_customer_date IS NULL) AS null_delivered_customer_date,
    COUNT_IF(order_estimated_delivery_date IS NULL) AS null_estimated_delivery_date
FROM OLIST_DW.STAGING.ORDERS;

/*
Column Issue:
_ORDER_DELIVERED_CARRIER_DATE

Expected:
Contains carrier handoff dates.

Actual:
100% NULL values after Snowflake import.

Action:
Exclude from current analysis.
Investigate/reload during data cleaning phase if needed.
No other null value is found during innitial screening.
*/

-- 6. Order Status Distribution
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM OLIST_DW.STAGING.ORDERS
GROUP BY order_status
ORDER BY total_orders DESC;

/*
ORDER STATUS FINDINGS RESULTS

Delivered: 96,478 (97.0%)
Shipped: 1,107
Canceled: 625
Unavailable: 609
Invoiced: 314
Processing: 301
Created: 5
Approved: 2

Observations:
- Majority of orders are completed.
- Cancelled and unavailable orders exist and should be handled separately in business analysis.
- In-progress orders may explain missing delivery information.
*/

-- 7. Orders by Year
SELECT
    MIN(TO_TIMESTAMP_NTZ(order_purchase_timestamp)) AS first_order,
    MAX(TO_TIMESTAMP_NTZ(order_purchase_timestamp)) AS last_order
FROM OLIST_DW.STAGING.ORDERS;

SELECT
    YEAR(TO_TIMESTAMP_NTZ(order_purchase_timestamp)) AS order_year,
    COUNT(*) AS total_orders
FROM OLIST_DW.STAGING.ORDERS
GROUP BY order_year
ORDER BY order_year;

/*
YEAR DISTRIBUTION Results

2016 : 329 orders
2017 : 45,101 orders
2018 : 54,011 orders

Observations:
- Dataset covers 2016-2018.
- 2016 appears incomplete.
- Majority of business activity occurred in 2017 and 2018.
*/

-- 8. Orders by Month
SELECT
    DATE_TRUNC(
        'month',
        TO_TIMESTAMP_NTZ(order_purchase_timestamp)
    ) AS order_month,
    COUNT(*) AS total_orders
FROM OLIST_DW.STAGING.ORDERS
GROUP BY order_month
ORDER BY order_month;

/*
MONTHLY TREND FINDINGS

- Dataset starts in Sep 2016.
- 2016 data is incomplete.
- Strong growth throughout 2017.
- Significant spike in Nov 2017 (Black Friday effect).
- Stable order volume during 2018.
- Sep 2018 and Oct 2018 are incomplete months.

Business Rule:
Use Jan 2017 - Aug 2018 for trend analysis.
*/

-- 9. Customer Order Frequency
SELECT
    customer_id,
    COUNT(order_id) AS total_orders
FROM OLIST_DW.STAGING.ORDERS
GROUP BY customer_id
ORDER BY total_orders DESC
LIMIT 20;

-- 10. Delivery Performance Overview
SELECT
    ROUND(AVG(DATEDIFF('day',
                TRY_TO_TIMESTAMP_NTZ(order_purchase_timestamp),
                TRY_TO_TIMESTAMP_NTZ(order_delivered_customer_date)
            )),2) AS avg_delivery_days,

    MIN(DATEDIFF('day',
            TRY_TO_TIMESTAMP_NTZ(order_purchase_timestamp),
            TRY_TO_TIMESTAMP_NTZ(order_delivered_customer_date)
        )) AS min_delivery_days,

    MAX(DATEDIFF('day',
            TRY_TO_TIMESTAMP_NTZ(order_purchase_timestamp),
            TRY_TO_TIMESTAMP_NTZ(order_delivered_customer_date)
        )) AS max_delivery_days
FROM OLIST_DW.STAGING.ORDERS
WHERE TRY_TO_TIMESTAMP_NTZ(order_delivered_customer_date) IS NOT NULL;

/*
DELIVERY PERFORMANCE

Average Delivery Days: 12.50
Minimum Delivery Days: 0
Maximum Delivery Days: 210

Observations:
- Average delivery time appears reasonable.
- Orders with 0-day delivery require validation.
- Extreme outliers exist (up to 210 days).
- Outlier treatment will be evaluated during cleaning phase.
*/

-- 11. Delayed Deliveries
SELECT
    COUNT(*) AS delayed_orders
FROM OLIST_DW.STAGING.ORDERS
WHERE order_delivered_customer_date >
      order_estimated_delivery_date;

-- Results = 7827 Delayed Deliveries 

-- 12. On-Time Deliveries
SELECT
    COUNT(*) AS on_time_orders
FROM OLIST_DW.STAGING.ORDERS
WHERE order_delivered_customer_date <=
      order_estimated_delivery_date;

-- Results = 91614 On-Time Deliveries
      
-- =========================================================
-- CUSTOMER TABLE PROFILING
-- =========================================================

-- 1. Total Rows
SELECT COUNT(*) AS total_rows
FROM OLIST_DW.STAGING.CUSTOMER

-- Result = 99441 Total Rows

-- 2. Unique Customers
SELECT COUNT(DISTINCT customer_id) AS unique_customers
FROM OLIST_DW.STAGING.CUSTOMER;

-- Result = 99441 Uique Customers

-- 3. Duplicate Customer Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT customer_id) AS duplicate_customers
FROM OLIST_DW.STAGING.CUSTOMER;

-- Result = 0 Duplicate Customers

-- 4. Null Analysis
SELECT
    COUNT_IF(customer_id IS NULL) AS null_customer_id,
    COUNT_IF(customer_unique_id IS NULL) AS null_customer_unique_id,
    COUNT_IF(customer_zip_code_prefix IS NULL) AS null_zip_code,
    COUNT_IF(customer_city IS NULL) AS null_city,
    COUNT_IF(customer_state IS NULL) AS null_state
FROM OLIST_DW.STAGING.CUSTOMER;

-- Result = No Null Values 

-- 5. State Distribution
SELECT
    customer_state,
    COUNT(*) AS total_customers
FROM OLIST_DW.STAGING.CUSTOMER
GROUP BY customer_state
ORDER BY total_customers DESC;

/*
STATE DISTRIBUTION FINDINGS

Top State:
SP = 41,746 customers

Top 3 States:
SP = 41,746
RJ = 12,852
MG = 11,635

Observations:
- Customer base heavily concentrated in Southeast Brazil.
- São Paulo dominates customer acquisition.
- Significant geographic imbalance exists.
- Regional analysis should focus on top states.
*/

-- 6. Top 20 Cities
SELECT
    customer_city,
    COUNT(*) AS total_customers
FROM OLIST_DW.STAGING.CUSTOMER
GROUP BY customer_city
ORDER BY total_customers DESC
LIMIT 20;

/*
CITY DISTRIBUTION FINDINGS

Top City:
Sao Paulo = 15,540 customers

Top 5 Cities:
Sao Paulo
Rio de Janeiro
Belo Horizonte
Brasilia
Curitiba

Observations:
- Customer base concentrated in major metropolitan areas.
- Sao Paulo is the dominant market.
- Geographic concentration suggests urban-focused customer acquisition.
*/

-- 7. Customers per State (Percentage)
SELECT
    customer_state,
    COUNT(*) AS customers,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM OLIST_DW.STAGING.CUSTOMER
GROUP BY customer_state
ORDER BY customers DESC;

/*
STATE PERCENTAGE ANALYSIS

SP = 41.98%
RJ = 12.92%
MG = 11.70%

Top 3 States = 66.60% of all customers

Observations:
- Customer base highly concentrated.
- São Paulo dominates the marketplace.
- Geographic distribution is uneven.
- Regional analysis should prioritize top states.
*/

-- 8. Customer Unique ID Analysis
SELECT
    COUNT(DISTINCT customer_id) AS customer_ids,
    COUNT(DISTINCT customer_unique_id) AS customer_unique_ids
FROM OLIST_DW.STAGING.CUSTOMER;

/*
CUSTOMER UNIQUENESS ANALYSIS

Customer IDs = 99,441
Customer Unique IDs = 96,096

Difference = 3,345

Observations:
- Repeat customers exist.
- customer_unique_id should be used for customer-level analysis.
- Dataset supports:
    • CLV Analysis
    • RFM Segmentation
    • Customer Retention Analysis
*/

-- =========================================================
-- ORDER_ITEMS TABLE PROFILING
-- =========================================================

-- 1. Row Count
SELECT COUNT(*) AS total_rows
FROM OLIST_DW.STAGING.ORDER_ITEMS;

-- Results = 112650 Rows 

-- 2. Distinct Orders
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM OLIST_DW.STAGING.ORDER_ITEMS;

-- Results = 98666 Distinct Orders

-- 3. Distinct Products
SELECT COUNT(DISTINCT product_id) AS unique_products
FROM OLIST_DW.STAGING.ORDER_ITEMS;

-- Results = 32951 Distinct Products 

-- 4. Distinct Sellers
SELECT COUNT(DISTINCT seller_id) AS unique_sellers
FROM OLIST_DW.STAGING.ORDER_ITEMS;

-- Results = 3095 Distinct Sellers


-- =========================================================
-- PAYMENTS TABLE PROFILING
-- =========================================================

-- 1. Payment Type Analysis
SELECT COUNT(*) AS total_rows
FROM OLIST_DW.STAGING.PAYMENTS;

SELECT
    payment_type,
    COUNT(*) AS payment_count
FROM OLIST_DW.STAGING.PAYMENTS
GROUP BY payment_type
ORDER BY payment_count DESC;

/*
PAYMENT TYPE ANALYSIS

Credit Card : 76,795
Boleto      : 19,784
Voucher     : 5,775
Debit Card  : 1,529
Not Defined : 3

Observations:
- Credit card is the dominant payment method.
- Boleto is the second most popular method.
- Data quality is excellent with only 3 undefined payments.
*/

-- 2. Avg, Min, Max Payment Value

SELECT
    ROUND(AVG(payment_value), 2) AS avg_payment,
    ROUND(MIN(payment_value), 2) AS min_payment,
    ROUND(MAX(payment_value), 2) AS max_payment
FROM OLIST_DW.STAGING.PAYMENTS;

/*
PAYMENT VALUE ANALYSIS

Average Payment : 154.10
Minimum Payment : 0.00
Maximum Payment : 13,664.08

Observations:
- Average payment value is reasonable.
- Zero-value payments exist and require investigation.
- Significant high-value outliers exist.
- Outlier treatment to be evaluated during cleaning phase.
*/

-- 3. Payment Installments 
SELECT
    payment_installments,
    COUNT(*) AS payments
FROM OLIST_DW.STAGING.PAYMENTS
GROUP BY payment_installments
ORDER BY payment_installments

/*
PAYMENT INSTALLMENT ANALYSIS

Most Common:
1 installment = 52,546
2 installments = 12,413

Observations:
- Single-payment purchases dominate.
- Installment payments are widely used.
- Long financing terms (up to 24 installments) exist.
- Two records have zero installments and require validation.
*/

-- =========================================================
-- REVIEWS TABLE PROFILING
-- =========================================================

-- 1. Total Reviews
SELECT COUNT(*) AS total_reviews
FROM OLIST_DW.STAGING.REVIEWS;

-- RESULTS = 99224 Total Reviews 

-- 2. Review Score Distribution
SELECT
    review_score,
    COUNT(*) AS reviews
FROM OLIST_DW.STAGING.REVIEWS
GROUP BY review_score
ORDER BY review_score;

/*
REVIEW ANALYSIS

5-Star Reviews : 57,328
4-Star Reviews : 19,142
3-Star Reviews : 8,179
2-Star Reviews : 3,151
1-Star Reviews : 11,424

Observations:
- Customer sentiment is generally positive.
- Majority of reviews are 4 or 5 stars.
- Significant volume of negative reviews exists.
- Review analysis can be linked to delivery performance and seller performance.
*/

-- 3. Average Review Score
SELECT
    ROUND(AVG(review_score),2) AS avg_review_score
FROM OLIST_DW.STAGING.REVIEWS;

-- Result = 4.09 Average Review Score

-- 4. Duplicate Review Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id) AS unique_reviews
FROM OLIST_DW.STAGING.REVIEWS;

/*
REVIEW DUPLICATE ANALYSIS

Total Rows    : 99,224
Unique Reviews: 98,410

Difference    : 814

Action:
Investigate review_id duplication before cleaning.
*/

-- Duplicate Review From SAme Profiles Analysis
SELECT
    review_id,
    COUNT(*) AS occurrences
FROM OLIST_DW.STAGING.REVIEWS
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC
LIMIT 20;

/*
REVIEW DUPLICATE INVESTIGATION

814 review_id duplicates detected.

Initial investigation shows duplicate review_ids
occur in small groups (mostly 3 occurrences).

Further validation required before removal.

Status:
UNDER INVESTIGATION
*/

-- =========================================================
-- PRODUCTS TABLE PROFILING
-- =========================================================

-- 1. Total Products
SELECT COUNT(*) AS total_products
FROM OLIST_DW.STAGING.PRODUCTS;

-- Results = 32951 Total Products

-- 2. Unique Products
SELECT COUNT(DISTINCT product_id) AS unique_products
FROM OLIST_DW.STAGING.PRODUCTS;

-- Results = 32951 Unique Products 

-- 3. Duplicate Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_products,
    COUNT(*) - COUNT(DISTINCT product_id) AS duplicate_products
FROM OLIST_DW.STAGING.PRODUCTS;

-- Results = 0 Duplicates Products Entry Found 

-- 4. Null Analysis
SELECT
    COUNT_IF(product_category_name IS NULL) AS null_category,
    COUNT_IF(product_name_lenght IS NULL) AS null_name_length,
    COUNT_IF(product_description_lenght IS NULL) AS null_description_length,
    COUNT_IF(product_photos_qty IS NULL) AS null_photos_qty,
    COUNT_IF(product_weight_g IS NULL) AS null_weight,
    COUNT_IF(product_length_cm IS NULL) AS null_length,
    COUNT_IF(product_height_cm IS NULL) AS null_height,
    COUNT_IF(product_width_cm IS NULL) AS null_width
FROM OLIST_DW.STAGING.PRODUCTS;

/*
PRODUCTS TABLE FINDINGS

Product Category Nulls: 0

Product Metadata Nulls:
- product_name_length: 610
- product_description_length: 610
- product_photos_qty: 610

Physical Attribute Nulls:
- product_weight_g: 2
- product_length_cm: 2
- product_height_cm: 2
- product_width_cm: 2

Observations:
- Product categorization is complete.
- 610 products lack descriptive metadata.
- Physical dimensions have excellent data quality.
*/

-- 5. Top Product Categories
SELECT
    product_category_name,
    COUNT(*) AS products
FROM OLIST_DW.STAGING.PRODUCTS
GROUP BY product_category_name
ORDER BY products DESC
LIMIT 20;

/*
PRODUCT CATEGORY ANALYSIS

Top Categories:
1. cama_mesa_banho
2. esporte_lazer
3. moveis_decoracao
4. beleza_saude
5. utilidades_domesticas

Data Quality Issue:
610 products have missing category information.

Observation:
These same products also appear to be missing
description and photo metadata.

Cleaning Strategy:
Assign category = 'Unknown'
instead of removing records.
*/

-- 6. Product Weight Statistics
SELECT
    ROUND(AVG(product_weight_g),2) AS avg_weight,
    MIN(product_weight_g) AS min_weight,
    MAX(product_weight_g) AS max_weight
FROM OLIST_DW.STAGING.PRODUCTS;

/*
PRODUCT WEIGHT ANALYSIS

Average Weight : 2,276.47 g
Minimum Weight : 0 g
Maximum Weight : 40,425 g

Observations:
- Average product weight appears reasonable.
- Products with 0 weight require investigation.
- Maximum weight is high but plausible.
*/

-- =========================================================
-- SELLERS TABLE PROFILING
-- =========================================================

-- 1. Total Sellers
SELECT COUNT(*) AS total_sellers
FROM OLIST_DW.STAGING.SELLERS;

-- Results = 3095 Total Sellers

-- 2. Unique Sellers
SELECT COUNT(DISTINCT seller_id) AS unique_sellers
FROM OLIST_DW.STAGING.SELLERS;

-- Results = 3095 Unique Sellers

-- 3. Duplicate Check
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_sellers,
    COUNT(*) - COUNT(DISTINCT seller_id) AS duplicate_sellers
FROM OLIST_DW.STAGING.SELLERS;

-- Results = No Duplicates Found 

-- 4. Null Analysis
SELECT
    COUNT_IF(seller_zip_code IS NULL) AS null_zip,
    COUNT_IF(seller_city IS NULL) AS null_city,
    COUNT_IF(seller_state IS NULL) AS null_state
FROM OLIST_DW.STAGING.SELLERS;

-- Result = No Null Value Found 

-- 5. Seller Distribution by State
SELECT
    seller_state,
    COUNT(*) AS sellers
FROM OLIST_DW.STAGING.SELLERS
GROUP BY seller_state
ORDER BY sellers DESC;

/*
SELLER DISTRIBUTION ANALYSIS

Top Seller States:
SP = 1,849
PR = 349
MG = 244
SC = 190
RJ = 171

Observations:
- Nearly 60% of sellers are located in São Paulo.
- Seller base is more concentrated than customer base.
- Geographic concentration may influence delivery performance.
- Long-tail seller distribution exists across Brazil.
*/

-- 6. Top Seller Cities
SELECT
    seller_city,
    COUNT(*) AS sellers
FROM OLIST_DW.STAGING.SELLERS
GROUP BY seller_city
ORDER BY sellers DESC
LIMIT 20;

/*
Top Seller Cities:

1. Sao Paulo        : 694 sellers
2. Curitiba         : 127 sellers
3. Rio de Janeiro   : 96 sellers
4. Belo Horizonte   : 68 sellers
5. Ribeirao Preto   : 52 sellers
6. Guarulhos        : 50 sellers
7. Ibitinga         : 49 sellers
8. Santo Andre      : 45 sellers
9. Campinas         : 41 sellers
10. Maringa         : 40 sellers

Key Findings:

• Sao Paulo is the dominant seller hub with 694 sellers.
• Seller concentration is heavily skewed toward major
  metropolitan and economic centers.
• Top seller cities align closely with top customer cities,
  suggesting strong regional demand-supply matching.
• Major logistics hubs such as Sao Paulo, Curitiba,
  Rio de Janeiro, and Belo Horizonte host a significant
  portion of marketplace sellers.
• Geographic seller concentration may influence
  delivery speed, product availability, and revenue.

Business Implications:

• Analyze whether seller-rich cities generate
  higher revenue.
• Evaluate the impact of seller location on
  delivery performance.
• Investigate regional seller concentration and
  market penetration opportunities.
*/
