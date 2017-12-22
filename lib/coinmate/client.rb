module Coinmate
  class Client

    def initialize(client_id = nil, pubkey = nil, privkey = nil, currency_pair = nil)
      @net = Coinmate::NetComm.new(client_id, pubkey, privkey)
      @currency_pair = currency_pair
    end

    def order_book(params = {})
      data = @net.get('orderBook', currencyPair: currency_pair(params), groupByPriceLimit: 'True')
      %w(asks bids).each do |dir|
        data[dir].map!{ |e| Coinmate::Model::Offer.new(e) }
      end
      data
    end


    # Get ticker data
    def ticker(params = {})
      data = @net.get('ticker', currencyPair: currency_pair(params))
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
    def orders(params = {})
      @orders ||= Coinmate::Orders.new(@net, currency_pair(params))
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

    private

    def currency_pair(params = {})
      params[:currencyPair] || @currency_pair || DEFAULT_CURR_PAIR
    end
  end
end
