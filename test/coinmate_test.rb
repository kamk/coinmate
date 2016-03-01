require 'test_helper'

class CoinmateTest < Minitest::Test
  
  def test_that_it_has_a_version_number
    refute_nil ::Coinmate::VERSION
  end

end
