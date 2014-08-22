require 'spec_helper'

describe Filter8::Result do

  it "will have a way to access the json-result directly" do
    result = Filter8::Result.new({"test" => "result"})
    expect(result.json).to eq({"test" => "result"})
  end

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
    let(:result) { Filter8::Result.new(response_without_results) }

    it "will state that there were no matches" do
      expect(result.matched?).to be_false
    end

    it "will return no matches" do
      expect(result.matches).to eq []
    end
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
    let(:result) { Filter8::Result.new(response_with_blacklist_results) }

    it "will return the correct replacement" do
      expect(result.replacement).to eq "**** this ************* **** ****!"
    end

    it "will state that there were matches" do
      expect(result.matched?).to be_true
    end

    it "will return all matches" do
      expect(result.matches).to eq(response_with_blacklist_results["filter"]["matches"].map { |match| OpenStruct.new(match) })
    end
  end

end
