---
layout: page
title: Databases and SQL
subtitle: Selecting Data
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Explain the difference between a table, a record, and a field.
> *   Explain the difference between a database and a database manager.
> *   Write a query to select all values for specific fields from a single table.

A [relational database](reference.html#relational-database)
is a way to store and manipulate information. 
Databases are arranged as [tables](reference.html#table).
Each table has columns (also known as [fields](reference.html#field)) that describe the data,
and rows (also known as [records](reference.html#record)) which contain the data.

When we are using a spreadsheet,
we put formulas into cells to calculate new values based on old ones.
When we are using a database,
we send commands
(usually called [queries](reference.html#query))
to a [database manager](reference.html#database-manager):
a program that manipulates the database for us.
The database manager does whatever lookups and calculations the query specifies,
returning the results in a tabular form
that we can then use as a starting point for further queries.

> ## Changing database managers {.callout}
>
> Every database manager --- Oracle,
> IBM DB2, PostgreSQL, MySQL, Microsoft Access, and SQLite --- stores
> data in a different way,
> so a database created with one cannot be used directly by another.
> However,
> every database manager can import and export data in a variety of formats, like .csv,
> so it *is* possible to move information from one to another.

Queries are written in a language called [SQL](reference.html#sql),
which stands for "Structured Query Language".
SQL provides hundreds of different ways to analyze and recombine data.
We will only look at a handful of queries,
but that handful accounts for most of what scientists do.

The tables below show the database we will use in our examples:

> **City**: Major cities in world
>

ID          Name        CountryCode  District    Population
----------  ----------  -----------  ----------  ----------
1           Kabul       AFG          Kabol       1780000   
2           Qandahar    AFG          Qandahar    237500    
3           Herat       AFG          Herat       186800    
4           Mazar-e-Sh  AFG          Balkh       127800    
5           Amsterdam   NLD          Noord-Holl  731200    
6           Rotterdam   NLD          Zuid-Holla  593321    
7           Haag        NLD          Zuid-Holla  440900    
8           Utrecht     NLD          Utrecht     234323    
9           Eindhoven   NLD          Noord-Brab  201843    
10          Tilburg     NLD          Noord-Brab  193238  
...

> **Country**: Countires in the world and their brief information
>

Code  Name                  Continent      Region                     Population  LifeExpect  GNP         GovernmentForm                  HeadOfState         
----  --------------------  -------------  -------------------------  ----------  ----------  ----------  ------------------------------  --------------------
ABW   Aruba                 North America  Caribbean                  103000      78.4        828.0       Nonmetropolitan Territory of T  Beatrix             
AFG   Afghanistan           Asia           Southern and Central Asia  22720000    45.9        5976.0      Islamic Emirate                 Mohammad Omar       
AGO   Angola                Africa         Central Africa             12878000    38.3        6648.0      Republic                        José Eduardo dos Sa
AIA   Anguilla              North America  Caribbean                  8000        76.1        63.2        Dependent Territory of the UK   Elizabeth II        
ALB   Albania               Europe         Southern Europe            3401200     71.6        3205.0      Republic                        Rexhep Mejdani      
AND   Andorra               Europe         Southern Europe            78000       83.5        1630.0      Parliamentary Coprincipality    Marc Forné Molné  
ANT   Netherlands Antilles  North America  Caribbean                  217000      74.7        1941.0      Nonmetropolitan Territory of T  Beatrix             
ARE   United Arab Emirates  Asia           Middle East                2441000     74.1        37966.0     Emirate Federation              Zayid bin Sultan al-
ARG   Argentina             South America  South America              37032000    75.1        340238.0    Federal Republic                Fernando de la Rúa 
ARM   Armenia               Asia           Middle East                3520000     66.4        1813.0      Republic                        Robert KotÂšarjan 
ASM   American Samoa        Oceania        Polynesia                  68000       75.1        334.0       US Territory                    George W. Bush      
ATA   Antarctica            Antarctica     Antarctica                 0                       0.0         Co-administrated                                    
ATF   French Southern terr  Antarctica     Antarctica                 0                       0.0         Nonmetropolitan Territory of F  Jacques Chirac 
...


> **CountryLanguage**: Language each country speaks
>

CountryCode  Language    IsOfficial  Percentage
-----------  ----------  ----------  ----------
ABW          Dutch       T           5.3       
ABW          English     F           9.5       
ABW          Papiamento  F           76.7      
ABW          Spanish     F           7.4       
AFG          Balochi     F           0.9       
AFG          Dari        T           32.1      
AFG          Pashto      T           52.4      
AFG          Turkmenian  F           1.9       
AFG          Uzbek       F           8.8       
AGO          Ambo        F           2.4
...


Notice that two entries have no data in `LifeExpectancy` column.

We'll return to these missing values [later](05-null.html).
For now, let's write an SQL query that displays Cities' names and country codes.
We do this using the SQL command `SELECT`,
giving it the names of the columns we want and the table we want them from.
Our query and its output look like this:

~~~ {.sql}
SELECT Name, CountryCode from City;
~~~

Name        CountryCode
----------  -----------
Kabul       AFG        
Qandahar    AFG        
Herat       AFG        
Mazar-e-Sh  AFG        
Amsterdam   NLD        
Rotterdam   NLD        
Haag        NLD        
Utrecht     NLD        
Eindhoven   NLD 
Tilburg     NLD   
....

The semicolon at the end of the query tells the database manager that the query is complete and ready to run.
As the example below shows, SQL is [case insensitive](reference.html#case-insensitive).

~~~ {.sql}
SeLeCt NaMe, CoUnTrYCoDe FrOm CiTy;
~~~
Name        CountryCode
----------  -----------
Kabul       AFG        
Qandahar    AFG        
Herat       AFG        
Mazar-e-Sh  AFG        
Amsterdam   NLD        
Rotterdam   NLD        
Haag        NLD        
Utrecht     NLD        
Eindhoven   NLD 
Tilburg     NLD   
...

You can use SQL's case insensitivity to your advantage. For instance, some people choose to write SQL keywords (such as `SELECT` and `FROM`) in capital letters and **field** and **table** names in lower case. This can make it easier to locate parts of an SQL statement. For instance, you can scan the statement, quickly locate the prominent `FROM` keyword and know the table name follows.
Whatever casing convention you choose,
please be consistent:
complex queries are hard enough to read without the extra cognitive load of random capitalization.
One convention is to use UPPER CASE for SQL statements, to distinguish them from tables and column
names. This is the convention that we will use for this lesson.

Going back to our query, you must have seen lots of output from the query.
To make it only print the first 10 lines, you can add `LIMIT 10` at the end of query.

~~~ {.sql}
SELECT Name, CountryCode from City LIMIT 10;
~~~
Name        CountryCode
----------  -----------
Kabul       AFG        
Qandahar    AFG        
Herat       AFG        
Mazar-e-Sh  AFG        
Amsterdam   NLD        
Rotterdam   NLD        
Haag        NLD        
Utrecht     NLD        
Eindhoven   NLD        
Tilburg     NLD  


it's important to understand that
the rows and columns in a database table aren't actually stored in any particular order.
They will always be *displayed* in some order,
but we can control that in various ways.
For example,
we could swap the columns in the output by writing our query as:

~~~ {.sql}
SELECT CountryCode, Name from City LIMIT 5;
~~~
CountryCode  Name      
-----------  ----------
AFG          Kabul     
AFG          Qandahar  
AFG          Herat     
AFG          Mazar-e-Sh
NLD          Amsterdam 

or even repeat columns:

~~~ {.sql}
SELECT Name,Name, Name from City LIMIT 10;
~~~

Name        Name        Name      
----------  ----------  ----------
Kabul       Kabul       Kabul     
Qandahar    Qandahar    Qandahar  
Herat       Herat       Herat     
Mazar-e-Sh  Mazar-e-Sh  Mazar-e-Sh
Amsterdam   Amsterdam   Amsterdam 

As a shortcut,
we can select all of the columns in a table using `*`:

~~~ {.sql}
SELECT * FROM City LIMIT 5;
~~~

ID          Name        CountryCode  District    Population
----------  ----------  -----------  ----------  ----------
1           Kabul       AFG          Kabol       1780000   
2           Qandahar    AFG          Qandahar    237500    
3           Herat       AFG          Herat       186800    
4           Mazar-e-Sh  AFG          Balkh       127800    
5           Amsterdam   NLD          Noord-Holl  731200    

> ## Selecting Site Names {.challenge}
>
> Write a query that selects only Continent names from the `Country` table.

> ## Query Style {.challenge}
>
> Many people format queries as:
>
> ~~~
> SELECT code, name FROM country;
> ~~~
>
> or as:
>
> ~~~
> select Code, Name from COUNTRY ;
> ~~~
>
> What style do you find easiest to read, and why?

~~~{.sql}
select Name, Region, Governmentform from COUNTRY limit 10;
~~~

Name        Region      GovernmentForm                              
----------  ----------  --------------------------------------------
Aruba       Caribbean   Nonmetropolitan Territory of The Netherlands
Afghanista  Southern a  Islamic Emirate                             
Angola      Central Af  Republic                                    
Anguilla    Caribbean   Dependent Territory of the UK               
Albania     Southern E  Republic                                    
Andorra     Southern E  Parliamentary Coprincipality                
Netherland  Caribbean   Nonmetropolitan Territory of The Netherlands
United Ara  Middle Eas  Emirate Federation                          
Argentina   South Amer  Federal Republic                            
Armenia     Middle Eas  Republic       

In `column` mode, we have a fixed width for a column and some text may be seen truncated. Don't worry, it is just a display issue - data is still there.
We can use `.width` to fix. We will give width of 25, 30 and 50 to each column.

~~~{.sql}
.width 25 30 50
select name, region, governmentform from country limit 10;
~~~

Name                       Region                          GovernmentForm                                    
-------------------------  ------------------------------  --------------------------------------------------
Aruba                      Caribbean                       Nonmetropolitan Territory of The Netherlands      
Afghanistan                Southern and Central Asia       Islamic Emirate                                   
Angola                     Central Africa                  Republic                                          
Anguilla                   Caribbean                       Dependent Territory of the UK                     
Albania                    Southern Europe                 Republic                                          
Andorra                    Southern Europe                 Parliamentary Coprincipality                      
Netherlands Antilles       Caribbean                       Nonmetropolitan Territory of The Netherlands      
United Arab Emirates       Middle East                     Emirate Federation                                
Argentina                  South America                   Federal Republic                                  
Armenia                    Middle East                     Republic     


