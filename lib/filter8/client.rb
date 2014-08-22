require 'digest'
require 'uri'
require 'faraday'
require 'json'

module Filter8
  class Client
    attr_accessor :api_key, :api_secret

    API_URL = 'https://api.filter8.com'
    API_ENDPOINT = '/content/item.js'

    def initialize(api_key: nil, api_secret: nil, options: {})
      @api_key = api_key
      @api_secret = api_secret
      @options = options
    end

    def send_request(filter8_request)
      conn = Faraday.new(:url => API_URL) do |faraday|
        faraday.request  :url_encoded
        faraday.adapter  Faraday.default_adapter
      end

      conn.basic_auth self.api_key, password
      response = conn.post "#{API_ENDPOINT}?#{nonce_param}", filter8_request.request_params

      raise Exception.new("Filter8-API error (Status: #{response.status}): #{response.body}") if(response.status != 200)

      Filter8::Result.new JSON.parse(response.body)
    end

    def nonce_param
      "nonce=#{timestamp}"
    end

    def password 
      Digest::MD5.hexdigest("#{timestamp}#{self.api_secret}")
    end

    def timestamp 
      @timestamp ||= Time.now.to_i.to_s
    end
  end
end