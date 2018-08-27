## README

### DB connection info

```r
con <- dbConnect(dbDriver("MySQL"), host = "192.168.2.233", dbname = "mysql", user = "mysql", password = "ntels123")
dbListTables(con)
```