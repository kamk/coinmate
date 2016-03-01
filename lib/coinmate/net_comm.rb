require 'uri'
require 'net/http'
require 'json'
require 'openssl'

module Coinmate
  class NetComm

    PRIVATE_RESOURCES = %w(balances transactionHistory openOrders cancelOrder buyLimit sellLimit buyInstant sellInstant bitcoinWithdrawal bitcoinDepositAddresses unconfirmedBitcoinDeposits)
    SHA256_DIGEST = OpenSSL::Digest.new('sha256')

    
    def initialize(client_id, pubkey, privkey)
      @client_id = client_id
      @public_key = pubkey
      @private_key = privkey
    end


    def get(resource, params = {})
      perform(Net::HTTP::Get, resource, params)
    end


    def post(resource, params = {})
      perform(Net::HTTP::Post, resource, params)
    end


    private
    def configured?
      @client_id && @public_key && @private_key
    end
    
        
    def perform(req_klass, resource, params)
      result = {}
      if PRIVATE_RESOURCES.include?(resource)
        raise Coinmate::Error.new("Missing API keys") unless configured?
        params.merge!(signature_params)
      end
      uri = URI(Coinmate::SERVICE_URI + resource)
      uri.query = URI.encode_www_form(params)

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        response = http.request req_klass.new(uri)
        unless response.is_a?(Net::HTTPSuccess)
          http.finish
          raise Coinmate::Error.new(sprintf("%d %s", response.code, response.message))
        end
        result = JSON.parse(response.body)
        if result['error']
          http.finish
          raise Coinmate::Error.new(result['errorMessage'])
        end
      end
      result['data']
    end

    
    def signature_params
      nonce = (Time.now.to_f * 100).to_i
      message = sprintf("%d%d%s", nonce, @client_id, @public_key)
      {
        clientId: @client_id,
        nonce: nonce,
        signature: OpenSSL::HMAC.hexdigest(SHA256_DIGEST, @private_key, message) \
                                .upcase
      }
    end


  end
end