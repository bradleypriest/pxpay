module Pxpay
  # The install generator for Pxpay
  class InstallGenerator < Rails::Generators::Base
    desc "Copies pxpay.yml to config"

    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      template        'pxpay.rb' ,'config/initializers/pxpay.rb'
    end
    
  end
end