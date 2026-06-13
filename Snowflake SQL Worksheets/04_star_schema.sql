-- =========================================================
-- DIM CUSTOMERS
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.DIM_CUSTOMERS AS
SELECT
    CUSTOMER_ID,
    CUSTOMER_UNIQUE_ID,
    CUSTOMER_CITY,
    CUSTOMER_STATE
FROM OLIST_DW.MART.CLEAN_CUSTOMERS;


-- =========================================================
-- DIM PRODUCTS
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.DIM_PRODUCTS AS
SELECT
    PRODUCT_ID,
    PRODUCT_CATEGORY_NAME,
    PRODUCT_WEIGHT_G,
    PRODUCT_LENGTH_CM,
    PRODUCT_HEIGHT_CM,
    PRODUCT_WIDTH_CM
FROM OLIST_DW.MART.CLEAN_PRODUCTS;


-- =========================================================
-- DIM SELLERS
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.DIM_SELLERS AS
SELECT
    SELLER_ID,
    SELLER_CITY,
    SELLER_STATE
FROM OLIST_DW.MART.CLEAN_SELLERS;


-- =========================================================
-- DIM DATE
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.DIM_DATE AS
SELECT DISTINCT
    CAST(ORDER_PURCHASE_TIMESTAMP AS DATE) AS DATE_KEY,

    YEAR(ORDER_PURCHASE_TIMESTAMP) AS YEAR,

    QUARTER(ORDER_PURCHASE_TIMESTAMP) AS QUARTER,

    MONTH(ORDER_PURCHASE_TIMESTAMP) AS MONTH,

    MONTHNAME(ORDER_PURCHASE_TIMESTAMP) AS MONTH_NAME,

    DAY(ORDER_PURCHASE_TIMESTAMP) AS DAY_OF_MONTH,

    DAYOFWEEK(ORDER_PURCHASE_TIMESTAMP) AS DAY_OF_WEEK

FROM OLIST_DW.MART.FE_ORDERS
WHERE ORDER_PURCHASE_TIMESTAMP IS NOT NULL;


-- =========================================================
-- FACT ORDERS
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.FACT_ORDERS AS
SELECT
    o.ORDER_ID,

    o.CUSTOMER_ID,

    r.TOTAL_ORDER_VALUE,

    r.TOTAL_PRODUCT_VALUE,

    r.TOTAL_FREIGHT,

    r.TOTAL_ITEMS,

    o.ORDER_STATUS,

    o.ORDER_YEAR,

    o.ORDER_MONTH,

    o.ORDER_QUARTER,

    o.DELIVERY_DAYS,

    o.DELIVERY_DELAY_DAYS,

    o.APPROVAL_HOURS

FROM OLIST_DW.MART.FE_ORDERS o

LEFT JOIN OLIST_DW.MART.ORDER_REVENUE r
    ON o.ORDER_ID = r.ORDER_ID;


-- =========================================================
-- FACT PAYMENTS
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.FACT_PAYMENTS AS
SELECT
    ORDER_ID,

    PAYMENT_TYPE,

    PAYMENT_INSTALLMENTS,

    PAYMENT_VALUE

FROM OLIST_DW.MART.CLEAN_PAYMENTS;


-- =========================================================
-- FACT REVIEWS
-- =========================================================

CREATE OR REPLACE TABLE OLIST_DW.MART.FACT_REVIEWS AS
SELECT
    ORDER_ID,

    REVIEW_ID,

    REVIEW_SCORE,

    REVIEW_CATEGORY

FROM OLIST_DW.MART.FE_REVIEWS;


SHOW TABLES IN SCHEMA OLIST_DW.MART;