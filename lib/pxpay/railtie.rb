require 'pxpay'
require 'rails'
module Pxpay
  class Railtie < ::Rails::Railtie
    generators do
      require 'pxpay/install_generator'
    end
    initializer "railtie.configure_rails_initialization" do
      require 'pxpay/init'
    end
  end
end