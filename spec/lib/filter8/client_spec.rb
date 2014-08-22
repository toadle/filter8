require 'spec_helper'

describe Filter8::Client do

  before do
    Timecop.freeze(Time.local(2014, 1, 1))
  end

  let(:client) {Filter8::Client.new(api_key: "12345", api_secret: "abcde")}

  describe "#initialization" do
    it "will configure a new client with the given parameters" do
      expect(client.api_key).to eq "12345"
      expect(client.api_secret).to eq "abcde"
    end
  end

  describe "#send_request" do
    let(:faraday_response) {double("Faraday::Response", body: { "test" => "response" }.to_json, status: 200)}
    let(:faraday_connection) {double("Faraday::Connection", basic_auth: nil, post: faraday_response)}
    let(:filter8_request) {double("Filter8::Request", request_params: { "test" => "data" })}

    before do
      Faraday.stub(:new).and_return(faraday_connection)
    end

    it "will correctly configure a new farady-connection to the filter8-server" do
      expect(Faraday).to receive(:new).with(:url => 'https://api.filter8.com').and_return(faraday_connection)
      client.send_request(filter8_request)
    end

    it "will use basic-auth with the api_key and the calculated password" do
      expect(faraday_connection).to receive(:basic_auth).with(client.api_key, client.password)
      client.send_request(filter8_request)
    end

    it "will send the given filter8_requests form-data via post" do
      expect(faraday_connection).to receive(:post).with("/content/item.js?#{client.nonce_param}", filter8_request.request_params)
      client.send_request(filter8_request)
    end

    it "will parse the response as JSON and return the result as a filter8-result" do
      filter8_result = client.send_request(filter8_request)

      expect(filter8_result).to be_a Filter8::Result
      expect(filter8_result.json).to eq({ "test" => "response" })
    end

  end

  describe "#timestamp" do
    it "will return the current Time as a unix-timestamp" do
      expect(client.timestamp).to eq Time.local(2014, 1, 1).to_i.to_s
    end

    it "will return the same value every time it is asked" do
      Timecop.return

      timestamp = client.timestamp
      sleep 1.0/10

      expect(client.timestamp).to eq timestamp
    end
  end

  describe "#password" do
    it "will return a md5-digested combination of nonce and api_secret" do
      expect(client.password).to eq Digest::MD5.hexdigest("#{client.timestamp}#{client.api_secret}")
    end
  end

  describe "#nonce_param" do
    it "will return the nonce-param with the clients timestamp" do
      expect(client.nonce_param).to eq "nonce=#{client.timestamp}"
    end
  end

end
