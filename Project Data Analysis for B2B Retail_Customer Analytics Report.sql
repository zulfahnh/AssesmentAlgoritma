#Project Data Analysis for B2B Retail: Customer Analytics Report 

**LATAR BELAKANG**
xyz.com adalah perusahan rintisan B2B yang menjual berbagai produk tidak langsung kepada end user tetapi ke bisnis/perusahaan lainnya. 
Sebagai data-driven company, maka setiap pengambilan keputusan di xyz.com selalu berdasarkan data. Setiap quarter xyz.com akan mengadakan 
townhall dimana seluruh atau perwakilan divisi akan berkumpul untuk me-review performance perusahaan selama quarter terakhir.

Adapun hal yang akan direview adalah :

- Bagaimana pertumbuhan penjualan saat ini?
- Apakah jumlah customers xyz.com semakin bertambah ?
- Dan seberapa banyak customers tersebut yang sudah melakukan transaksi?
- Category produk apa saja yang paling banyak dibeli oleh customers?
- Seberapa banyak customers yang tetap aktif bertransaksi?

**Tabel yang Digunakan**
Tabel yang akan digunakan pada project kali ini adalah sebagai berikut.

- Tabel orders_1 : Berisi data terkait transaksi penjualan periode quarter 1 (Jan – Mar 2004)
- Tabel Orders_2 : Berisi data terkait transaksi penjualan periode quarter 2 (Apr – Jun 2004)
- Tabel Customer : Berisi data profil customer yang mendaftar menjadi customer xyz.com

---------------------------------------------------------------------------------------------------------------------------------------------
1. Total Penjualan dan Revenue pada Quarter-1 (Jan, Feb, Mar) dan Quarter-2 (Apr,Mei,Jun)

- Dari tabel orders_1 lakukan penjumlahan pada kolom quantity dengan fungsi aggregate sum() dan beri nama “total_penjualan”, 
kalikan kolom quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”
- Perusahaan hanya ingin menghitung penjualan dari produk yang terkirim saja, jadi kita perlu mem-filter kolom ‘status’ 
sehingga hanya menampilkan order dengan status “Shipped”
**QUERY SQL: Tabel_1**
SELECT SUM(quantity) AS total_penjualan, SUM(priceEach * quantity) as revenue 
FROM orders_1 
WHERE status = "Shipped";

**OUTPUT: Tabel_1**
+-----------------+-----------+
| total_penjualan | revenue   |
+-----------------+-----------+
|            8694 | 799579310 |
+-----------------+-----------+

**QUERY SQL: Tabel_2**
SELECT SUM(quantity) AS total_penjualan, SUM(priceEach * quantity) as revenue
FROM orders_2 
WHERE status = "Shipped";

**OUTPUT: Tabel_2**
+-----------------+-----------+
| total_penjualan | revenue   |
+-----------------+-----------+
|            6717 | 607548320 |
+-----------------+-----------+

---------------------------------------------------------------------------------------------------------------------------------------------
2. Menghitung persentasi keseluruhan penjualan
    Kedua tabel orders_1 dan orders_2 masih terpisah, untuk menghitung persentasi keseluruhan penjualan dari kedua tabel tersebut perlu 
    digabungkan :
- Pilihlah kolom “orderNumber”, “status”, “quantity”, “priceEach” pada tabel orders_1, dan tambahkan kolom baru dengan nama “quarter” dan 
isi dengan value “1”. Lakukan yang sama dengan tabel orders_2, dan isi dengan value “2”, kemudian gabungkan kedua tabel tersebut.
- Gunakan statement dari Langkah 1 sebagai subquery dan beri alias “tabel_a”.
- Dari “tabel_a”, lakukan penjumlahan pada kolom “quantity” dengan fungsi aggregate sum() dan beri nama “total_penjualan”, dan kalikan kolom 
quantity dengan kolom priceEach kemudian jumlahkan hasil perkalian kedua kolom tersebut dan beri nama “revenue”
- Filter kolom ‘status’ sehingga hanya menampilkan order dengan status “Shipped”.
- Kelompokkan total_penjualan berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

**QUERY SQL:**
SELECT quarter, SUM(quantity) AS total_penjualan, SUM(priceEach * quantity) as revenue
FROM (SELECT orderNumber, status, quantity, priceEach, '1' as quarter
FROM orders_1
UNION
SELECT orderNumber, status, quantity,priceEach, '2' as quarter
FROM orders_2) AS tabel_a
WHERE status = 'Shipped'
GROUP BY quarter

**OUTPUT:**
+---------+-----------------+-----------+
| quarter | total_penjualan | revenue   |
+---------+-----------------+-----------+
| 1       |            8694 | 799579310 |
| 2       |            6717 | 607548320 |
+---------+-----------------+-----------+

---------------------------------------------------------------------------------------------------------------------------------------------
3. Apakah jumlah customers xyz.com semakin bertambah?
    Penambahan jumlah customers dapat diukur dengan membandingkan total jumlah customers yang registrasi di periode saat ini dengan total 
    jumlah customers yang registrasi diakhir periode sebelumnya.
- Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak
nilai quarter dari CreateDate dan beri nama “quarter”
- Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30Juni 2004
- Gunakan statement Langkah 1 & 2 sebagai subquery dengan alias tabel_b
- Hitunglah jumlah unik customers à tidak ada duplikasi customers dan beri nama “total_customers”
- Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

**QUERY SQL:**
SELECT quarter, COUNT(DISTINCT customerID) as total_customers 
FROM(SELECT customerID, createDate, QUARTER(createDate) as quarter
FROM customer
WHERE createDate BETWEEN "2004-01-01" AND "2004-06-30") as tabel_b
GROUP BY quarter

*OUTPUT:**
+---------+-----------------+
| quarter | total_customers |
+---------+-----------------+
|       1 |              43 |
|       2 |              35 |
+---------+-----------------+

---------------------------------------------------------------------------------------------------------------------------------------------
4. Seberapa banyak customers tersebut yang sudah melakukan transaksi?
    Problem ini merupakan kelanjutan dari problem sebelumnya yaitu dari sejumlah customer yang registrasi di periode quarter-1 dan quarter-2, 
    berapa banyak yang sudah melakukan transaksi
- Dari tabel customer, pilihlah kolom customerID, createDate dan tambahkan kolom baru dengan menggunakan fungsi QUARTER(…) untuk mengekstrak 
nilai quarter dari CreateDate dan beri nama “quarter”
- Filter kolom “createDate” sehingga hanya menampilkan baris dengan createDate antara 1 Januari 2004 dan 30 Juni 2004
- Gunakan statement Langkah A&B sebagai subquery dengan alias tabel_b
- Dari tabel orders_1 dan orders_2, pilihlah kolom customerID, gunakan DISTINCT untuk menghilangkan duplikasi, kemudian gabungkan dengan kedua 
tabel tersebut dengan UNION.
- Filter tabel_b menggunakan operator IN() dan ‘Select statement Langkah d’, sehingga hanya customerID yang pernah bertransaksi (customerID 
tercatat di tabel orders) yang diperhitungkan.
- Hitunglah jumlah unik customers (tidak ada duplikasi customers) di statement SELECT dan beri nama “total_customers”
- Kelompokkan total_customer berdasarkan kolom “quarter”, dan jangan lupa menambahkan kolom ini pada bagian select.

**QUERY SQL:**
SELECT quarter, COUNT(DISTINCT customerID) as total_customers 
FROM (SELECT customerID, createDate, QUARTER(createDate) as quarter
FROM customer
WHERE createDate BETWEEN "2004-01-01" AND "2004-06-30") as tabel_b
WHERE customerID IN (SELECT DISTINCT customerID FROM orders_1
					 UNION 
					 SELECT DISTINCT customerID FROM orders_2)
GROUP BY quarter

**OUTPUT:**
+---------+-----------------+
| quarter | total_customers |
+---------+-----------------+
|       1 |              25 |
|       2 |              19 |
+---------+-----------------+

---------------------------------------------------------------------------------------------------------------------------------------------
5. Category produk apa saja yang paling banyak di-order oleh customers di Quarter-2?
    Untuk mengetahui kategori produk yang paling banyak dibeli, maka dapat dilakukan dengan menghitung total order dan jumlah penjualan 
    dari setiap kategori produk.
- Dari kolom orders_2, pilih productCode, orderNumber, quantity, status
- Tambahkan kolom baru dengan mengekstrak 3 karakter awal dari productCode yang merupakan ID untuk kategori produk; dan beri nama categoryID
- Filter kolom “status” sehingga hanya produk dengan status “Shipped” yang diperhitungkan
- Gunakan statement Langkah 1, 2, dan 3 sebagai subquery dengan alias tabel_c
- Hitunglah total order dari kolom “orderNumber” dan beri nama “total_order”, dan jumlah penjualan dari kolom “quantity” dan beri nama 
“total_penjualan”
- Kelompokkan berdasarkan categoryID, dan jangan lupa menambahkan kolom ini pada bagian select.
- Urutkan berdasarkan “total_order” dari terbesar ke terkecil

**QUERY SQL:**
SELECT * FROM (SELECT categoryID, COUNT(DISTINCT orderNumber) AS total_order, SUM(quantity) AS total_penjualan
FROM ( SELECT productCode, orderNumber, quantity, status, LEFT(productCode,3) AS categoryID
FROM orders_2
WHERE status = "Shipped") tabel_c
GROUP BY categoryID ) a ORDER BY total_order DESC

**OUTPUT:**
+------------+-------------+-----------------+
| categoryID | total_order | total_penjualan |
+------------+-------------+-----------------+
| S18        |          25 |            2264 |
| S24        |          21 |            1826 |
| S32        |          11 |             616 |
| S12        |          10 |             491 |
| S10        |           8 |             492 |
| S50        |           8 |             292 |
| S70        |           7 |             675 |
| S72        |           2 |              61 |
+------------+-------------+-----------------+

---------------------------------------------------------------------------------------------------------------------------------------------
6. Seberapa banyak customers yang tetap aktif bertransaksi setelah transaksi pertamanya?
    Oleh karena baru terdapat 2 periode yang Quarter 1 dan Quarter 2, maka retention yang dapat dihitung adalah retention dari customers 
    yang berbelanja di Quarter 1 dan kembali berbelanja di Quarter 2, sedangkan untuk customers yang berbelanja di Quarter 2 baru bisa dihitung 
    retentionnya di Quarter 3.
- Dari tabel orders_1, tambahkan kolom baru dengan value “1” dan beri nama “quarter”
- Dari tabel orders_2, pilihlah kolom customerID, gunakan distinct untuk menghilangkan duplikasi
- Filter orders_1 menggunakan operator IN() dan ‘Select statement Langkah 2)’, sehingga hanya customerID yang pernah bertransaksi di quarter 2 
(customerID tercatat di tabel orders_2) yang diperhitungkan.
- Hitunglah jumlah unik customers (tidak ada duplikasi customers) dibagi dengan total_ customers dalam percentage, pada Select statement dan 
beri nama “Q2”
**QUERY SQL:**
#Menghitung total unik customers yang transaksi di quarter_1
SELECT COUNT(DISTINCT customerID) as total_customers FROM orders_1;
#output = 25

SELECT '1' AS quarter, (COUNT(DISTINCT customerID)*100 )/25 AS Q2 
FROM orders_1 
WHERE customerID IN (SELECT DISTINCT customerID FROM orders_2)

**OUTPUT:**
+-----------------+
| total_customers |
+-----------------+
|              25 |
+-----------------+
+---------+---------+
| quarter | Q2      |
+---------+---------+
| 1       | 24.0000 |
+---------+---------+

---------------------------------------------------------------------------------------------------------------------------------------------
**KESIMPULAN**
Berdasarkan data yang telah kita peroleh melalui query SQL, Kita dapat menarik kesimpulan bahwa :
    > Performance xyz.com menurun signifikan di quarter ke-2, terlihat dari nilai penjualan dan revenue yang drop hingga 20% dan 24%,
    perolehan customer baru juga tidak terlalu baik, dan sedikit menurun dibandingkan quarter sebelumnya.
    > Ketertarikan customer baru untuk berbelanja di xyz.com masih kurang, hanya sekitar 56% saja yang sudah bertransaksi. 
    Disarankan tim Produk untuk perlu mempelajari behaviour customer dan melakukan product improvement, sehingga conversion rate 
    (register to transaction) dapat meningkat.
    > Produk kategori S18 dan S24 berkontribusi sekitar 50% dari total order dan 60% dari total penjualan, sehingga xyz.com sebaiknya 
    fokus untuk pengembangan category S18 dan S24.
    > Retention rate customer xyz.com juga sangat rendah yaitu hanya 24%, artinya banyak customer yang sudah bertransaksi di quarter-1 
    tidak kembali melakukan order di quarter ke-2 (no repeat order).
    > com mengalami pertumbuhan negatif di quarter ke-2 dan perlu melakukan banyak improvement baik itu di sisi produk dan bisnis marketing, 
    jika ingin mencapai target dan positif growth di quarter ke-3. Rendahnya retention rate dan conversion rate bisa menjadi diagnosa awal 
    bahwa customer tidak tertarik/kurang puas/kecewa berbelanja di xyz.com.
---------------------------------------------------------------------------------------------------------------------------------------------