---
layout: page
title: Databases and SQL
subtitle: Sorting and Removing Duplicates
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Write queries that display results in a particular order.
> *   Write queries that eliminate duplicate values from data.

Data is often redundant,
so queries often return redundant information.
For example,
if we select the languages spoken in countries from the CountryLanguage table, 
we get this:

~~~ {.sql}
SELECT continent FROM Country;
~~~


|Continent    |
|-------------|
|North America|
|Asia         |
|Africa       |
|North America|
|Europe       |
|Europe       |
|North America|
|Asia         |
|South America|
|Asia         |
|Oceania      |
|Antarctica   |
|Antarctica   |
|North America|
|Oceania      |
|Europe       |
|Asia         |
|Africa       |
|Europe       |
|Africa       |
|Africa       |
|Asia         |
|Europe       |
|Asia         |
|North America|

...

We can eliminate the redundant output by adding the `DISTINCT` keyword
to our query:

~~~ {.sql}
SELECT DISTINCT continent FROM Country;
~~~

|Continent    |
|-------------|
|North America|
|Asia         |
|Africa       |
|Europe       |
|South America|
|Oceania      |
|Antarctica   |


If we want to determine which Region belongs to which Continent, 
we can use the `DISTINCT` keyword on multiple columns.
If we select more than one column,
the distinct *pairs* of values are returned:

~~~ {.sql}
SELECT DISTINCT continent,region FROM Country;
~~~

Continent        Region                        
---------------  ------------------------------
North America    Caribbean                     
Asia             Southern and Central Asia     
Africa           Central Africa                
Europe           Southern Europe               
Asia             Middle East                   
South America    South America                 
Oceania          Polynesia                     
Antarctica       Antarctica                    
Oceania          Australia and New Zealand     
Europe           Western Europe                
Africa           Eastern Africa                
Africa           Western Africa                
Europe           Eastern Europe                
North America    Central America               
North America    North America                 
Asia             Southeast Asia                
Africa           Southern Africa               
Asia             Eastern Asia                  
Europe           Nordic Countries              
Africa           Northern Africa               
Europe           Baltic Countries              
Oceania          Melanesia                     
Oceania          Micronesia                    
Europe           British Islands               
Oceania          Micronesia/Caribbean  

Notice in both cases that duplicates are removed
even if the rows they come from didn't appear to be adjacent in the database table.

> If "Region" data look truncated, such as
>

Continent        Region    
---------------  ----------
North America    Caribbean 
Asia             Southern a
Africa           Central Af
Europe           Southern E
Asia             Middle Eas
South America    South Amer
Oceania          Polynesia 
...

> specify the column width such as,
>
> ~~~{.sql}
> .width 15 30
> SELECT DISTINCT continent,region FROM Country;
> ~~~


Our next task is to study population of each country by looking at the `Country` table.
As we mentioned earlier,
database records are not stored in any particular order.
This means that query results aren't necessarily sorted,
and even if they are,
we often want to sort them in a different way,
e.g., by country code instead of by name.
We can do this in SQL by adding an `ORDER BY` clause to our query:

~~~ {.sql}
SELECT name, continent, population FROM Country ORDER BY name;
~~~

Name             Continent                       Population
---------------  ------------------------------  ----------
Afghanistan      Asia                            22720000  
Albania          Europe                          3401200   
Algeria          Africa                          31471000  
American Samoa   Oceania                         68000     
Andorra          Europe                          78000     
Angola           Africa                          12878000  
Anguilla         North America                   8000   
..

By default,
results are sorted in ascending order (i.e., from least to greatest).
We can sort in the opposite order using `DESC` (for "descending"):

~~~ {.sql}
SELECT name, continent, population FROM Country ORDER BY name DESC;
~~~~

Name             Continent                       Population
---------------  ------------------------------  ----------
Zimbabwe         Africa                          11669000  
Zambia           Africa                          9169000   
Yugoslavia       Europe                          10640000  
Yemen            Asia                            18112000  
Western Sahara   Africa                          293000    
Wallis and Futu  Oceania                         15000     
Virgin Islands,  North America                   93000   
~~~

(And if we want to make it clear that we're sorting in ascending order,
we can use `ASC` instead of `DESC`.)


We can also sort on several fields at once. For example, this query sorts results first in ascending order by `continent`,
and then in descending order by `population` within each group of equal `continent` values:

~~~ {.sql}
SELECT name, continent, population FROM Country ORDER BY continent ASC, population DESC;
~~~


Name             Continent                       Population
---------------  ------------------------------  ----------
Nigeria          Africa                          111506000 
Egypt            Africa                          68470000  
Ethiopia         Africa                          62565000  
Congo, The Demo  Africa                          51654000  
South Africa     Africa                          40377000  
Tanzania         Africa                          33517000  
Algeria          Africa                          31471000  
Kenya            Africa                          30080000  
...
China            Asia                            1277558000
India            Asia                            1013662000
Indonesia        Asia                            212107000 
Pakistan         Asia                            156483000 
Bangladesh       Asia                            129155000 
Japan            Asia                            126714000 
...
Russian Federat  Europe                          146934000 
Germany          Europe                          82164700  
United Kingdom   Europe                          59623400  
France           Europe                          59225700  
Italy            Europe                          57680000  
Ukraine          Europe                          50456000  
Spain            Europe                          39441700  
...
United States    North America                   278357000 
Mexico           North America                   98881000  
Canada           North America                   31147000  
Guatemala        North America                   11385000  
Cuba             North America                   11201000  
Dominican Repub  North America                   8495000   
...
Australia        Oceania                         18886000  
Papua New Guine  Oceania                         4807000   
New Zealand      Oceania                         3862000 
...
Brazil           South America                   170115000 
Colombia         South America                   42321000  
Argentina        South America                   37032000  
...


This query gives us a good idea of which country in which continent has what size of population.

> ### Find distinct government forms {.challenge}
> Write a query that selects distinct government form from the `Country` table. Order the output alphabetically.

> ### Displaying pairs of continent and government form {.challenge}
>
> Write a query that displays continent and government form from `Country` table ordered by continent then by government form.
> Remove duplicates from the output.

