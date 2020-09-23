# Pwnagotchi-Converter
Script to download and convert handshakes from your Pwnagotchi.

## Table of contents
* [General info](#general-info)
* [Setup on your local machine](#Setup-on-your-local-machine)
* [Setup Hashcat](#Setup-Hashcat)
* [Setup on your Pwnagotchi](#Setup-on-your-Pwnagotchi)

## General info
These two scripts should help to download the handshakes from your Pwnagotchi. 

## Setup on your local machine
To run this script, you need to change some values in the script.
At first you have to create a private and a public ssh key. It will prompt for the location. The default location is `~/.ssh/`.

```
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/pwnagotchi.key
```
**Keep your private key always safe, don't give it away! Don't share it!**
Now there should be two files in this folder`~/.ssh/`. The **pwnagotchi.key** and the **pwnagotchi.key.pub** file. You need install the public key on your remote server, your Pwnagotchi. The following command adds the public key to the authorized keys on your remote Pwnagotchi. 

```
$ %HOME/.ssh/pwnagotchi.key.pub pi@pwnagotchi:~/.ssh/authorized_keys
```

## Setup on your Pwnagotchi
If you want to use the same file locations as me, you have to change the location where your Pwnagotchi saves your captured handshakes.
