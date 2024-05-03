#!/bin/bash

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
N="\e[0m"
echo "please provide db password"
read  mysql_root_password

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
   echo "runn the script with root access"
   exit 1
else
   echo "you are super user"
fi

dnf module disable nodejs -y &>>LOGFILE
Validate $? "disabling nodejs"

dnf module enable nodejs:20 -y &>>LOGFILE
Validate $? "enabling nodejs"

dnf install nodejs -y &>>LOGFILE
Validate $? "installing nodejs"

id expense
if [ $? -ne 0 ]
   then 
     useradd expense &>>LOGFILE
     Validate $? "creating expense user" 
   else 
     echo -e "user already exists....$G SKIPPING $N"
fi

mkdir -p /app &>>LOGFILE
Validate $? "CREATING APP DIRECTORY"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>LOGFILE
Validate $? "COPYING ZIP FILE"

cd /app 
rm -rf /app/*
unzip /tmp/backend.zip &>>LOGFILE

cd /app 
npm install &>>LOGFILE
Validate $? "installing nodejs dependencies"

cp /home/ec2-user/expenses-shell/backend.service /etc/systemd/system/backend.service &>>LOGFILE
Validate $? "COPIED BACKEND SERVICE"

systemctl daemon-reload &>>LOGFILE
Validate $? "system reload"

systemctl start backend &>>LOGFILE
Validate $? "starting backend"

systemctl enable backend &>>LOGFILE
Validate $? "enabling backend"

dnf install mysql -y &>>LOGFILE
Validate $? "installimg mysql client"

mysql -h db.daws1998.online -uroot -p${mysql_root_password} < /app/schema/backend.sql &>>LOGFILE
Validate $? "setting up schema"

systemctl restart backend &>>LOGFILE
Validate $? "restating backend"