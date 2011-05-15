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
    # :currency_input,      currency for transaction, default is NZD, can be any of Pxpay::Base.currency_types
    # :merchant_reference,  a reference field, default is the id.
    # :email_address,       email address of user, optional.
    # :token_billing,       boolean value, set to true to enable token billing.
    # :billing_id,          optional billing_id field only used if token_billing is set to true.
    # :txn_type,            can be set to :auth for Auth transaction, defaults to Purchase
    # :url_success,         Success URL, can optionally be set globally via Pxpay::Base.url_success=
    # :url_failure,         Failure URL, can optionally be set globally via Pxpay::Base.url_failure=
    # :txn_data1,           Optional data
    # :txn_data2,           Optional data
    # :txn_data3,           Optional data
    # :txn_data4,           Optional data
    # :opt,                 Optional data
    
    def initialize( id , price, options = {} )
      warn "Using :reference is deprecated, please use :merchant_reference instead" if options[:reference]
      @post = build_xml( id, price, options )
    end
    
    # Get the redirect URL from Payment Express
    def url
      response = ::RestClient.post("https://sec2.paymentexpress.com/pxpay/pxaccess.aspx", post )
      response_text = ::Nokogiri::XML(response)
      if response_text.at_css("Request").attributes["valid"].value == "1"
        url = response_text.at_css("URI").inner_html
      else
        if Pxpay::Base.pxpay_user_id && Pxpay::Base.pxpay_key
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
        xml.PxPayUserId       ::Pxpay::Base.pxpay_user_id
        xml.PxPayKey          ::Pxpay::Base.pxpay_key
        xml.AmountInput       sprintf("%.2f", price)
        xml.TxnId             id
        xml.TxnType           options[:txn_type]            ? options[:txn_type].to_s.capitalize : "Purchase"
        xml.CurrencyInput     options[:currency_input]      || "NZD"
        xml.MerchantReference options[:merchant_reference]  || options[:reference]       || id.to_s ## Backwards compatibility
        xml.UrlSuccess        options[:url_success]         || ::Pxpay::Base.url_success 
        xml.UrlFail           options[:url_failure]         || ::Pxpay::Base.url_failure
        xml.EmailAddress      options[:email_address]       if options[:email_address]
        xml.TxnData1          options[:txn_data1]           if options[:txn_data1]
        xml.TxnData2          options[:txn_data2]           if options[:txn_data2]
        xml.TxnData3          options[:txn_data3]           if options[:txn_data3]
        xml.TxnData4          options[:txn_data4]           if options[:txn_data4]
        xml.Opt               options[:opt]                 if options[:opt]
        xml.EnableAddBillCard 1                             if options[:token_billing]
        xml.BillingId         options[:billing_id]          if options[:token_billing]
      end
    end
  end
end