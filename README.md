# Pwnagotchi-Converter
Script to download and convert handshakes from your Pwnagotchi.
* **convert2hccapx.sh** used to convert \*.pcap-files to \*.hccapx-files
* **downloadPCAP.sh** used to download the \*.pcap-files and convert them to \*.hccapx-files

## Table of contents
* [General info](#general-info)
* [Setup on your local machine](#Setup-on-your-local-machine)
* [Setup Hashcat](#Setup-Hashcat)
* [Setup on your Pwnagotchi](#Setup-on-your-Pwnagotchi)
* [Usage of convert2hccapx](#Usage-of-convert2hccapx)
* [Usage of downloadPCAP](#Usage-of-downloadPCAP)

## General info
These three scripts should help to download the handshakes from your Pwnagotchi. 
If you only got a few handshakes to convert, you could use the [online converter tool](https://hashcat.net/cap2hccapx/), provided by hashcat.

## Setup on your local machine
To run this script, you need to change some values in the script.
At first you have to create a private and a public ssh key. It will prompt for the location. The default location is `~/.ssh/`.

```
$ ssh-keygen -t rsa -b 4096 -f ~/.ssh/pwnagotchi.key
```
**Keep your private key always safe, don't give it away! Don't share it!**
Now there should be two files in this folder`~/.ssh/`. The **pwnagotchi.key** and the **pwnagotchi.key.pub** file. You need install the public key on your remote server, your Pwnagotchi. The following command adds the public key to the authorized keys on your remote Pwnagotchi. Don't forget to change the IP-address of your little device.

```
$ %HOME/.ssh/pwnagotchi.key.pub pi@10.0.0.5:~/.ssh/authorized_keys
```
If the above command doesn't work, you have to use this command:
```
$ ssh-copy-id pi@10.0.0.5
```

**NOTE:** If you don't do the steps on your local machine, you have to enter your ssh-passphrase three times.

### Installing cap2hccapx
At first you have to download the source code of cap2hccapx. It's located in the [hashcat-utils](https://github.com/hashcat/hashcat-utils) Github repository. To download it, use the following code.
```
cd ~/Downloads
wget https://raw.githubusercontent.com/hashcat/hashcat-utils/master/src/cap2hccapx.c
```
After that you have to compile the source code with C-compiler(gcc). That's very easy. You only have to specify the output filename and the input source file as following. After that you can delet the downloaded source code file.
```
gcc -o cap2hccapx cap2hccapx.c
rm cap2hccapx.c
```
Now you are already able to use the tool in the same folder like this: `cap2hccapx`. However, for this script we have to get it globaly accessible. For this I used the easiest way I knew, I moved the compiled file into the `\bin` folder. This is managed with the next command.
```
mv cap2hccapx /bin
```

## Setup on your Pwnagotchi
To save the captured handshakes, like me, in this directory `/home/pi/handshakes` you have to modify the `config.toml` file. For this you need the following command.

```
$ sudo nano /etc/pwnagotchi/config.toml
```
With this command the nano editor opens to edit the file. In there you have to find the line `bettercap.handshakes = ""`. The default location of the handshakes is the `/root/handshakes` directory. In my case I changed it to `bettercap.handshakes = "/home/pi/handshakes"` because it's much easier with the file ownership and the permissions.

## Usage of convert2hccapx
If you only want to convert your \*.pcap files to \*.hccapx you should use this little scipt. You have to launch it in the folder with the \*.pcap files from your Pwnagotchi. It will create a new folder called "hccapx" where all converted files are located. Furthermore it will create a **log.txt** file and a **combinded.hccapx**. The log file contains every error and success of the script. The combinded.hccapx file contains all \*.hccapx files combinded into one file. So, you are able to crack multiple hashes at once.

Usage of the command:
**`$ ./convert2hccapx.sh`**

## Usage of downloadPCAP
If you want to download all handshakes from your Pwnagotchi to your local machine and convert them you should use this script. At first this script creates a Tar-folder from the pcap files over SSH. Than it will copy them to your local machine with Secure Copy Protocol (SCP). The files will be saved in `~/Downloads/handshakes/`. The file name of the downloaded file is marked with a timestamp at the end. Then it removes the Tar-folder from your Pwnagotchi to save space. Now it moves over to your local machine and starts to unzip the folder. It will do now the same as the [convert2hccapx.sh](#Usage-of-downloadPCAP) script. The only thing I've added to this script is, that only \*.pcap are converted. So, there are no error messages anymore. Only the name of the log file changed to convert.log instead of log.txt. At the end it moves the log-file, the combinded.hccapx and the hccapx folder into the root directory of the handshakes.

Usage of the command:
**`$ ./downloadPCAP.sh`**
