module Coinmate
  class Client
  
    def initialize(client_id = nil, pubkey = nil, privkey = nil)
      @net = Coinmate::NetComm.new(client_id, pubkey, privkey)
    end

    def order_book
      data = @net.get('orderBook', currencyPair: CURR_PAIR, groupByPriceLimit: 'True')
      %w(asks bids).each do |dir|
        data[dir].map!{ |e| Coinmate::Model::Offer.new(e) }
      end
      data
    end


    # Get ticker data
    def ticker
      data = @net.get('ticker', currencyPair: CURR_PAIR)
      Coinmate::Model::Ticker.new(data)
    end


    # Access to tranasactions
    def transactions
      @transactions ||= Coinmate::Transactions.new(@net)
    end


    # Get balances
    def balances
      data = @net.post('balances')
      data.each do |currency, balance|
        data[currency] = Coinmate::Model::Balance.new(balance)
      end
      data
    end
    

    # Access to orders
    def orders
      @orders ||= Coinmate::Orders.new(@net)
    end


    def withdraw_btc(amount, address)
      @net.post('bitcoinWithdrawal', amount: amount, address: address)
    end


    def deposit_addresses
      @net.post('bitcoinDepositAddresses')
    end


    def unconfirmed_deposits
      @net.post('unconfirmedBitcoinDeposits')
    end

  end
end
