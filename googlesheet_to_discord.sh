#!/bin/bash
# Esamatti Käkelä 02-02-2020
# Script to process Google Sheet output to Discord, with state tracking. Sends only new lines to Discord. Meant to be run in Crontab with user defined frequency
# Not under any license, feel free to use how ever you want
###############################################################################################################################################################
# Mandatory Parameters:
# GSHEET: URL to the Published Google Sheet in CSV format
# STATE = Statefile location ie /home/user/.discord_state
# DISCORD = Discord WebHook URL 
# NICK = Discord Webhook Nickname to use
###############################################################################################################################################################
# Initial setup, create the statefile with value 1 if your Google Sheet has a header row (or what ever number if you want to start processing from later row)
# This one excepts that Google sheet has 6 Columns with Timestamp, Character Name, Realm, Discord Username, Class and Score
#  
###############################################################################################################################################################
# Modifiable Parameters
GSHEET="https://docs.google.com/spreadsheets/d/e/REDACTED/pub?gid=0&single=true&output=csv"
STATE=/home/REDACTED/.discord-state
DISCORD="https://discordapp.com/api/webhooks/REDACTED"
NICK="DiscordNICK"

# Initializing Temporary Files
FILE=$(mktemp)
LAINI=$(mktemp)

trap "rm $FILE $LAINI" 0 1 2 3 15

# Downloading the Google Sheet CSV and removing unwanted crlf - linebreaks from the sheet
curl -s "$GSHEET" | tr -d '\r' > $FILE
echo $'\n' >> $FILE
# Counting current file rows
ROWS=`wc -l $FILE | awk ' { print $1 } '`
# Checking last row that has been sent to Discord
STATEL=`cat $STATE | awk ' { print $1 } '`
#echo STATEL $STATEL

if [ $STATEL -le $ROWS ] ; then
while [[ $STATEL -le $ROWS ]]; do
#Process line after last row
S3=$(($STATEL))
LINE=$(sed ""$S3"q;d" $FILE)
echo $LINE > $LAINI
cat $LAINI--
while IFS=$',' read TS NAME REALM DUSER CLASS ROLE SCORE; do
CNAME=$NAME
REALMI=$REALM
DUSERI=$DUSER
CLASSI=$CLASS
ROOLI=$ROLE
SC=$SCORE

if [ -z "$ROOLI" ]; then
echo "tyhja"
else
generate_post_data() {
cat <<EOF
{ "username": "$NICK", "content": "Ideal Candidate Found! Character Name: $CNAME Realm: $REALMI Discord Usename: $DUSERI Class : $CLASSI Role: $ROOLI Score: $SC" }
EOF
}

#echo  "$(generate_post_data)"
curl -H "Content-Type: application/json" -X POST -d "$(generate_post_data)" $DISCORD 
fi

done <$LAINI
STATEL=$(($STATEL+1))
sleep 5
done
echo $(($ROWS)) > $STATE
echo $ROWS
else 
exit 1
fi
