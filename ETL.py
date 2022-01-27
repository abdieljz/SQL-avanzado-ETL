#!/usr/bin/env python
# coding: utf-8

# In[1]:


#librerias

import sqlalchemy
from sqlalchemy import create_engine
from sqlalchemy import Table, Column, Integer, String, MetaData, ForeignKey
from sqlalchemy import inspect


# In[2]:


#Conectar el motor al archivo de la base de datos a usar
engine = create_engine('sqlite:///chinook.db')
engine


# # Extract

# In[3]:




metadata = MetaData()

# This method instantiates the tables that already 
# exist in the database, which the engine is connected to. 
metadata.create_all(engine)

# Checking this out, we can see the table structure and variable types for the employees table
inspector = inspect(engine)

# Checked out the columns in the employees table
inspector.get_columns('customers')



#Revisé las columnas en la tabla de Customers 


# # Transform

# In[4]:


#seleccionar todos los campos de la tabla Customers
with engine.connect() as con:
    
    rs = con.execute('SELECT * FROM customers')
    
    for row in rs:
        print(row)
        
con.close()



# In[5]:


#Proporcione una consulta que muestre el total de la factura, el nombre del cliente, el país y el nombre del agente de ventas para todas las facturas y clientes.
#Dyllan Raza
with engine.connect() as con: 
    rs = con.execute("""select emp.firstname as 'Nombre Empleado', emp.Lastname as 'Apellido Empleado', cust.Firstname as 'Nombre Cliente', cust.Lastname as 'Apellido Cliente', cust.Country, inv.Total
from employees as emp
	join customers as cust on emp.employeeid = cust.supportrepid
	join invoices as inv on cust.customerid = inv.customerid""")
    
    for row in rs:
        print(row)
        
con.close()


# # Load

# In[11]:


#Cargar a última query. Aquí debe utilizar un objeto dataframe 1
import pandas as pd
df = pd.read_sql_query("""select playlists.Name as Playlist, artists.Name as Artista, tracks.bytes as Bytes, albums.Title as Nombre_Album, media_types.Name as Formato, genres.Name as Genero 
From playlist_track
inner join artists on albums.ArtistId = artists.ArtistId
inner join albums on tracks.AlbumId = albums.AlbumId
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
inner join tracks on playlist_track.TrackId = tracks.TrackId
inner join playlists on playlist_track.PlaylistId = playlists.PlaylistId 
where tracks.Bytes > 7000000
Order By artists.Name;
    
    """, con=engine.connect())

df.head()


# In[ ]:


#Exportar el archivo en un formato a su elección.
df.to_csv('dataframe_Raza_Zambrano1.csv')


# In[13]:


#Cargar a última query. Aquí debe utilizar un objeto dataframe 2
import pandas as pd
df = pd.read_sql_query("""SELECT C.CUSTOMERID,
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
    
    """, con=engine.connect())

df.head()


# In[ ]:





# In[14]:


#Exportar el archivo en un formato a su elección.
df.to_csv('dataframe_Raza_Zambrano2.csv')




# In[15]:


#Cargar a última query. Aquí debe utilizar un objeto dataframe 2
import pandas as pd
df = pd.read_sql_query("""select customers.FirstName as Cliente, tracks.Name as Canción, albums.Title as Album, media_types.Name as Formato, genres.Name as Genero, invoices.BillingCity as Ciudad, Count(Quantity) as Cantidad
from invoice_items
inner join customers on invoices.CustomerId = customers.CustomerId 
inner join invoices on invoice_items.InvoiceId = invoices.InvoiceId
inner join tracks on invoice_items.TrackId = tracks.TrackId
inner join albums on tracks.AlbumId = albums.AlbumId
inner join media_types on tracks.MediaTypeId = media_types.MediaTypeId
inner join genres on tracks.GenreId = genres.GenreId
group by customers.FirstName
Having  genres.Name = "Metal";
    
    """, con=engine.connect())

df.head()


# In[16]:


#Exportar el archivo en un formato a su elección.
df.to_csv('dataframe_Raza_Zambrano3.csv')



# In[ ]:




