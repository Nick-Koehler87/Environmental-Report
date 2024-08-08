#!/bin/bash

USER="XXX"
PASSWORD="XXX"
DATABASE="emissionsreport"
Table="Emissions"
mysql --local-infile = 1
for f in *_country_emissions.csv
do  
    if [[ -f $f ]]; then
        echo "loading data from $f into $TABLE..."
         
        mysql -u $USER --password="$PASSWORD" $DATABASE -e  "LOAD DATA LOCAL INFILE '"$f"' INTO TABLE Emissions COLUMNS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;" 
        if [ $? -eq 0 ]; then
            echo "Successfully loaded $f,"
        else
            echo "Error loading $f,"
        fi
    else
        echo "No CSV files found."
    fi
done