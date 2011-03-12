module Pxpay
  class Request
    
    attr_accessor :post
    
    def initialize( id , price, options = {} )
      @post = build_xml( id, price, options )
    end
    
    def url
      require 'rest_client'
      response = ::RestClient.post("https://sec2.paymentexpress.com/pxpay/pxaccess.aspx", post )
      url =  Hash.from_xml(response)['Request']['URI']
      return URI::extract(url).first.gsub("&amp;", "&")
    end
    
    private
    
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