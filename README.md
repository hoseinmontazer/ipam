# ipam (IP address management)
This script manage ip as ipam app with bash script and sqlite

## install

for install  you  clone repo and just run ipam.sh
if you dont have permision run
```
chmod +x ipam.sh
```
and then you should init the db with
```
./ipam.sh init
``` 
if database file (ipam.db) is not available in home directory that create .ipam directory and create ipam.db file 
you can also mv ipam.sh in to /usr/bin/ipam
## install
in this update we can use git and sync data anywhere 
```
./ipam.sh repo init
./ipam.sh repo pull
./ipam.sh repo push
``` 
# example image

<img src="https://raw.githubusercontent.com/hoseinmontazer/ipam/main/image/image1.png" width=700>
<img src="https://raw.githubusercontent.com/hoseinmontazer/ipam/main/image/image2.png" width=700>
<img src="https://raw.githubusercontent.com/hoseinmontazer/ipam/main/image/image3.png" width=700>