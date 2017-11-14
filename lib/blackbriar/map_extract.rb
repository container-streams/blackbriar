module Blackbriar
  class MapExtract
    def initialize(map, data)
      @map, @data = map, data
    end

    def output
      provider = ValueProvider.new(data)
      map.to_a.map do |key, value|
        Node.new({key => value}, provider).resolve
      end.reduce(&:merge)
    end

    private
    attr_reader :map, :data
  end
end
