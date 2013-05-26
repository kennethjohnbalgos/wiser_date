require "wiser_date/view_helpers"
module WiserDate
  class Engine < ::Rails::Engine
  end
  
  class Railtie < Rails::Railtie
    initializer "wiser_date.view_helpers" do |app|
      ActionView::Base.send :include, ViewHelpers
    end
  end 
end