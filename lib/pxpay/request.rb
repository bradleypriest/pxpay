module Pxpay
  class Request
    
    attr_accessor :post
    
    # Create a new instance of Pxpay::Request
    # Pxpay::Request.new( id, amount, options = {} )
    # Current available options are:
    # :currency, currency for transaction, default is NZD, can be any of Pxpay::Base.currency_types
    # :reference, a reference field, default is the id
    # :email, email address of user, default is nil
    
    def initialize( id , price, options = {} )
      @post = build_xml( id, price, options )
    end
    
    # Get the redirect URL from Payment Express
    def url
      require 'rest_client'
      response = ::RestClient.post("https://sec2.paymentexpress.com/pxpay/pxaccess.aspx", post )
      url =  Hash.from_xml(response)['Request']['URI']
      return URI::extract(url).first.gsub("&amp;", "&")
    end
    
    private
    # Internal method to build the xml to send to Payment Express
    def build_xml( id, price, options )
      xml = Builder::XmlMarkup.new
      xml.GenerateRequest do
        xml.PxPayUserId PXPAY_CONFIG[:pxpay][:pxpay_user_id]
        xml.PxPayKey PXPAY_CONFIG[:pxpay][:pxpay_key]
        xml.AmountInput sprintf("%.2f", price)
        xml.CurrencyInput options[:currency] || "NZD"
        xml.MerchantReference options[:reference] || id.to_s
        xml.EmailAddress options[:email]
        xml.TxnType "Purchase"
        xml.TxnId id
        xml.UrlSuccess PXPAY_CONFIG[:pxpay][:success_url]
        xml.UrlFail PXPAY_CONFIG[:pxpay][:failure_url]
      end
    end
  end
end