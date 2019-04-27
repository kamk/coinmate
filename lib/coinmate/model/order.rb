module Coinmate::Model
  class Order < Base
    attr_writer :net
    attr_accessor :id, :client_order_id, :timestamp, :type, :currency_pair, :price, :amount, :order_trade_type, :stop_price, :trailing, :trailing_updated_timestamp, :original_stop_price, :market_price_at_last_update, :market_price_at_order_creation, :hidden

    def initialize(attributes = {})
      super
      self.timestamp = Time.at(timestamp / 1000.0)
      self.price = BigDecimal(price, 8)
      self.amount = BigDecimal(amount, 12)
    end
    
    
    def cancel!
      @net.post('cancelOrder', orderId: id)
    end

  end
end
