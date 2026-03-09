#!/bin/bash

# SMART STUDENT ACTIVITY & SAFETY MONITOR

LOG_DIR="logs"
REPORT_DIR="reports"

DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M:%S")

mkdir -p $LOG_DIR
mkdir -p $REPORT_DIR

LOGIN_LOG="$LOG_DIR/login_activity.log"
FILE_LOG="$LOG_DIR/file_activity.log"
COMMAND_LOG="$LOG_DIR/command_alerts.log"
REPORT_FILE="$REPORT_DIR/daily_report_$DATE.txt"

login_monitor() {

echo "----- Login Activity $DATE $TIME -----" >> $LOGIN_LOG

who >> $LOGIN_LOG

echo "Login activity stored."

}

file_monitor() {

echo "----- File Activity $DATE $TIME -----" >> $FILE_LOG

find /home -type f -mtime -1 2>/dev/null >> $FILE_LOG

echo "File activity stored."

}

command_monitor() {

echo "----- Suspicious Commands $DATE $TIME -----" >> $COMMAND_LOG

grep -E "rm -rf|chmod 777|sudo su" ~/.bash_history >> $COMMAND_LOG

echo "Command monitoring done."

}

generate_report() {

echo "===== DAILY REPORT =====" > $REPORT_FILE

echo "Date: $DATE" >> $REPORT_FILE

echo "--- Login Activity ---" >> $REPORT_FILE

tail -n 10 $LOGIN_LOG >> $REPORT_FILE

echo "--- File Activity ---" >> $REPORT_FILE

tail -n 10 $FILE_LOG >> $REPORT_FILE

echo "--- Suspicious Commands ---" >> $REPORT_FILE

tail -n 10 $COMMAND_LOG >> $REPORT_FILE

echo "Report generated."

}

while true
do

echo "-----------------------------"
echo "SMART STUDENT MONITOR SYSTEM"
echo "-----------------------------"

echo "1 Monitor Login Activity"
echo "2 Monitor File Activity"
echo "3 Monitor Suspicious Commands"
echo "4 Generate Report"
echo "5 Run Full Scan"
echo "6 Exit"

read choice

case $choice in

1) login_monitor ;;

2) file_monitor ;;

3) command_monitor ;;

4) generate_report ;;

5)
login_monitor
file_monitor
command_monitor
generate_report
;;

6)
echo "Exiting..."
break
;;

*)
echo "Invalid Choice"
;;

esac

done
