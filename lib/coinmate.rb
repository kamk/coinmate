require 'active_support'
require 'active_model'
require 'bigdecimal'

require "coinmate/version"
require "coinmate/model/offer"
require "coinmate/model/ticker"
require "coinmate/model/transaction"
require "coinmate/model/balance"
require "coinmate/model/order"
require "coinmate/transactions"
require "coinmate/orders"
require "coinmate/error"
require "coinmate/net_comm"
require "coinmate/client"


module Coinmate
  SERVICE_URI = "https://coinmate.io/api/"
  CURR_PAIR = 'BTC_EUR'

  private
  def self.to_api_params(opts)
    r = {}
    opts.each do |k, v|
      k = k.to_s.camelcase
      k[0] = k[0].downcase
      r[k.to_sym] = v
    end
    r
  end
  
end
