---
layout: page
title: Databases and SQL
subtitle: Aggregation
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Define "aggregation" and give examples of its use.
> *   Write queries that compute aggregated values.
> *   Trace the execution of a query that performs aggregation.
> *   Explain how missing data is handled during aggregation.

We now want to calculate ranges and averages for our data.
Let's examine the output of the query.

~~~{.sql}
SELECT lifeexpectancy FROM country WHERE region="Polynesia";
~~~

|LifeExpectancy|
|--------------|
|75.1          |                
|71.1          |
|              |
|              |
|74.8          |
|              |
|67.9          |
|66.3          |
|              |
|69.2          |


but to combine them,
we must use an [aggregation function](reference.html#aggregation-function)
such as `min` or `max`.
Each of these functions takes a set of records as input,
and produces a single record as output:

~~~ {.sql}
SELECT min(lifeexpectancy) FROM country WHERE region="Polynesia";
~~~

|min(lifeexpectancy)|
|-------------------|
|66.3               |


<img src="fig/sql-aggregation.svg" alt="SQL Aggregation" />

~~~ {.sql}
SELECT max(lifeexpectancy) FROM country WHERE region="Polynesia";
~~~

|max(lifeexpectancy)|
|-------------------|
|75.1               |

`min` and `max` are just two of the aggregation functions built into SQL.
Three others are `avg`,`count`,and `sum`:

~~~ {.sql}
SELECT avg(lifeexpectancy) FROM country WHERE region="Polynesia";
~~~

|avg(lifeexpectancy)|
|-------------------|
|70.7333333333333   |

~~~{.sql}
SELECT count(lifeexpectancy) FROM country WHERE region="Polynesia";
~~~

|count(lifeexpectanc|
|-------------------|
|6                  |

We used `count(lifeexpectancy)` here.
Note that the records with null life expectancy were *ignored*. This is a very useful feature.
In fact, `avg(lifeexpectancy)` above was computed by adding all non-null values and division by 6.

If we counted other files like `name` or any other field in the table,
or even used `count(*)`, the result will be different

~~~{.sql}
SELECT count(*) FROM country WHERE region="Polynesia";
~~~

|count(*)           |
|-------------------|
|10                 |

~~~{.sql}
SELECT count(name) FROM country WHERE region="Polynesia";
~~~

|count(name)        |
|-------------------|
|10                 |



~~~ {.sql}
SELECT sum(lifeexpectancy) FROM country WHERE region="Polynesia";
~~~

|sum(lifeexpectancy)|
|-------------------|
|424.4              |


SQL lets us do several aggregations at once.
We can, for example, find the total population and average life expectancy in Polynesian countries.

~~~ {.sql}
SELECT sum(population),avg(lifeexpectancy) FROM country WHERE region="Polynesia";

sum(population)      avg(lifeex
-------------------  ----------
633050               70.7333333


We can also combine aggregated results with raw results,
although the output might surprise you:

~~~ {.sql}
SELECT name, sum(population),avg(lifeexpectancy) FROM country WHERE region="Polynesia";
~~~

Name                 sum(popula  avg(lifeexpecta
-------------------  ----------  ---------------
Samoa                633050      70.733333333333


Why does Samoa appear? 
The answer is that when it has to aggregate a field,
but isn't told how to, the database manager chooses a random value from the input set.

Another important fact is that when there are no values to aggregate --- for example, where there are no rows satisfying the `WHERE` clause ---
aggregation's result is "don't know"
rather than zero or some other arbitrary value:

~~~ {.sql}
SELECT name, sum(population),avg(lifeexpectancy) FROM country WHERE region="Polynesia" AND lifeexpectancy IS NULL;
~~~

Name                 sum(popula  avg(lifeexpecta
-------------------  ----------  ---------------
Wallis and Futuna    19050                      

Here, average life expectancy is all NULL because there was no values to aggregate.



Aggregating all records at once doesn't always make sense.
For example,
suppose Gina suspects that there is a systematic bias in her data,
and that some scientists' radiation readings are higher than others.
We know that this doesn't work:

~~~ {.sql}
SELECT person, count(reading), round(avg(reading), 2)
FROM  Survey
WHERE quant='rad';
~~~

|person|count(reading)|round(avg(reading), 2)|
|------|--------------|----------------------|
|roe   |8             |6.56                  |

because the database manager selects a single arbitrary scientist's name
rather than aggregating separately for each scientist.
Since there are only five scientists,
she could write five queries of the form:

~~~ {.sql}
SELECT person, count(reading), round(avg(reading), 2)
FROM  Survey
WHERE quant='rad'
AND   person='dyer';
~~~

person|count(reading)|round(avg(reading), 2)|
------|--------------|----------------------|
dyer  |2             |8.81                  |

but this would be tedious,
and if she ever had a data set with fifty or five hundred scientists,
the chances of her getting all of those queries right is small.

What we need to do is
tell the database manager to aggregate the hours for each scientist separately
using a `GROUP BY` clause:

~~~ {.sql}
SELECT   person, count(reading), round(avg(reading), 2)
FROM     Survey
WHERE    quant='rad'
GROUP BY person;
~~~

person|count(reading)|round(avg(reading), 2)|
------|--------------|----------------------|
dyer  |2             |8.81                  |
lake  |2             |1.82                  |
pb    |3             |6.66                  |
roe   |1             |11.25                 |

`GROUP BY` does exactly what its name implies:
groups all the records with the same value for the specified field together
so that aggregation can process each batch separately.
Since all the records in each batch have the same value for `person`,
it no longer matters that the database manager
is picking an arbitrary one to display
alongside the aggregated `reading` values.

Just as we can sort by multiple criteria at once,
we can also group by multiple criteria.
To get the average reading by scientist and quantity measured,
for example,
we just add another field to the `GROUP BY` clause:

~~~ {.sql}
SELECT   person, quant, count(reading), round(avg(reading), 2)
FROM     Survey
GROUP BY person, quant;
~~~

|person|quant|count(reading)|round(avg(reading), 2)|
|------|-----|--------------|----------------------|
|-null-|sal  |1             |0.06                  |
|-null-|temp |1             |-26.0                 |
|dyer  |rad  |2             |8.81                  |
|dyer  |sal  |2             |0.11                  |
|lake  |rad  |2             |1.82                  |
|lake  |sal  |4             |0.11                  |
|lake  |temp |1             |-16.0                 |
|pb    |rad  |3             |6.66                  |
|pb    |temp |2             |-20.0                 |
|roe   |rad  |1             |11.25                 |
|roe   |sal  |2             |32.05                 |

Note that we have added `quant` to the list of fields displayed,
since the results wouldn't make much sense otherwise.

Let's go one step further and remove all the entries
where we don't know who took the measurement:

~~~ {.sql}
SELECT   person, quant, count(reading), round(avg(reading), 2)
FROM     Survey
WHERE    person IS NOT NULL
GROUP BY person, quant
ORDER BY person, quant;
~~~

|person|quant|count(reading)|round(avg(reading), 2)|
|------|-----|--------------|----------------------|
|dyer  |rad  |2             |8.81                  |
|dyer  |sal  |2             |0.11                  |
|lake  |rad  |2             |1.82                  |
|lake  |sal  |4             |0.11                  |
|lake  |temp |1             |-16.0                 |
|pb    |rad  |3             |6.66                  |
|pb    |temp |2             |-20.0                 |
|roe   |rad  |1             |11.25                 |
|roe   |sal  |2             |32.05                 |

Looking more closely,
this query:

1.  selected records from the `Survey` table
    where the `person` field was not null;

2.  grouped those records into subsets
    so that the `person` and `quant` values in each subset
    were the same;

3.  ordered those subsets first by `person`,
    and then within each sub-group by `quant`;
    and

4.  counted the number of records in each subset,
    calculated the average `reading` in each,
    and chose a `person` and `quant` value from each
    (it doesn't matter which ones,
    since they're all equal).

> ## Counting Temperature Readings {.challenge}
>
> How many temperature readings did Frank Pabodie record,
> and what was their average value?

> ## Averaging with NULL {.challenge}
>
> The average of a set of values is the sum of the values
> divided by the number of values.
> Does this mean that the `avg` function returns 2.0 or 3.0
> when given the values 1.0, `null`, and 5.0?

> ## What Does This Query Do? {.challenge}
>
> We want to calculate the difference between
> each individual radiation reading
> and the average of all the radiation readings.
> We write the query:
>
> ~~~ {.sql}
> SELECT reading - avg(reading) FROM Survey WHERE quant='rad';
> ~~~
>
> What does this actually produce, and why?

> ## Ordering When Concatenating {.challenge}
>
> The function `group_concat(field, separator)`
> concatenates all the values in a field
> using the specified separator character
> (or ',' if the separator isn't specified).
> Use this to produce a one-line list of scientists' names,
> such as:
>
> ~~~ {.sql}
> William Dyer, Frank Pabodie, Anderson Lake, Valentina Roerich, Frank Danforth
> ~~~
>
> Can you find a way to order the list by surname?
