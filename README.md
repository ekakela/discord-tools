# discord-tools
Miscelaneous Discord Related tools and Scripts

## googlesheet_to_discord.sh
Script to process Google Sheet output to Discord, with state tracking. Sends only new lines to Discord. Meant to be run in Crontab with user defined frequency
Not under any license, feel free to use how ever you want

### Mandatory Parameters:
GSHEET: URL to the Published Google Sheet in CSV format
STATE = Statefile location ie /home/user/.discord_state
DISCORD = Discord WebHook URL
NICK = Discord Webhook Nickname to use
### Initial setup
create the statefile with value 1 if your Google Sheet has a header row (or what ever number if you want to start processing from later row)
This one excepts that Google sheet has 6 Columns with Timestamp, Character Name, Realm, Discord Username, Class and Score
