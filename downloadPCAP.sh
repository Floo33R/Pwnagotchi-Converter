#script to download handshakes from your pwnagotchi
#zip your handshakes, copy it with scp, removes the zip from the pwnagotchi,
#converts the *.pcap file to *.hccapx to crack with hashcat, creates one hccapx file
#with all handshakes in it to crack multiple hashes with one file

#you may have to change the IP-address
#need to create a private and public ssh key on your local machine
#need to add your public ssh key to your pwnagotchi

#!/bin/bash

function usage {
  echo "Usage: $(basename $0) [-dhpv]" 2>&1
  echo '    -h   shows this help'
  echo '    -d   used to define the output directory'
  echo '    -p   used to define the Pwnagotchis IP-address, default it is 10.0.0.5'
  #echo '    -v   verbose mode on'
return 0
}

# function print_out{
#    local MESSAGE="${@}"
#    if [[ "${VERBOSE}" == true ]]
#    then
#      echo "${MESSAGE}"
#    fi
# }

if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]
then
  usage
else
  echo "Incorrect input provided!"
  usage
fi

# list of expected arguments
optstring="hdp"

while getopts ${optstring} arg; do
  case "${arg}" in
    -h) usage
       ;;
    -d) LOCATION=$1
       echo $LOCATION
       ;;
    -p) IP=$1
       echo $IP
       ;;
    # v) VERBOSE='true'
    #    print_out "Verbose mode is ON"
    #    ;;
    ?) 
      echo "Invalid option: -${OPTARG}."
      echo
      usage
      ;;
  esac
done


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

#ssh pi@$IP "zip -r $FILENAME handshakes"
ssh pi@$IP "tar -cvf $FILENAME handshakes"

scp pi@$IP:${FILENAME} $LOCATION

ssh pi@$IP "rm -rf $FILENAME"

# if [ -n "$1" ]
# then 
#   if [ -d $1 ]
#   then
#     echo "Using entered path: $1"
#     $LOCATION=$1
#   else
#     echo -e "${RED}No valid path entered! Using default path!${NC}"
#   fi
# else
#   echo -e "${RED}No path entered! Using default path!${NC}"
# fi

cd $LOCATION

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

mv combinded.hccapx convert.log $LOCATION/$FILE
mv $LOCATION/$FILE/handshakes/hccapx $LOCATION/$FILE
