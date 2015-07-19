module Pxpay
  # The response object received from Payment Express
  class Response
    require 'rest_client'
    require 'builder'
    attr_accessor :post
    
    # Create a new Payment Express response object by passing in the return parameters provided to the success/failure URL
    
    def initialize(params, px_pay_user_id = nil, px_pay_key = nil)
      @result = params[:result]
      @user_id = params[:userid]
      @px_pay_user_id = px_pay_user_id
      @px_pay_key = px_pay_key
      @post = build_xml( params[:result] )
    end
    
    # Retrieving the transaction details from Payment Express as an instance of Pxpay::Notification
    def response
      response = ::RestClient.post( Pxpay::Base.pxpay_request_url,  self.post )
      return ::Pxpay::Notification.new( response )
    end
  
    private
    # Internal method to build the xml to send to Payment Express
    def build_xml( result )
      xml = ::Builder::XmlMarkup.new
    
      xml.ProcessResponse do 
        xml.PxPayUserId @px_pay_user_id || ::Pxpay::Base.pxpay_user_id
        xml.PxPayKey    @px_pay_key     || ::Pxpay::Base.pxpay_key
        xml.Response result
      end
    end
  end
end