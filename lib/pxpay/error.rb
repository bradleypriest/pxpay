module Pxpay
  class Error < StandardError
  end
  class MissingKey < Pxpay::Error
  end
end