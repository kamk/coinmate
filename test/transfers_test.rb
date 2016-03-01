require 'test_helper'

class TransfersTest < Minitest::Test
  
  def setup
    @cm = Coinmate::Client.new(CLIENT_ID, PUBKEY, PRIVKEY)
  end


  def test_withdrawal
    VCR.use_cassette('withdrawal') do
      assert 121786, @cm.withdraw_btc(0.13668431, "1B5mzWnLh3NAZg3xfRdU5gMQxTdFYUYYqL")
    end
  end


  def test_deposit_addresses
    VCR.use_cassette('deposit_addresses') do
      assert_equal ["1HdTtLCFyCGaUbYLAiuPwU3kMYLdvX6tYH", "15v16WuR5QgM6wTX5oMBmy78LgNPLoGXm6"],
                   @cm.deposit_addresses
    end
  end
  

  def test_unconfirmed_deposits
    VCR.use_cassette('unconfirmed_deposits') do
      data = @cm.unconfirmed_deposits
      assert_equal 1, data.length 
      assert_equal({ "id" => 121787, "amount" => 0.137, "address" => nil, "numberOfConfirmations" => 0 },
                   data[0])
    end
  end

end