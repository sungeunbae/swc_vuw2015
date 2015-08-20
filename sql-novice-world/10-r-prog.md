---
layout: page
title: Databases and SQL
subtitle: R Programming with Databases
minutes: 20
---
> ## Learning Objectives {.objectives}
>
> *   Write short programs that execute SQL queries.
> *   Trace the execution of a program that contains an SQL query.
> *   Explain why most database applications are written in a general-purpose language rather than in SQL.

To close,
let's have a look at how to access a database from
a general-purpose programming language like R.
Other languages use almost exactly the same model:
library and function names may differ,
but the concepts are the same.

Here's a short R program that selects data from an SQLite database stored in a file called `world.db`:

~~~ {.r}
library(RSQLite)
db<-dbConnect(SQLite(),dbname="world.db")
query <- "SELECT * FROM Country WHERE region='Australia and New Zealand';"
raw_results<-dbSendQuery(conn=db, query)
results<- fetch(raw_results)
dbClearResult(raw_results)
print(results)
dbDisconnect(db)
~~~

~~~ {.output}
  Code                    Name Continent                    Region Population LifeExpectancy    GNP                      GovernmentForm
1  AUS               Australia   Oceania Australia and New Zealand   18886000           79.8 351182 Constitutional Monarchy, Federation
2  CCK Cocos (Keeling) Islands   Oceania Australia and New Zealand        600             NA      0              Territory of Australia
3  CXR        Christmas Island   Oceania Australia and New Zealand       2500             NA      0              Territory of Australia
4  NFK          Norfolk Island   Oceania Australia and New Zealand       2000             NA      0              Territory of Australia
5  NZL             New Zealand   Oceania Australia and New Zealand    3862000           77.8  54669             Constitutional Monarchy
   HeadOfState
1 Elizabeth II
2 Elizabeth II
3 Elizabeth II
4 Elizabeth II
5 Elizabeth II
~~~

The program starts by importing the `RSQLite` library.
If we were connecting to MySQL, DB2, or some other database, we would import a different library,
but all of them provide the same functions,so that the rest of our program does not have to change (at least, not much)
if we switch from one database to another.

Line 2 establishes a connection to the database. 
Since we're using SQLite, all we need to specify is the name of the database file.
Other systems may require us to provide a username and password as well.
On line 3, we create a SQL query, and passed to `dbSendQuery` as a string on line 4.
It's our job to make sure that SQL is properly formatted;
if it isn't, or if something goes wrong when it is being executed,
the database will report an error.
`dbSendQuery` executes a query for us, and returns a SQLiteResult object. We extract readable output from it by `fetch()` on line 5.
`dbClearResult` frees all resources associated with `results`. 
Finally, lines 7 closes our connection,
since the database can only keep a limited number of these open at one time.
Since establishing a connection takes time,
though,
we shouldn't open a connection,
do one operation,
then close the connection,
only to reopen it a few microseconds later to do another operation.
Instead,
it's normal to create one connection that stays open for the lifetime of the program.

Instead of using `dbSendQuery()` followed by `fetch()` and `dbClearResult()`, we can use
`dbGetQuery`, such as:

~~~ {.r}
library(RSQLite)
db<-dbConnect(SQLite(),dbname="world.db")
query <- "SELECT * FROM Country WHERE region='Australia and New Zealand';"
results<-dbGetQuery(conn=db, query)
print(results)
dbDisconnect(db)
~~~



Queries in real applications will often depend on values provided by users.
For example,
this function takes a country code as a parameter and returns the country name:

~~~ {.r}
get_country_name <- function(database_file, country_code) {
  require(RSQLite)
  db<-dbConnect(SQLite(),dbname=database_file)
  query <-  paste0("SELECT name FROM Country WHERE code='",country_code,"';")
  print(paste0("Query:",query))
  results<-dbGetQuery(conn=db, query)
  print(paste0("Country Code '",country_code,"' is for ",results))
  dbDisconnect(db)
}

get_country_name('world.db', 'NZL')
get_country_name("world.db","AUS")
~~~

~~~ {.output}
> get_country_name('world.db', 'NZL')
[1] "Query:SELECT name FROM Country WHERE code='NZL';"
[1] "Country Code 'NZL' is for New Zealand"
[1] TRUE
> get_country_name("world.db","AUS")
[1] "Query:SELECT name FROM Country WHERE code='AUS';"
[1] "Country Code 'AUS' is for Australia"
[1] TRUE
~~~

We use string concatenation using `paste0(str1,str2,...)`on line 3 of this function
to construct a query containing the country code.

> ## Filling a Table vs. Printing Values {.challenge}
>
> Write a R program that creates a new database in a file called
> `original.db` containing a single table called `Pressure`, with a
> single field called `reading`, and inserts 100,000 random numbers
> between 10.0 and 25.0.  How long does it take this program to run?
> How long does it take to run a program that simply writes those
> random numbers to a file?

> ## Filtering in SQL vs. Filtering in R {.challenge}
>
> Write a R program that creates a new database called
> `backup.db` with the same structure as `original.db` and copies all
> the values greater than 20.0 from `original.db` to `backup.db`.
> Which is faster: filtering values in the query, or reading
> everything into memory and filtering in R?
