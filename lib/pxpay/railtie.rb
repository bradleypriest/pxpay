require 'pxpay'
require 'rails'
module Pxpay
  class Railtie < ::Rails::Railtie
    generators do
      require 'pxpay/install_generator'
    end
  end
end