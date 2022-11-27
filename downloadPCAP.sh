#script to download handshakes from your pwnagotchi
#zip your handshakes, copy it with scp, removes the zip from the pwnagotchi,
#converts the *.pcap file to *.hccapx to crack with hashcat, creates one hccapx file
#with all handshakes in it to crack multiple hashes with one file

#you may have to change the IP-address
#need to create a private and public ssh key on your local machine
#need to add your public ssh key to your pwnagotchi

#!/bin/bash

function show_usage (){
    printf "Usage: $0 [options [parameters]]\n"
    printf "\n"
    printf "Options:\n"
    printf " -d|--destination, used to define the output directory, default value: ~/Downloads/handshakes/\n"
    printf " -p|--pwnagotchi,  used to define the Pwnagotchis IP-address, default value: 10.0.0.5\n"
    printf " -v|--verbose, used to start in verbose mode\n"
    printf " -h|--help, Print help\n"

exit 1
}

#colors for output
RED='\033[0;31m'
NC='\033[0m'  #No color

#var
FILES=./*
EXT_PCAP=".pcap"

NOW=$(date +"%m-%d-%y"_"%H-%M-%S")
NAME="handshakes_"
EXT=".zip"

FILENAME="$NAME$NOW$EXT"
FILE="$NAME$NOW"

IP="10.0.0.5"
LOCATION="~/Downloads/handshakes/"

while [ ! -z "$1" ]
do
  case "$1" in
     -d|--destination)
         shift
         LOCATION=$1
         ;;
     -p|--pwnagotchi)
         shift
         IP=$1
         ;;
     *)
        show_usage
        ;;
  esac
if [ $# -gt 0 ]; then
  shift
fi
done

ssh pi@$IP "tar -cvf $FILENAME handshakes"

scp pi@$IP:${FILENAME} $LOCATION

ssh pi@$IP "rm -rf $FILENAME"

cd $LOCATION

mkdir %{FILE}
tar -xvf %{FILENAME} -C ${FILE}
cd ${FILE}

cd handshakes
touch convert.log
mkdir hc22000
for f in $FILES
do
  
  FileName=$f
  if [[ "${FileName##*.}" == "$EXT_PCAP"]];
  then
    echo "Processing $f"
    cap2hccapx ./$f ./hc22000/${FileName/.pcap}.hc22000 >> ./hccapx/convert.log
  fi
done

cd ./hccapx
cat *.hccapx > combinded.hc22000

mv combinded.hc22000 convert.log $LOCATION/$FILE
mv $LOCATION/$FILE/handshakes/hc22000 $LOCATION/$FILE