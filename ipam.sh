#!/bin/bash


set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
CLEAR='\033[0m'

usage() {
	echo -e ${CYAN}
  echo -e "usage: $(basename $0) [option]"
	echo
	printf "show             show\n"
	printf "insert           insert new ip\n"
  printf "help             show this help\n"
	printf ${CLEAR}
}


show() {
counOfKeys=`cat ipam.json| jq -r 'keys[]' | wc -l`
if [ -z $2 ]
then
  echo "var is unset"

        counter=0
        count=`cat ipam.json| jq  -r --arg  name "$2" '(.[$name]) | length '`
        #echo $count
        while [ $counter -le $count ]
        do
          #echo "Welcome $counter times"
          #cat daria.json| jq -r --arg  id "$counter" '([.daria[$id|tonumber] | .ipaddr , .dec]) | @tsv' ;
          cat ipam.json| jq -r --arg  id "$counter"  '([.[][$id|tonumber] | .id , .ipaddr , .dec ]) | @tsv' ;
          counter=$(( $counter + 1 ))
        done
        break
else
  counterOfKey=0
  while [ $counterOfKey -le $counOfKeys ]
  #while [ $2 != `cat ipam.json| jq -r --arg  id "$counterOfKey" 'keys[$id|tonumber]'` ]
  do
    #echo "hi eeee"
    if [ $2 == `cat ipam.json| jq -r --arg  id "$counterOfKey" 'keys[$id|tonumber]'` ]
    then
        #echo "arg number two available"

        #echo "hiii"
        counter=0
        count=`cat ipam.json| jq  -r --arg  name "$2" '(.[$name]) | length '`
        #echo $count
        while [ $counter -le $count ]
        do
          #echo "Welcome $counter times"
          #cat daria.json| jq -r --arg  id "$counter" '([.daria[$id|tonumber] | .ipaddr , .dec]) | @tsv' ;
          cat ipam.json| jq -r --arg  id "$counter"  --arg  name "$2" '([.[$name][$id|tonumber] | .id , .ipaddr , .dec ]) | @tsv' ;
          counter=$(( $counter + 1 ))
        done
        break
    elif [ $counterOfKey == $counOfKeys ]
    then
      echo "arg number two not available"
      break
      #cat ipam.json| jq -r 'keys[]' | wc -l
      #counterOfKey=$(( $counterOfKey + 1 ))
    else
      counterOfKey=$(( $counterOfKey + 1 ))
    fi


  done
  #echo "arg number two not available"
fi
}



insert() {
  #echo "hello insert"
  read -p 'IP: ' userIp
  read -p 'Descrption: ' userDec
  echo "you add $userIp $userDec $2 "
  lastId=`cat ipam.json| jq  -r --arg  name "daria" '.[$name][-1].id'`
  y=$((lastId++))
  echo "aaaaaaaaa" $lastId
  #jq -r --arg  index "$lastId"  --arg  userip "$userIp"  --arg  userdec "$userDec"  --arg  userid "$lastId" '.daria[$index|tonumber] += {"id" : $userid|tonumber , "ipaddr" : $userip , "dec": $userdec }' ipam.json  > ipam.json.tmp
  jq -r --arg  index "$lastId"  --arg  userip "$userIp"  --arg  userdec "$userDec"  --arg  userid "$lastId" --arg  name "$2" '(.[$name][$index|tonumber]) += {"id" : $userid|tonumber , "ipaddr" : $userip , "dec": $userdec }' ipam.json  > ipam.json.tmp
  mv ipam.json.tmp ipam.json

}















if [ $# -eq 0 ]
then
usage
exit 1
fi

p1=$1
p2=$2
# case $1 in
#     "show")
#       show
#     ;;
#     "server-gost")
#     server-gost
#         ;;
#     "local-gost")
#     local-gost
#         ;;
#     "revoke-conf")
#     revoke-conf
#         ;;
#     "v2ray")
#     v2ray
#         ;;
#     "help")
#         usage
#         break
#         ;;
#     *) echo "invalid option";;
# esac

case $1 in
    "show" )
    show $1 $2
    ;;
    "insert" )
    insert $1 $2
esac