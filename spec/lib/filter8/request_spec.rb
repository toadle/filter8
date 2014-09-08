require 'spec_helper'

describe Filter8::Request do

  describe "#initialization" do

    it "will configure a new request with no options" do
      expect(Filter8::Request.new("fuck")).to be_a Filter8::Request
    end

    it "will not be initializable without a content" do
      expect{Filter8::Request.new}.to raise_error
    end

    it "will translate only options into content and options" do
      request = Filter8::Request.new(content: "fuck", blacklist: "test")
      expect(request.content).to eq "fuck"
      expect(request.blacklist).to eq "test"
    end

    it "will raise an error when only options and no content is given" do
      expect{Filter8::Request.new(blacklist: "test")}.to raise_error
    end

    it "will raise an error when onlyno content is given" do
      expect{Filter8::Request.new(nil)}.to raise_error
      expect{Filter8::Request.new("")}.to raise_error
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

    it "will allow filters to be disabled" do
      request = Filter8::Request.new("fuck", blacklist: {enabled: false})

      expect(request.blacklist).to eq({enabled: false})
    end
  end

  describe "#request_params" do
    it "will return the correct parameters, when no options are given" do
      expect(Filter8::Request.new("fuck").request_params).to eq "content=fuck"
    end

    it "escapes url-critical parameters nicely" do
      expect(Filter8::Request.new("Leaders! Start a book club with a new release from #OrangeBooks & get a free ticket to Orange Tour 2014.").request_params).to eq "content=Leaders%21+Start+a+book+club+with+a+new+release+from+%23OrangeBooks+%26+get+a+free+ticket+to+Orange+Tour+2014."
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

    it "will return the correct parameters, when multiple options with a multiple values are given" do
      expect(Filter8::Request.new("fuck", blacklist: {locale: [:en, :de]}, characters: {character: ["a", "b", "c"]}).request_params).to eq "content=fuck&blacklist.enabled=true&blacklist.locale=en&blacklist.locale=de&characters.enabled=true&characters.character=a&characters.character=b&characters.character=c"
    end
  end

end
