---
layout: page
title: Databases and SQL
subtitle: Creating and Modifying Data
minutes: 30
---
> ## Learning Objectives {.objectives}
>
> *   Write statements that creates tables.
> *   Write statements to insert, modify, and delete records.

So far we have only looked at how to get information out of a database,
both because that is more frequent than adding information,
and because most other operations only make sense once queries are understood.
If we want to create and modify data,
we need to know two other sets of commands.

The first pair are [`CREATE TABLE`][CREATE-TABLE] and [`DROP TABLE`][DROP-TABLE].
While they are written as two words,
they are actually single commands.
The first one creates a new table;
its arguments are the names and types of the table's columns.
For example,
the following statements create the three tables in our world database:

~~~ {.sql}
CREATE TABLE `Country` (`Code` TEXT, `Name` TEXT, `Continent` TEXT,`Region` TEXT,`Population` INTEGER,
                        `LifeExpectancy` REAL,`GNP` REAL,`GovernmentForm` TEXT, `HeadOfState` TEXT);
CREATE TABLE `City` (`ID` INTEGER,`Name` TEXT,`CountryCode` TEXT,`District` TEXT,`Population` INTEGER);
CREATE TABLE `CountryLanguage` (`CountryCode` TEXT,`Language` TEXT, `IsOfficial` CHAR,`Percentage` REAL);
~~~

We can get rid of one of our tables using:

~~~ {.sql}
DROP TABLE CountryLanguage;
~~~

Be very careful when doing this:
most databases have some support for undoing changes,
but it's better not to have to rely on it.

Different database systems support different data types for table columns,
but most provide the following:

data type  use
---------  -----------------------------------------
INTEGER    a signed integer
REAL       a floating point number
TEXT       a character string
BLOB       a "binary large object", such as an image

Most databases also support Booleans and date/time values. An increasing number of databases also support geographic data types, such as latitude and longitude.
Keeping track of what particular systems do or do not offer, and what names they give different data types, is an unending portability headache.

When we create a table,
we can specify several kinds of constraints on its columns.
For example,
a better definition for the `CountryLanguage` table would be:

~~~ {.sql}
CREATE TABLE `CountryLanguage` (
  `CountryCode` TEXT NOT NULL DEFAULT '',
  `Language` TEXT NOT NULL DEFAULT '',
  `IsOfficial` CHAR NOT NULL DEFAULT 'F',
  `Percentage` REAL NOT NULL DEFAULT 0.0,
  PRIMARY KEY (`CountryCode`,`Language`)
  FOREIGN KEY(`CountryCode`) references Country(`Code`)
);
~~~

Once again,
exactly what constraints are available
and what they're called
depends on which database manager we are using.

Once tables have been created,
we can add, change, and remove records using our other set of commands,
`INSERT`, `UPDATE`, and `DELETE`.

Let's modify New Zealand language data.

~~~{.sql}
SELECT * FROM CountryLanguage WHERE countrycode='NZL';
~~~

CountryCode  Language   IsOfficial  Percentage
-----------  ---------  ----------  ----------
NZL          English    T           87.0      
NZL          Maori      F           4.3   

There are some issues. Maori and NZ Sign Language became New Zealand's official languages in 1987 and 2006, and this information need to be updated. 

According to the 2013 New Zealand Census, English is spoken by 96.14%, Maori by 3.73% and NZ Sign Language by 0.51%.
(https://en.wikipedia.org/wiki/Languages_of_New_Zealand)

Language 	 Number 	  Percentage
---------  ---------  ----------
English    3,819,969 	96.14
Maori 	   148,395 	  3.73 	
Samoan 	   86,403 	  2.17
Hindi 	   66,309 	  1.67
NZ Sign    20,235     0.51

Let's insert NZ Sign Language - The simplest form of `INSERT` statement lists values in order:

~~~{.sql}
INSERT INTO CountryLanguage values('NZL','NZ Sign Language','T', 0.51);
~~~

Similarly, we can insert Samoan and Hindi.

~~~ {.sql}
INSERT INTO CountryLanguage values('NZL','Samoan','F', 2.17);
INSERT INTO CountryLanguage values('NZL','Hindi','F', 1.67);
~~~

Modifying existing records is done using the `UPDATE` statement.
To do this we tell the database which table we want to update,
what we want to change the values to for any or all of the fields,
and under what conditions we should update the values.

For example, English speaking population has increased to 96.14% and Maori has decreased to 3.74%, but it has become an official language.

~~~ {.sql}
UPDATE CountryLanguage SET percentage=96.14 WHERE countrycode='NZL' AND language='English';
UPDATE CountryLanguage SET percentage=3.74, isofficial='T' WHERE countrycode='NZL' AND language='Maori';
~~~

Now, let's see the modified records.

~~~ {.sql}
SELECT * FROM CountryLanguage WHERE countrycode='NZL';
~~~

CountryCode  Language   IsOfficial  Percentage
-----------  ---------  ----------  ----------
NZL          English    T           96.14     
NZL          Hindi      F           1.67      
NZL          Maori      T           3.74      
NZL          NZ Sign L  T           0.51      
NZL          Samoan     F           2.17 



Be careful to not forget the `where` clause or the update statement will
modify *all* of the records in the database.


Deleting records can be a bit trickier,
because we have to ensure that the database remains internally consistent.
If all we care about is a single table,
we can use the `DELETE` command with a `WHERE` clause
that matches the records we want to discard.
For example,
if we wish to delete a country, we can remove from the `Country` table like this:

~~~ {.sql}
DELETE FROM Country WHERE code = 'NZL';
~~~

What is going to happen? Our `City` table would still contain a number of New Zealand cities and 
`CountryLanguage` table also have a few records related to New Zealand. 
This shouldn't happen because `Country.code` is a foreign key into the `City` table, and the `CountryLanguage` table,
and all our queries assume there will be a row in the `City` and `CountryLanguage` matching every value in the `Country`.

This problem is called [referential integrity](reference.html#referential-integrity):
we need to ensure that all references between tables can always be resolved correctly.
One way to do this is to delete all the records
that use `'NZL'` as a foreign key
before deleting the record that uses it as a primary key.
If our database manager supports it,
we can automate this
using [cascading delete](reference.html#cascading-delete).
However,
this technique is outside the scope of this chapter.


<!---
We can also insert values into one table directly from another:

~~~ {.sql}
CREATE TABLE JustLatLong(lat text, long text);
INSERT INTO JustLatLong SELECT lat, long FROM Site;
~~~
--->

> ### Hybrid Storage Models {.callout}
>
> Many applications use a hybrid storage model
> instead of putting everything into a database:
> the actual data (such as astronomical images) is stored in files,
> while the database stores the files' names,
> their modification dates,
> the region of the sky they cover,
> their spectral characteristics,
> and so on.
> This is also how most music player software is built:
> the database inside the application keeps track of the MP3 files,
> but the files themselves live on disk.

> ### Replacing NULL {.challenge}
>
> Write an SQL statement to replace all uses of `null` in
> `Country.headofstate` with the string `'unknown'`.

> ### Importing CSV {.challenge}
>
> If you have [CSV](reference.html#comma-separated-values) files, you can import the data using SQLite's CSV import feature.
>
> First, you need to create the table. You can enter the SQL commands for creating tables. Alternatively, you can execute `create_tables.sql` 
> (which already contains the SQL commands) by:
>
>~~~{.sql}
>.read create_tables.sql
>~~~
> Secondly, as we have created the table structure, the heading in csv file (first row) can be now removed. Delete
> the first line, and leave the data only.
>
> Thirdly, you need to set the mode to load CSV format correctly.
>
>~~~{.sql}
>.mode csv
>~~~
>
> Finally, import each CSV file into table.
>
>~~~{.sql}
>.import country.csv Country
>.import city.csv City
>.import countrylanguage.csv CountryLanguage
>~~~
>
> Note: Importing from CSV might have an issue in handling NULL values because an empty (ie. NULL) value in CSV is an empty string (ie. ""), 
> which might not be exactly what you expect. If we used [sentinel value](reference.html#sentinel-value))
> by marking missing data rather than `null`, such a problem can be avoided.

> ### Backing Up with SQL {.challenge}
>
> SQLite has several administrative commands that aren't part of the
> SQL standard.  One of them is `.dump`, which prints the SQL commands
> needed to re-create the database.  Another is `.read`, which reads a
> file created by `.dump` and restores the database.  A colleague of
> yours thinks that storing dump files (which are text) in version
> control is a good way to track and manage changes to the database.
> What are the pros and cons of this approach?  (Hint: records aren't
> stored in any particular order.)


[CREATE-TABLE]: https://www.sqlite.org/lang_createtable.html
[DROP-TABLE]: https://www.sqlite.org/lang_droptable.html
