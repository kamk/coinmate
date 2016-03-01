module Coinmate
  class Orders
    
    def initialize(net)
      @net = net
    end


    def all
      @net.post('openOrders', currencyPair: CURR_PAIR) \
          .map do |order|
            o = Coinmate::Model::Order.new(order)
            o.net = @net
            o
          end
    end


    def find(order_id)
      order = @net.post('openOrders', currencyPair: CURR_PAIR) \
                  .detect{ |o| o['id'] == order_id }
      return unless order
      order = Coinmate::Model::Order.new(order)
      order.net = @net
      order
    end


    def buy_limit(amount, price)
      @net.post('buyLimit', amount: amount, price: price, currencyPair: CURR_PAIR)
    end

    def sell_limit(amount, price)
      @net.post('sellLimit', amount: amount, price: price, currencyPair: CURR_PAIR)
    end

    def buy_instant(total)
      @net.post('buyInstant', total: total, currencyPair: CURR_PAIR)
    end

    def sell_instant(amount)
      @net.post('buyInstant', amount: amount, currencyPair: CURR_PAIR)
    end

  end
end