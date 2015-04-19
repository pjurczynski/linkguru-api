# Linkguru (backend)

Backend in Rails for linguru-web application

## Installation

Install all gems:

    $ bundle

Specify database config:

    $ cp config/database.yml.sample config/database.yml



### slack configuration

go to https://company.slack.com/services/new and add outgoing message:

```
trigger word: add link, linkguru, upvote, downvote

URL(s):
http://your.domain.com/slack/links
http://your.domain.com/slack/links/last_upvote
http://your.domain.com/slack/links/last_downvote
```

go to https://company.slack.com/services/new and add incoming message

### ENV setup (.env):

```
SLACK_WEBHOOK=configured incoming webhook (incoming message integration)
SLACK_READ_TOKEN=slack web token (https://api.slack.com/web)
SLACK_OUTGOING_TOKEN=slack outgoinig token (outgoing message integration)
```

## Recommendations

### Ngrok

to easily redirect slack post messages to your local maching it is recommended to use ngrok domains for that:

Go to: http://ngrok.com and create account.
Download `ngrok` executable file and place it in project root directory.

to run grok, use:

```bash
./ngrok -log stdout -authtoken $NGROK_TOKEN -subdomain $LOGNAME.linkguru $RAILS_PORT
```

## Contributing

1. Fork it ( https://github.com/mxaly/linkguru-api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

Copyright (c) 2015 Rafał Gawlik

MIT License
