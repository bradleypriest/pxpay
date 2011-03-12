module Pxpay
  # The return notification from Payment Express 
  class Notification
    mattr_accessor :order_details
    attr_accessor :response
  
    def initialize(response)
      @response = response
    end
    
    # Return the xml response
    def to_xml
      response
    end 
    
    # Return the response as a hash
    def to_hash
      require 'nokogiri'
      doc = Nokogiri::XML(self.response)
      hash = {}
      doc.at_css("Response").element_children.each do |attribute|
        hash[attribute.name.underscore.to_sym] = attribute.inner_text
      end
      hash[:valid] = doc.at_css("Response")['valid']
      hash
    end
  end
end