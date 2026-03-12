#!/bin/bash

# ==========================================
# SMART STUDENT ACTIVITY & SAFETY MONITOR
# ==========================================

# -------- PASSWORD PROTECTION --------

echo "======================================="
echo " SMART STUDENT ACTIVITY MONITOR SYSTEM "
echo "======================================="

read -sp "Enter System Password: " password
echo

if [ "$password" != "Vishwa" ]
then
echo "Access Denied! Wrong Password."
exit
fi

echo "Access Granted."

# -------- DIRECTORY VARIABLES --------

LOG_DIR="logs"
REPORT_DIR="reports"
BACKUP_DIR="backup"

DATE=$(date +"%Y-%m-%d")
TIME=$(date +"%H:%M:%S")

mkdir -p $LOG_DIR
mkdir -p $REPORT_DIR
mkdir -p $BACKUP_DIR

LOGIN_LOG="$LOG_DIR/login_activity.log"
FILE_LOG="$LOG_DIR/file_activity.log"
COMMAND_LOG="$LOG_DIR/command_alerts.log"
ERROR_LOG="$LOG_DIR/error_log.log"

REPORT_FILE="$REPORT_DIR/daily_report_$DATE.txt"

# -------- LOGIN MONITOR --------

login_monitor() {

echo "----- Login Activity $DATE $TIME -----" >> $LOGIN_LOG

who >> $LOGIN_LOG

echo "Login activity stored."

}

# -------- FILE MONITOR --------

file_monitor() {

echo "----- File Activity $DATE $TIME -----" >> $FILE_LOG

find /home -type f -mtime -1 2>> $ERROR_LOG >> $FILE_LOG

echo "File activity stored."

}

# -------- COMMAND MONITOR --------

command_monitor() {

echo "----- Suspicious Commands $DATE $TIME -----" >> $COMMAND_LOG

grep -E "rm -rf|chmod 777|sudo su" ~/.bash_history >> $COMMAND_LOG

echo "Command monitoring done."

}

# -------- FAILED LOGIN DETECTION --------

failed_login_check() {

echo "----- Failed Login Attempts -----" >> $LOGIN_LOG

lastb | head >> $LOGIN_LOG

echo "Failed login attempts recorded."

}

# -------- ERROR DETECTION WITH TYPE --------

error_check() {

echo "----- System Error Analysis $DATE $TIME -----" >> $ERROR_LOG

# Collect last system messages
ERRORS=$(dmesg | tail -n 20)

echo "$ERRORS" >> $ERROR_LOG

echo "Error Type Analysis:" >> $ERROR_LOG

# Detect Permission Errors
if echo "$ERRORS" | grep -i "permission"
then
echo "Type: Permission Error detected." >> $ERROR_LOG
fi

# Detect Disk Errors
if echo "$ERRORS" | grep -i "disk"
then
echo "Type: Disk Error detected." >> $ERROR_LOG
fi

# Detect File System Errors
if echo "$ERRORS" | grep -i "filesystem"
then
echo "Type: File System Error detected." >> $ERROR_LOG
fi

# Detect Memory Errors
if echo "$ERRORS" | grep -i "memory"
then
echo "Type: Memory Error detected." >> $ERROR_LOG
fi

# Detect Kernel Errors
if echo "$ERRORS" | grep -i "kernel"
then
echo "Type: Kernel/System Error detected." >> $ERROR_LOG
fi

echo "Error analysis completed."

}

# -------- REPORT GENERATION --------

generate_report() {

echo "===== DAILY REPORT =====" > $REPORT_FILE

echo "Date: $DATE" >> $REPORT_FILE
echo "Time: $TIME" >> $REPORT_FILE

echo "--- Login Activity ---" >> $REPORT_FILE
tail -n 10 $LOGIN_LOG >> $REPORT_FILE

echo "--- File Activity ---" >> $REPORT_FILE
tail -n 10 $FILE_LOG >> $REPORT_FILE

echo "--- Suspicious Commands ---" >> $REPORT_FILE
tail -n 10 $COMMAND_LOG >> $REPORT_FILE

echo "--- Failed Login Attempts ---" >> $REPORT_FILE
lastb | head >> $REPORT_FILE

echo "--- Error Analysis ---" >> $REPORT_FILE
tail -n 10 $ERROR_LOG >> $REPORT_FILE

echo "Report generated."

}

# -------- AUTOMATIC LOG BACKUP --------

backup_logs() {

tar -czf $BACKUP_DIR/log_backup_$DATE.tar.gz $LOG_DIR

echo "Logs backed up successfully."

}

# -------- MAIN MENU --------

while true
do

echo "---------------------------------"
echo " SMART STUDENT MONITOR SYSTEM"
echo "---------------------------------"

echo "1 Monitor Login Activity"
echo "2 Monitor File Activity"
echo "3 Monitor Suspicious Commands"
echo "4 Check Failed Login Attempts"
echo "5 Check System Errors with Type"
echo "6 Generate Report"
echo "7 Backup Logs"
echo "8 Run Full System Scan"
echo "9 Exit"

echo "Enter your choice:"
read choice

case $choice in

1) login_monitor ;;

2) file_monitor ;;

3) command_monitor ;;

4) failed_login_check ;;

5) error_check ;;

6) generate_report ;;

7) backup_logs ;;

8)
login_monitor
file_monitor
command_monitor
failed_login_check
error_check
generate_report
backup_logs
;;

9)
echo "Exiting system..."
break
;;

*)
echo "Invalid Choice. Please try again." >> $ERROR_LOG
echo "Invalid choice entered."
;;

esac

done
