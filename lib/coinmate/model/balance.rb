module Coinmate::Model
  class Balance < Base
    
    attr_accessor :currency, :balance, :reserved, :available
    
    def initialize(attributes = {})
      super
      self.balance = BigDecimal(balance, 12)
      self.reserved = BigDecimal(reserved, 12)
      self.available = BigDecimal(available, 12)
    end

  end  
end