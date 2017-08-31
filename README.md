# Go-Light

Lua code to convert a toy traffic light into a extreme feedback device

## Setup for ubuntu

1. Install python

2. Install virtualenvwrapper
```bash
    apt install virtualenvwrapper
    . /usr/local/bin/virtualenvwrapper_lazy.sh # add to .bashrc as well
```
3. Create a virtualenv
```bash
    mkvirtualenv nodemcu
```
4. Install esptool
```bash
    workon nodemcu
    pip install esptool
    pip install nodemcu-uploader
```
## Firmware for nodemcu

1. Change to this repo

2. Make sure the microcontroller is connected to ttyUSB0 (needs: timer, gpio and string module)
```bash
    esptool.py  --port /dev/ttyUSB0 erase_flash
    esptool.py  --port /dev/ttyUSB0 write_flash --flash_mode dio 0x00000 nodemcu-master-*-integer.bin
```
3. Check if flashing worked (press the reset button while doing this and wait about 10 sec for the repl to appear)
```bash
    cu --nostop -s 115200 -l /dev/ttyUSB0
```
4. Customize config.lua

5. Upload the source the lua source to the nodemcu
```bash
    ./upload.sh
```
## Preconfigured Ubuntu VM

1. To mitigate driver issues and platform hassle, just install [VirtualBox|https://www.virtualbox.org/] and [Vagrant|https://www.vagrantup.com/]. 
2. Call ```vagrant up && vagrant reload``` from the repository root.
4. Call ```vagrant ssh``` to access the VM. 
5. Continue with chapter 'Firmware for nodemcu' as all reguired dependencies have already been installed. Repository root is available as shared folder ```/vagrant```, changes are immediately propagated to the host.
