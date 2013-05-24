require 'date'

module WiserDate
  module ViewHelpers
    FORMAT_REPLACEMENTES = { "yy" => "%Y", "mm" => "%m", "dd" => "%d", "d" => "%-d", "m" => "%-m", "y" => "%y", "M" => "%b"}
    include ActionView::Helpers::JavaScriptHelper
    include ActionView::Helpers::TagHelper
    include ActionView::Context    
      
    def wiser_date(timestamp, options = {})
      if options.has_key?(:format)
        format = options[:format] 
      else
        format = "%l:%M%p %b %d, %Y"
      end
      new_timestamp = format_date(timestamp, format)
      html = content_tag(:div, new_timestamp, :class => "wiser_date", "data-timestamp" => new_timestamp)
      html += javascript_tag("jQuery(document).ready(function(){ alert('nice'); });")
      html.html_safe
    end
    
    def format_date(tb_formatted, format)
      new_format = translate_format(format)
      Date.parse(tb_formatted).strftime(new_format)
    end
    
    def translate_format(format)
      format.gsub!(/#{FORMAT_REPLACEMENTES.keys.join("|")}/) { |match| FORMAT_REPLACEMENTES[match] }
    end
    
  end
end