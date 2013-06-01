require 'date'

module WiserDate
  
  module ViewHelpers
  
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Context    
    
    def wiser_date_global(options = {})
      timezone = options.has_key?(:timezone) ? options[:timezone] : ""
      interval = options.has_key?(:interval) ? options[:interval] : ""
      time_now = options.has_key?(:time_now) ? options[:time_now] : ""
      
      cookies[:wiser_date_timezone] = timezone
      cookies[:wiser_date_interval] = interval 
      cookies[:wiser_date_time_now] = time_now
    end

    def wiser_date(timestamp, options = {})
      # Options
      date_format = options.has_key?(:date_format) ? options[:date_format] : "%B %d, %Y"
      time_format = options.has_key?(:time_format) ? options[:time_format] : "%l:%M%P"
      title = options.has_key?(:title) ? options[:title] : ""
      humanize = options.has_key?(:humanize) ? options[:humanize] : true
      time_first = options.has_key?(:time_first) ? options[:time_first] : false
      hide_same_year = options.has_key?(:hide_same_year) ? options[:hide_same_year] : false
      
      capitalize = options.has_key?(:capitalize) ? options[:capitalize] : true
      custom_class = options.has_key?(:custom_class) ? options[:custom_class] : nil
      real_time = options.has_key?(:real_time) ? options[:real_time] : true
      
      if cookies[:wiser_date_time_now].present? && !cookies[:wiser_date_time_now].blank?
        time_now = cookies[:wiser_date_time_now]
      else
        time_now = options.has_key?(:time_now) ? options[:time_now].to_datetime : Time.now
      end
      
      if cookies[:wiser_date_interval].present? && !cookies[:wiser_date_interval].blank?
        interval = cookies[:wiser_date_interval]
      else
        interval = options.has_key?(:interval) ? options[:interval] : 20
      end

      if cookies[:wiser_date_timezone].present? && cookies[:wiser_date_timezone].blank?
        time_now = time_now.in_time_zone(ActiveSupport::TimeZone[cookies[:wiser_date_timezone]]) 
        timestamp = timestamp.in_time_zone(ActiveSupport::TimeZone[cookies[:wiser_date_timezone]]) 
      end
    
      # Formats
      flat_format = "%Y%m%d%H%M%S"
      plain_format = "%Y-%m-%d %H:%M:%S"
      custom_format = time_first ? "#{time_format} #{date_format}" : "#{date_format} #{time_format}"

      # Timestamps
      custom_timestamp = timestamp.strftime(custom_format)
      plain_timestamp = timestamp.strftime(plain_format)

      # Default Title
      if title == ""
        title = custom_timestamp
      end
      
      # Humanize Display
      if humanize
        time_diff_in_seconds = (time_now - timestamp.to_time).ceil
        time_diff_in_hours = (time_diff_in_seconds / (60*60))
        time_diff_in_days = (time_diff_in_seconds / (60*60*24))
        if time_diff_in_seconds < 60 && time_diff_in_seconds >= 0
          custom_timestamp = "just now"
          custom_timestamp = "today" if time_format == ""
        elsif time_now.to_date - 1.day == timestamp.to_date 
          date_value = "yesterday"
          time_value = timestamp.strftime(time_format)
          custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} at #{time_value}"
          custom_timestamp = date_value if time_format == ""
        elsif time_diff_in_days < 0
          if time_diff_in_days > -2
            date_value = "tomorrow"
            time_value = timestamp.strftime(time_format)
            custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} at #{time_value}"
            custom_timestamp = date_value if time_format == ""
          elsif time_diff_in_days > -7
            date_value = "on " + timestamp.strftime('%A')
            time_value = timestamp.strftime(time_format)
            custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} at #{time_value}"
            custom_timestamp = date_value if time_format == ""
          end
        elsif time_diff_in_days < 1
          if time_now.to_date == timestamp.to_date && time_diff_in_hours >= 8
            date_value = "today"
            time_value = timestamp.strftime(time_format)
            custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} at #{time_value}"
            custom_timestamp = date_value if time_format == ""
          else
            custom_timestamp = "#{distance_of_time_in_words(time_now, timestamp.to_time)} ago"
            custom_timestamp = "today" if time_format == ""
          end
        elsif time_diff_in_days < 7
          date_value = "last " + timestamp.strftime('%A')
          time_value = timestamp.strftime(time_format)
          custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} at #{time_value}"
          custom_timestamp = date_value if time_format == ""
        end
      end

      # Hide Same Year
      if hide_same_year && time_now.year == timestamp.year 
        custom_timestamp = custom_timestamp.gsub(", #{time_now.year.to_s} ", ' at')
      end
      # Capitalize
      if capitalize
        custom_timestamp[0] = custom_timestamp[0].upcase
      end

      classes = ["wiser_date"]
      classes << custom_class if custom_class.present?
      classes << "time_first" if time_first
      classes << "hide_same_year" if hide_same_year
      classes << "humanize" if humanize
      classes << "capitalize" if capitalize
      classes << "real_time" if real_time
      classes << "on" if real_time
      classes << "-#{@timezone}-"
      classes = classes.join(' ')

      uniq_id = Digest::SHA1.hexdigest([Time.now, rand].join)
      html = content_tag(:span, custom_timestamp, 
        "id" => uniq_id,
        "class" => classes, 
        "data-plain-timestamp" => plain_timestamp, 
        "data-date-format" => date_format,
        "data-time-format" => time_format,
        "title" => title
      )

      formatted_time_now = time_now.strftime(plain_format)
      meta_vars = []
      meta_vars << "data-custom-format=\"" + custom_format + "\""
      meta_vars << "data-server-datetime=\"" + formatted_time_now + "\""
      meta_vars << "data-interval=\"" + interval.to_s + "\""
      meta_vars << "id=\"wiser_date\""

      html += javascript_tag("make_it_wiser_date('#" + uniq_id + "', '" + meta_vars.join(' ') + "');")
      html.html_safe
    end
  end
end