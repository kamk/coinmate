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
      params = URI.encode_www_form(params)
      uri.query = params if req_klass == Net::HTTP::Get

      begin
        Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
          req = req_klass.new(uri)
          if req_klass == Net::HTTP::Post
            req['Content-Type'] = 'application/x-www-form-urlencoded'
            req.body = params
          end
          response = http.request(req)
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
      rescue SocketError, SystemCallError => err
        if err.is_a?(SystemCallError)
          raise if err.class.name !~ /^Errno::/
        end
        raise Coinmate::Error.new("Network error: #{err}")
      end
      result['data']
    end

    
    def signature_params
      nonce = Time.now.to_i
      message = sprintf("%d%d%s", nonce, @client_id, @public_key)
      sleep 1
      {
        clientId: @client_id,
        nonce: nonce,
        signature: OpenSSL::HMAC.hexdigest(SHA256_DIGEST, @private_key, message) \
                                .upcase
      }
    end


  end
end