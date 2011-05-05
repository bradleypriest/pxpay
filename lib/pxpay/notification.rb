module Pxpay
  # The return notification from Payment Express 
  class Notification
    require 'nokogiri'
    attr_accessor :response
    # Create a new Notification from Payment Express' response
    def initialize(response)
      @response = response
    end
    
    # Return the xml response
    def to_xml
      response
    end 
    
    # Return the response as a hash
    def to_hash
      doc = ::Nokogiri::XML( self.response )
      hash = {}
      doc.at_css("Response").element_children.each do |attribute|
        hash[attribute.name.underscore.to_sym] = attribute.inner_text
      end
      hash
    end
  end
end

class String
  # A copy of Rails' ActiveSupport underscore method
   def underscore
     self.gsub(/::/, '/').
     gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
     gsub(/([a-z\d])([A-Z])/,'\1_\2').
     tr("-", "_").
     downcase
   end
end