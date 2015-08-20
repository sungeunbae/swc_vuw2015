---
layout: page
title: Databases and SQL
subtitle: Setting Up
---

## Setup

For the SQL lessons, 
we will use the [SQLite](https://www.sqlite.org/) relational database management system, 
which comes pre-installed on most operating systems. 
While these instructions are specific to SQLite,
most other database management systems
(e.g. MySQL, Oracle, PostGreSQL)
have similar functions for loading data and performing basic operations.


First, download and install SQLite if it is not already installed on your operating system:

* Windows: Download the [SQLite program](https://github.com/swcarpentry/windows-installer/releases/download/v0.2/SWCarpentryInstaller.exe).
* Mac OS X: <code>sqlite3</code> comes pre-installed on Mac OS X.
* Linux: <code>sqlite3</code> comes pre-installed on Linux.

<!--
Create a directory where you will carry out the exercises for this lesson, and
change to it using the <code>cd</code> command. Download the file [world.db](http://files.software-carpentry.org/world.db) into this
directory.

    $ mkdir swc_sql 
    $ cd swc_sql
    $ wget http://files.software-carpentry.org/world.db

-->

First, load the example database into SQLite. 
On the shell command line, type

    sqlite3 world.db
    
This command instructs SQLite to load the database in the `world.db` file. The sample data used is © Statistics Finland [International tables], [2002] http://www.stat.fi/tup/kvportaali/pxweb_en.html

You should see something like the following.

    SQLite version 3.8.8 2015-01-16 12:08:06
    Enter ".help" for usage hints.
    sqlite>

For a list of useful system commands, enter <code>.help</code>.

All SQLite-specific commands are prefixed with a . to distinguish them from SQL commands. 
Type <code>.tables</code> to list the tables in the database. 

     sqlite> .tables
     City             Country          CountryLanguage  


Type the following SQL <code>SELECT</code> command. 
This <code>SELECT</code> statement selects all (*) rows from the Site table.

<code>select * from City;</code>

Complete your SQL statement with a semicolon.

     sqlite> select * from City;
     1|Kabul|AFG|Kabol|1780000
     2|Qandahar|AFG|Qandahar|237500
     3|Herat|AFG|Herat|186800
     4|Mazar-e-Sharif|AFG|Balkh|127800
     5|Amsterdam|NLD|Noord-Holland|731200
     6|Rotterdam|NLD|Zuid-Holland|593321
     7|Haag|NLD|Zuid-Holland|440900
     8|Utrecht|NLD|Utrecht|234323
     9|Eindhoven|NLD|Noord-Brabant|201843
     10|Tilburg|NLD|Noord-Brabant|193238
     11|Groningen|NLD|Groningen|172701
     ....


You can change some SQLite settings to make the output easier to read. 
First, 
set the output mode to display left-aligned columns. 
Then turn on the display of column headers.

    sqlite> .mode column
    sqlite> .header on
    sqlite> select * from City;
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
    11          Groningen   NLD          Groningen   172701 
    ....

You can adjust the width by `.width` command

    sqlite> .width 3 20 4 20 10
    sqlite> select * from City;
    ID   Name                  Coun  District              Population
    ---  --------------------  ----  --------------------  ----------
    1    Kabul                 AFG   Kabol                 1780000   
    2    Qandahar              AFG   Qandahar              237500    
    3    Herat                 AFG   Herat                 186800    
    4    Mazar-e-Sharif        AFG   Balkh                 127800    
    5    Amsterdam             NLD   Noord-Holland         731200    
    6    Rotterdam             NLD   Zuid-Holland          593321    
    7    Haag                  NLD   Zuid-Holland          440900    
    8    Utrecht               NLD   Utrecht               234323    
    9    Eindhoven             NLD   Noord-Brabant         201843    
    10   Tilburg               NLD   Noord-Brabant         193238 


To exit SQLite and return to the shell command line, 
you can use either `.quit` or `.exit`.


> ### Arrow keys NOT working?
> Arrow keys allow you to reuse the command you entered before and save typing
> Sometimes, the version of SQLite may not allow it. In such a case (in Linux), 
> try to run sqlite3 by `rlwrap sqlite3`.
