function make_it_wiser_date(id, meta_vars) {
  jQuery(document).ready(function(){
    if(jQuery('body meta#wiser_date').size() == 0){
      jQuery('body').prepend("<meta " + meta_vars + " />")
    };
    updateWiserDate(id);
  })
}

function updateWiserDate(id) {
  if(jQuery('meta#wiser_date').attr('data-real-time-started') != "true"){
    update_interval = parseInt(jQuery('meta#wiser_date').attr('data-interval')) * 1000;
    setInterval(function() {
      update_timer(update_interval)
      jQuery('.wiser_date.on').each(function(){
        updateDate(jQuery(this));
      })
    },update_interval); 
  }
  jQuery('meta#wiser_date').attr('data-real-time-started','true');
}

function updateDate(el){
  el.text(prettyDate(el));
}

function prettyDate(element){
  datetime = element.attr('data-plain-timestamp')
  date_format = element.attr('data-date-format')
  time_format = element.attr('data-time-format')
  
  hide_same_year = element.hasClass('hide_same_year')
  capitalize = element.hasClass('capitalize')
  humanize = element.hasClass('humanize')
  time_first = element.hasClass('time_first')
  
  server_datetime = jQuery('meta#wiser_date').attr('data-server-datetime')
  var time_now = new Date((server_datetime || "").replace(/-/g,"/").replace(/[TZ]/g," "));
  var timestamp = new Date((datetime || "").replace(/-/g,"/").replace(/[TZ]/g," "));
  var time_diff_in_seconds = ((time_now.getTime() - timestamp.getTime()) / 1000);
  var time_diff_in_hours = Math.floor(time_diff_in_seconds / 3600);
  var time_diff_in_days = Math.floor(time_diff_in_seconds / 86400);
  
  date_yesterday = time_now;
  date_yesterday.setDate(time_now.getDate() - 1);

  flat_format = "%Y%m%d%H%M%S"
  plain_date_format = "%Y-%m-%d"
  plain_format = "%Y-%m-%d %H:%M:%S"

  if(time_first){
    regular_date_display = custom_format(timestamp, time_format + " " + date_format);
  }else{
    regular_date_display = custom_format(timestamp, date_format + " " + time_format);
  }
  
  if(isNaN(time_diff_in_days)){
    custom_timestamp = datetime;
  }else if(humanize){
    if(time_diff_in_seconds < 60 && time_diff_in_seconds >= 0){
      custom_timestamp = "just now"
      if(time_format == ""){
        custom_timestamp = "today"
      }
    }else if(custom_format(date_yesterday, plain_date_format) == custom_format(timestamp, plain_date_format)){
      date_value = "yesterday"
      time_value = custom_format(timestamp, time_format)
      if(time_first){
        custom_timestamp = time_value + " " + date_value;
      }else{
        custom_timestamp = date_value + " at " + time_value;
      } 
      if(time_format == ""){
        custom_timestamp = date_value
      }
    }else if(time_diff_in_days < 0){
      if(time_diff_in_days > -2){
        date_value = "tomorrow"
        time_value = custom_format(timestamp, time_format)
        if(time_first){
          custom_timestamp = time_value + " " + date_value;
        }else{
          custom_timestamp = date_value + " at " + time_value;
        } 
        if(time_format == ""){
          custom_timestamp = date_value
        }
      }else if(time_diff_in_days > -7){
        date_value = "on " + custom_format(timestamp, "%A")
        time_value = custom_format(timestamp, time_format)
        if(time_first){
          custom_timestamp = time_value + " " + date_value;
        }else{
          custom_timestamp = date_value + " at " + time_value;
        } 
        if(time_format == ""){
          custom_timestamp = date_value
        }
      }else{
        element.removeClass('on')
        custom_timestamp = regular_date_display
      }
    }else if(time_diff_in_days < 1){
      if(time_diff_in_hours >= 8){
        date_value = "today"
        time_value = custom_format(timestamp, time_format)
        if(time_first){
          custom_timestamp = time_value + " " + date_value;
        }else{
          custom_timestamp = date_value + " at " + time_value;
        } 
        if(time_format == ""){
          custom_timestamp = date_value
        }
      }else{
        custom_timestamp = humanize_format(time_diff_in_seconds, time_diff_in_days);
        if(time_format == ""){
          custom_timestamp = "today"
        }
      }
    }else if(time_diff_in_days < 7){
      date_value = "last " + custom_format(timestamp, "%A")
      time_value = custom_format(timestamp, time_format)
      if(time_first){
        custom_timestamp = time_value + " " + date_value;
      }else{
        custom_timestamp = date_value + " at " + time_value;
      } 
      if(time_format == ""){
        custom_timestamp = date_value
      }
    }else{
      element.removeClass('on')
      custom_timestamp = regular_date_display
    }
  }else{
    element.removeClass('on')
    custom_timestamp = regular_date_display
  }
  
  if(hide_same_year){
    custom_timestamp = custom_timestamp.replace(", "+time_now.getFullYear(), ' at')
  }
  if(capitalize){
    custom_timestamp = custom_timestamp[0].toUpperCase() + custom_timestamp.slice(1);
  }
  
  custom_timestamp = custom_timestamp.replace(/ 0\:/, "12:")
  
  return custom_timestamp; // + " - ["+time_diff_in_seconds.toString()+":"+time_diff_in_days+"]";
}

function update_timer(interval){
  if(!interval){interval = 1000;}
  current_datetime = jQuery('meta#wiser_date').attr('data-server-datetime');
  current_datetime = new Date((current_datetime || "").replace(/-/g,"/").replace(/[TZ]/g," "));
  current_datetime.setTime(current_datetime.getTime() + interval);
  current_datetime = custom_format(current_datetime, "%Y-%m-%d %H:%M:%S");
  jQuery('meta#wiser_date').attr('data-server-datetime', current_datetime);
  jQuery('#real_time').text('The actual server time is ' + current_datetime);
}

function humanize_format(sec_diff, day_diff){
  return day_diff == 0 && (
          sec_diff < 60 && "just now" ||
          sec_diff < 120 && "1 minute ago" ||
          sec_diff < 3600 && Math.floor( sec_diff / 60 ) + " minutes ago" ||
          sec_diff < 7200 && "about 1 hour ago" ||
          sec_diff < 86400 && "about " + Math.floor( sec_diff / 3600 ) + " hours ago") ||
          day_diff == 1 && "Yesterday" ||
          day_diff < 7 && day_diff + " days ago" ||
          day_diff < 31 && Math.ceil( day_diff / 7 ) + " week ago";
}

function custom_format(timestamp, format){
  func = new DateFmt();
  datetime = format;
  datetime = datetime.replace("%Y", func.format(timestamp,"%Y"));
  datetime = datetime.replace("%m", func.format(timestamp,"%m"));
  datetime = datetime.replace("%d", func.format(timestamp,"%d"));
  datetime = datetime.replace("%b", func.format(timestamp,"%b"));
  datetime = datetime.replace("%B", func.format(timestamp,"%B"));
  datetime = datetime.replace("%H", func.format(timestamp,"%H"));
  datetime = datetime.replace("%M", func.format(timestamp,"%M"));
  datetime = datetime.replace("%S", func.format(timestamp,"%S"));
  datetime = datetime.replace("%A", func.format(timestamp,"%A"));
  datetime = datetime.replace("%a", func.format(timestamp,"%a"));
  if(timestamp.getHours() > 12){
    datetime = datetime.replace("%l", lead_zero(timestamp.getHours() - 12, " "));
    datetime = datetime.replace("%P", "pm");
    datetime = datetime.replace("%p", "PM");
  }else{
    datetime = datetime.replace("%l", lead_zero(timestamp.getHours(), " "));
    datetime = datetime.replace("%P", "am");
    datetime = datetime.replace("%p", "AM");
  }
  return datetime;
}

function lead_zero(val, extra){
  str_val = parseInt(val);
  if(!extra){extra = "0";}
  if(str_val < 10){
    return extra + str_val;
  }else{
    return str_val;
  }
}

function DateFmt() {
  this.dateMarkers = { 
     d:['getDate',function(v) { return ("0"+v).substr(-2,2)}], 
     m:['getMonth',function(v) { return ("0"+(v+1)).substr(-2,2)}],
     b:['getMonth',function(v) {
         var mthNames = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
         return mthNames[v];
         }],
     B:['getMonth',function(v) {
         var mthNames = ["January","February","March","April","May","June","July","August","September","October","Novovember","December"];
         return mthNames[v];
         }],
     a:['getDay',function(v) {
         var dayNames = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"];
         return dayNames[v];
         }],
     A:['getDay',function(v) {
         var dayNames = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
         return dayNames[v];
         }],
     Y:['getFullYear'],
     H:['getHours',function(v) { return ("0"+v).substr(-2,2)}],
     M:['getMinutes',function(v) { return ("0"+v).substr(-2,2)}],
     S:['getSeconds',function(v) { return ("0"+v).substr(-2,2)}],
     i:['toISOString',null]
  };

  this.format = function(date, fmt) {
    var dateMarkers = this.dateMarkers
    var dateTxt = fmt.replace(/%(.)/g, function(m, p){
    var rv = date[(dateMarkers[p])[0]]()
    if ( dateMarkers[p][1] != null ) rv = dateMarkers[p][1](rv)
    return rv
  });

  return dateTxt
  }
}