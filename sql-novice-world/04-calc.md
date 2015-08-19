---
layout: page
title: Databases and SQL
subtitle: Calculating New Values
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Write queries that calculate new values for each selected record.

The world data has been compiled by Statistics Finland, apparently in early 2000s. What was the average income in some countries back then?

Let's start with the following query.

~~~{.sql}
SELECT name,gnp,population FROM Country WHERE name in ("New Zealand","Australia","United Kingdom","Canada","United States");
~~~

Name                  GNP         Population
--------------------  ----------  ----------
Australia             351182.0    18886000  
Canada                598862.0    31147000  
United Kingdom        1378330.0   59623400  
New Zealand           54669.0     3862000   
United States         8510700.0   278357000 


We can calculate GNP per capita (ie. GNP divided by Population) and we can do this calculation on the fly as part of our query.

~~~{.sql}
SELECT name,gnp,population,gnp/population FROM Country WHERE name in ("New Zealand","Australia","United Kingdom","Canada","United States");
~~~

Name                  GNP                   Population  gnp/population                
--------------------  --------------------  ----------  ------------------------------
Australia             351182.0              18886000    0.0185948321507995            
Canada                598862.0              31147000    0.0192269560471313            
United Kingdom        1378330.0             59623400    0.0231172660398434            
New Zealand           54669.0               3862000     0.0141556188503366            
United States         8510700.0             278357000   0.0305747654989815   

This looks somewhat strange. It appears figures in GNP are in million dollars (ie. 6 zeros). Let's multiply by 1,000,000 to get the GNP per capita.

~~~{.sql}
SELECT name,gnp,population,gnp/population*1000000 FROM Country WHERE name in ("New Zealand","Australia","United Kingdom","Canada","United States");
~~~

Name                  GNP                   Population  gnp/population*1000000        
--------------------  --------------------  ----------  ------------------------------
Australia             351182.0              18886000    18594.8321507995              
Canada                598862.0              31147000    19226.9560471313              
United Kingdom        1378330.0             59623400    23117.2660398434              
New Zealand           54669.0               3862000     14155.6188503366              
United States         8510700.0             278357000   30574.7654989815   

When we run the query,
the expression `gnp/populatioon*1000000` is evaluated for each row.
Expressions can use any of the fields, all of usual arithmetic operators,and a variety of common functions.
(Exactly which ones depends on which database manager is being used.)
For example,we can round to two decimal places

~~~ {.sql}
SELECT name,gnp,population,round(gnp/population*1000000,2) FROM Country WHERE name in ("New Zealand","Australia","United Kingdom","Canada","United States");
~~~

Name                  GNP                   Population  round(gnp/population*1000000,2
--------------------  --------------------  ----------  ------------------------------
Australia             351182.0              18886000    18594.83                      
Canada                598862.0              31147000    19226.96                      
United Kingdom        1378330.0             59623400    23117.27                      
New Zealand           54669.0               3862000     14155.62                      
United States         8510700.0             278357000   30574.77     

We can give a better name for this new column simply by placing a new name.

~~~{.sql}
SELECT name,gnp,population,round(gnp/population*1000000,2) GNP_per_capita FROM Country WHERE name in ("New Zealand","Australia","United Kingdom","Canada","United States");
~~~

Name                  GNP                   Population  GNP_per_capita                
--------------------  --------------------  ----------  ------------------------------
Australia             351182.0              18886000    18594.83                      
Canada                598862.0              31147000    19226.96                      
United Kingdom        1378330.0             59623400    23117.27                      
New Zealand           54669.0               3862000     14155.62                      
United States         8510700.0             278357000   30574.77      

We can also combine values from different fields,
for example by using the string concatenation operator `||`:

~~~ {.sql}
SELECT name || ',' || continent, population FROM Country WHERE name LIKE "N%";
~~~

name || ',' || continent                  Population
----------------------------------------  ----------
Netherlands Antilles,North America        217000    
Northern Mariana Islands,Oceania          78000     
Namibia,Africa                            1726000   
New Caledonia,Oceania                     214000    
Niger,Africa                              10730000  
Norfolk Island,Oceania                    2000      
Nigeria,Africa                            111506000 
Nicaragua,North America                   5074000   
Niue,Oceania                              2000      
Netherlands,Europe                        15864000  
Norway,Europe                             4478500   
Nepal,Asia                                23930000  
Nauru,Oceania                             12000     
New Zealand,Oceania                       3862000   
North Korea,Asia                          24039000  



> ## Converting to New Zealand dollar {.challenge}
>
> GNP per capita we computed was in US dollar. In November 2000, about the time this data was compiled, NZD/USD exchange rate dropped to historic low 0.39. 
> Modify the query for GNP per capita to output the amount in NZD using this exchange rate.

> ## Unions {.challenge}
>
> The `UNION` operator combines the results of two queries:
>
> ~~~ {.sql}
> SELECT * FROM City WHERE CountryCode="NZL" UNION SELECT * FROM City WHERE CountryCode="AUS";
> ~~~
>

ID                    Name                  CountryCod  District                        Population
--------------------  --------------------  ----------  ------------------------------  ----------
130                   Sydney                AUS         New South Wales                 3276207
131                   Melbourne             AUS         Victoria                        2865329
132                   Brisbane              AUS         Queensland                      1291117
133                   Perth                 AUS         West Australia                  1096829
134                   Adelaide              AUS         South Australia                 978100
135                   Canberra              AUS         Capital Region                  322723
136                   Gold Coast            AUS         Queensland                      311932
137                   Newcastle             AUS         New South Wales                 270324
138                   Central Coast         AUS         New South Wales                 227657
139                   Wollongong            AUS         New South Wales                 219761
140                   Hobart                AUS         Tasmania                        126118
141                   Geelong               AUS         Victoria                        125382
142                   Townsville            AUS         Queensland                      109914
143                   Cairns                AUS         Queensland                      92273
3494                  Auckland              NZL         Auckland                        381800
3495                  Christchurch          NZL         Canterbury                      324200
3496                  Manukau               NZL         Auckland                        281800
3497                  North Shore           NZL         Auckland                        187700
3498                  Waitakere             NZL         Auckland                        170600
3499                  Wellington            NZL         Wellington                      166700
3500                  Dunedin               NZL         Dunedin                         119600
3501                  Hamilton              NZL         Hamilton                        117100
3502                  Lower Hutt            NZL         Wellington                      98100

> Use `UNION` to create a consolidated list of name and region of countries in Melanesia and Micronesia.
> The output should be something like:
>

name                                 region              
-----------------------------------  --------------------
Fiji Islands                         Melanesia           
Guam                                 Micronesia          
Kiribati                             Micronesia          
Marshall Islands                     Micronesia          
Micronesia, Federated States of      Micronesia          
Nauru                                Micronesia          
New Caledonia                        Melanesia           
Northern Mariana Islands             Micronesia          
Palau                                Micronesia          
Papua New Guinea                     Melanesia           
Solomon Islands                      Melanesia           
Vanuatu                              Melanesia    
