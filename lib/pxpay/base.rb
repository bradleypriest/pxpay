module Pxpay
  # The base Pxpay class, contains the acceptable currency types and the details that are returned from Payment Express
  class Base
    # A list of the acceptable payment currencies
    # See http://www.paymentexpress.com/technical_resources/ecommerce_hosted/pxpay.html#Properties
    def self.currency_types
      %w( CAD CHF EUR FRF GBP HKD JPY NZD SGD USD ZAR AUD WST VUV TOP SBD PNG MYR KWD FJD )
    end

    # The currently returned details from Payment Express. Access with Pxpay::Base.return_details
    def self.return_details
      [ :dps_billing_id, :txn_data1, :success, :card_number2, :email_address, :card_number, :amount_settlement, :txn_data2, :client_info, :date_expiry, :currency_settlement, :txn_data3, :txn_id, :txn_type, :date_settlement, :auth_code, :dps_txn_ref, :currency_input, :txn_mac, :card_name, :billing_id, :merchant_reference, :response_text, :card_holder_name ]
    end

    def self.pxpay_request_url
      "https://sec.paymentexpress.com/pxpay/pxaccess.aspx"
    end

    class << self
      attr_accessor :pxpay_user_id, :pxpay_key, :url_success, :url_failure, :pxpay_request_url
    end
  end
end