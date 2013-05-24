require 'date'

module WiserDate
  module ViewHelpers

    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Context    
    
    def wiser_date(timestamp, options = {})
      # Options
      date_format = options.has_key?(:date_format) ? options[:date_format] : "%b %d, %Y"
      time_format = options.has_key?(:time_format) ? options[:time_format] : "%l:%M%P"
      humanize = options.has_key?(:humanize) ? options[:humanize] : true
      time_first = options.has_key?(:time_first) ? options[:time_first] : false
      hide_same_year = options.has_key?(:hide_same_year) ? options[:hide_same_year] : true
      
    
      # Now
      time_now = Time.now
    
      # Formats
      flat_format = "%Y%m%d%H%M%S"
      plain_format = "%Y-%m-%d %H:%M:%S"
      custom_format = time_first ? "#{time_format} #{date_format}" : "#{date_format} #{time_format}"
    
      # Timestamps
      custom_timestamp = timestamp.strftime(custom_format)
      plain_timestamp = timestamp.strftime(plain_format)
    
      # Humanize Display
      if humanize
        time_diff = ((time_now - timestamp.to_time).to_f / (60*60*24))
        if time_now.strftime(plain_format) == timestamp.strftime(plain_format)
          custom_timestamp = "just now"
        elsif time_now.to_date - 1.day == timestamp.to_date 
          date_value = "yesterday"
          time_value = timestamp.strftime(time_format)
          custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} #{time_value}"
        elsif time_diff < 1.0
          custom_timestamp = "#{distance_of_time_in_words(Time.now, timestamp.to_time)} ago"
        elsif hide_same_year && time_now.year == timestamp.year 
          custom_timestamp = custom_timestamp.gsub(", #{time_now.year.to_s}", '')
        end
      end
    
      uniq_id = Digest::SHA1.hexdigest([Time.now, rand].join)
      html = content_tag(:span, custom_timestamp, 
        "id" => uniq_id,
        "class" => "wiser_date", 
        "data-plain-timestamp" => plain_timestamp, 
        "data-custom-timestamp" => custom_timestamp,
        "data-new-custom-timestamp" => custom_timestamp
      )
      html += javascript_tag("jQuery(document).ready(function(){if(jQuery('body meta#wiser_date').size() == 0){$('body').prepend('<meta id=\"wiser_date\" data-value=\"#"+uniq_id+"\"/>')}else{$('meta#wiser_date').attr('data-value',$('meta#wiser_date').attr('data-value')+', #"+uniq_id+"')}});")
      html.html_safe
    end
    
    
  end
end