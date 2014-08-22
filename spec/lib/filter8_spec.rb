require 'spec_helper'

describe Filter8 do

  describe "#configure" do

    before do
      Filter8.configure do |config|
        config.api_key = "12345"
        config.api_secret = "abcde"
      end
    end

    after do
      Filter8.configuration = nil
    end

    it "will correctly retain it's configuration" do
      expect(Filter8.configuration.api_key).to eq "12345"
      expect(Filter8.configuration.api_secret).to eq "abcde"
    end
  end

  describe "#filter" do
    context "when not configured first" do
      it "will raise an error and asks to configure first" do
        expect{Filter8.filter("test", blacklist: "test")}.to raise_error(Filter8::Exception)
      end
    end
    context "when correct configured first" do
      let(:request) { double() }
      let(:client) { double() }
      let(:result) { double() }

      before do
        Filter8.configure do |config|
          config.api_key = "12345"
          config.api_secret = "abcde"
        end
      end

      after do
        Filter8.configuration = nil
      end

      it "will use the module-config to configure a client and send a request to filter8 with the given parameters. Returns the result" do
        expect(Filter8::Client).to receive(:new).with(api_key: "12345", api_secret: "abcde").and_return(client)
        expect(Filter8::Request).to receive(:new).with("test", blacklist: "test").and_return(request)
        expect(client).to receive(:send_request).with(request).and_return(result)
        expect(Filter8.filter("test", blacklist: "test")).to eq result
      end
    end
  end

end
