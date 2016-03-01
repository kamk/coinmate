module Coinmate::Model
  class Balance
    include ActiveModel::Model
    
    attr_accessor :currency, :balance, :reserved, :available
  end  
end