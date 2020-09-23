#!/bin/bash

mkdir hccapx

FILES=./*
EXT=".pcap"

for f in $FILES
do
  echo "Processing $f"
  FileName=$f
  cap2hccapx ./$f ./hccapx/${FileName/.pcap}.hccapx >> ./hccapx/log.txt
done

cd ./hccapx
cat *.hccapx > combinded.hccapx
