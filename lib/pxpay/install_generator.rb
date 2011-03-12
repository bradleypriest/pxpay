module Pxpay
  class InstallGenerator < Rails::Generators::Base
    desc "Copies pxpay.yml to config and a config initializer to config/initializers/pxpay_config.rb"

    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      template        'pxpay.rb'  ,'config/initializers/pxpay.rb'
      template        'pxpay.yml' ,'config/pxpay.yml'
    end
    
  end
end