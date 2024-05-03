#!/bin/bash

USERID=(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"


Validate(){
    if [ $1 -ne 0 ]
  then 
    echo -e "$2 is ....$R failure $N"
    exit 1
 else
    echo -e "$2 is ....$G sucess $N"
    fi
}

if [ $USERID -ne  0 ]
then 
   echo "run the script with root access"
   exit 1
else
   echo "you are super user"
fi

dnf module disable nodejs -y
Validate $? "disabling nodejs"

dnf module enable nodejs:20 -y
Validate $? "enabling nodejs"

dnf install nodejs -y
Validate $? "installing nodejs"

id expense
if [ $? -ne 0 ]
   then 
     useradd expense
     Validate $? "creating expense user" 
   else 
     echo -e "user already exists....$G SKIPPING $N"
fi
