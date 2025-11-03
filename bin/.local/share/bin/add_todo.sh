#!/bin/bash

book=$1
begin=$2
end=$3
rate=${4:-1.5}

for i in $(seq "$begin" "$end"); do
  habitipy todos add -p "$rate" Read \""$book"\" Section "$i".
done
