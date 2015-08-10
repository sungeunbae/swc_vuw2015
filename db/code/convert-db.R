filename <- "/home/seb56/swc/swc_vuw2015/db/data/bibliography.csv"
bibData <- read.csv(file=filename, header=FALSE,sep=",")

CREATE = 'create table data(key text not null, author text not null);'
cat(CREATE,sep="\n")

INSERT <- "insert into data values(\"%s\",\"%s\");"
for (i in 1:nrow(bibData)) {
  key<-bibData[i,1]
  authors<-strsplit(as.character(bibData[i,4]),"; ")[[1]]
  for (j in 1:length(authors)) {
    cat(sprintf(INSERT,key,authors[j]),sep="\n")
  }
}
