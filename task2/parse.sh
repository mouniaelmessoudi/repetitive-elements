#!/bin/bash

COLUMNS=("repeat_sequence" "repeat_family_clade" "class" "category_one" "autonomy" "age" "repeat_number" "tsd" "remark" "repbase_year" "repeat_id" "sequence_length" "species_of_origin")
header=$(IFS=, ; echo "${COLUMNS[*]}") #join the columns by , => for e.g: repeat_sequence,repeat_family_clade,age...
echo $header

LINE=()
BLOCK=""
DISPLAY_ROW=false
KW_LINE_OCCURENCE=0 #counter for the KW line on each block
index=0
while read line; do # read every line
   BLOCK="${BLOCK} $line" # concact line to current block
   if [[ "$line" =~ 'SQ   ' ]];then #each line within a block starting with SQ
     if [[ $(echo $BLOCK | grep "nonautonomous\|non-autonomous\|Nonautonomous\|Non-autonomous") != "" ]];then #grep return results if a match is found
       LINE[4]="nonautonomous"
     else
       LINE[4]="autonomous"
     fi

     if [[ $(echo $BLOCK | grep "young\|Young") != "" ]];then
       LINE[5]="young"
     elif [[ $(echo $BLOCK | grep "old\|Old") != "" ]];then
       LINE[5]="old"
     else
      LINE[5]="not documented"
     fi

    # if $DISPLAY_ROW;then # if display row is true
       echo "${LINE[0]},${LINE[1]},,${LINE[3]},${LINE[4]},${LINE[5]},,,,${LINE[9]},,${LINE[11]},${LINE[12]}"
     #fi

     DISPLAY_ROW=false
     LINE=()
     BLOCK=""
     KW_LINE_OCCURENCE=0 #initiate counter for the KW line
     index=$((index+1))
   else
     if [[ $line == "ID"* ]];then #each line within a block starting with ID
       repeat_sequence=$(echo $line | awk '{print $2}')
       sequence_length=$(echo $line | awk '{print $6}')
       LINE[0]=$repeat_sequence
       LINE[11]=$sequence_length
       #echo "$repeat_sequence $sequence_length"
     elif [[ $line =~ ^DT[[:alnum:][:blank:][:punct:]]+(Created)\)$ ]];then #each line within a block starting with DT and ending with "Created"
       repbase_year=$(echo $line | awk '{print $2}' | cut -d"-" -f3) #separate the date with - to put only the year
       LINE[9]=$repbase_year
       #echo $repbase_year
     elif [[ $line == "OS"* ]];then #each line within a block starting with OS
        species_of_origin=$(echo $line | sed -e 's/OS   //') # | cut -d " " -f2) #eliminate the specifier
        LINE[12]=$species_of_origin
        #echo $species_of_origin
     elif [[ $line == "KW"* ]];then
       KW_LINE_OCCURENCE=$((KW_LINE_OCCURENCE+1))
       if [[ $KW_LINE_OCCURENCE == 1 ]];then #to avoid choosing the second KW line
         family_clade=$(echo $line | cut -d ';' -f1 | cut -d " " -f2) #eliminate the specifier
         category_one=$(echo $line | cut -d ';' -f2)
         LINE[1]=$family_clade
         LINE[3]=$category_one
       fi

#       if [[ $(echo $line | grep "SAT\|Satellite\|Simple Repeat") == "" ]];then
#         DISPLAY_ROW=true
#       fi
     fi
   fi
done < "vrtrep.ref"
