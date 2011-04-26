PxPay
=======
A Rubygem to integrate DPS-hosted payments through the Payment Express PxPay system.

Notice:
-------
The upgrade from 0.1.3 - 0.2.0 is not backwards compatible. It has changed from a yml file to variables for config

For self-hosted systems check out the amazing [ActiveMerchant](https://www.github.com/Shopify/active_merchant) gem.

See <http://www.paymentexpress.com/technical_resources/ecommerce_hosted/pxpay.html> or <http://www.paymentexpress.com/downloads/DPSECOM_PXPay.pdf> for more details about PxPay.

Installation
------------
Install from Rubygems
    gem install pxpay
Then run `rails generate pxpay:install` to copy an initializer and a config yml file to your rails app.
Make sure you add your own development credentials to the `config/initializers/pxpay.rb` file and create success and failure URLs for Payment Express to redirect you back.
You can apply for a development account at <https://www.paymentexpress.com/pxmi/apply>


Usage
-----
    >> require 'nokogiri'
    >> require 'pxpay'
    >> request = Pxpay::Request.new( 1, 12.00, {:url_success => 'http://example.com/success/', :url_failure => 'http://example.com/failure'})
    => #<Pxpay::Request:0x00000101c9a840 >
    >> request.url
    => "https://sec2.paymentexpress.com/pxpay/pxpay.aspx?userid=Fake_Dev&request=xxxxxxxxxx"


To send your customer to Payment Express for payment make a call to Pxpay::Request to request a redirection URL

    def create
      request = Pxpay::Request.new( id , price, options )
      redirect_to request.url
    end

Once your customer has entered their details Payment Express will redirect them back to the success URL that you provided.

Use Pxpay:Response to get the transaction details back from Payment Express.

    def success
      response = Pxpay::Response.new(params).response
      hash = response.to_hash
      ## Do something with the results hash
    end

N.B. There is a minor caveat here: Payment Express includes a system called fail-proof result notification where as soon as the customer has finished the transaction they will send a background request.

This means your success/failure URL will be hit at least twice for each transaction, so you must allow for this in your code. See <http://www.paymentexpress.com/technical_resources/ecommerce_hosted/pxpay.html#ResultNotification> for details.


Token Billing can be implemented by setting `:token_billing => true` inside the Request option hash.
N.B.
----

This gem is in no way endorsed or affiliated with Payment Express

TODO
----
* Add ability to set global configuration options
* Add more tests
* Add support for optional text fields

Contributing to PxPay
=====================
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

Copyright
=========

Copyright (c) 2011 Bradley Priest. See LICENSE.txt for
further details.

