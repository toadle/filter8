require 'spec_helper'

describe Filter8::Response do

  context "when initialized with an empty filter8-response" do
    let(:response_without_results) do
      {
        "filter" => {
          "matched" => false,
          "matches" => [
          ],
        "replacement" => "Fuck this motherfucking fuck shit!"
        }
      }
    end
    let(:response) { Filter8::Response.new(response_without_results) }
  end

  context "when initialized with a blacklist filter8-response" do
    let(:response_with_blacklist_results) do
      {
        "filter" => {
              "matched" => true,
              "matches" => [
            {
                 "start" => 0,
                "length" => 4,
                  "type" => "blacklist",
                  "tags" => [
                  "Vulgarity"
              ],
              "severity" => "severe",
                "locale" => "en",
               "matched" => "fuck",
                  "root" => "fuck",
               "quality" => 1.0
            },
            {
                 "start" => 10,
                "length" => 13,
                  "type" => "blacklist",
                  "tags" => [
                "Vulgarity"
              ],
              "severity" => "severe",
                "locale" => "en",
               "matched" => "fucking",
                  "root" => "fuck",
               "quality" => 1.0
            },
            {
                 "start" => 24,
                "length" => 4,
                  "type" => "blacklist",
                  "tags" => [
                "Vulgarity"
              ],
              "severity" => "severe",
                "locale" => "en",
               "matched" => "fuck",
                  "root" => "fuck",
               "quality" => 1.0
            },
            {
                 "start" => 29,
                "length" => 4,
                  "type" => "blacklist",
                  "tags" => [
                "Vulgarity"
              ],
              "severity" => "severe",
                "locale" => "en",
               "matched" => "shit",
                  "root" => "shit",
               "quality" => 1.0
            }
          ],
          "replacement" => "**** this ************* **** ****!"
        }
      }
    end
    let(:response) { Filter8::Response.new(response_with_blacklist_results) }

    it "will return the correct replacement" do
      expect(response.replacement).to eq "**** this ************* **** ****!"
    end
  end

end
