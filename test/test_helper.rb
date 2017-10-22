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
PUBKEY = "LX4z8o5p00_0aZtbU-3TydoBY8VTawhkIDzj7t2vUio"
PRIVKEY = "oiBpIeM7UIRBK_GmdDgWZvI2R-oVu45p4YG4GqCW7Xk"


# BigDecimal numbers
def to_bigd(num)
  BigDecimal.new(num, 12)
end
