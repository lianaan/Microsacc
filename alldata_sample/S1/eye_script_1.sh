#!/bin/bash
for file in *.asc; do
  mv $file ${file/.asc/0.txt} 
done

for file in *.txt; do
  grep 'Trial End' "$file" >> "${file%.txt}_ended.txt"
done

for file in *_ended.txt; do
  awk '{print $5}' "$file" >> "${file%.txt}_tr.txt"
done

for file in *0.txt; do
  awk '/Trial Start/ { show=1 } show; /Response/ { show=1 }' "$file" >> "${file%.txt}_parsed.txt"
done
