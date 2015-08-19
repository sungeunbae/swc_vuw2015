---
layout: page
title: Databases and SQL
subtitle: Missing Data
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Explain how databases represent missing information.
> *   Explain the three-valued logic databases use when manipulating missing information.
> *   Write queries that handle missing information correctly.

Real-world data is never complete --- there are always holes.
Databases represent these holes using a special value called `null`.
`null` is not zero, `False`, or the empty string;
it is a one-of-a-kind value that means "nothing here".
Dealing with `null` requires a few special tricks
and some careful thinking.

To start, let's have a look at what the following query returns.

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia";
~~~

Name                            Population  LifeExpectancy 
------------------------------  ----------  ---------------
American Samoa                  68000       75.1           
Cook Islands                    20000       71.1           
Niue                            2000                       
Pitcairn                        50                         
French Polynesia                235000      74.8           
Tokelau                         2000                       
Tonga                           99000       67.9           
Tuvalu                          12000       66.3           
Wallis and Futuna               15000                      
Samoa                           180000      69.2   


There are 10 records, but 4 records don't have LifeExpectancy --- or rather, they have null values.

Null doesn't behave like other values.
If we select the records with LifeExpectancy below 70:

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia" AND lifeexpectancy < 70;
~~~

Name                            Population  LifeExpectancy 
------------------------------  ----------  ---------------
Tonga                           99000       67.9           
Tuvalu                          12000       66.3           
Samoa                           180000      69.2

we get 3 results,
and if we select the ones with life expencanty higher than 70:

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia" AND lifeexpectancy >= 70;
~~~

Name                            Population  LifeExpectancy 
------------------------------  ----------  ---------------
American Samoa                  68000       75.1           
Cook Islands                    20000       71.1           
French Polynesia                235000      74.8   

we get 3,
but those records with null life expentancy aren't in either set of results.

The reason is that
`null< 70`
is neither true nor false:
null means, "We don't know,"
and if we don't know the value on the left side of a comparison,
we don't know whether the comparison is true or false.
Since databases represent "don't know" as null,
the value of `null< 70`
is actually `null`.
`null>=70` is also null
because we can't answer to that question either.
And since the only records kept by a `WHERE`
are those for which the test is true,
these 4 records aren't included in either set of results.

Comparisons aren't the only operations that behave this way with nulls.
`1+null` is `null`,
`5*null` is `null`,
`log(null)` is `null`,
and so on.
In particular,
comparing things to null with = and != produces null:

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia" AND lifeexpectancy = NULL;
~~~

produces no output, and neither does:

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia" AND lifeexpectancy != NULL;
~~~

To check whether a value is `null` or not,
we must use a special test `IS NULL`:

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia" AND lifeexpectancy IS NULL;
~~~

Name                            Population  LifeExpectancy 
------------------------------  ----------  ---------------
Niue                            2000                       
Pitcairn                        50                         
Tokelau                         2000                       
Wallis and Futuna               15000   

or its inverse `IS NOT NULL`:

~~~ {.sql}
SELECT name,population,lifeexpectancy FROM Country WHERE region="Polynesia" AND lifeexpectancy IS NOT NULL;
~~~

Name                            Population  LifeExpectancy 
------------------------------  ----------  ---------------
American Samoa                  68000       75.1           
Cook Islands                    20000       71.1           
French Polynesia                235000      74.8           
Tonga                           99000       67.9           
Tuvalu                          12000       66.3           
Samoa                           180000      69.2           
sqlite> 


Null values can cause headaches wherever they appear.
For example, from the next query result, we wish to find records that are not represented by "Elizabeth II" as the head of state.

~~~ {.sql}
SELECT name, headofstate FROM Country WHERE region="Antarctica";
~~~

Name                                                HeadOfState         
--------------------------------------------------  --------------------
Antarctica                                                              
French Southern territories                         Jacques Chirac      
Bouvet Island                                       Harald V            
Heard Island and McDonald Islands                   Elizabeth II        
South Georgia and the South Sandwich Islands        Elizabeth II     

It's natural to write the query like this:

~~~ {.sql}
SELECT name, headofstate FROM Country WHERE region="Antarctica" AND headofstate!="Elizabeth II";
~~~

Name                                                HeadOfState         
--------------------------------------------------  --------------------
French Southern territories                         Jacques Chirac      
Bouvet Island                                       Harald V 

but this query filters omits the record of Antactica because its head of state is `null` and 
the `!=` comparison produces `null`,
so the record isn't kept in our results.
If we want to keep these records
we need to add an explicit check:

~~~ {.sql}
SELECT name, headofstate FROM Country WHERE region="Antarctica" AND (headofstate!="Elizabeth II" OR headofstate IS NULL);
~~~

Name                                                HeadOfState         
--------------------------------------------------  --------------------
Antarctica                                                              
French Southern territories                         Jacques Chirac      
Bouvet Island                                       Harald V    


In contrast to arithmetic or Boolean operators, aggregation functions that combine multiple values, such as `min`, `max` or `avg`, *ignore* `null` values. In the majority of cases, this is a desirable output: for example, unknown values are thus not affecting our data when we are averaging it. Aggregation functions will be addressed in more detail in [the next section](06-agg.html).

> ## Sorting by Known Date {.challenge}
>
> Write a query that sorts the records of Polynesian countries (show name, population and life expectancy only) by life expectancy,
> omitting entries for which the life expectancy is not known
> (i.e., is null).

> ## NULL in a Set {.challenge}
>
> What do you expect the query:
>
> ~~~ {.sql}
> SELECT name, headofstate FROM Country WHERE region="Antarctica" AND headofstate IN ("Elizabeth II", NULL);
> ~~~
>
> to produce?
> What does it actually produce?

> ## Pros and Cons of Sentinels {.challenge}
>
> Some database designers prefer to use
> a [sentinel value](reference.html#sentinel-value))
> to mark missing data rather than `null`.
> For example,
> they will use -1.0 for missing life expectancy (since alcutal life expectancy cannot be negative)
> or "N/A" to mark a missing head of state
> What does this simplify?
> What burdens or risks does it introduce?
