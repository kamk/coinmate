module Coinmate
  class Orders

    def initialize(net, currency_pair)
      @net = net
      @currency_pair = currency_pair
    end


    def all
      @net.post('openOrders', currencyPair: @currency_pair) \
          .map do |order|
            o = Coinmate::Model::Order.new(order)
            o.net = @net
            o
          end
    end


    def find(order_id)
      order = @net.post('openOrders', currencyPair: @currency_pair) \
                  .detect{ |o| o['id'] == order_id }
      return unless order
      order = Coinmate::Model::Order.new(order)
      order.net = @net
      order
    end


    def buy_limit(amount, price)
      @net.post('buyLimit', amount: amount, price: price, currencyPair: @currency_pair)
    end

    def sell_limit(amount, price)
      @net.post('sellLimit', amount: amount, price: price, currencyPair: @currency_pair)
    end

    def buy_instant(total)
      @net.post('buyInstant', total: total, currencyPair: @currency_pair)
    end

    def sell_instant(amount)
      @net.post('sellInstant', amount: amount, currencyPair: @currency_pair)
    end

  end
end
