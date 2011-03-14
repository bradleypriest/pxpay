if File.exists?("#{Rails.root}/config/pxpay.yml")
  PXPAY_CONFIG = YAML.load_file("#{Rails.root}/config/pxpay.yml")[Rails.env]
else
  PXPAY_CONFIG = []
end