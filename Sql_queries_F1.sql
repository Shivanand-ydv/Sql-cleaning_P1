USE sales_cleaning;
DESCRIBE esales;  
SELECT * FROM  esales;
SELECT COUNT(*) FROM  esales; 

                                         -- STEP 1 BACKUP TABLE 
CREATE TABLE esales_backup AS SELECT * FROM esales;

DESCRIBE esales_backup ;

-- By adding an auto-increment primary key, each row got a unique identity.

ALTER TABLE esales_backup
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

                               -- STEP 2 IDENTIFICATION AND REMOVAL OF DUPLICATE RECORDS --
-- To check for duplicates

WITH dup_rows AS (
    SELECT *,ROW_NUMBER() OVER(
    PARTITION BY transaction_id 
    ORDER BY id) AS rn
    FROM esales_backup)
SELECT *FROM dup_rows WHERE rn > 1;

-- To delete duplicates values from table 'esales_backup'

DELETE FROM esales_backup
WHERE id IN (
    SELECT id FROM (
        SELECT id,
               ROW_NUMBER() OVER(
                   PARTITION BY transaction_id
                   ORDER BY id
               ) AS rn
        FROM esales_backup
    ) t
    WHERE rn > 1
);
select count(*) from esales_backup;
                             -- STEP 3 CHECK FOR NULL VALUES (Total No of Null Values)

SELECT COUNT(*) FROM esales_backup WHERE transaction_id= ''
OR customer_id  = ''OR customer_name = ''OR email = ''
OR purchase_date= ''OR product_id=''OR category=''OR price=''OR quantity=''
OR total_amount=''OR payment_method=''OR delivery_status=''OR customer_address='';

                                    -- STEP 4 TREATING NULL VALUES
--  category
select count(*) from esales_backup where category is null;
update esales_backup set category='Unknown' where category is null;

-- customer_address
select count(*) from esales_backup where customer_address is null;
update esales_backup set  customer_address='Not Available' where  customer_address is null;

-- Payment_method
select distinct payment_method from esales_backup;
update esales_backup set  payment_method='Credit Card' where  payment_method in ('creditcard','CC','credit');
update esales_backup set payment_method='Cash' Where payment_method is null;

-- Delivery_status 
select distinct Delivery_status from esales_backup;
update esales_backup set Delivery_status ='Not Delivered' Where Delivery_status is null;

-- Customer_name
select * from esales_backup where customer_name is null;
update esales_backup set customer_name='User' where customer_name is null;

								-- STEP 5 HANDLING NEGATIVE VALUES 
 Select * from esales_backup;
 
 Select * from esales_backup where quantity<0;

-- I standardized the data by converting them to absolute values to maintain consistency for downstream analysis.
-- Cleaned sales data by correcting invalid negative quantities using SQL transformation logic (ABS()), improving data accuracy and reliability.

 Update esales_backup set quantity= abs(quantity) where quantity<0;
 
 Update esales_backup set Total_amount =price*quantity where Total_amount is null OR Total_amount<> price*quantity;
 


