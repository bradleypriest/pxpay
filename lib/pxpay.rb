# A Ruby wrapper around the DPS-hosted PxPay service
module Pxpay
  require "pxpay/railtie" if defined?(Rails)
  require "pxpay/base"
  require "pxpay/request"
  require "pxpay/response"
  require "pxpay/notification"
  require "pxpay/error"
end