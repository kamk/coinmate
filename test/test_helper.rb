$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'vcr'
require 'pry'

require 'coinmate'

require 'minitest/autorun'

VCR.configure do |config|
  config.cassette_library_dir = "test/vcr_cassettes"
  config.default_cassette_options = {
    match_requests_on: [
      :method,
      VCR.request_matchers.uri_without_param(:nonce, :signature)
    ]
  }
  config.hook_into :webmock
end


# API keys
CLIENT_ID = 2629
PUBKEY = "anM7oLqI6QwICoFO5ikQ-7oQ-EX5CcRKYtq3JyhdsJw"
PRIVKEY = "l8IbN2JOD5n7Lw3jjPg6ovvYHSr3eBi2341HdNg0_eM"


# BigDecimal numbers
def to_bigd(num)
  BigDecimal.new(num, 12)
end
