## DB file format ##
   a. the db file is named as "db-(table name)-(project).csv
   b. the line which begins with '#' is ignored
   c. the index line begins with '!'
   d. the column whose name has '!' will be primary key (defalut is 'id' but multiple keys are allowed)
   e. if there is db file having the field name in its own file name, it is treated as forign key (referenced field name should be 'id')
   f. if the filed name includes the table name in bracket, the bracket will be removed and set the table name as forign key  

## Exported CSV file ##
   You can generate the db files from exported file of spread sheet.
   The format of the exported file is,
   a. the fist column of index will have '%'
   b. each line will be splitted into the sorted dbs based on the first column
   c. the fist column is removed in the sorted db
   d. index line will be stored into /utils/db/db-(table).csv

## Procedure for translation from csv to sqlite3 ##
 1. export csv file from spread sheet as exp-db (exp-teble.csv)
 2. split the exp-db into files that sorted by projects which is stored in /cfg.(project) directory (db-split)
 3. register the db files (link to /db directory) (file-register)
 4. update sqlite3 rdb (upd-db) 
