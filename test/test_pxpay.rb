require 'helper'


class TestPxpay < Test::Unit::TestCase
  context "create a request object" do
    setup do
      @request = Pxpay::Request.new( 1, 12.34 )
    end
  
    should "generate an xml request" do
      assert_match(/GenerateRequest/, @request.post )
    end

    should "generate an xml request with username and id" do
      assert_match(/<PxPayUserId>Test_Dev<\/PxPayUserId><PxPayKey>\w{64}<\/PxPayKey>/, @request.post )
    end
    
    should "generate an xml request with correct amount" do
      assert_match(/<AmountInput>12.34<\/AmountInput>/, @request.post)
    end
    
    # should "return a URL" do
    #   assert_match(/https:\/\/sec2.paymentexpress.com\/pxpay\/pxpay.aspx\?userid=\w{64}&request=\S{270}/, @request.url)
    # end
  end
  
  context "create a response object" do
    setup do
      @response_text = "v5l4alYudyoKcCD1vSADyfiuWv4QqCKyJVdaXCuJR0_7jUyj9reTWi7Jdhe5-xtbDRlwLpPG56qO7AOKR-h65Awaa886kw9vjf5YglO1fz2wyyshMsaJT5XrEhGFBsNLycaqou0rxwRxF4Y0chcA_laRn8Ev1sOqpNNXafUwP2fDMQVQ7gla11Ibdv7K5v0TIvV28rPVLZgnbty5rtnK_AdR0W9XOXpo6w4NlNzh81KcFJeVc_5n_4QITRZ1zVYrrCGzg3T3S902ej1kgqBGGJf904IWEgNfbjc8teg3ereUWLYhDK-E3FrP-v3L06VxRwR96wZkkO2rucYUrxc2drOQfZipqijabZTRjyoLK37jFQkg5JfrQPOvXZaQeY6eby2Voh_XLAYtoUawPPvkupiEI3b5_TlANhnOLl0_fUS95ObLG1VIHenw=="
      @response = Pxpay::Response.new(:userid => 'Test_Dev', :result => @response_text )
    end
    
    should "generate an xml request" do
      assert_match(/ProcessResponse/, @response.post )
    end

    should "generate an xml request with username and id" do
      assert_match(/<PxPayUserId>#{Pxpay::Base.pxpay_user_id}<\/PxPayUserId><PxPayKey>#{Pxpay::Base.pxpay_key}<\/PxPayKey>/, @response.post )
    end
    
    should "generate an xml request with the correct response text" do
      assert_match( %r(<Response>#{@response_text}</Response), @response.post)
    end    
  end
  
  context "create a notification" do
    setup do
      @notification = Pxpay::Notification.new( File.read('test/response.xml') )
    end
  
    should "parse xml to hash" do
      assert_instance_of(Hash, @notification.to_hash )
    end
    
    should "return info in hash" do
      assert_match(@notification.to_hash[:success], "1")
      assert_match(@notification.to_hash[:valid], "1")
      assert_match(@notification.to_hash[:amount_settlement], "12.00")
    end
  end
end
