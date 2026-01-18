                             -- STEP 6 HANDLING NULL RECORD PRICES ---
-- Mean -- 2510.768038
SELECT AVG(price) from esales_backup;
-- Mode 
SELECT price,count(*) as Max_count from esales_backup group by price order by Max_count desc ;

 -- Average by category
SELECT category,AVG(price) from esales_backup group by category;

-- Toys	2235.471689
-- Unknown	2511.416405
-- Electronics	2663.927841
-- Home & Kitchen	2507.058378
-- Clothing	2539.278187
-- Books	2574.457347


UPDATE esales_backup e
JOIN (
    SELECT category, AVG(price) AS avg_price
    FROM esales_backup
    WHERE price IS NOT NULL
    GROUP BY category
) a
ON e.category = a.category
SET e.price = a.avg_price
WHERE e.price IS NULL;

							-- Step 7: Identify Mixed and Invalid Date Value
SELECT DISTINCT purchase_date
FROM esales_backup;

-- Step 1: Handle Clearly Invalid Dates
-- Some dates were invalid (for example, 2024-02-30, which does not exist).
UPDATE esales_backup
SET purchase_date = NULL
WHERE purchase_date = '2024-02-30';
-- Step 2: Convert Slash-Based Dates (DD/MM/YYYY)
UPDATE esales_backup
SET purchase_date = STR_TO_DATE(purchase_date, '%d/%m/%Y')
WHERE purchase_date LIKE '%/%';
-- Step 3: Convert Dash-Based Dates (YYYY-MM-DD)
UPDATE esales_backup
SET purchase_date = STR_TO_DATE(purchase_date, '%Y-%m-%d')
WHERE purchase_date LIKE '%-%';

SELECT purchase_date
FROM esales_backup
WHERE purchase_date IS NULL;

ALTER TABLE esales_backup
MODIFY purchase_date DATE;

select purchase_date from esales_backup;

                            -- STEP 8 FIXING INVALID EMAIL ADDRESSES
Select* from esales_backup;                               
Select count(*)  AS No_of_null from esales_backup where customer_address is null;      
SELECT email FROM esales_backup WHERE email NOT LIKE '%@%';
update esales_backup set email= null where email not like '%@%';

						         -- STEP 9 DATA TYPE CONVERSION  --
ALTER TABLE esales_backup
MODIFY customer_id INT,
MODIFY customer_name VARCHAR(100),
MODIFY email VARCHAR(150),
MODIFY product_id INT,
MODIFY category VARCHAR(50),
MODIFY price DECIMAL(10,2),
MODIFY quantity INT,
MODIFY total_amount DECIMAL(12,2),
MODIFY payment_method VARCHAR(50),
MODIFY delivery_status VARCHAR(50),
MODIFY customer_address VARCHAR(255);

describe esales_backup;

