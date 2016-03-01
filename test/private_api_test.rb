require 'test_helper'

class PrivateApiTest < Minitest::Test
    
  def setup
    @cm = Coinmate::Client.new(CLIENT_ID, PUBKEY, PRIVKEY)
  end
  
  
  def test_balances
    VCR.use_cassette('balances') do
      data = @cm.balances
      eur = data['EUR']
      assert_equal 'EUR', eur.currency
      assert_equal 44.53277936, eur.balance
      assert_equal 9.97010256, eur.reserved
      assert_equal 34.56267680, eur.available
      btc = data['BTC']
      assert_equal 'BTC', btc.currency
      assert_equal 0.02533462, btc.balance
      assert_equal 0.01, btc.reserved
      assert_equal 0.01533462, btc.available
    end
  end


  def test_orders
    VCR.use_cassette('orders') do
      data = @cm.orders.all
      sell_order = data[0]
      assert_equal 3611161, sell_order.id
      assert_equal Time.at(1456736191), sell_order.timestamp
      assert_equal 'SELL', sell_order.type
      assert_equal 405, sell_order.price
      assert_equal 0.01, sell_order.amount
      buy_order = data[1]
      assert_equal 3611158, buy_order.id
      assert_equal Time.at(1456736153), buy_order.timestamp
      assert_equal 'BUY', buy_order.type
      assert_equal 380, buy_order.price
      assert_equal 0.026224, buy_order.amount
    end
  end


  def test_cancel_order
    VCR.use_cassette('cancel_order') do
      order = @cm.orders.find(3611161)
      assert order.cancel!
    end
  end

  
  def test_transactions
    VCR.use_cassette('user_transactions') do
      data = @cm.transactions.user(limit: 2)
      sell_tx = data[0]
      assert_equal 121675,      sell_tx.transaction_id
      assert_equal 'SELL',      sell_tx.transaction_type
      assert_equal 394.09,      sell_tx.price
      assert_equal 'EUR',       sell_tx.price_currency
      assert_equal -0.025,      sell_tx.amount
      assert_equal 'BTC',       sell_tx.amount_currency
      assert_equal 0.03448287,  sell_tx.fee
      assert_equal 'EUR',       sell_tx.fee_currency
      assert_nil                sell_tx.description
      assert_equal 'OK',        sell_tx.status
      assert_equal 3611652,     sell_tx.order_id
      buy_tx = data[1]
      assert_equal 121670,      buy_tx.transaction_id
      assert_equal 'BUY',       buy_tx.transaction_type
      assert_equal 394,         buy_tx.price
      assert_equal 'EUR',       buy_tx.price_currency
      assert_equal 0.01820933,  buy_tx.amount
      assert_equal 'BTC',       buy_tx.amount_currency
      assert_equal 0.02511066,  buy_tx.fee
      assert_equal 'EUR',       buy_tx.fee_currency
      assert_nil                buy_tx.description
      assert_equal 'OK',        buy_tx.status
      assert_equal 3611628,     buy_tx.order_id
    end
  end


  def test_buy_limit
    VCR.use_cassette('buy_limit') do
      assert_equal 3611628, @cm.orders.buy_limit(0.025, 394)
    end    
  end


  def test_sell_limit
    VCR.use_cassette('sell_limit') do
      assert_equal 3611652, @cm.orders.sell_limit(0.025, 394)
    end    
  end


  def test_buy_instant
    VCR.use_cassette('buy_instant') do
      assert 3612415, @cm.orders.buy_instant(24.52)
    end
  end

end
