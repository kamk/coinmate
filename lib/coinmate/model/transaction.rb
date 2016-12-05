module Coinmate::Model
  class Transaction < Base
    
    DEBIT_TRANSACTION_TYPES = %w(SELL QUICK_SELL WITHDRAWAL CREATE_VOUCHER DEBIT)
    
    attr_accessor :transaction_id, :timestamp, :transaction_type,
                  :amount, :amount_currency,
                  :price, :price_currency,
                  :fee, :fee_currency,
                  :description, :status, :order_id, :currency_pair


    def initialize(attributes = {})
      super
      self.timestamp = Time.at(timestamp / 1000.0)
      self.price = BigDecimal.new(price, 8)
      self.amount = BigDecimal.new(amount, 12)
      self.fee = BigDecimal.new(fee, 12) if fee
      if DEBIT_TRANSACTION_TYPES.include?(transaction_type)
        self.amount *= -1
      end
    end


    def fiat_amount
      if price
        (price * amount).round(2)
      else
        raise Coinmate::Error.new("Cannot get fiat_amount for #{transaction_type}")
      end
    end


    def to_hash
      @raw
    end

  end
end