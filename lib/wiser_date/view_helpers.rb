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
      hide_same_year = options.has_key?(:hide_same_year) ? options[:hide_same_year] : false
      capitalize = options.has_key?(:capitalize) ? options[:capitalize] : true
      custom_class = options.has_key?(:custom_class) ? options[:custom_class] : nil
      time_now = options.has_key?(:time_now) ? options[:time_now].to_datetime : Time.now

      # Formats
      flat_format = "%Y%m%d%H%M%S"
      plain_format = "%Y-%m-%d %H:%M:%S"
      custom_format = time_first ? "#{time_format} #{date_format}" : "#{date_format} #{time_format}"

      # Timestamps
      custom_timestamp = timestamp.strftime(custom_format)
      plain_timestamp = timestamp.strftime(plain_format)

      # Humanize Display
      if humanize
        time_diff_in_seconds = (time_now - timestamp.to_time).ceil
        time_diff_in_days = (time_diff_in_seconds / (60*60*24))
        if time_diff_in_seconds <= 30 && time_diff_in_seconds >= 0
          custom_timestamp = "just now"
        elsif time_now.to_date - 1.day == timestamp.to_date 
          date_value = "yesterday"
          time_value = timestamp.strftime(time_format)
          custom_timestamp = time_first ? "#{time_value} #{date_value}" : "#{date_value} #{time_value}"
        elsif time_diff_in_days <= 1.0 && time_diff_in_days >= 0
          custom_timestamp = "#{distance_of_time_in_words(Time.now, timestamp.to_time)} ago"
        elsif hide_same_year && time_now.year == timestamp.year 
          custom_timestamp = custom_timestamp.gsub(", #{time_now.year.to_s}", '')
        end
      end
  
      # Capitalize
      if capitalize
        custom_timestamp = custom_timestamp.to_s.capitalize
      end

    
      uniq_id = Digest::SHA1.hexdigest([Time.now, rand].join)
      html = content_tag(:span, custom_timestamp, 
        "id" => uniq_id,
        "class" => "wiser_date #{custom_class if custom_class.present?}", 
        "data-plain-timestamp" => plain_timestamp, 
        "data-custom-timestamp" => custom_timestamp,
        "data-new-custom-timestamp" => custom_timestamp
      )
    
      meta_vars = []
      meta_vars << "data-value=\"#"+uniq_id+"\""
      meta_vars << "data-custom-format=\""+custom_format+"\""
      meta_vars << "data-date-format=\""+date_format+"\""
      meta_vars << "data-time-format=\""+time_format+"\""
      meta_vars << "data-humanize=\""+humanize.to_s+"\""
      meta_vars << "data-hide-same-year=\""+hide_same_year.to_s+"\""
      meta_vars << "data-time-first=\""+time_first.to_s+"\""
      meta_vars << "data-capitalize=\""+capitalize.to_s+"\""
      meta_vars << "id=\"wiser_date\""
    
      html += javascript_tag("jQuery(document).ready(function(){if(jQuery('body meta#wiser_date').size() == 0){$('body').prepend('<meta "+meta_vars.join(' ')+" />')}else{$('meta#wiser_date').attr('data-value',$('meta#wiser_date').attr('data-value')+', #"+uniq_id+"')}});")
      html.html_safe
    end
  end
end