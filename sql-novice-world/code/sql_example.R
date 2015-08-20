#setwd("/home/seb56/swc/swc_vuw2015/sql-novice-world/data") #set the directory where world.db is stored.

library(RSQLite)
db<-dbConnect(SQLite(),dbname="world.db")
query <- "SELECT * FROM Country WHERE region='Australia and New Zealand';"
raw_results<-dbSendQuery(conn=db, query)
results<- fetch(raw_results)
dbClearResult(raw_results)
print(results)
dbDisconnect(db)


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
