---
layout: page
title: Databases and SQL
subtitle: Python Programming with Databases
minutes: 20
---
> ## Learning Objectives {.objectives}
>
> *   Write short programs that execute SQL queries.
> *   Trace the execution of a program that contains an SQL query.
> *   Explain why most database applications are written in a general-purpose language rather than in SQL.

To close,
let's have a look at how to access a database from
a general-purpose programming language like Python.
Other languages use almost exactly the same model:
library and function names may differ,
but the concepts are the same.

Here's a short Python program that selects data from an SQLite database stored in a file called `world.db`:

~~~ {.python}
import sqlite3
connection = sqlite3.connect("world.db")
cursor = connection.cursor()
query = "SELECT * FROM Country WHERE region='Australia and New Zealand';"
cursor.execute(query)
results = cursor.fetchall()
for r in results:
    print r
    
cursor.close()
connection.close()
~~~
~~~ {.output}
(u'AUS', u'Australia', u'Oceania', u'Australia and New Zealand', 18886000, 79.8, 351182.0, u'Constitutional Monarchy, Federation', u'Elizabeth II')
(u'CCK', u'Cocos (Keeling) Islands', u'Oceania', u'Australia and New Zealand', 600, None, 0.0, u'Territory of Australia', u'Elizabeth II')
(u'CXR', u'Christmas Island', u'Oceania', u'Australia and New Zealand', 2500, None, 0.0, u'Territory of Australia', u'Elizabeth II')
(u'NFK', u'Norfolk Island', u'Oceania', u'Australia and New Zealand', 2000, None, 0.0, u'Territory of Australia', u'Elizabeth II')
(u'NZL', u'New Zealand', u'Oceania', u'Australia and New Zealand', 3862000, 77.8, 54669.0, u'Constitutional Monarchy', u'Elizabeth II')
~~~

The program starts by importing the `sqlite3` library.
If we were connecting to MySQL, DB2, or some other database,
we would import a different library,
but all of them provide the same functions,
so that the rest of our program does not have to change
(at least, not much)
if we switch from one database to another.

Line 2 establishes a connection to the database.
Since we're using SQLite,
all we need to specify is the name of the database file.
Other systems may require us to provide a username and password as well.
Line 3 then uses this connection to create a [cursor](reference.html#cursor).
Just like the cursor in an editor,
its role is to keep track of where we are in the database.

On line 5, we use that cursor to ask the database to execute a query for us.
The query is written in SQL,
and passed to `cursor.execute` as a string.
It's our job to make sure that SQL is properly formatted;
if it isn't,
or if something goes wrong when it is being executed,
the database will report an error.

The database returns the results of the query to us
in response to the `cursor.fetchall` call on line 6.
This result is a list with one entry for each record in the result set;
if we loop over that list (line 7) and print those list entries (line 8),
we can see that each one is a tuple
with one element for each field we asked for.

Finally, lines 9 and 10 close our cursor and our connection,
since the database can only keep a limited number of these open at one time.
Since establishing a connection takes time,
though,
we shouldn't open a connection,
do one operation,
then close the connection,
only to reopen it a few microseconds later to do another operation.
Instead,
it's normal to create one connection that stays open for the lifetime of the program.

Queries in real applications will often depend on values provided by users.
For example,
this function takes a country code as a parameter and returns the country name:

~~~ {.python}
import sqlite3
def get_country_name(database_file, country_code):
    query = "SELECT name FROM Country WHERE code='" + country_code + "';"
    connection = sqlite3.connect(database_file)
    print "Query:"+query
    cursor = connection.cursor()
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    connection.close()
    print "Country Code '"+country_code+"' is for "+results[0][0]

get_country_name('world.db', 'NZL')
get_country_name('world.db', 'AUS')
~~~

~~~ {.output}
Query:SELECT name FROM Country WHERE code='NZL';
Country Code 'NZL' is for New Zealand

Query:SELECT name FROM Country WHERE code='AUS';
Country Code 'AUS' is for Australia
~~~

We use string concatenation on the first line of this function
to construct a query containing the country code.

> ### Filling a Table vs. Printing Values {.challenge}
>
> Write a Python program that creates a new database in a file called
> `original.db` containing a single table called `Pressure`, with a
> single field called `reading`, and inserts 100,000 random numbers
> between 10.0 and 25.0.  How long does it take this program to run?
> How long does it take to run a program that simply writes those
> random numbers to a file?

> ### Filtering in SQL vs. Filtering in Python {.challenge}
>
> Write a Python program that creates a new database called
> `backup.db` with the same structure as `original.db` and copies all
> the values greater than 20.0 from `original.db` to `backup.db`.
> Which is faster: filtering values in the query, or reading
> everything into memory and filtering in Python?
