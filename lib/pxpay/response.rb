module Pxpay
  class Response
    attr_accessor :result
    def initialize(params)
      @result = params[:result]
      @user_id = params[:userid]
    end
  
    def response
      require 'rest_client'
      response = ::RestClient.post( 'https://www.paymentexpress.com/pxpay/pxaccess.aspx', build_xml( result ) )
      return ::Pxpay::Notification.new( response )
    end
  
    private
    def build_xml( result )
      xml = Builder::XmlMarkup.new
    
      xml.ProcessResponse do 
        xml.PxPayUserId PXPAY_CONFIG[:pxpay][:pxpay_user_id]
        xml.PxPayKey PXPAY_CONFIG[:pxpay][:pxpay_key]
        xml.Response result
      end
    end
  end
end