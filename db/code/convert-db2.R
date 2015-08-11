setwd('/home/seb56/swc/swc_vuw2015/db')
filename <- "/home/seb56/swc/swc_vuw2015/db/data/bibliography.csv"
bibData <- read.csv(file=filename, header=FALSE,sep=",")
library(sqldf)

db<-dbConnect(SQLite(),dbname="Bibliography_sqldf.sqlite")
CREATE = 'create table data(key text not null, author text not null);'
dbSendQuery(conn=db, CREATE)

INSERT <- "insert into data values(\"%s\",\"%s\");"
for (i in 1:nrow(bibData)) {
  key<-bibData[i,1]
  authors<-strsplit(as.character(bibData[i,4]),"; ")[[1]]
  if (length(authors)==0) {
    authors<-c('')
  }
  for (author in authors) {
    cmd<-sprintf(INSERT,key,author)
    dbSendQuery(conn=db,cmd)
  }  
}

dbDisconnect(db)
