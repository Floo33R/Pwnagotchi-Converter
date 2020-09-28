#!/bin/bash

#to search where no handshakes were found
#grep -i "Written 0 WPA Handshakes" convert.log

#to delete all charakters in the line expect the wlan name
#sed -r 's/.{40}//'

#combinded
grep -i "Written 0 WPA Handshakes" convert.log | sed -r 's/.{40}//' > wifiNames

