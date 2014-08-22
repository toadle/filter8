module Filter8
  class Request
    attr_accessor :content

    def initialize(content, options = {})
      if content.is_a? Hash
        @content = content[:content]
        raise Exception.new("No value for 'content' given") if @content.nil?
        options = content.reject!{ |k| k == :content }
      else
        @content = content
      end

      options.each do |filter_name, filter_options|
        validate_filter_options(filter_name, filter_options)

        instance_variable_value = nil
        if filter_options.is_a? Hash
          instance_variable_value = { enabled: true }
          instance_variable_value = instance_variable_value.merge(filter_options)
        else
          instance_variable_value = filter_options
        end
        instance_variable_set("@#{filter_name}", instance_variable_value)
        self.class.send(:attr_accessor, filter_name)
      end
    end

    def request_params
      request_params = "content=#{self.content}"

      Filter8::AVAILABLE_FILTERS.each do |filter_name|
        if self.respond_to?(filter_name) && !self.send(filter_name).nil?
          request_params = request_params + "&" + filter_options_to_params(filter_name)          
        end
      end

      request_params
    end

    private

      def filter_options_to_params(filter_name)
        params = []

        filter_options = self.send(filter_name)
        if filter_options.is_a? Hash
          filter_options.each do |filter_option, filter_option_value|
            if filter_option_value.respond_to? :each
              filter_option_value.each do |value|
                params << "#{filter_name}.#{filter_option}=#{value}"
              end
            else
              params << "#{filter_name}.#{filter_option}=#{filter_option_value}"
            end
          end
        else
          params << "#{filter_name}=#{filter_options}"
        end

        return params.join("&")
      end

      def validate_filter_options(filter_name, filter_options)
        raise Exception.new("'#{filter_name}' is not a valid filter8-filter") unless Filter8::AVAILABLE_FILTERS.include?(filter_name)

        if filter_options.respond_to? :each
          filter_options.each do |filter_option, filter_option_value|
            raise Exception.new("'#{filter_option}' is not a valid option for filter '#{filter_name}'") unless Filter8::FILTER_PARAMS[filter_name].include?(filter_option)
          end
        end
      end
  end
end