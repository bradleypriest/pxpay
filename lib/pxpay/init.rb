if File.exists?("#{Rails.root}/config/pxpay.yml")
  PXPAY_CONFIG = YAML.load_file("#{Rails.root}/config/pxpay.yml")[Rails.env]
else
  print "Please run rails generate pxpay:install to generate a pxpay config file"
end