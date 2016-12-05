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
PUBKEY = "k44fJw6plTKGLxHy-N1iYOmHJvWjFymR6DJuuN-NBJM"
PRIVKEY = "i6hRWMytiycrmfcjY1u6rJt9NtmWaF9Glww0bsanw4s"


# BigDecimal numbers
def to_bigd(num)
  BigDecimal.new(num, 12)
end
