#!/bin/bash

# VARIABLES
STOP_WORD_FILE=$(dirname $0)/stop_words.txt
VARIATION_WORD_FILE=$(dirname $0)/word_variation.txt

function help() {
  echo "Usage $0 [-h] -i <input file> -o <output file>"
  echo "stop words file $STOP_WORD_FILE required."
}


input_file=""
output_file=""

while getopts :i:o:h opt; do
  case "$opt" in
    i) input_file="$OPTARG" ;;
    o) output_file="$OPTARG" ;;
    h) help; exit ;;
    *) help ; exit 1;;
    esac
  done

if [ "$input_file" = "" -o ! -f "$input_file" -o ! -f "$STOP_WORD_FILE" -o -z "$output_file" ]; then
  help
  exit 1
fi

# convert punctuation to space
tmp_res=`cat $input_file | tr '[:punct:]' ' '`

# remove non-ascii characters
tmp_res=`echo "$tmp_res" | tr -dc '[\00-\176]'`

# convert line feed to space
tmp_res=`echo "$tmp_res" | tr '\r\n' ' ' | tr '[:cntrl:]' ' ' | tr -s ' ' | tr ' ' '\n'`

# count word frequency and sort
tmp_res=`echo "$tmp_res" | awk '{for(i=1;i<=NF;i++) freq[$i]++} END {for(a in freq) print freq[a],a}' `

# remove stop words
tmp_res=`echo "$tmp_res" | grep -v -w -i -f $STOP_WORD_FILE`

# process result list with word variation list
tmp_res=`awk 'ARGIND==1{len=split($2,v_arr,",");for(i=1;i<=len;i++){v_words[v_arr[i]]=$1}} ARGIND==2{if(v_words[$2]!=""){w_arr[v_words[$2]]+=$1}else{w_arr[$2]+=$1}} END{for(item in w_arr)print w_arr[item],item }' $VARIATION_WORD_FILE <(echo "$tmp_res") | sort -nr`

echo "$tmp_res" > $output_file
echo "Done! please see the result in file $output_file"
