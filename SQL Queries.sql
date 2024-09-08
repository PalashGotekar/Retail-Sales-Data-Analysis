select * from RETAILSALESDATA

-- REQUIRED COLUMN DATA TYPE CHANGED
ALTER TABLE RETAILSALESDATA
ALTER COLUMN INVOICE_ID VARCHAR(30)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN BRANCH VARCHAR(5)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN CITY VARCHAR(30)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN CUSTOMER_TYPE VARCHAR(30)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN UNIT_PRICE DECIMAL(10,2)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN TAX_5 DECIMAL(10,2)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN TOTAL DECIMAL(10,2)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN DATE DATE

ALTER TABLE RETAILSALESDATA
ALTER COLUMN TIME TIME(0)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN COGS DECIMAL(10,2)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN GROSS_MARGIN_PERCENTAGE DECIMAL(10,2)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN GROSS_INCOME DECIMAL(10,2)

ALTER TABLE RETAILSALESDATA
ALTER COLUMN RATING DECIMAL(10,2)

SELECT * FROM RETAILSALESDATA

-- ADDING NEW COULMN IN EXISTING TABLE

ALTER TABLE RETAILSALESDATA
ADD Time_of_Day varchar(30)

UPDATE retailsalesdata
SET time_of_day = CASE 
    WHEN DATEPART(hour, Time) BETWEEN 0 AND 11 THEN 'Morning'
    WHEN DATEPART(hour, Time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END;

SELECT time, time_of_day
FROM retailsalesdata
ORDER BY time

-- new column in existing table 

ALTER TABLE retailsalesdata
ADD Day_name varchar(10)

 UPDATE retailsalesdata
SET day_name = CASE DATENAME(weekday, date)
    WHEN 'Monday' THEN 'Mon'
    WHEN 'Tuesday' THEN 'Tue'
    WHEN 'Wednesday' THEN 'Wed'
    WHEN 'Thursday' THEN 'Thu'
    WHEN 'Friday' THEN 'Fri'
    WHEN 'Saturday' THEN 'Sat'
    WHEN 'Sunday' THEN 'Sun'
END;

select date, day_name
from retailsalesdata
order by date

-- new column named_month

AlTER TABLE retailsalesdata
ADD MONTH_NAME VARCHAR(10)

UPDATE retailsalesdata
SET month_name = CASE DATENAME(month, DATE)
    WHEN 'January' THEN 'Jan'
    WHEN 'February' THEN 'Feb'
    WHEN 'March' THEN 'Mar'
    WHEN 'April' THEN 'Apr'
    WHEN 'May' THEN 'May'
    WHEN 'June' THEN 'Jun'
    WHEN 'July' THEN 'Jul'
    WHEN 'August' THEN 'Aug'
    WHEN 'September' THEN 'Sep'
    WHEN 'October' THEN 'Oct'
    WHEN 'November' THEN 'Nov'
    WHEN 'December' THEN 'Dec'
END;

SELECT DATE, month_name
FROM retailsalesdata
ORDER BY DATE;

select * from RETAILSALESDATA

--1.How many unique cities does the data have?
select count( distinct city)
AS Unique_city
from RetailSalesData

--2.In which city is each branch?
select branch,city
from RetailSalesData
order by branch

--Product questions

--1.How many unique product lines does the data have?
select count(distinct product_line)
AS Unique_PL
 from RetailSalesData

 --2.What is the most common payment method?
 select top 3 payment, count(*)
 AS Frequency
 from RetailSalesData
 group by payment
 order by frequency desc;

 --3.What is the most selling product line?
  select top 10 product_line, count(*)
 AS Frequency
 from RetailSalesData
 group by product_line
 order by frequency desc;

--4.What is the total revenue by month?
select month_name, sum(total)
AS Total_revenue
from RetailSalesData
group by month_name
order by Total_revenue desc

--5.What month had the largest COGS
select top 10 month_name, sum(cogs)
as total_cogs
from RetailSalesData
group by month_name
order by Total_cogs desc

--6.What product line had the largest revenue?
select product_line, sum(total) 
as Largest_revenue
from RetailSalesData
group by product_line
order by Largest_revenue desc

--7.What is the city with the largest revenue?
select city, sum(total)
as largest_revenue
from RetailSalesData
group by City
order by Largest_revenue desc

--8.What product line had the largest VAT?
select Product_line, sum(Tax_5)
as largest_VAT
from RetailSalesData
group by Product_line
order by Largest_VAT desc

--etch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
WITH AverageSales AS (
    SELECT AVG(Total) AS avg_sales
    FROM RetailSalesData
)
SELECT product_line,
    CASE
        WHEN SUM(Total) > (SELECT avg_sales FROM AverageSales) THEN 'Good'
        ELSE 'Bad'
    END AS sales_status
FROM RetailSalesData
GROUP BY product_line;

--Which branch sold more products than average product sold?
WITH averageQuantity AS (
    SELECT AVG(quantity) AS avg_quantity
    FROM RetailSalesData
)
SELECT branch, 
       AVG(quantity) AS branch_avg_quantity
FROM RetailSalesData
GROUP BY branch;

--11.What is the most common product line by gender?
select product_line, count(*)
as frequency
FROM RetailSalesData
GROUP BY product_line, gender
order by gender, frequency desc

--12 12.What is the average rating of each product line?
select product_line, avg(rating)
as avergae_rating
FROM RetailSalesData
GROUP BY product_line

--SALES
--1.Number of sales made in each time of the day per weekday
SELECT DAY_NAME, TIME_OF_DAY, COUNT(*)
AS SALES_COUNT
FROM RetailSalesData
GROUP BY DAY_NAME, TIME_OF_DAY
ORDER BY DAY_NAME,TIME_OF_DAY

--2.Which of the customer types brings the most revenue?
SELECT CUSTOMER_TYPE,SUM(TOTAL)
AS TOTAL_REVENUE
FROM RetailSalesData
GROUP BY CUSTOMER_TYPE
ORDER BY TOTAL_REVENUE DESC

--3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT CITY,AVG(TAX_5/TOTAL)*100
AS AVG_VAT_percent
FROM RetailSalesData
GROUP BY City
ORDER BY Avg_Vat_percent DESC

--4.Which customer type pays the most in VAT?
SELECT Customer_type, Sum(TAX_5)
AS Total_VAT
FROM RetailSalesData
GROUP BY Customer_type
ORDER BY Total_VAT DESC

--Customer
-- 1.How many unique customer types does the data have?

select count(distinct customer_type)
as unique_customer_type
from RetailSalesData

--2.How many unique payment methods does the data have?
select count(distinct payment)
as unique_payment_methods
from RetailSalesData

--3.What is the most common customer type?
select customer_type, count(*)
as count
from RetailSalesData
group by customer_type
order by count desc
offset 0 rows 
fetch next 1 rows only

--4.Which customer type buys the most?
select customer_type, sum(quantity)
as total_quantity
from RetailSalesData
group by customer_type
order by total_quantity desc

--5.What is the gender of most of the customers?
select gender, count(*)
as count
from RetailSalesData
group by gender
order by count desc
offset 0 row fetch next 1 rows only

--6.What is the gender distribution per branch?
select branch,gender, count(*)
as count
from RetailSalesData
group by gender, branch
order by branch, gender

--7.Which time of the day do customers give most ratings?
select time_of_day, count(rating)
as rating_count
from RetailSalesData
group by time_of_day 
order by rating_count desc

--8.Which time of the day do customers give most ratings per branch?
select branch, time_of_day, count(rating)
as rating_count
from RetailSalesData
group by time_of_day,branch 
order by rating_count desc

--9.Which day fo the week has the best avg ratings?
select day_name, avg(rating)
as avg_rating
from RetailSalesData
group by  day_name
order by avg_rating desc

--10 10.Which day of the week has the best average ratings per branch?
select day_name,branch, avg(rating)
as avg_rating
from RetailSalesData
group by  day_name,  branch
order by avg_rating desc
