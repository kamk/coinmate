module Coinmate::Model
  class Offer < Base
    attr_accessor :price, :amount
    
    def initialize(attributes = {})
      super
      self.price = BigDecimal.new(price, 8)
      self.amount = BigDecimal.new(amount, 12)
    end

    
    def price_total
      price * amount
    end

  end
end