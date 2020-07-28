#!/bin/bash


for file in *.txt; do
  awk '/Trial Start/ { show=1 } show; /Response ON/ { show=0 }' "$file" >> "${file%.txt}_A.txt"
done

for file in *_A.txt; do
  sed '/[a-zA-Z]/d' "$file" >> "${file%.txt}_B.txt"
  sed -n -e '/Trial Start/p' "$file" >  "${file%.txt}1T.txt"
  sed -n -e '/Delay1 /p' "$file" >  "${file%.txt}2T.txt"
  sed -n -e '/Stim /p' "$file" >  "${file%.txt}3T.txt"
  sed -n -e '/Delay2 /p' "$file" >  "${file%.txt}4T.txt"
  sed -n -e '/Response /p' "$file" >  "${file%.txt}5T.txt"
done

for file in *_B.txt; do
  awk '{print $1, $2, $3, $4}' "$file" >> "${file%.txt}_C.txt"
done

for file in *_C.txt; do
  sed -n '/. . 0.0/!p' "$file" >> "${file%.txt}_D.txt"
done

for file in *T.txt; do
  awk '{print $2, $5}'  "$file" >> "${file%.txt}T.txt"
done


