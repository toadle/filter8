module Filter8
  class Result
    attr_accessor :json

    def initialize(json)
      @json = json
    end

    def replacement
      @json["filter"]["replacement"]
    end

    def matched?
      @json["filter"]["matched"]
    end

    def matches
      @json["filter"]["matches"].map { |match| OpenStruct.new(match) }
    end
    
  end
end