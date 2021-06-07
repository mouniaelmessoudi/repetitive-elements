#!/bin/bash

PATTERN="Satellite\|Simple_repeat\|Low_complexity\|rRNA\|tRNA\|snRNA\|mRNA\|smRNA"

grep -v $PATTERN mellotropicalis.fasta.out | awk '{print $10}' | sort | sed -e '/^$/d' | uniq -c > mellotropicalis.uniq
grep -v $PATTERN tropicalis.fasta.out | awk '{print $10}' | sort | sed -e '/^$/d' | uniq -c > tropicalis.uniq

# -1 2 -2 2 = Join the two files using the 2nd column from mellotropicalis.uniq and 2nd column from tropicalis.uniq
# -o 1.1,2.1,1.2 = 1st column from 1st file, 1st column from 2nd file, 2nd column from 1st file
join -1 2 -2 2 -o 1.1,2.1,1.2 mellotropicalis.uniq tropicalis.uniq  | sort -k1 -n > matching.data
# -v to display missing elements
# -e "0" to display "0" if the element is missing
join -v 1 -1 2 -2 2 -e '0' -o 1.1,2.2,1.2 mellotropicalis.uniq tropicalis.uniq | sort -k1 -n > missing_in_tropicalis.data
join -v 1 -1 2 -2 2 -e '0' -o 2.1,1.1,1.2 tropicalis.uniq mellotropicalis.uniq | sort -k1 -n > missing_in_mellotropicalis.data
echo "Mellotropicalis,Tropicalis, Element" > result.csv
cat matching.data missing_in_tropicalis.data missing_in_mellotropicalis.data | awk '{print $1","$2","$3}' >> result.csv
