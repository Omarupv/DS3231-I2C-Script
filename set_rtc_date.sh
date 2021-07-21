#!/bin/bash

echo -n "Input date in YYYY-MM-DD HH-MM-SS format:  "
read answer

IFS=$' \t\n'
read -ra test <<< "$answer"

date=${test[0]}
time=${test[1]}

IFS=$'-'
read -ra date_array <<< "$date"
read -ra time_array <<< "$time"

len_date="${#date_array[@]}"
len_time="${#time_array[@]}"


if [ $len_date -ne 3 ] || [ $len_time -ne 3 ]; then 
echo "Wrong format, input as YYYY-MM-DD HH-MM-SS and re-run" 
exit 1
fi 

for i in "${time_array[@]}"
do
if [[ $i =~ ^[0-9]+$ ]];then
      :
   else
      echo "Wrong format for time, check format and re-run"
      exit 1
   fi
done

for i in "${date_array[@]}"
do
if [[ $i =~ ^[0-9]+$ ]];then
   :
   else
      echo "Wrong format for date, check format and re-run"
      exit 1
   fi
done

if [ "${#date_array[0]}" -ne 4 ]; then 
   echo "Check year length, must be 4 digits"
   exit 1
else
   if [ ${date_array[0]} -lt 2000 ] || [ ${date_array[0]} -gt 2099 ]; then
   echo "Year must be between 2000-2099, out of range for value ${date_array[0]}"
   exit 1
   fi
   
fi

if [ "${#date_array[1]}" -ne 2 ]; then 
   echo "Check Month length, must be 2 digits"
   exit 1
else
   if [ ${date_array[1]} -lt 1 ] || [ ${date_array[1]} -gt 12 ]; then
   echo "Month must be between 01-12, out of range for value ${date_array[1]}"
   exit 1
   fi
fi

if [ "${#date_array[1]}" -ne 2 ]; then 
   echo "Check Day length, must be 2 digits"
   exit 1
else
   if [ ${date_array[2]} -lt 1 ] || [ ${date_array[2]} -gt 31 ]; then
   echo "Day must be between 01-31, out of range for value ${date_array[2]}"
   exit 1
   fi
fi

if [ "${#time_array[0]}" -ne 2 ]; then 
   echo "Check Hour length, must be 2 digits"
   exit 1
else
   if [ ${time_array[0]} -lt 0 ] || [ ${time_array[0]} -gt 23 ]; then
   echo "Hour must be between 00-23, out of range for value ${time_array[0]}"
   exit 1
   fi
fi

if [ "${#time_array[1]}" -ne 2 ]; then 
   echo "Check Minutes length, must be 2 digits"
   exit 1
else
   if [ ${time_array[1]} -lt 0 ] || [ ${time_array[1]} -gt 59 ]; then
   echo "Minutes must be between 00-59, out of range for value ${time_array[1]}"
   exit 1
   fi 
fi

if [ "${#time_array[2]}" -ne 2 ]; then 
   echo "Check Seconds length, must be 2 digits"
   exit 1
else
   if [ ${time_array[2]} -lt 0 ] || [ ${time_array[2]} -gt 59 ]; then
   echo "Seconds must be between 00-59, out of range for value ${time_array[2]}"
   exit 1
   fi 
fi

echo "Setting date to $answer"
IFS=$' \t\n'

probe=$(sudo i2cget -y 8 0x68 0x00)

if [ "$probe" == "" ]; then
echo "Could not find hardware, please check connections and refer to wiki"
echo "Additionaly, please make sure i2c-tools is installed on your system with: "
echo "sudo apt install i2c-tools"
exit 1 
else 
:
fi

second_format=0x"${time_array[2]}"
minute_format=0x"${time_array[1]}"
hour_format=0x"${time_array[0]}"

year_format=0x"${date_array[0]:2}"
month_format=0x"${date_array[1]}"
day_format=0x"${date_array[2]}"


sudo i2cset -y 8 0x68 0x00 $second_format
sudo i2cset -y 8 0x68 0x01 $minute_format
sudo i2cset -y 8 0x68 0x02 $hour_format
sudo i2cset -y 8 0x68 0x04 $day_format
sudo i2cset -y 8 0x68 0x05 $month_format
sudo i2cset -y 8 0x68 0x06 $year_format 

echo "date set in rtc, remember to execute clock.sh script to modify the system time"
exit 0


























