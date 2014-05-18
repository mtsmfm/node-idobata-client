# (UNOFFICIAL) Idobata Client for Node.js

Post messages in HTML format via generic webhook.

## Usage

```coffee
API_TOKEN     = process.env.HUBOT_IDOBATA_API_TOKEN
IdobataClient = require('idobata-client')

module.exports = (robot) ->
  robot.respond /HELLO$/i, (msg) ->
    client = new IdobataClient('https://idobata.io', API_TOKEN)
    client.postViaWebhook(msg.message.data.room_id, format: 'html', source: '<h1>hello</h1>')
```
