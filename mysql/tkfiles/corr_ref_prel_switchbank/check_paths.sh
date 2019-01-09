#!/bin/bash

while read p; do
  if [ ! -f $p ]; then
    echo "$p"
fi

done < $1
