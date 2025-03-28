USE nortwind;
--Soru1'in Cevabı
SELECT COUNT(*)AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE ='BASE TABLE';


--Soru2'nin Cevabı
SELECT 
    c.CompanyName AS "Şirket Adı",
    CONCAT(e.FirstName, ' ', e.LastName) AS "Çalışan Adı",
    o.OrderDate AS "Sipariş Tarihi",
    s.CompanyName AS "Gönderici Şirket"
FROM 
    Orders o
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    Employees e ON o.EmployeeID = e.EmployeeID
JOIN 
    Shippers s ON o.ShipVia = s.ShipperID
ORDER BY 
    o.OrderDate;

--SELECT: İlgili sütunları seçiyoruz.
--CONCAT: Çalışan adını ve soyadını birleştiriyoruz.
--FROM: Orders tablosunu temel alıyoruz.
--JOIN:
--Customers tablosunu siparişin müşteri kimliği ile birleştiriyoruz.
--Employees tablosunu siparişin çalışan kimliği ile birleştiriyoruz.
--Shippers tablosunu siparişin gönderici kimliği ile birleştiriyoruz.
--ORDER BY: Sipariş tarihine göre sıralıyoruz.

--Soru 3 cevabı
SELECT SUM(Quantity * UnitPrice) AS TotalAmount
FROM "Order Details";


--SUM(Quantity * UnitPrice): Her bir siparişin toplam tutarını hesaplar (miktar x birim fiyat).
--AS TotalAmount: Sonucu TotalAmount olarak adlandırır.
--FROM "Order Details": Verilerin Order Details tablosundan alındığını belirtir.

--Soru 4 Cevabı--
SELECT 
    Country, 
    COUNT(CustomerID) AS NumberOfCustomers 
FROM 
    Customers 
GROUP BY 
    Country 
ORDER BY 
    Country;

--COUNT(CustomerID): CustomerID sütunundaki benzersiz değerleri sayar (null olmayan kayıtlar).

--GROUP BY Country: Verileri ülkelere göre gruplar.

--ORDER BY Country: Sonuçları ülke adına göre alfabetik sıralar.

--Soru 5 cevabı
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM Products);

--SELECT MAX(UnitPrice) FROM Products: Alt sorgu (subquery) olarak en yüksek ürün fiyatını bulur


--Soru 6 Cevabı--
SELECT e.EmployeeID,
CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
COUNT(o.OrderID) AS TotalOrders
FROM Employees e

LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalOrders DESC;

--1)JOIN

---Employees ve Orders tablolarını EmployeeID üzerinden birleştiriyoruz.

----LEFT JOIN kullanarak siparişi olmayan çalışanları da listeye dahil ediyoruz (TotalOrders = 0 olarak görünür).

--2)Aggregate Fonksiyonu:

----COUNT(o.OrderID), her çalışanın kaç sipariş aldığını hesaplar.

--3)Gruplama ve Sıralama:

----ORDER BYile en çok sipariş alandan en az olana sıralıyoruz

--Soru7 Cevabı
SELECT OrderID,OrderDate
FROM Orders
WHERE YEAR(OrderDate) = 1997;

--YEAR(OrderDate) = 1997 ile OrderDate sütunundaki yıl bilgisi 1997 olan kayıtları seçer.

--Soru 8 cevabı
SELECT ProductName,UnitPrice,
CASE 
     WHEN UnitPrice < 20 THEN '0-19.99 (Ucuz)'
     WHEN UnitPrice BETWEEN 20 AND 50 THEN '20-50 (Orta)'
     ELSE '50+ (Pahalı)'
END AS PriceCategory
FROM Products

--CASE 

--UnitPrice değerini 4 kategoriye ayırır:

--0-19.99: Ucuz.

--20-50: Orta.

--50+: Pahalı Ürünler.

--Aralıklar isteğe bağlı olarak değiştirilebilir.

--Soru 9 cevabı
SELECT p.ProductName,od.TotalOrdered
FROM Products p
INNER JOIN (
	SELECT ProductID,
    SUM(Quantity) AS TotalOrdered
    FROM [Order Details]
    GROUP BY ProductID
) 
od ON p.ProductID = od.ProductID

--[Order Details] tablosundan ProductID ve SUM(Quantity) ile her ürünün toplam sipariş adedini hesaplar.

--

--Soru 10 cevabı
CREATE VIEW ProductsWithCategories AS
SELECT p.ProductID,p.ProductName,p.UnitPrice,p.UnitsInStock,c.CategoryName,c.Description AS CategoryDescription
FROM Products p
INNER JOIN Categories c ON p.CategoryID = c.CategoryID;

--CREATE VIEW ProductsWithCategories AS ile ProductsWithCategories adında bir view tanımlanır.

--View, Products ve Categories tablolarını CategoryID üzerinden birleştirir.

--Ürün bilgileri: ProductID, ProductName, UnitPrice, UnitsInStock.

--Soru11
CREATE TABLE ProductDeletionLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    ProductName NVARCHAR(50),
    DeletedBy NVARCHAR(100),
    DeletionDate DATETIME
);

--LogID: Otomatik artan benzersiz log kaydı.

--ProductID & ProductName: Silinen ürünün bilgileri.

--DeletedBy: Silme işlemini yapan kullanıcı (SYSTEM_USER ile oturum açan kullanıcı alınır).

--DeletionDate: Silinme tarihi ile anlık zaman

--Soru 12 cevabı
CREATE PROCEDURE GetCustomersByCountry 
	@CountryName NVARCHAR(15)
AS
BEGIN
    SELECT CustomerID,CompanyName,ContactName,City,Country
    FROM Customers
    WHERE Country = @CountryName
END;


--@CountryName parametresi alındı

--Parametre tipi NVARCHAR(15), çünkü Customers tablosundaki Country sütunu bu şekilde tanımlanmıştır.

--ustomers tablosundan belirtilen ülkedeki müşterileri seçer.

--ORDER BY ile şirket adına göre alfabetik sıralar.

------------
--Soru13 cevabı--

SELECT p.ProductID,p.ProductName,s.SupplierID,s.CompanyName AS SupplierCompany,s.ContactName AS SupplierContact
FROM Products p
LEFT JOIN Suppliers s ON p.SupplierID = s.SupplierID
--WHERE s.SupplierID IS NULL;

--1)left JOIN
----a)Products tablosundaki tüm ürünler listelenir (tedarikçisi olmasa bile).

----b)Ürün bilgileri: ProductID, ProductName.

----c)Eğer bir ürünün tedarikçisi yoksa (Suppliers tablosunda eşleşme yoksa), SupplierID NULL olarak görünür.
----Tedarikçi bilgileri: SupplierID, CompanyName, ContactName 

--Soru14 cevabı--
SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM Products)
ORDER BY UnitPrice DESC;

--(SELECT AVG(UnitPrice) FROM Products -> Tüm ürünlerin ortalama fiyatını hesaplar.

-- ortalama fiyat nekadarsa , bu değerin üzerindeki ürünler listelenir.

--UnitPrice > ... ile ortalama fiyatın üzerindeki ürünler filtrelenir


--Soru15 cevabı
SELECT TOP 1
    e.EmployeeID,
    CONCAT(e.FirstName, ' ', e.LastName) AS EmployeeName,
    SUM(od.Quantity) AS TotalProductsSold
FROM Employees e
INNER JOIN Orders o ON e.EmployeeID = o.EmployeeID
INNER JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID, e.FirstName, e.LastName
ORDER BY TotalProductsSold DESC

--1)Tablolar birleştirilir
--Employees ve Orders: Çalışanların hangi siparişleri aldığını bulmak için EmployeeID üzerinden birleştirilir.

--Orders ve Order Details: Siparişlerin detaylarındaki ürün miktarlarını almak için OrderID üzerinden birleştirilir.

--2)total ürün miktarını hesaplama
--SUM(od.Quantity): Her çalışanın sattığı toplam ürün miktarını hesaplar.

--3)Gruplama
--GROUP BY: Çalışan bazında gruplama yapar.

--ORDER BY TotalProductsSold DESC: En çok satandan en aza doğru sıralar.

--TOP 1: Sadece en yüksek satış yapan çalışanı getirir

--Soru16 cevabı
SELECT ProductID,ProductName,UnitsInStock
FROM Products
WHERE UnitsInStock < 10
ORDER BY UnitsInStock DESC;

--UnitsInStock < 10: Stok adedi 10'dan az olan ürünleri filtreler.

ORDER BY UnitsInStock DESC : Sonuçları stok miktarına göre büyükten küçüğe sıralar.

--Soru 17
SELECT 
    Customers.CompanyName,
    COUNT(Orders.OrderID) AS SiparisSayisi,
    SUM(Orders.Freight) AS ToplamHarcama
FROM Customers
LEFT JOIN Orders ON Customers.CustomerID = Orders.CustomerID
GROUP BY Customers.CompanyName
ORDER BY ToplamHarcama DESC;

--Customers.CompanyName: Müşteri şirketinin adını seçer.
--COUNT(Orders.OrderID): Her müşteri için sipariş sayısını sayar.
--SUM(Orders.Freight): Her müşteri için toplam harcamayı hesaplar.
--LEFT JOIN: Müşterileri siparişleriyle birleştirir, böylece siparişi olmayan müşteriler de listede görünür.
--GROUP BY: Müşteri adıyla gruplar, böylece her müşteri için ayrı bir satır oluşturur.
--ORDER BY ToplamHarcama DESC: Toplam harcamaya göre azalan sırada sıralar


--Soru 18
SELECT 
    Country,
    COUNT(CustomerID) AS MüşteriSayısı
FROM 
    Customers
GROUP BY 
    Country
ORDER BY 
    MüşteriSayısı DESC
LIMIT 1;


--Country: Ülke adını seçer.
--COUNT(CustomerID): Her ülke için müşteri sayısını hesaplar.
--GROUP BY: Ülke bazında gruplar, böylece her ülke için ayrı bir satır oluşturur.
--ORDER BY MüşteriSayısı DESC: Müşteri sayısına göre azalan sırada sıralar.
--LIMIT 1: Sadece en üstteki (en fazla müşterisi olan) kaydı döndürür

--Soru 19
SELECT 
    o.OrderID,
    COUNT(DISTINCT od.ProductID) AS FarkliUrunSayisi
FROM Orders o
JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY FarkliUrunSayisi DESC;

--Orders tablosu ile Order Details tablosunu OrderID alanı üzerinden birleştiriyoruz.

--COUNT ifadesi ile her siparişteki farklı ürün ID'lerini sayıyoruz.

--GROUP BY o.OrderID ile sonuçları sipariş numarasına göre grupluyoruz.

--ORDER BY FarkliUrunSayisi DESC ile en çok farklı ürün içeren siparişler üstte görünecek şekilde sıralıyoruz.


--Soru 20

SELECT 
    c.CategoryName AS KategoriAdı,
    AVG(p.UnitPrice) AS OrtalamaFiyat
FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY OrtalamaFiyat DESC;

--Categories tablosu ile Products tablosunu CategoryID alanı üzerinden birleştiriyoruz

--AVG(p.UnitPrice) fonksiyonu ile her kategorideki ürünlerin ortalama fiyatını hesaplıyoruz

--GROUP BY c.CategoryName ile sonuçları kategori adına göre grupluyoruz

--ORDER BY OrtalamaFiyat DESC ile en yüksek ortalama fiyata sahip kategoriler üstte görünecek şekilde sıralıyoruz


--Soru21

SELECT 
    YEAR(OrderDate) AS Yıl,
    MONTH(OrderDate) AS Ay,
    COUNT(OrderID) AS SiparişSayısı
FROM 
    Orders
GROUP BY 
    YEAR(OrderDate),
    MONTH(OrderDate)
ORDER BY 
    Yıl, Ay;

--YEAR(OrderDate) - Sipariş tarihinin yıl bilgisini alır

--MONTH(OrderDate) - Sipariş tarihinin ay numarasını alır (1-12)

--DATENAME(MONTH, OrderDate) - Ay adını yazılı olarak getirir (Ocak, Şubat vb.)

--COUNT(OrderID) - Her ay için sipariş sayısını hesaplar

--GROUP BY ile yıl, ay numarası ve ay adına göre gruplama yapılıyor


--Soru 22
SELECT 
    e.EmployeeID,
    e.FirstName + ' ' + e.LastName AS EmployeeName,
    COUNT(DISTINCT o.CustomerID) AS CustomerCount
FROM Employees e
LEFT JOIN Orders o ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID,e.FirstName,e.LastName
ORDER BY CustomerCount DESC;

--Employees tablosundan çalışan bilgilerini alıyoruz

--Orders tablosu ile LEFT JOIN yaparak çalışanların siparişlerini buluyoruz

--COUNT(DISTINCT o.CustomerID) ile her çalışanın ilgilendiği benzersiz müşteri sayısını hesaplıyoruz

--GROUP BY ile sonuçları çalışanlara göre grupluyoruz

--ORDER BY CustomerCount DESC ile en çok müşteriye sahip çalışanlar üstte görünecek şekilde sıralıyoruz


--Soru 23
SELECT c.CustomerID,c.CompanyName AS MüşteriAdı,c.ContactName,c.Phone
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL
ORDER BY c.CompanyName;

--Customers tablosundan tüm müşterileri seçiyoruz

--LEFT JOIN ile Orders tablosuna bağlanıyoruz (siparişi olmayan müşteriler de gelsin diye)

--WHERE o.OrderID IS NULL koşuluyla sadece sipariş tablosunda kaydı olmayan müşterileri filtreliyoruz

--Sonuçları müşteri adına göre sıralıyoruz


--Soru 24
SELECT TOP 5
    o.OrderID,
    c.CompanyName AS Müşteri,
    o.OrderDate,
    o.ShippedDate,
    o.Freight AS NakliyeMaliyeti,
    e.FirstName + ' ' + e.LastName AS SorumluPersonel,
    s.CompanyName AS NakliyeciFirma
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
JOIN Employees e ON o.EmployeeID = e.EmployeeID
LEFT JOIN Shippers s ON o.ShipVia = s.ShipperID
ORDER BY o.Freight DESC;

--Freight alanını DESC (büyükten küçüğe) sıralayarak en yüksek nakliye maliyetine sahip siparişleri başa alıyoruz

--Sipariş bilgilerini zenginleştirmek için ilgili tablolardan müşteri, çalışan ve nakliyeci bilgilerini join ile listeliyoruz

--LEFT JOIN kullanarak nakliyeci bilgisi olmayan siparişlerin de listelenmesini sağlıyoruz


















