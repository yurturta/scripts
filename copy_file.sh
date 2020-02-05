#!/bin/bash
#
DIR=/Users/yurtaturta/Downloads/files
IPFILE="$1"
USERNAME="$2"
PASSWORD="$3"
REMOTEDIR="$4"
FILE="$5"
DIRECTION="$6"


case $DIRECTION in
1)
for IP in $(cat $IPFILE); 
do
      a=`grep $IP ~/.ssh/known_hosts | wc -l`
      if [ "$a" -le 0 ] 
        then
      	ssh-keyscan $IP >> ~/.ssh/known_hosts;
      fi
      sshpass -p "$PASSWORD" scp -o PubkeyAuthentication=no $DIR/$FILE $USERNAME@$IP:$REMOTEDIR;
      echo "COPY $IP FINISHED" 
done
;;
2)
for IP in $(cat $IPFILE); 
do
      a=`grep $IP ~/.ssh/known_hosts | wc -l`
      if [ "$a" -le 0 ] 
        then
      	ssh-keyscan $IP >> ~/.ssh/known_hosts
      fi
      if [ ! -f file_"$FILE"_$IP.txt ] 
	then
        echo $IP;
        echo file_"$FILE"_$IP.txt;
        echo $USERNAME@$IP:$REMOTEDIR/$FILE;
      	sshpass -p "$PASSWORD" scp -o PubkeyAuthentication=no $USERNAME@$IP:$REMOTEDIR/$FILE $DIR/file_"$FILE"_$IP.txt;
	echo "COPY $IP FINISHED"
      fi
done
;;
*)
echo "Usage IPFILE USERNAME PASSWORD REMOTEDIR FILE DIRECTION (1-TO 2-FROM) parameters";
;;
esac

