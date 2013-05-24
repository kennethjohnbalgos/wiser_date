require 'rails3-jquery-autocomplete/form_helper'
require 'rails3-jquery-autocomplete/autocomplete'

class WiserDate
  def self.hi
    puts "Hello world!"
  end
end

class ActionController::Base
  include Rails3JQueryAutocomplete::Autocomplete
end

require 'rails3-jquery-autocomplete/formtastic'

begin
  require 'simple_form'
  require 'rails3-jquery-autocomplete/simple_form_plugin'
rescue LoadError
end