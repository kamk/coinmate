module Coinmate::Model  
  class Ticker
    include ActiveModel::Model
  
    attr_accessor :last, :high, :low, :amount, :bid, :ask, :timestamp

    def initialize(attributes = {})
      attributes.each do |a, v|
        p = (a == 'amount') ? 12 : 8
        attributes[a] = BigDecimal.new(v, p)
      end
      super
      self.timestamp = Time.at(attributes['timestamp'])
    end
  end
end
