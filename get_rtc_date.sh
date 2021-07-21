#!/bin/bash
## Sets the system time on boot, call me from rc.local to set time on system boot
## See wiki for setting up rc.local script

## Gets the info from the chip
##seconds
SECS=$(i2cget -y 8 0x68 0x00)
##minutes
MINUTES=$(i2cget -y 8 0x68 0x01)
##hour
HOUR=$(i2cget -y 8 0x68 0x02)
##day
DAY=$(i2cget -y 8 0x68 0x04)
##month
MONTH=$(i2cget -y 8 0x68 0x05)
##year
YEAR=$(i2cget -y 8 0x68 0x06)

## Formats the info
YEAR_FORMAT=20${YEAR/0x}
MONTH_FORMAT=${MONTH/0x}
DAY_FORMAT=${DAY/0x}
DATE_STRING=$YEAR_FORMAT-$MONTH_FORMAT-$DAY_FORMAT

HOUR_FORMAT=${HOUR/0x}
MINUTE_FORMAT=${MINUTES/0x}
SECOND_FORMAT=${SECS/0x}

##temp one is for debug, in case reading seconds does not work
TIME_STRING=$HOUR_FORMAT:$MINUTE_FORMAT:$SECOND_FORMAT
TIME_STRING_TEMP=$HOUR_FORMAT:$MINUTE_FORMAT:00
DATE_TIME="$DATE_STRING $TIME_STRING" 

## Sets the system time from the chip, make sure you edit sudoers file with sudo visudo or this will not work
timedatectl set-ntp false
sudo date -s "$DATE_TIME" 
