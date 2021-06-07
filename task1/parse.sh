#!/bin/bash

types=("SINEs" "LINEs" "LTR elements" "DNA transposons" "Unclassified" "Satellites")

index=0
for file in $*; do
   echo "Parsing file: $file"
   columns=()
   rows=()
   counter=0
   while IFS= read -r line; do
       if [[ $counter -ge 10 ]] && [[ $counter -le 50 ]]
       then
          for t in ${types[@]};do
           type=$(echo $line | awk '{print $1}')
           if [[ $type = $t* ]]
           then
              if [[ $type == "LTR" ]] || [[ $type == "DNA" ]]
              then
               value=$(echo $line | awk '{print $6}')
               columns+=($t)
               rows+=($value)
              else
               value=$(echo $line | awk '{print $5}')
               columns+=($t)
               rows+=($value)
              fi
           fi
          done
       fi
       counter=$((counter+1))
   done < $file

   if [[ $index == 0 ]]
   then
     COLUMNS=${columns[@]}
     COLUMNS=${COLUMNS// /,}
     echo $COLUMNS > "result.csv"
  fi
   ROWS=${rows[@]}
   ROWS=${ROWS// /,}
   echo $ROWS >> "result.csv"

   index=$((index+1))
done

echo "Drawing charts"
Rscript plot.r
