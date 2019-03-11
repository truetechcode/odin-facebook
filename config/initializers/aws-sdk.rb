require 'aws-sdk-s3'

Aws.config.update({
  access_key_id: ENV['AWS_ACCESS_KEY_ID'] ,
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
  region: 'eu-west-2'
  #bucket: 'odin-book-jttm',
  #service: 'S3'
})

Aws.config.update({
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'] ,ENV['AWS_SECRET_ACCESS_KEY'])
})
