---
layout: page
title: Databases and SQL
subtitle: Data Hygiene
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Explain what an atomic value is.
> *   Distinguish between atomic and non-atomic values.
> *   Explain why every value in a database should be atomic.
> *   Explain what a primary key is and why every record should have one.
> *   Identify primary keys in database tables.
> *   Explain why database entries should not contain redundant information.
> *   Identify redundant information in databases.

Now that we have seen how joins work,
we can see why the relational model is so useful
and how best to use it.

The first rule is that every value should be [atomic](reference.html#atomic),
i.e.,
not contain parts that we might want to work with separately.
For example, if we store a person's name, we should store personal and family names in separate columns instead of putting the entire name in one column so that we don't have to use substring operations to get the name's components.
More importantly, we store the two parts of the name separately because splitting on spaces is unreliable:
just think of a name like "Eloise St. Cyr" or "Jan Mikkel Steubart".

The second rule is that every record should have a unique primary key.
This can be a serial number that has no intrinsic meaning,
one of the values in the record (like the `ID` field in the `City` table),
or even a combination of values:
the pair `(countrycode, language)` from the `CountryLanguage` table uniquely identifies every record.

The third rule is that there should be no redundant information.
For example,
we could get rid of the `CountryLanguage` table and rewrite the `Country` table like this (showing only "New Zealand" here)

name  Continent   Region                      Population  LifeExpect  GNP      GovernmentForm           HeadOfState   Language    IsOfficial  Percentage
----  ----------  --------------------------  ----------  ----------  -------  -----------------------  ------------  ----------  ----------  ----------
NZL   Oceania     Australia and New Zealand   3862000     77.8        54669.0  Constitutional Monarchy  Elizabeth II  English     T           87.0      
NZL   Oceania     Australia and New Zealand   3862000     77.8        54669.0  Constitutional Monarchy  Elizabeth II  Maori       F           4.3  

In fact,
we could use a single table that recorded all the information about each reading in each row,
just as a spreadsheet would.
The problem is that it's very hard to keep data organized this way consistent:
if we realize that the date of a particular visit to a particular site is wrong,
we have to change multiple records in the database.
What's worse,
we may have to guess which records to change,
since other sites may also have been visited on that date.

The fourth rule is that the units for every value should be stored explicitly.
Our database doesn't do this, and that's a problem:
For example, `GNP` in `Country` table is given in unit of million dollars. New Zealand's GNP, 54669.0 must be interpreted as 54,669,000,000 dollars. However, it is not explicitly mandated and someone may enter a record in full amount instead of truncating six decimal places. We can guarantee the integrity of our data if this ever happens.

> ## Identifying Atomic Values {.challenge}
>
> Which of the following are atomic values? Which are not? Why?
>
> *   New Zealand
> *   87 Turing Avenue
> *   January 25, 1971
> *   the XY coordinate (0.5, 3.3)

> ## Identifying a Primary Key {.challenge}
>
> What is the primary key in this table?
> I.e., what value or combination of values uniquely identifies a record?
>
> |latitude|longitude|date      |temperature|
> |--------|---------|----------|-----------|
> |57.3    |-22.5    |2015-01-09|-14.2      |
