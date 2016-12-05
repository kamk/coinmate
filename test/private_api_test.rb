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
      assert_equal to_bigd(16.64502607), eur.balance
      assert_equal to_bigd(7.0035), eur.reserved
      assert_equal to_bigd(9.64152607), eur.available
      btc = data['BTC']
      assert_equal 'BTC', btc.currency
      assert_equal to_bigd(0.03647412), btc.balance
      assert_equal to_bigd(0.02), btc.reserved
      assert_equal to_bigd(0.01647412), btc.available
    end
  end


  def test_orders
    VCR.use_cassette('orders') do
      data = @cm.orders.all
      sell_order = data[0]
      assert_equal 9737946, sell_order.id
      assert_equal Time.at(1480951952327 / 1000.0), sell_order.timestamp
      assert_equal 'SELL', sell_order.type
      assert_equal to_bigd(725), sell_order.price
      assert_equal to_bigd(0.02), sell_order.amount
      buy_order = data[1]
      assert_equal 9737945, buy_order.id
      assert_equal Time.at(1480951950543 / 1000.0), buy_order.timestamp
      assert_equal 'BUY', buy_order.type
      assert_equal to_bigd(350), buy_order.price
      assert_equal to_bigd(0.02), buy_order.amount
    end
  end


  def test_cancel_order
    VCR.use_cassette('cancel_order') do
      order = @cm.orders.find(9737945)
      assert order.cancel!
      order = @cm.orders.find(9737946)
      assert order.cancel!
    end
  end


  def test_transactions
    VCR.use_cassette('user_transactions') do
      data = @cm.transactions.user(offset: 4, limit: 2)
      buy_tx = data[0]
      assert_equal Time.at(1480945482259 / 1000.0), buy_tx.timestamp
      assert_equal 284115,              buy_tx.transaction_id
      assert_equal 'BUY',               buy_tx.transaction_type
      assert_equal to_bigd(707.89),     buy_tx.price
      assert_equal 'EUR',               buy_tx.price_currency
      assert_equal to_bigd(0.005),      buy_tx.amount
      assert_equal 'BTC',               buy_tx.amount_currency
      assert_equal to_bigd(0.01238807), buy_tx.fee
      assert_equal 'EUR',               buy_tx.fee_currency
      assert_nil                        buy_tx.description
      assert_equal 'OK',                buy_tx.status
      assert_equal 9736364,             buy_tx.order_id
      assert_equal to_bigd(3.54),       buy_tx.fiat_amount
      sell_tx = data[1]
      assert_equal Time.at(1480945439607 / 1000.0), sell_tx.timestamp
      assert_equal 284107,              sell_tx.transaction_id
      assert_equal 'SELL',              sell_tx.transaction_type
      assert_equal to_bigd(706.58),     sell_tx.price
      assert_equal 'EUR',               sell_tx.price_currency
      assert_equal to_bigd(-0.02),      sell_tx.amount
      assert_equal 'BTC',               sell_tx.amount_currency
      assert_equal to_bigd(0.0494606),  sell_tx.fee
      assert_equal 'EUR',               sell_tx.fee_currency
      assert_nil                        sell_tx.description
      assert_equal 'OK',                sell_tx.status
      assert_equal 9736352,             sell_tx.order_id
      assert_equal to_bigd(-14.13),     sell_tx.fiat_amount
    end
  end


  def test_buy_limit
    VCR.use_cassette('buy_limit') do
      assert_equal 9737945, @cm.orders.buy_limit(0.02, 350)
    end
  end


  def test_sell_limit
    VCR.use_cassette('sell_limit') do
      assert_equal 9737946, @cm.orders.sell_limit(0.02, 725)
    end
  end


  def test_buy_instant
    VCR.use_cassette('buy_instant') do
      assert_equal 9740025, @cm.orders.buy_instant(15)
    end
  end


  def test_sell_instant
    VCR.use_cassette('sell_instant') do
      assert_equal 9740107, @cm.orders.sell_instant(0.02)
    end
  end

end
