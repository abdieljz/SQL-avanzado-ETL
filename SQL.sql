SELECT * FROM INVOICES; --facturas
SELECT * FROM ARTISTS;
SELECT * FROM ALBUMS;
SELECT * FROM TRACKS;   --pistas
SELECT * FROM INVOICE_ITEMS;
SELECT * FROM INVOICES;  --facturas
SELECT * FROM CUSTOMERS;  --clientes
SELECT * FROM EMPLOYEES;   -- empleados
SELECT * FROM PLAYLIST_TRACK;
SELECT * FROM PLAYLISTS;
SELECT * FROM MEDIA_TYPES;
SELECT * FROM GENRES;


--¿QUÉ ARTISTA HA GANADO MÁS SEGÚN LAS INVOICEITEMS?
--AHORA USA ESTE ARTISTA PARA ENCONTRAR QUÉ CLIENTE GASTÓ MÁS EN ESTE ARTISTA.
--PARA ESTA CONSULTA, DEBERÁ UTILIZAR LAS TABLAS FACTURA, INVOICELINE, TRACK, CUSTOMER, ALBUM Y ARTIST.
--TENGA EN CUENTA QUE ESTE ES COMPLICADO PORQUE EL TOTAL GASTADO EN LA TABLA FACTURA PODRÍA NO ESTAR EN UN SOLO PRODUCTO, POR LO QUE DEBE USAR LA TABLA INVOICELINE PARA AVERIGUAR CUÁNTOS DE CADA PRODUCTO SE COMPRARON Y LUEGO MULTIPLICAR ESTO POR EL PRECIO DE CADA ARTISTA.

SELECT Y.NAME AS ARTIST_NAME, SUM(TOTAL) AS GRAND_TOTAL
FROM (SELECT X.NAME, X.UNITPRICE * X.QUANTITY AS TOTAL
FROM (SELECT AR.NAME, IL.UNITPRICE, IL.QUANTITY, P.BILLINGCOUNTRY, C.COUNTRY, M.NAME AS TIPO
FROM ARTISTS AR
JOIN MEDIA_TYPES M ON T.MEDIATYPEID = M.MEDIATYPEID
JOIN ALBUMS AL ON AR.ARTISTID = AL.ARTISTID
JOIN TRACKS T ON AL.ALBUMID = T.ALBUMID
JOIN INVOICE_ITEMS IL ON T.TRACKID = IL.TRACKID
JOIN INVOICES P ON IL.INVOICEID = P.INVOICEID
JOIN CUSTOMERS C ON P.CUSTOMERID = C.CUSTOMERID
WHERE TIPO LIKE "PROTECTED MPEG-4 VIDEO FILE"
AND INVOICEDATE LIKE "2012%"
AND COUNTRY LIKE "USA"
ORDER BY 1 DESC) AS X) AS Y
GROUP BY 1
HAVING GRAND_TOTAL > 5
ORDER BY 2 DESC
LIMIT 4;

--LA SOLUCIÓN CONTINUÓ CON EL COMPRADOR SUPERIOR
--LUEGO, LOS PRINCIPALES COMPRADORES SE MUESTRAN EN LA TABLA A CONTINUACIÓN. EL CLIENTE CON EL MONTO TOTAL DE LA FACTURA MÁS ALTO ES EL CLIENTE 55, AC/DC

SELECT C.CUSTOMERID,
C.FIRSTNAME || ' ' || C.LASTNAME AS CUSTOMER,
AR.NAME AS ARTIST,
SUM(IL.UNITPRICE) AS PRICE,
G.NAME AS TYPE
FROM CUSTOMERS C
JOIN INVOICES I ON C.CUSTOMERID = I.CUSTOMERID
JOIN INVOICE_ITEMS IL ON I.INVOICEID = IL.INVOICEID
JOIN TRACKS T ON IL.TRACKID = T.TRACKID
JOIN GENRES G ON G.GENREID = T.GENREID
JOIN ALBUMS AL ON T.ALBUMID = AL.ALBUMID
JOIN ARTISTS AR ON AL.ARTISTID = AR.ARTISTID
WHERE AR.NAME = 'AC/DC'
AND TYPE LIKE "ROCK"
GROUP BY 1,2,3
HAVING PRICE > 2
ORDER BY 4 DESC
LIMIT 3;

--¿QUÉ AGENTE DE VENTAS TUVO MÁS VENTAS EN 2009? STEVE JOHNSON - $164.34

SELECT (EMPLOYEES.FIRSTNAME || " " || EMPLOYEES.LASTNAME) AS SALESREP, ROUND(SUM(INVOICES.TOTAL), 2) AS TOTALSALES
FROM EMPLOYEES
JOIN CUSTOMERS ON CUSTOMERS.SUPPORTREPID = EMPLOYEES.EMPLOYEEID
JOIN INVOICES ON INVOICES.CUSTOMERID = CUSTOMERS.CUSTOMERID
JOIN INVOICE_ITEMS IL ON INVOICES.INVOICEID = IL.INVOICEID
JOIN TRACKS T ON IL.TRACKID = T.TRACKID
JOIN MEDIA_TYPES AL ON AL.MEDIATYPEID = T.MEDIATYPEID
JOIN ALBUMS AB ON T.ALBUMID = AB.ALBUMID
WHERE STRFTIME('%Y', INVOICES.INVOICEDATE) = "2013"
AND QUANTITY LIKE "1"
AND AL.NAME LIKE "MPEG AUDIO FILE"
GROUP BY EMPLOYEES.FIRSTNAME
HAVING TOTALSALES > 1000
ORDER BY TOTALSALES DESC
LIMIT 1;

--REPLANTEAR
--OJO
--LA SOLUCIÓN CONTINUÓ CON EL COMPRADOR SUPERIOR
--LUEGO, LOS PRINCIPALES COMPRADORES SE MUESTRAN EN LA TABLA A CONTINUACIÓN. EL CLIENTE CON EL MONTO TOTAL DE LA FACTURA MÁS ALTO ES EL CLIENTE 55, AC/DC
SELECT * FROM INVOICES; --facturas
SELECT * FROM ARTISTS;
SELECT * FROM ALBUMS;
SELECT * FROM TRACKS;   --pistas
SELECT * FROM INVOICE_ITEMS;
SELECT * FROM INVOICES;  --facturas
SELECT * FROM CUSTOMERS;  --clientes
SELECT * FROM EMPLOYEES;   -- empleados
SELECT * FROM PLAYLIST_TRACK;
SELECT * FROM PLAYLISTS;
SELECT * FROM MEDIA_TYPES;
SELECT * FROM GENRES;

SELECT C.CUSTOMERID,
C.FIRSTNAME || ' ' || C.LASTNAME AS CUSTOMER,AR.NAME AS ARTIST,SUM(IL.UNITPRICE) AS PRICE, G.NAME AS GENERO ,MY.NAME AS TIPO
FROM CUSTOMERS C
JOIN INVOICES I ON C.CUSTOMERID = I.CUSTOMERID
JOIN INVOICE_ITEMS IL ON I.INVOICEID = IL.INVOICEID
JOIN TRACKS T ON IL.TRACKID = T.TRACKID
JOIN GENRES G ON G.GENREID = T.GENREID
JOIN ALBUMS AL ON T.ALBUMID = AL.ALBUMID
JOIN ARTISTS AR ON AL.ARTISTID = AR.ARTISTID
JOIN MEDIA_TYPES MY ON T.MEDIATYPEID = MY.MEDIATYPEID
GROUP BY 1,2,3
HAVING PRICE > 0
ORDER BY 4 desc
LIMIT 1;


-- REMPLANTEAR
-- OJO
--¿QUÉ AGENTE DE VENTAS TUVO MÁS VENTAS EN 2009? STEVE JOHNSON - $164.34

SELECT (EMPLOYEES.FIRSTNAME || " " || EMPLOYEES.LASTNAME) AS SALESREP, ROUND(SUM(INVOICES.TOTAL), 2) AS TOTALSALES
FROM EMPLOYEES
JOIN CUSTOMERS ON CUSTOMERS.SUPPORTREPID = EMPLOYEES.EMPLOYEEID
JOIN INVOICES ON INVOICES.CUSTOMERID = CUSTOMERS.CUSTOMERID
JOIN INVOICE_ITEMS IL ON INVOICES.INVOICEID = IL.INVOICEID
JOIN TRACKS T ON IL.TRACKID = T.TRACKID
JOIN MEDIA_TYPES AL ON AL.MEDIATYPEID = T.MEDIATYPEID
JOIN ALBUMS AB ON T.ALBUMID = AB.ALBUMID
WHERE INVOICES.INVOICEDATE BETWEEN '2009-00-00' AND '2013-00-00'
AND QUANTITY LIKE "1"
GROUP BY EMPLOYEES.FIRSTNAME
ORDER BY TOTALSALES ASC
LIMIT 3;