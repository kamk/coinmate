module Coinmate::Model
  class Order
    include ActiveModel::Model
  
    attr_writer :net

    attr_accessor :id, :timestamp, :type, :price, :amount
  
    def initialize(attributes = {})
      super
      self.timestamp = Time.at(timestamp / 1000)
    end
    
    
    def cancel!
      @net.post('cancelOrder', orderId: id)
    end

  end
end
