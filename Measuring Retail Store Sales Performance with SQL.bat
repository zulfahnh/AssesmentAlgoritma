#Project Data Analysis for Retail: Sales Performance Report
---------------------------------------------------------------------------------------------------------------------------------------------
1. (Overall Performance by Year) : Mendapatkan total penjualan (sales) dan jumlah order (number_of_order) dari tahun 2009 sampai 2012 (years)
**QUERY SQL:**
SELECT YEAR(order_date) as years, ROUND(SUM(sales), 2) as sales, COUNT(order_status) as number_of_order
FROM dqlab_sales_store 
WHERE order_status = 'Order Finished'
GROUP BY YEAR(order_date)

**OUTPUT:**
+-------+---------------+-----------------+
| years | sales         | number_of_order |
+-------+---------------+-----------------+
|  2009 | 4613872681.00 |            1244 |
|  2010 | 4059100607.00 |            1248 |
|  2011 | 4112036186.00 |            1178 |
|  2012 | 4482983158.00 |            1254 |
+-------+---------------+-----------------+

---------------------------------------------------------------------------------------------------------------------------------------------
2. (Overall Performance by Product Sub Category) : Mendapatkan total penjualan (sales) berdasarkan sub category dari produk 
    (product_sub_category) pada tahun 2011 dan 2012 saja (years)
**QUERY SQL:**
SELECT YEAR(order_date) as years, product_sub_category, SUM(sales) as sales
FROM dqlab_sales_store
WHERE YEAR(order_date) >= 2011 AND order_status = 'Order Finished'
GROUP BY YEAR(order_date), product_sub_category
ORDER BY YEAR(order_date) ASC, Sales DESC

**OUTPUT: 5 data teratas**
+-------+--------------------------------+-----------+
| years | product_sub_category           | sales     |
+-------+--------------------------------+-----------+
|  2011 | Chairs & Chairmats             | 622962720 |
|  2011 | Office Machines                | 545856280 |
|  2011 | Tables                         | 505875008 |
|  2011 | Copiers and Fax                | 404074080 |
|  2011 | Telephones and Communication   | 392194658 |
+-------+--------------------------------+-----------+

---------------------------------------------------------------------------------------------------------------------------------------------
3. (Promotion Effectiveness and Efficiency by Years) : 
    - Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini
    - Efektifitas dan efisiensi dari promosi yang dilakukan akan dianalisa berdasarkan Burn Rate yaitu dengan membandigkan total value promosi 
    yang dikeluarkan terhadap total sales yang diperoleh 
    -  burn rate tetap berada diangka maskimum 4.5%
    - menghitung total sales (sales) dan total discount (promotion_value) berdasarkan tahun(years) dan formulasikan persentase burn rate nya 
    (burn_rate_percentage).
**QUERY SQL:**
SELECT YEAR(order_date) as years, SUM(sales) as sales, SUM(discount_value) as promotion_value, 
       ROUND((SUM(discount_value)/SUM(sales)*100),2) as burn_rate_percentage
FROM dqlab_sales_store
WHERE order_status = 'Order Finished'
GROUP BY YEAR(order_date)

**OUTPUT:**
+-------+------------+-----------------+----------------------+
| years | sales      | promotion_value | burn_rate_percentage |
+-------+------------+-----------------+----------------------+
|  2009 | 4613872681 |       214330327 |                 4.65 |
|  2010 | 4059100607 |       197506939 |                 4.87 |
|  2011 | 4112036186 |       214611556 |                 5.22 |
|  2012 | 4482983158 |       225867642 |                 5.04 |
+-------+------------+-----------------+----------------------+ 

---------------------------------------------------------------------------------------------------------------------------------------------
4. (Promotion Effectiveness and Efficiency by Product Sub Category) :
    - Pada bagian ini kita akan melakukan analisa terhadap efektifitas dan efisiensi dari promosi yang sudah dilakukan selama ini seperti 
    pada bagian sebelumnya. 
    - Akan tetapi, ada kolom yang harus ditambahkan, yaitu : product_sub_category dan product_category
**QUERY SQL:**
SELECT YEAR(order_date) as years, product_sub_category, product_category, SUM(sales) as sales, SUM(discount_value) as promotion_value, ROUND((SUM(discount_value)/SUM(sales)*100),2) as burn_rate_percentage
FROM dqlab_sales_store
WHERE YEAR(order_date) = 2012 AND order_status = 'Order Finished'
GROUP BY YEAR(order_date),product_sub_category, product_category
ORDER BY sales DESC

**OUTPUT: 5 data teratas**
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
| years | product_sub_category           | product_category | sales     | promotion_value | burn_rate_percentage |
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+
|  2012 | Office Machines                | Technology       | 811427140 |        46616695 |                 5.75 |
|  2012 | Chairs & Chairmats             | Furniture        | 654168740 |        26623882 |                 4.07 |
|  2012 | Telephones and Communication   | Technology       | 422287514 |        18800188 |                 4.45 |
|  2012 | Tables                         | Furniture        | 388993784 |        16348689 |                 4.20 |
|  2012 | Binders and Binder Accessories | Office Supplies  | 363879200 |        22338980 |                 6.14 |
+-------+--------------------------------+------------------+-----------+-----------------+----------------------+

---------------------------------------------------------------------------------------------------------------------------------------------
5. (Customers Transactions per Year) : Mengetahui jumlah customer (number_of_customer) yang bertransaksi setiap tahun dari 2009 sampai 
    2012 (years).
**QUERY SQL:**
SELECT YEAR(order_date) as years, COUNT(DISTINCT customer) as number_of_customer
FROM dqlab_sales_store
WHERE order_status = 'Order Finished'
GROUP BY YEAR(order_date)

**OUTPUT:**
+-------+--------------------+
| years | number_of_customer |
+-------+--------------------+
|  2009 |                585 |
|  2010 |                593 |
|  2011 |                581 |
|  2012 |                594 |
+-------+--------------------+