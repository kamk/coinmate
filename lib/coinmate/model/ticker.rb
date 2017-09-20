module Coinmate::Model  
  class Ticker < Base
    include ActiveModel::Model
  
    attr_accessor :last, :high, :low, :amount, :bid, :ask, :change, :open, :timestamp

    def initialize(attributes = {})
      super
      attributes.each do |a, v|
        next if a == 'timestamp'
        public_send("#{a}=".to_sym, BigDecimal.new(v, (a == 'amount') ? 12 : 8))
      end
      self.timestamp = Time.at(attributes['timestamp'])
    end
  end
end
