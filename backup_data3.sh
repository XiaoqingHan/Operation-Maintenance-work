#!/bin/bash

# get files that smaller than 1g
ll -Sh  *.tar.gz | tail -68 | awk -F ' ' '{print $9}' > small

# move those files to one folder
while read line
do
	mv $line ../files/lessthan1g/
done < small
