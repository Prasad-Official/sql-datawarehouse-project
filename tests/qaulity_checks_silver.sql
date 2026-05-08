/*
=====================================================================================
Quality Checks
=====================================================================================
Script Purpose:
  This script performs various quality checks for data consistency, accuracy, and 
  standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys
    -  Unwanted spaces in string fields
    - Data standardization and consistency
    - Invalid data ranges and orders
    - Data consistency between related fields

Usage Notes:
    - Run these checks after data loading silver layer.
    - Investigate and resolve any discrepancies found during the checks.
=====================================================================================
*/


-- Testing after INSERTING the data into silver.crm_cust_info
SELECT
cst_id,
COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 or cst_id IS NULL


SELECT
cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)


SELECT
cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname!= TRIM(cst_lastname)


SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info


SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info


-- Check for Nulls or Duplicates in Primary Key
SELECT
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL


-- Quality Check for distinct id
SELECT DISTINCT id
FROM bronze.erp_px_cat_g1v2


-- Quality Check for sales details
SELECT
sls_prd_key
FROM bronze.crm_sales_details


-- Quality Check for unwanted spaces details
SELECT
prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm!= TRIM(prd_nm)


-- Check for Nulls or Negative numbers
SELECT
prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


-- Check for distinct values in the column
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info


-- Check for invalid date orders
SELECT
*
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt


-- Step 8: Testing the final outcome
SELECT
prd_id,
COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 or prd_id IS NULL


SELECT
prd_nm
FROM silver.crm_prd_info
WHERE prd_nm!= TRIM(prd_nm)


SELECT
prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL


SELECT DISTINCT prd_line
FROM silver.crm_prd_info


SELECT
*
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt


--Final Look of the table
SELECT
*
FROM silver.crm_prd_info


-- Step 10: Issue noticed in the Order Date so fix is below
SELECT
NULLIF(sls_order_dt, 0) AS sls_order_date
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0 OR LEN(sls_order_dt) != 8 OR sls_order_dt > 20500101


-- Step 11: Check for invalid date orders
SELECT
*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt or sls_order_dt > sls_due_dt


-- Step 12: Checking Sales data (Sales = Quantity * Price) and cannot be 0, NULL or negative
SELECT DISTINCT
sls_sales,
sls_quantity,
sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL or sls_quantity is NULL OR sls_price IS NULL
OR sls_sales <=0 or sls_quantity <=0  OR sls_price <=0
ORDER BY sls_sales, sls_quantity, sls_price


-- Identifying out of range dates
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()


-- Data Standardization & Consistency
SELECT DISTINCT gen
FROM bronze.erp_cust_az12


-- Final result
SELECT DISTINCT
bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

SELECT DISTINCT gen
FROM silver.erp_cust_az12


-- Quality check
SELECT
cst_key from silver.crm_cust_info;

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101
ORDER BY cntry


-- Test
SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry


-- Quality check for unwanted spaces
SELECT
*
FROM bronze.erp_px_cat_g1v2
WHERE TRIM(cat) != cat OR subcat!= TRIM(subcat) OR maintenance != TRIM(maintenance)


--Data Standardization & Consistency
SELECT DISTINCT
cat,
subcat,
maintenance
FROM bronze.erp_px_cat_g1v2


--Test
SELECT
*
FROM silver.erp_px_cat_g1v2
