require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'test/unit'
require 'shoulda'
require 'builder'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'pxpay'
require 'rest_client'

Pxpay::Base.pxpay_user_id = 'Test_Dev'
Pxpay::Base.pxpay_key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
Pxpay::Base.url_success = 'http://localhost:3000/success'
Pxpay::Base.url_failure = 'http://localhost:3000/failure'

class Test::Unit::TestCase
end
