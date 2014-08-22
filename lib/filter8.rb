require "filter8/exception"
require "filter8/client"
require "filter8/result"
require "filter8/request"

module Filter8
  BLACKLIST_FILTER = :blacklist
  CHARACTERS_FILTER = :characters
  EMAILS = :emails
  PHONE_NUMBERS_FILTER = :phoneNumbers
  URLS_FILTER = :urls
  WORDS_FILTER = :words

  AVAILABLE_FILTERS = [BLACKLIST_FILTER, CHARACTERS_FILTER, EMAILS, PHONE_NUMBERS_FILTER, URLS_FILTER, WORDS_FILTER]

  FILTER_PARAMS = {
    BLACKLIST_FILTER => [:enabled, :locale, :tags, :severity], 
    CHARACTERS_FILTER => [:character],
    PHONE_NUMBERS_FILTER => [:maximumMatchLength, :minimumMatchLength, :separatorPenalty, :spacePenalty, :wordPenalty],
    WORDS_FILTER => [:word]
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