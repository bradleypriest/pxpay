module Pxpay
  # The response object received from Payment Express
  class Response
    attr_accessor :post
    
    # Create a new Payment Express response object by passing in the return parameters provided to the success/failure URL
    
    def initialize(params)
      @result = params[:result]
      @user_id = params[:userid]
      @post = build_xml( params[:result] )
    end
    
    # Retrieving the transaction details from Payment Express as an instance of Pxpay::Notification
    def response
      require 'rest_client'
      response = ::RestClient.post( Pxpay::Base.pxpay_request_url,  self.post )
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