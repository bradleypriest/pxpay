module Pxpay
  class Notification
    mattr_accessor :order_details
    attr_accessor :hash, :xml
  
    def initialize(response)
      @hash = parse(response)
      @xml = response
    end
  
    def parse(response)
      require 'nokogiri'
      doc = Nokogiri::XML(response)
      hash = {}
      doc.at_css("Response").element_children.each do |attribute|
        hash[attribute.name.underscore.to_sym] = attribute.inner_text# if ::Pxpay::Base.return_details.include?(attribute.name)
      end
      hash
    end
  end
end