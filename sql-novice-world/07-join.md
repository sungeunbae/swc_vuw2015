---
layout: page
title: Databases and SQL
subtitle: Combining Data
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Explain the operation of a query that joins two tables.
> *   Explain how to restrict the output of a query containing a join to only include meaningful combinations of values.
> *   Write queries that join tables on equal keys.
> *   Explain what primary and foreign keys are, and why they are useful.

So far we left the `CountryLanguage` alone. Let's have a look at it.

~~~{.sql}
SELECT * FROM CountryLanguage LIMIT 10;
~~~~

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

This table gives languages spoken in each country. However, country name is not kept here. Each country is distingusied by `CountryCode`. Of course, we know this `CountryCode` matches `code` field in `Country` table.

~~~{.sql}
SELECT Code,Name FROM Country LIMIT 10;
~~~

Code        Name      
----------  ----------
ABW         Aruba     
AFG         Afghanista
AGO         Angola    
AIA         Anguilla  
ALB         Albania   
AND         Andorra   
ANT         Netherland
ARE         United Ara
ARG         Argentina 
ARM         Armenia   

To display the country name and the languages spoken by each contry, we need to combine these tables somehow.

The SQL command to do this is `JOIN`.
To see how it works,
let's start by joining the `Country` and `CountryLanguage` tables: 

(Press Ctrl+C as soon as you enter the following query)

~~~{.sql}
SELECT * FROM Country JOIN CountryLanguage;
~~~

This will produce enormous amount of output, which is omitted here.


`JOIN` creates the [cross product](reference.html#cross-product) of two tables,
i.e., it joins each record of one table with each record of the other table to give all possible combinations.
Since there are 239 records in `Country`
and 984 in `CountryLanguage`,
the join's output has 235,176 records (239 * 984 = 235,176).
And since `Country` table has 15 fields, and `CountryLanguage` table has 4 fields,
the output has 19 fields (15 + 4 = 19).

Let's only select relevant fields and select first 30 records.

~~~{.sql}
SELECT Country.code, Country.name, CountryLanguage.countrycode, CountryLanguage.language 
FROM Country 
JOIN CountryLanguage 
LIMIT 30;

~~~

Code  Name                            Coun  Language                      
----  ------------------------------  ----  ------------------------------
ABW   Aruba                           ABW   Dutch                         
ABW   Aruba                           ABW   English                       
ABW   Aruba                           ABW   Papiamento                    
ABW   Aruba                           ABW   Spanish                       
ABW   Aruba                           AFG   Balochi                       
ABW   Aruba                           AFG   Dari                          
ABW   Aruba                           AFG   Pashto                        
ABW   Aruba                           AFG   Turkmenian                    
ABW   Aruba                           AFG   Uzbek                         
ABW   Aruba                           AGO   Ambo                          
ABW   Aruba                           AGO   Chokwe                        
ABW   Aruba                           AGO   Kongo                         
ABW   Aruba                           AGO   Luchazi                       
ABW   Aruba                           AGO   Luimbe-nganguela              
ABW   Aruba                           AGO   Luvale                        
ABW   Aruba                           AGO   Mbundu                        
ABW   Aruba                           AGO   Nyaneka-nkhumbi               
ABW   Aruba                           AGO   Ovimbundu                     
ABW   Aruba                           AIA   English                       
ABW   Aruba                           ALB   Albaniana                     
ABW   Aruba                           ALB   Greek                         
ABW   Aruba                           ALB   Macedonian                    
ABW   Aruba                           AND   Catalan                       
ABW   Aruba                           AND   French                        
ABW   Aruba                           AND   Portuguese                    
ABW   Aruba                           AND   Spanish                       
ABW   Aruba                           ANT   Dutch                         
ABW   Aruba                           ANT   English                       
ABW   Aruba                           ANT   Papiamento                    
ABW   Aruba                           ARE   Arabic    


What the join *hasn't* done is
figure out if the records being joined have anything to do with each other.

It has no way of knowing whether they do or not until we tell it how.
To do that, we add a clause specifying that
we're only interested in combinations that have the same country code,
thus we need to use a filter:

~~~ {.sql}
SELECT Country.code, Country.name, CountryLanguage.countrycode, CountryLanguage.language 
FROM Country 
JOIN CountryLanguage ON Country.code=CountryLanguage.countrycode 
LIMIT 30;
~~~

Code  Name                            Coun  Language                      
----  ------------------------------  ----  ------------------------------
ABW   Aruba                           ABW   Dutch                         
ABW   Aruba                           ABW   English                       
ABW   Aruba                           ABW   Papiamento                    
ABW   Aruba                           ABW   Spanish                       
AFG   Afghanistan                     AFG   Balochi                       
AFG   Afghanistan                     AFG   Dari                          
AFG   Afghanistan                     AFG   Pashto                        
AFG   Afghanistan                     AFG   Turkmenian                    
AFG   Afghanistan                     AFG   Uzbek                         
AGO   Angola                          AGO   Ambo                          
AGO   Angola                          AGO   Chokwe                        
AGO   Angola                          AGO   Kongo                         
AGO   Angola                          AGO   Luchazi                       
AGO   Angola                          AGO   Luimbe-nganguela              
AGO   Angola                          AGO   Luvale                        
AGO   Angola                          AGO   Mbundu                        
AGO   Angola                          AGO   Nyaneka-nkhumbi               
AGO   Angola                          AGO   Ovimbundu                     
AIA   Anguilla                        AIA   English                       
ALB   Albania                         ALB   Albaniana                     
ALB   Albania                         ALB   Greek                         
ALB   Albania                         ALB   Macedonian                    
AND   Andorra                         AND   Catalan                       
AND   Andorra                         AND   French                        
AND   Andorra                         AND   Portuguese                    
AND   Andorra                         AND   Spanish                       
ANT   Netherlands Antilles            ANT   Dutch                         
ANT   Netherlands Antilles            ANT   English                       
ANT   Netherlands Antilles            ANT   Papiamento                    
ARE   United Arab Emirates            ARE   Arabic    

`ON` is very similar to `WHERE`,
and for all the queries in this lesson you can use them interchangeably.
There are differences in how they affect [outer joins][OUTER],
but that's beyond the scope of this lesson.
Once we add this to our query,
the database manager throws away records
that combined information about two different countires,
leaving us with just the ones we want.

Notice that we used `Table.field` to specify field names
in the output of the join.
We do this because tables can have fields with the same name,
and we need to be specific which ones we're talking about.

In this example, no two table have fields with the same name, 
so we can get the same result with `field` name alone.

~~~ {.sql}
SELECT code, name, countrycode,language 
FROM Country 
JOIN CountryLanguage ON code=countrycode 
LIMIT 30;
~~~

However, if we joined the `Country` and `City` tables, both tables have a field called `name`, and database manager 
can get confused, and will demand to use `Table.field` format to avoid ambiguity.

In fact, we can join any number of tables simply by adding more `JOIN` clauses to our query,
and more `ON` tests to filter out combinations of records that don't make sense:


~~~ {.sql}
SELECT country.name, city.name,language 
FROM Country 
JOIN City ON code=city.countrycode 
JOIN CountryLanguage ON code=countrylanguage.countrycode 
WHERE country.name="New Zealand";
~~~

Name                            Name                            Language                      
------------------------------  ------------------------------  ------------------------------
New Zealand                     Auckland                        English                       
New Zealand                     Auckland                        Maori                         
New Zealand                     Christchurch                    English                       
New Zealand                     Christchurch                    Maori                         
New Zealand                     Manukau                         English                       
New Zealand                     Manukau                         Maori                         
New Zealand                     North Shore                     English                       
New Zealand                     North Shore                     Maori                         
New Zealand                     Waitakere                       English                       
New Zealand                     Waitakere                       Maori                         
New Zealand                     Wellington                      English                       
New Zealand                     Wellington                      Maori                         
New Zealand                     Dunedin                         English                       
New Zealand                     Dunedin                         Maori                         
New Zealand                     Hamilton                        English                       
New Zealand                     Hamilton                        Maori                         
New Zealand                     Lower Hutt                      English                       
New Zealand                     Lower Hutt                      Maori  


We can tell which records from `Country`, `City`, and `CountryLanguage`
correspond with each otherbecause those tables contain [primary keys](reference.html#primary-key)
and [foreign keys](reference.html#foreign-key). A primary key is a value,
or combination of values, that uniquely identifies each record in a table.
A foreign key is a value (or combination of values) from one table
that identifies a unique record in another table.
Another way of saying this is that
a foreign key is the primary key of one table
that appears in some other table.
In our database,
`Country.code` is the primary key in the `Country` table,
while `City.countrycode` is a foreign key
relating the `City` table's entries
to entries in `Country`. (Note: We didn't use foreign keys when creating this db as it is disabled by default.)(https://www.sqlite.org/foreignkeys.html)

Most database designers believe that
every table should have a well-defined primary key.
They also believe that this key should be separate from the data itself,
so that if we ever need to change the data,
we only need to make one change in one place.
One easy way to do this is
to create an arbitrary, unique ID for each record
as we add it to the database.
This is actually very common:
those IDs have names like "student numbers" and "patient numbers",
and they almost always turn out to have originally been
a unique record identifier in some database system or other.
As the query below demonstrates,
SQLite [automatically numbers records][rowid] as they're added to tables,
and we can use those record numbers in queries:

~~~ {.sql}
SELECT rowid, * FROM CountryLanguage LIMIT 10;
~~~

rowid  CountryCod  Language                        IsOfficial  Percentage
-----  ----------  ------------------------------  ----------  ----------
1      ABW         Dutch                           T           5.3       
2      ABW         English                         F           9.5       
3      ABW         Papiamento                      F           76.7      
4      ABW         Spanish                         F           7.4       
5      AFG         Balochi                         F           0.9       
6      AFG         Dari                            T           32.1      
7      AFG         Pashto                          T           52.4      
8      AFG         Turkmenian                      F           1.9       
9      AFG         Uzbek                           F           8.8       
10     AGO         Ambo                            F           2.4  

> ## Listing primary languages {.challenge}
>
> Write a query that lists country name and the primary language (spoken by over 50% of its population. Use `percentage` field)

> ## Listing countries where English is official, but not popular {.challenge}
>
> Write a query that lists the name of countries where English is its official language but it is spoken less than 50% of its population. (use `isofficial` field, whose value is either "T" or "F")

> ## Reading Queries {.challenge}
>
> Describe in your own words what the following query produces:
>
> ~~~ {.sql}
> SELECT name, language, population, percentage*population/100 
> FROM Country 
> JOIN Countrylanguage ON code=countrycode 
> WHERE language LIKE "%Chinese%";
> ~~~

> ## Population of Chinese speakers {.challenge}
>
> Modify the query above and work out the world population of Chinese speakers.
> Can you also find the population of English speakers?


[OUTER]: http://en.wikipedia.org/wiki/Join_%28SQL%29#Outer_join
[rowid]: https://www.sqlite.org/lang_createtable.html#rowid

