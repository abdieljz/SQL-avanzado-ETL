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

-- Genere una consulta que muestre solo los primeros 5 clientes  que hayan comprado discos tipo metal y de formato MPEG, también se debe mostrar
--el nombre del cliente, el disco que ha comprado, el álbum, la ciudad de compra y la cantidad correspondiente al disco comprado.
select customers.FirstName as Cliente, 
tracks.Name as Canción, 
albums.Title as Album, media_types.Name as Formato,
genres.Name as Genero, 
invoices.BillingCity as Ciudad, 
Count(Quantity) as Cantidad
from invoice_items
inner join customers on invoices.CustomerId = customers.CustomerId 
inner join invoices on invoice_items.InvoiceId = invoices.InvoiceId
inner join tracks on invoice_items.TrackId = tracks.TrackId
inner join albums on tracks.AlbumId = albums.AlbumId
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
group by customers.FirstName
Having  genres.Name = "Metal" LIMIT 5;

--Genere una consulta que busque las 5 primeras facturas que se han vendido mayores a $60, será necesario mostrar el nombre del artista
--el nombre del album, el compositor, el formato del track, el género, el total de costo de venta y el total de cantidad vendidas.
select artists.Name as Artista, 
        albums.Title as Album, 
        tracks.Composer as Compositor, 
        media_types.Name as Formato, 
        genres.Name as Genero, 
        sum(Total) as Total, 
        Count(Quantity) as Cantidad
from invoice_items
inner join artists on albums.ArtistId = artists.ArtistId
inner join albums on tracks.AlbumId = albums.AlbumId
inner join invoices on invoice_items.InvoiceId = invoices.InvoiceId
inner join tracks on invoice_items.TrackId = tracks.TrackId
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
group by artists.Name
Having sum(Total) > 60 LIMIT 5;

--Genere una conulta que busque busque las 3 primeras tracks que cuenten con un número de Bytes superior a 7000000, teniendo que mostrar los datos
-- del nombre de la canción, la playlist, el álbum, el forato, el género y nombre del artista
select playlists.Name as Playlist, 
        artists.Name as Artista, 
        tracks.bytes as Bytes, 
        albums.Title as Nombre_Album, 
        media_types.Name as Formato, 
        genres.Name as Genero 
From playlist_track
inner join artists on albums.ArtistId = artists.ArtistId
inner join albums on tracks.AlbumId = albums.AlbumId
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
inner join tracks on playlist_track.TrackId = tracks.TrackId
inner join playlists on playlist_track.PlaylistId = playlists.PlaylistId 
where tracks.Bytes > 7000000
Order By artists.Name LIMIT 3;

--Genere una consulta que muestre los 5 discos más vendidos en Alemania, para esto será necesario mostrar el nombre del comprador
-- El nombre del vendedor, el nombre del compositor, el formato de la canción, el género, el país de compra, el total de compra y la cantidad comprada.
select customers.FirstName as Nombre_Comprador, 
        employees.FirstName as Nombre_Vendedor, 
        tracks.Name as Compositor, 
        media_types.Name as Formato, 
        genres.Name as Genero, 
        invoices.BillingCountry, 
        sum(Total) as Total, Count(Quantity) as Cantidad
From invoice_items
inner join employees on customers.SupportRepId = employees.EmployeeId
inner join customers on invoices.CustomerId = customers.CustomerId
inner join invoices on invoice_items.InvoiceId = invoices.InvoiceId
inner join tracks on invoice_items.TrackId = tracks.trackid
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
Where invoices.BillingCountry LIKE 'Germany' 
group by invoices.InvoiceId order by sum(Total) DESC limit 5;

-- Genere una consulta que muestre el nombre del comprador, el nombre del vendedor, el compositor, el formato, el género, el país de compra, el total y la cantidad de compra
-- de los clientes que sean oriundos de Prague.
select customers.FirstName as Nombre_Comprador, 
        employees.FirstName as Nombre_Vendedor, 
        tracks.Name as Compositor, 
        media_types.Name as Formato, 
        genres.Name as Genero, 
        invoices.BillingCountry, 
        sum(Total) as Total, Count(Quantity) as Cantidad
From invoice_items
inner join employees on customers.SupportRepId = employees.EmployeeId
inner join customers on invoices.CustomerId = customers.CustomerId
inner join invoices on invoice_items.InvoiceId = invoices.InvoiceId
inner join tracks on invoice_items.TrackId = tracks.trackid
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
Where customers.City = 'Prague'
group by employees.FirstName;


--¿QUÉ ARTISTA HA GANADO MÁS SEGÚN LAS FACTURAS DETERMINADO EL QUÉ CLIENTE GASTÓ MÁS EN ESTE ARTISTA EN EL AÑO 2012 BAJO LA MODALIDAD DE VIDEO QUE SE VENDEN EN USA
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

-- DETERMINAR LOS 3 CLIENTES QUE MAS A COMPRADO DEL ARTISTA AC/DC QUE SEA MAYOR A 2$ EN EL GENERO ROCK, EL CUAL ESTA DE MODA LA CUAL DETERINARA 
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


-- DETERMINAR EL QUE MAS A COMPRADO, DETERMINANDO ASI QUE TIPO DE ARCHIVO ES EL MAS FACTIBLE PARA FUTURAS VENTAS JUNTAMENTE CON SU GENERO.

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

-- LISTA 10 GÉNEROS DE CANCIONES MÁS USADAS EN CHICAGO, BASADOS EN UN LISTA DE 10 
SELECT GENRES.GENREID, GENRES.NAME,TITLE,AR.NAME
FROM CUSTOMERS 
INNER  JOIN INVOICES ON CUSTOMERS.CUSTOMERID = INVOICES.CUSTOMERID
INNER  JOIN INVOICE_ITEMS ON INVOICES.INVOICEID=INVOICE_ITEMS.INVOICEID
INNER  JOIN TRACKS ON INVOICE_ITEMS.TRACKID=TRACKS.TRACKID
INNER  JOIN GENRES ON GENRES.GENREID=TRACKS.GENREID
INNER  JOIN ALBUMS AL ON TRACKS.ALBUMID = AL.ALBUMID
INNER  JOIN ARTISTS AR ON AL.ARTISTID = AR.ARTISTID
WHERE  CUSTOMERS.CITY="Chicago"
GROUP BY GENRES.NAME
ORDER BY GENRES.GENREID  DESC
LIMIT 10;


-- ¿QUIÉN ESTÁ ESCRIBIENDO LA MÚSICA ROCK?, PRESENTAR 3 QUE ESTAN EN LOS AÑOS 2009 Y 2010 BADADOS EN LS 3 PRIMEROS
SELECT  ARTISTS.NAME , COUNT(TRACKS.TRACKID) AS SONGS,UNITPRICE, BILLINGCOUNTRY
FROM ARTISTS
INNER  JOIN ALBUMS ON ARTISTS.ARTISTID = ALBUMS.ARTISTID
INNER  JOIN TRACKS ON TRACKS.ALBUMID=ALBUMS.ALBUMID
INNER  JOIN GENRES ON GENRES.GENREID=TRACKS.GENREID
INNER JOIN INVOICE_ITEMS ON INVOICE_ITEMS.TRACKID = TRACKS.TRACKID
INNER JOIN INVOICES ON INVOICES.INVOICEID =  INVOICE_ITEMS.INVOICEID
INNER JOIN CUSTOMERS ON  CUSTOMERS.CUSTOMERID = INVOICES.INVOICEID
WHERE GENRES.GENREID=1 --ROCK
AND INVOICES.INVOICEDATE BETWEEN '2009-01-01' AND '2010-12-31'
GROUP BY ARTISTS.ARTISTID
HAVING SONGS > 3
ORDER BY COUNT(TRACKS.TRACKID) DESC
LIMIT 3;