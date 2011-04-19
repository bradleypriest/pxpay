module Pxpay
  # The request object to send to Payment Express
  class Request
    require 'pxpay/error'
    require 'rest_client'
    require 'nokogiri'
    require 'builder'
    
    attr_accessor :post
    
    # Create a new instance of Pxpay::Request
    # Pxpay::Request.new( id, amount, options = {} )
    # Current available options are:
    # :currency, currency for transaction, default is NZD, can be any of Pxpay::Base.currency_types
    # :reference, a reference field, default is the id.
    # :email, email address of user, default is nil.
    # :token_billing, boolean value, set to true to enable token billing.
    # :billing_id, optional billing_id field only used if token_billing is set to true.
    # :txn_type, can be set to :auth for Auth transaction, defaults to Purchase
    
    def initialize( id , price, options = {} )
      @post = build_xml( id, price, options )
    end
    
    # Get the redirect URL from Payment Express
    def url
      response = ::RestClient.post("https://sec2.paymentexpress.com/pxpay/pxaccess.aspx", post )
      response_text = ::Nokogiri::XML(response)
      if response_text.at_css("Request").attributes["valid"].value == "1"
        url = response_text.at_css("URI").inner_html
      else
        if Pxpay::Base.pxpay_user_id
          raise Pxpay::Error, response_text.at_css("Request").inner_html
        else
          raise Pxpay::MissingKey, "Your Pxpay config is not set up properly, run rails generate pxpay:install"
        end
      end
      return URI::extract(url).first.gsub("&amp;", "&")
    end
    
    private
    # Internal method to build the xml to send to Payment Express
    def build_xml( id, price, options )
      xml = ::Builder::XmlMarkup.new
      xml.GenerateRequest do
        xml.PxPayUserId ::Pxpay::Base.pxpay_user_id
        xml.PxPayKey ::Pxpay::Base.pxpay_key
        xml.AmountInput sprintf("%.2f", price)
        xml.CurrencyInput options[:currency] || "NZD"
        xml.MerchantReference options[:reference] || id.to_s
        xml.EmailAddress options[:email]
        xml.TxnType options[:txn_type] ? options[:txn_type].to_s.capitalize : "Purchase"
        xml.TxnId id
        xml.UrlSuccess ::Pxpay::Base.success_url
        xml.UrlFail ::Pxpay::Base.failure_url
        xml.EnableAddBillCard 1 if options[:token_billing]
        xml.BillingId options[:billing_id] if options[:token_billing]
      end
    end
  end
end