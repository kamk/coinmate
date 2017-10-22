module Coinmate::Model
  class Order < Base
    attr_writer :net
    attr_accessor :id, :timestamp, :type, :currency_pair, :price, :amount
  
    def initialize(attributes = {})
      super
      self.timestamp = Time.at(timestamp / 1000.0)
      self.price = BigDecimal.new(price, 8)
      self.amount = BigDecimal.new(amount, 12)
    end
    
    
    def cancel!
      @net.post('cancelOrder', orderId: id)
    end

  end
end
