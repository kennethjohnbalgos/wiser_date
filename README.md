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

## License
Copyright (c) 2013 Kenneth John Balgos

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
