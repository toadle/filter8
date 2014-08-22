require "filter8/exception"
require "filter8/client"
require "filter8/result"
require "filter8/request"

module Filter8
  BLACKLIST_FILTER = :blacklist

  AVAILABLE_FILTERS = [BLACKLIST_FILTER]

  FILTER_PARAMS = {
    BLACKLIST_FILTER => [:locale, :tags, :severity]
  }
  
  class Configuration
    attr_accessor :api_key
    attr_accessor :api_secret
  end

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  def self.filter(content, options = {})
    raise Exception.new "Configure Filter8-module before using" if(Filter8.configuration.nil?)
    %i(api_key api_secret).each do |attribute|
      raise Exception.new "Configure 'attribute' first" if(Filter8.configuration.send(attribute).nil?)
    end

    client = Filter8::Client.new(api_key: Filter8.configuration.api_key, api_secret: Filter8.configuration.api_secret)
    client.send_request(Filter8::Request.new(content, options))
  end
end