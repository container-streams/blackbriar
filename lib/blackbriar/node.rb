module Blackbriar
  class Node
    def initialize(hash, value_provider)
      @key, @value = hash.to_a.first
      @value_provider = value_provider
    end

    attr_reader :key, :value, :value_provider

    def resolve
      if value.is_a? String
        {key => resolve_string(value)}
      elsif value.is_a? Numeric
        {key => value}
      elsif value.is_a? Time
        {key => value}
      elsif value.is_a? Hash
        {key => resolve_hash(value)}
      elsif value.is_a? Array
        {key => resolve_array(value)}
      end
    end

    def resolve_array_item(item)
      if item.is_a? String
        resolve_string(item)
      elsif value.is_a? Numeric
        {key => value}
      elsif value.is_a? Time
        {key => value}
      elsif item.is_a? Hash
        resolve_hash item
      elsif item.is_a? Array
        resolve_array(item)
      end
    end

    def resolve_string(string)
      value_provider.resolve(string)
    end

    def resolve_hash(hash)
      hash.to_a.map {|item| self.class.new([item].to_h, value_provider).resolve}.reduce(&:merge)
    end

    def resolve_array(array)
      array.map {|item| resolve_array_item(item)}
    end
  end
end
