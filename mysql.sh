#!/bin/bash

USERID=$(id -u)
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

dnf install mysql-server -y
validate $? "installing MYSQL-SERVER"

systemctl enable mysqld
validate $? "enabling MYSQL"

systemctl start mysqld
validate $? "STARTING MYSQL"

mysql_secure_installation --set-root-pass ExpenseApp@1
validate $? "SETTING ROOT PASSWORD OF MYSQL"
