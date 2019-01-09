#!/bin/bash

while read p; do
  IFS=';' read -r -a files <<< "$p"
  mv ${files[0]} ${files[1]}

done < $1
