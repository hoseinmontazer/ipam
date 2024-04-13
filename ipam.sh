#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
CLEAR='\033[0m'

MAIN_DIR=~/.ipam


usage() {
	echo -e ${CYAN}
  echo -e "usage: $(basename $0) [option]"
	echo
  printf "init             init db\n"
	printf "show             show\n"
	printf "insert           insert new ip\n"
  printf "del              delete  ip\n"
  printf "help             show this help\n"
	printf ${CLEAR}
}




init() {
  echo -e ${YELLOW}
  echo "start create database"
  #echo ~
  sleep 3


  if [ ! -d $MAIN_DIR ]
  then
    mkdir $MAIN_DIR
  else
    if [ -f $MAIN_DIR/ipam.db ]
    then
      echo "database is exists"
      
    else
      sqlite3 $MAIN_DIR/ipam.db "create table ipam (id INTEGER PRIMARY KEY , host TEXT, ip INTEGER , dec TEXT);"
      echo "created database"
    fi
    printf ${CLEAR}
  fi
}




show() {
if [ -z $2 ]
then
  echo -e '\n\n'
  sqlite3 $MAIN_DIR/ipam.db ".mode column" "select * from ipam;"

else
  sqlite3 $MAIN_DIR/ipam.db ".mode column"  "SELECT  * from ipam WHERE host='$2' ";
fi

}



insert() {

if [ -z $2 ]
then
  echo -e '\n\n'
  echo -e ${RED}
  echo "please add your host name"
  echo -e ${CLEAR}

else
  read -p 'IP: ' userIp
  #sqlite3 ipam.db "SELECT  ip from ipam WHERE host='$2' AND IP='$userIp' limit 1"
  if [[ $(sqlite3 $MAIN_DIR/ipam.db "SELECT  ip from ipam WHERE host='$2' AND IP='$userIp' limit 1") == $userIp ]]
  then
    echo -e '\n\n'
    echo -e ${RED}
    echo "The entred ip is duplicate"
    echo -e ${CLEAR}
  else
    read -p 'Descrption: ' userDec
    sqlite3 $MAIN_DIR/ipam.db  "insert into ipam (host , ip , dec) values ('$2','$userIp','$userDec'); ";
    echo -e '\n\n'
    echo -e ${GREEN}
    echo "Your ip added in database"
    printf ${CLEAR}
  fi
fi
}


del() {

if [ -z $2 ]
then
  echo "please add your host name"

else
  read -p 'ID NUMBER: ' IPID
  echo -e ${RED}
  echo
  sqlite3 $MAIN_DIR/ipam.db ".mode column"  "SELECT  * from ipam WHERE host='$2' AND id='$IPID' "
  echo
  read -p 'Are you sure? y or n: ' CONFIRM
  echo
  if [[ $CONFIRM == 'y'  ]]
  then
    echo -e ${CLEAR}
    sqlite3 $MAIN_DIR/ipam.db  "DELETE FROM ipam WHERE id LIKE '%$IPID%'; ";
    echo -e ${GREEN}
    echo "Your ip deleted from database."
    printf ${CLEAR}

  else
    echo -e ${CLEAR}
    sqlite3 $MAIN_DIR/ipam.db ".mode column"  "SELECT  * from ipam WHERE host='$2' ";
  fi
  
fi
}












if [ $# -eq 0 ]
then
usage
exit 1
fi

p1=$1
p2=$2

case $1 in
    "show" )
    show $1 $2
    ;;
    "insert" )
    insert $1 $2
    ;;
    "init" )
    init $1 $2
    ;;
    "del" )
    del $1 $2
esac