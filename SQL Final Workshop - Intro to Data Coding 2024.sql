-- SQL : FINAL WORKSHOP--

/*
REQUIREMENT
• We have `Superstore` dataset
• Want data for further use in a reporting 

• Final Data to use including: order_id, order_date, region, country, customer_id, customer_name, segment
                                ,day_to_ship,product_ID,product_category,product_subcategory
                                ,quantity, sales_USD, sales_THB

• Data between [15 MAR 2023, 3 MAY 2024]
• File name : Sales_data_for_Superstore_team_2months
*/

-- Common Table Expressions or CTEs --

WITH
/*
• Table name : t1
• Get data between 15 MAR 2023, 3 MAY 2024
• Problem : order cancelation and sales_USD is negative value.
            order promotion (free) and sales_USD is zero. (ไม่ตัดข้อมูลทิ้ง)
*/
t1 AS (
SELECT Order_ID, Order_Date_YMD AS order_date, Ship_Date_YMD AS ship_date
, julianday(Ship_Date_YMD) - julianday(Order_Date_YMD) AS day_to_ship
, Region, Country, Customer_ID
, Product_ID, Quantity, Sales AS sales_USD
FROM Trans_table_compact
WHERE Order_Date_YMD >= '2023-03-15' AND Order_Date_YMD <= '2024-05-03'
)

-- Table name : trans_if_sum_per_order_is_zero
, trans_if_sum_per_order_is_zero AS (
SELECT DISTINCT Order_ID FROM
(
SELECT Order_ID, round(sum(sales_USD), 1) = 0
FROM t1
GROUP BY 1
HAVING round(sum(sales_USD), 1) = 0
)
)

-- Table name : trans_if_negative_sales
, trans_if_negative_sales AS (
SELECT DISTINCT Order_ID
FROM t1
WHERE sales_USD < 0
)

-- Table name : has_nagative_value_and_sum_per_order_is_zero
, has_nagative_value_and_sum_per_order_is_zero AS (
SELECT DISTINCT lt.Order_ID
FROM trans_if_sum_per_order_is_zero lt INNER JOIN trans_if_negative_sales rt
ON lt.Order_ID = rt.Order_ID
)

/*
• Table name : ex_master
• Problem : NULL in table
*/
, ex_master AS (SELECT * FROM Exchange_master WHERE import_date IS NOT NULL)

/*
• Table name : cust_master
• Get data last import date
• Problem : more than 1 order per customer ID
*/
, cust_master AS (
SELECT * FROM
(
SELECT *, row_number() OVER (PARTITION BY Customer_ID ORDER BY import_date DESC) AS rn_import_date
FROM Customer_master
)
WHERE rn_import_date = 1
)

/*
• Table name : prod_master
• Get data import date is 2024-05-04 (today)
• Problem : dubplicated Product_ID and Product_Name
*/
, prod_master AS (
SELECT * FROM
(
SELECT *, row_number() OVER (PARTITION BY Product_ID ORDER BY length(Product_Name) ASC) AS rn
FROM Product_master
WHERE import_date = '2024-05-04'
ORDER BY Product_ID
)
WHERE rn = 1
)

-- Requirement table data --

SELECT t1.order_id, t1.order_date, t1.region, t1.country, t1.customer_id
, c.Customer_Name, c.Segment, t1.day_to_ship, t1.product_ID, pd.Category
, pd.Subcategory, t1.quantity, round(t1.sales_USD * ex.exchange_rate, 2) AS sales_THB
FROM t1
LEFT JOIN prod_master pd ON pd.Product_ID = t1.Product_ID
LEFT JOIN ex_master ex ON ex.date = t1.Order_Date
LEFT JOIN cust_master c ON c.Customer_ID = t1.Customer_ID 
WHERE Order_ID NOT IN (
SELECT Order_ID FROM has_nagative_value_and_sum_per_order_is_zero
)
;

/* Note : 
        sales_THB บางบรรทัดจะเป็น null เพราะใน exchange_master ไม่มีมี value date ครบเหมือนที่ transaction มี
        นี่จึงเป็นเหตุผลที่เราควร left join เพราะเราอยากเก็บข้อมูล transaction ไว้ทุกบรรทัดเหมือนเดิม  
        ในขณะที่เทเบิลที่เอามา join ถ้าจอยกันไม่เจอก็ไม่เป็นไร ให้ขึ้นว่า null ไว้ */