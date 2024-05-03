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
   echo "run the script with root access"
   exit 1
else
   echo "you are super user"
fi

dnf install mysql-server -y &>>LOGFILE
Validate $? "installing MYSQL-SERVER"

systemctl enable mysqld &>>LOGFILE
Validate $? "enabling MYSQL"

systemctl start mysqld &>>LOGFILE
Validate $? "STARTING MYSQL"

# mysql_secure_installation --set-root-pass ExpenseApp@1
# Validate $? "SETTING ROOT PASSWORD OF MYSQL"

#idempotancy nature code
 mysql -h db.daws1998.online -uroot -p${mysql_root_password} -e 'SHOW DATABASES;'
 if [ $? -ne 0 ]
   then 
      mysql_secure_installation --set-root-pass ${mysql_root_password} &>>LOGFILE
      Validate $? "root password setup"
   else
      echo -e " root password already setup .... $G SKIPPING $N"     
fi 
