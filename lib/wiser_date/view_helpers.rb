require 'date'

module WiserDate
  module ViewHelpers
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Helpers::DateHelper
    include ActionView::Context    
      
    def wiser_date(timestamp, options = {})
      # Options
      format = options.has_key?(:format) ? options[:format] : "%l:%M%P %b %d, %Y"
      humanize = options.has_key?(:humanize) ? options[:humanize] : true
      
      
      # Timestamps
      custom_timestamp = timestamp.strftime(format)
      plain_timestamp = timestamp.strftime("%Y-%m-%d %H:%M:%S")
      
      # Humanize Display
      if humanize
        unless ((Time.now - timestamp.to_time).to_f / (60*60*24)).to_i >= 1
          custom_timestamp = "#{distance_of_time_in_words(Time.now, timestamp.to_time)} ago"
        end
      end
      
      html = content_tag(:div, custom_timestamp, 
        "class" => "wiser_date", 
        "data-plain-timestamp" => plain_timestamp, 
        "data-custom-timestamp" => custom_timestamp,
        "data-new-custom-timestamp" => custom_timestamp
      )
      html += javascript_tag("jQuery(document).ready(function(){});")
      html.html_safe
    end
    
  end
end