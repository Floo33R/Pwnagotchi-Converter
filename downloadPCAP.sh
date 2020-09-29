#script to download handshakes from your pwnagotchi
#zip your handshakes, copy it with scp, removes the zip from the pwnagotchi,
#converts the *.pcap file to *.hccapx to crack with hashcat, creates one hccapx file
#with all handshakes in it to crack multiple hashes with one file

#you may have to change the IP-address
#need to create a private and public ssh key on your local machine
#need to add your public ssh key to your pwnagotchi

#!/bin/bash

#colors for output
RED='\033[0;31m'
NC='\033[0m'  #No color

FILES=./*
EXT_PCAP=".pcap"

NOW=$(date +"%m-%d-%y"_"%H-%M-%S")
NAME="handshakes_"
EXT=".zip"

FILENAME="$NAME$NOW$EXT"
FILE="$NAME$NOW"

#ssh pi@10.0.0.5 "zip -r $FILENAME handshakes"
ssh pi@10.0.0.5 "tar -cvf $FILENAME handshakes"

scp pi@10.0.0.5:${FILENAME} ~/Downloads/handshakes

ssh pi@10.0.0.5 "rm -rf $FILENAME"

if [ -n "$1" ]
then 
  if [ -d $1 ]
  then
    echo "Using entered path: $1"
    cd $1
  else
    echo -e "${RED}No valid path entered! Using default path!${NC}"
    cd ~/Downloads/handshakes/
  fi
else
  echo -e "${RED}No path entered! Using default path!${NC}"
  cd ~/Downloads/handshakes/
fi

mkdir %{FILE}
#unzip ${FILENAME} -d ./$FILE
tar -xvf %{FILENAME} -C ${FILE}
cd ${FILE}

cd handshakes
touch convert.log
mkdir hccapx
for f in $FILES
do
  
  FileName=$f
  if [[ "${FileName##*.}" == "$EXT_PCAP"]];
  then
    echo "Processing $f"
    cap2hccapx ./$f ./hccapx/${FileName/.pcap}.hccapx >> ./hccapx/convert.log
  fi
done

cd ./hccapx
cat *.hccapx > combinded.hccapx

mv combinded.hccapx convert.log ~/Downloads/handshakes/$FILE
mv ~/Downloads/handshakes/$FILE/handshakes/hccapx ~/Downloads/handshakes/$FILE
