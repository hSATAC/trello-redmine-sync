# Sync Trello with Redmine

This script grabs trello card names and fetch data from redmine, update info to trello.

## How to get trello token

Basic authorization:

1. Get your API keys from [trello.com/app-key](https://trello.com/app-key).
2. Visit the URL [trello.com/1/authorize], with the following GET parameters:
    - `key`: the API key you got in step 1.
    - `response_type`: "token"
    - `expiration`: "never" if you don't want your token to ever expire. If you leave this blank,
       your generated token will expire after 30 days.
    - The URL will look like this:
      `https://trello.com/1/authorize?key=YOURAPIKEY&response_type=token&expiration=never&scope=read,write`
3. You should see a page asking you to authorize your Trello application. Click "allow" and you should see a second page with a long alphanumeric string. This is your member token.
