module Filter8
  class Response
    def initialize(json)
      @json = json
    end

    def replacement
      @json["filter"]["replacement"]
    end
  end
end