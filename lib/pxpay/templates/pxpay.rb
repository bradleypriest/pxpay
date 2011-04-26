## Configuration for the PxPay gem for Payment Express

# Your Pxpay UserID and Key
Pxpay::Base.pxpay_user_id = 'ExampleUser'
Pxpay::Base.pxpay_key = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

# Return Endpoints for payment confirmation
# Uncomment for global success & failure URLs
# Pxpay::Base.url_success = 'http://localhost:3000/success'
# Pxpay::Base.url_failure = 'http://localhost:3000/failure'

# Coming Soon Global Variables