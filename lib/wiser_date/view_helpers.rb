require 'date'

module WiserDate
  module ViewHelpers
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Context    
      
    def wiser_date(timestamp, options = {})
      if options.has_key?(:format)
        format = options[:format] 
      else
        format = "%l:%M%p %b %d, %Y"
      end
      new_timestamp = timestamp.strftime(format)
      html = content_tag(:div, new_timestamp, :class => "wiser_date", "data-timestamp" => new_timestamp)
      html += javascript_tag("jQuery(document).ready(function(){ alert('nice'); });")
      html.html_safe
    end
    
  end
end