# Special thanks to https://robots.thoughtbot.com/validating-json-schemas-with-an-rspec-matcher
# Depends on json_schema

RSpec::Matchers.define :match_yaml_schema do |schema|
  match do |response|
    # Setup
    if defined?(Rails)
      schema_path = Rails.root.join("spec/support/schemas", "#{schema}.yaml")
    else
      schema_path = "spec/support/schemas/#{schema}.yaml"
    end

    # Parse and expand the schema definition
    @schema = JsonSchema.parse!(YAML.load(File.read(schema_path)))
    @schema.expand_references!
    # ap @schema.inspect_schema

    # Get data to match
    @data = response.respond_to?(:body) ? response.body : response

    # Validate
    begin
      @schema.validate! @data.deep_stringify_keys
      true
    rescue JsonSchema::AggregateError => e
      @errors = e.message
      false
    end
  end

  failure_message do
    @errors
  end
end

RSpec::Matchers.define_negated_matcher :not_match_yaml_schema, :match_yaml_schema

RSpec::Matchers.define :match_json_schema do |schema|
  match do |response|
    if schema.is_a? String
      # Setup
      if defined?(Rails)
        schema_path = Rails.root.join("spec/support/schemas", "#{schema}.json")
      else
        schema_path = "spec/support/schemas/#{schema}.yaml"
      end

      # Parse and expand the schema definition
      @schema = JsonSchema.parse!(YAML.load(File.read(schema_path)))
    elsif schema.kind_of? Hash
      @schema = JsonSchema.parse!(schema)
    end

    @schema.expand_references!

    # Get data to match
    @data = response.respond_to?(:body) ? response.body : response

    begin
      # Validate
      @schema.validate! @data
      true
    rescue JsonSchema::AggregateError => e
      @errors = e.message
      false
    end
  end

  failure_message do
    binding.pry
    @errors
  end
end

RSpec::Matchers.define_negated_matcher :not_match_json_schema, :match_json_schema
