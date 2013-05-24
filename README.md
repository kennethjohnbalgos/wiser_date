# Wiser Date for Rails

[wiser_date](https://github.com/kennethjohnbalgos/wiser_date) is a date formatting plugin written by [Kenneth John Balgos](https://github.com/kennethjohnbalgos). Wiser Date features dynamic presentation of feed timestamps. 

## Notice

Right now, it only displays the date statically. I'm writing the jQuery scripts to update the displays dynamically.

## Installing Gem

    gem "wiser_date"

## Using the javascripts -- Coming Soon

Require jquery.wiser_date in your app/assets/application.js file.

    //= require jquery.wiser_date

## Usage

Use the wiser_date function in your views.

    <%= wiser_date @user.last_login_at %>
    
@user.last_login_at can be any timestamp you want to display.

## Options

You can customized the behavior of the date display using the following options:

* Date Format - The default date format is "%b %d, %Y" which displays "Jan 1, 2013".
    
    <%= wiser_date @user.last_login_at, :date_format => "%Y-%m-%d" %>

## Thanks
Thanks to [Kenneth John Balgos](https://github.com/kennethjohnbalgos) for writing an awesome real-time date display plugin.

## Support
Open an issue in [wiser_date](https://github.com/kennethjohnbalgos/wiser_date) if you need further support or want to report a bug.
