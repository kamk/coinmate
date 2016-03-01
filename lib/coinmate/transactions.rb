module Coinmate
  class Transactions
    
    def initialize(net)
      @net = net
    end

    # Public transactions
    def all(minutes_ago = 10)
      @net.get('transactions', minutesIntoHistory: minutes_ago) \
          .map{ |t| Coinmate::Model::Transaction.new(t) }
    end

    
    # User transactions
    def user(options = {})
      @net.post('transactionHistory', Coinmate.to_api_params(options)) \
          .map{ |t| Coinmate::Model::Transaction.new(t) }
    end


  end
end