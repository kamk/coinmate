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
      [ { price: 710.9,  amount: 0.04 },
        { price: 710.91, amount: 0.2389556 },
        { price: 711.01, amount: 5 },
        { price: 712.26, amount: 0.8116528 },
        { price: 712.27, amount: 0.37 },
      ].each_with_index do |offer, i|
        check_order_book(offer, data['asks'][i])
      end
      # BIDS side
      assert_includes data, 'bids'
      [ { price: 709.86, amount: 0.281745 },
        { price: 709.85, amount: 0.01037433 },
        { price: 708.9,  amount: 0.4 },
        { price: 708.89, amount: 0.68387475 },
        { price: 708.86, amount: 4.788565 }
      ].each_with_index do |offer, i|
        check_order_book(offer, data['bids'][i])
      end
    end
  end

  def test_order_book_czk
    VCR.use_cassette('order_book_czk') do
      data = Coinmate::Client.new(nil, nil, nil, 'BTC_CZK').order_book
      # ASKS side
      assert_includes data, 'asks'
      [ { price: 180100,  amount: 0.00126278 },
        { price: 180377.6, amount: 1.67066532 },
        { price: 180479.94, amount: 0.12162191 }
      ].each_with_index do |offer, i|
        check_order_book(offer, data['asks'][i])
      end
      # BIDS side
      assert_includes data, 'bids'
      [ { price: 180095.75, amount: 0.05453235 },
        { price: 179589.04, amount: 0.0112 },
        { price: 179589.03,  amount: 0.038438 }
      ].each_with_index do |offer, i|
        check_order_book(offer, data['bids'][i])
      end
    end
  end

  def test_ticker
    VCR.use_cassette('ticker') do
      data = @cm.ticker
      assert_instance_of Coinmate::Model::Ticker, data
      assert_equal to_bigd(711.01), data.last
      assert_equal to_bigd(730.69), data.high
      assert_equal to_bigd(705), data.low
      assert_equal to_bigd(139.41507092), data.amount
      assert_equal to_bigd(709.88), data.bid
      assert_equal to_bigd(711), data.ask
      assert_equal Time.at(1480951456), data.timestamp
    end
  end

  def test_ticker_czk
    VCR.use_cassette('ticker_czk') do
      data = @cm.ticker(currencyPair: 'BTC_CZK')
      assert_instance_of Coinmate::Model::Ticker, data
      assert_equal to_bigd(179313.35), data.last
      assert_equal to_bigd(180000), data.high
      assert_equal to_bigd(172000), data.low
      assert_equal to_bigd(98.17279234), data.amount
      assert_equal to_bigd(179300), data.bid
      assert_equal to_bigd(179900), data.ask
      assert_equal to_bigd(1.91), data.change
      assert_equal to_bigd(175950.81), data.open
      assert_equal Time.at(1511271993), data.timestamp
    end
  end

  def test_transactions
    VCR.use_cassette('public_transactions') do
      data = @cm.transactions.all
      [ { timestamp: 1480951251433, transactionId: "284285", price: 711.01, amount: 0.3 },
        { timestamp: 1480951237277, transactionId: "284282", price: 711.01, amount: 1.1210444 },
        { timestamp: 1480951235873, transactionId: "284279", price: 710.91, amount: 0.2389556 }
      ].each_with_index do |tx, i|
        assert_equal Time.at(tx[:timestamp] / 1000.0), data[i].timestamp
        assert_equal tx[:transactionId], data[i].transaction_id
        assert_equal tx[:price], to_bigd(data[i].price)
        assert_equal tx[:amount], to_bigd(data[i].amount)
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
