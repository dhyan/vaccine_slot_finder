# VaccineSlotFinder(for 18-44 age group)

Install this gem and add cronjobs(using whenever gem).
Every `10` minutes it will check for vaccine availability in your pincode
area and also surrounding 5 pincodes. These pincodes are picked from open source and available in `lib/vaccine_slot_finder/bengaluru_pincodes.yaml`.

`PLEASE DOWNLOAD AND COPY THIS TO YOUR DESKTOP`.

For example my current pincode is `560067`, hence i get results for:
`560065
 560066
 560067
 560068
 560070`
 
 `Because of API throttling, searching more pincodes is difficult at this moment.`

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vaccine_slot_finder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vaccine_slot_finder

## Usage
###Pincode must be of 6 digits
###Example(Run it from your terminal)    
 
    $ vaccine_slot_finder 560067
 
### Send notifications to teams channel?
    $ // Add TEAMS_WEBHOOK as an environment variable to your favourite shell. You will get notifcations, only if there are any slots available for age group 18-44.     

## Need a cron job?

    $ // Add cronjob to your crontab file. Or this gem also has whenever gem installed as dev dependency.
    $ // Please refer https://github.com/javan/whenever to learn more. Makes adding cron jobs very easy.
    $ // If ading crons manually, below is how my crontab file looks. Please edit the pincode(ie 560067) of your location.
    $  0,20,40 * * * * /bin/bash -l -c 'vaccine_slot_finder '\''560067'\'' >> /Users/nakumar/learnings/vaccine_slot_finder/config/cron_log.log 2>&1'

## Credits
#### -- Whenever  (https://github.com/javan/whenever)
#### -- httparty  (https://github.com/jnunemaker/httparty)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
