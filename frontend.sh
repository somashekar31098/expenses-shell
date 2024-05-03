#!/bin/bash

USERID=(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log


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

dnf install nginx -y &>>LOGFILE
Validate $? "installing nginx" 

systemctl enable nginx &>>LOGFILE
Validate $? "ENABLING nginx" 

systemctl start nginx &>>LOGFILE
Validate $? "STARTING nginx" 
 
rm -rf /usr/share/nginx/html/* &>>LOGFILE
Validate $? "REMOVING EXISTING FILES " 

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOGFILE
Validate $? "DOWNLOADING FRONTEND CODE" 

cd /usr/share/nginx/html 
 
unzip /tmp/frontend.zip &>>LOGFILE
Validate $? "unzipping the file" 

cp /home/ec2-user/expenses-shell/expense.conf /etc/nginx/default.d/expense.conf &>>LOGFILE
Validate $? "copying ngnix dependencies" 

systemctl restart nginx &>>LOGFILE
Validate $? "restarting nginz" 
