#With this script you are able to convert \*.pcap-files to \*.hc22000-files to use with Hashcat.
#!/bin/bash

mkdir hc22000

FILES=./*
EXT=".pcap"

echo -e "\e[1;5;31mDO NOT CRACK WIFI PASSWORDS OF ACCESS POINTS YOU DO NOT OWN UNLESS YOU HAVE EXPLICIT PERMISSION TO DO SO\e[0m"
echo; read -rsn1 -p "Press any key to continue . . ."; echo
for f in $FILES
do
  echo "Processing $f"
  FileName=$f
  hcxpcapngtool -o ./hc22000/${FileName/.pcap}.hc22000 ./$f >> ./hc22000/log.txt
done
cd ./hc22000
cat *.hc22000 > combinded.hc22000
