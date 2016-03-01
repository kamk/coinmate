require 'test_helper'

class PublicApiTest < Minitest::Test

  def setup
    @cm = Coinmate::Client.new
  end

  
  def test_order_book
    VCR.use_cassette('order_book') do
      data = @cm.order_book
      # ASKS side
      assert_includes data, 'asks'
      [ { price: 393.83, amount: 0.30947198 },
        { price: 393.93, amount: 0.01635127 },
        { price: 393.96, amount: 0.01794565 }
      ].each_with_index do |offer, i|
        check_order_book(offer, data['asks'][i])
      end
      # BIDS side
      assert_includes data, 'bids'
      [ { price: 392.98, amount: 0.508931 },
        { price: 392.97, amount: 0.30947198 },
        { price: 392.85, amount: 0.58687988}
      ].each_with_index do |offer, i|
        check_order_book(offer, data['bids'][i])
      end
    end
  end
  
  
  def test_ticker
    VCR.use_cassette('ticker') do
      data = @cm.ticker
      assert_instance_of Coinmate::Model::Ticker, data
      assert_equal to_bigd(391.06), data.last
      assert_equal to_bigd(394), data.high
      assert_equal to_bigd(385.91), data.low
      assert_equal to_bigd(83.11065935), data.amount
      assert_equal to_bigd(392.23), data.bid
      assert_equal to_bigd(392.49), data.ask
      assert_equal Time.at(1456692517), data.timestamp
    end
  end


  def test_transactions
    VCR.use_cassette('public_transactions') do
      data = @cm.transactions.all(240)
      [ { timestamp: 1456718339, transactionId: "121640", price: 393.85, amount: 0.71841753 },
        { timestamp: 1456718284, transactionId: "121639", price: 393.74, amount: 0.58687988 },
        { timestamp: 1456716964, transactionId: "121638", price: 393.65, amount: 0.09845169 }
      ].each_with_index do |tx, i|
        assert_equal Time.at(tx[:timestamp]), data[i].timestamp
        assert_equal tx[:transactionId], data[i].transaction_id
        assert_equal tx[:price], data[i].price
        assert_equal tx[:amount], data[i].amount
      end
    end
  end


  private
  def check_order_book(offer, data)
    price, amount = to_bigd(offer[:price]), to_bigd(offer[:amount])
    assert_equal price, data.price
    assert_equal amount, data.amount
    assert_equal price * amount, data.price_total
  end

end