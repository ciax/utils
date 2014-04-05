## CSV DB file format ##
   a. the db file is named as "db-(table name)-(project).csv
   b. the line which begins with '#' is ignored
   c. the index line begins with '!'
   d. the field whose name has '!' will be primary key (defalut is 'id' but multiple keys are allowed)
   e. if there is db file whose name includes the field name,
      the field is treated as forign key (default reference key is 'id')
   f. the refenece table/key can be specifyed by attaching "(table:key)" to the field name

## Exported CSV file ##
   You can generate the db files from exported file of spread sheet.
   This exported file can be splitted into db files by project.
   The format of the exported file is,
   a. the fist column of index will have '%' which contains project
   b. each line will be splitted into the sorted dbs based on the first column
   c. the fist column is removed in the sorted db
   d. index line will be stored into ~/utils/db/db-(table).csv
   e. the sorted dbs will be stored into ~/cfg.(project)/db

## Procedure for translation from csv to sqlite3 ##
 1. export csv file from spread sheet as exp-db
 2. split the exp-db by project into files which is stored in /cfg.(project) (command: db-split)
 3. register the db files (link to /db directory) (command: file-register)
 4. update sqlite3 rdb (command: upd-db) 
