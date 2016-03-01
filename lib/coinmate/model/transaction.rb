module Coinmate::Model
  class Transaction
    include ActiveModel::Model
    
    DEBIT_TRANSACTION_TYPES = %w(SELL QUICK_SELL WITHDRAWAL CREATE_VOUCHER DEBIT)
    
    attr_accessor :transaction_id, :timestamp, :transaction_type,
                  :amount, :amount_currency,
                  :price, :price_currency,
                  :fee, :fee_currency,
                  :description, :status, :order_id, :currency_pair


    def initialize(attributes = {})
      attributes.each do |a, v|
        v = Time.at(v / 1000) if a == 'timestamp'
        send((a.underscore + '=').to_sym, v)
      end
      if DEBIT_TRANSACTION_TYPES.include?(transaction_type)
        self.amount *= -1
      end
    end

  end
end