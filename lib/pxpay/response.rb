module Pxpay
  class Response
    attr_accessor :post
    def initialize(params)
      @result = params[:result]
      @user_id = params[:userid]
      @post = build_xml( params[:result] )
    end
    
    # Retrieving the transaction details from Payment Express as an instance of Pxpay::Notification
    def response
      require 'rest_client'
      response = ::RestClient.post( 'https://www.paymentexpress.com/pxpay/pxaccess.aspx',  self.post )
      return ::Pxpay::Notification.new( response )
    end
  
    private
    # Internal method to build the xml to send to Payment Express
    def build_xml( result )
      xml = ::Builder::XmlMarkup.new
    
      xml.ProcessResponse do 
        xml.PxPayUserId PXPAY_CONFIG[:pxpay][:pxpay_user_id]
        xml.PxPayKey PXPAY_CONFIG[:pxpay][:pxpay_key]
        xml.Response result
      end
    end
  end
end