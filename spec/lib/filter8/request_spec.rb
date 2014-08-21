require 'spec_helper'

describe Filter8::Request do

  describe "#initialization" do
    it "will configure a new request with no options" do
      expect(Filter8::Request.new("fuck")).to be_a Filter8::Request
    end

    it "will allow valid filters as options" do
      request = Filter8::Request.new("fuck", blacklist: "test")
      expect(request.blacklist).to eq "test"
    end

    it "will NOT allow invalid filters as options" do
      expect{Filter8::Request.new("fuck", some_filter: "test")}.to raise_error(Filter8::Exception)
    end

    it "will allow valid filters with valid options" do
      request = Filter8::Request.new("fuck", blacklist: {locale: [:en, :de]})

      expect(request.blacklist).to eq({enabled: true, locale: [:en, :de]})
    end

    it "will NOT allow valid filters with invalid options" do
      expect{Filter8::Request.new("fuck", blacklist: {myarg: "test"})}.to raise_error(Filter8::Exception)
    end
  end

  describe "#request_params" do
    it "will return the correct parameters, when no options are given" do
      expect(Filter8::Request.new("fuck").request_params).to eq "content=fuck"
    end

    it "will return the correct parameters, when one option with a single value is given" do
      expect(Filter8::Request.new("fuck", blacklist: "test").request_params).to eq "content=fuck&blacklist=test"
    end

    it "will return the correct parameters, when one option with a hash is given" do
      expect(Filter8::Request.new("fuck", blacklist: {locale: :en}).request_params).to eq "content=fuck&blacklist.enabled=true&blacklist.locale=en"
    end

    it "will return the correct parameters, when one option with a multiple value is given" do
      expect(Filter8::Request.new("fuck", blacklist: {locale: [:en, :de]}).request_params).to eq "content=fuck&blacklist.enabled=true&blacklist.locale=en&blacklist.locale=de"
    end
  end

end
