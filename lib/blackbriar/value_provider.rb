# Module is responsible for returning a json_path value from the given data Hash
#
# Example:
# irb> provider = Messages::Transformation::ValueProvider.new(some_hash)
# irb> provider.send('json_path:$.test.value[0]')
#
# Our use case for the creation was that this was to be used in conjuction with a json mapping
# template to populate the template with real values

module Blackbriar
  class ValueProvider
    def initialize(data)
      @data = data
    end

    def resolve(arg)
      path = is_json_path?(arg.to_s) ? arg.to_s.split(":").last : nil
      return arg unless path
      JsonPath.on(data, path).first
    end

    private
    attr_reader :data

    def is_json_path?(method_name)
      # Ensure that we are dealin with a json path object
      /^json_path/.match(method_name)
    end
  end
end
