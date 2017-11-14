require 'spec_helper'

module Blackbriar
  RSpec.describe MapExtract, type: :model do
    let(:map) do
      {
        moved: {
          root: "json_path:$.root"
        },
        some_value: "json_path:$.some.arbitrary.value"
      }
    end

    let(:data) do
      {
        some: {
          arbitrary: {
            value: "Hello World"
          }
        },
        root: "element",
        nested: {
          array:[
            "value One",
            {value: "two"},
            {value: "three", array: [1,2,3,4,5]}
          ]
        }
      }
    end

    let(:extract) { described_class.new(map, data) }

    subject { extract }

    describe 'interface' do
      it { is_expected.to respond_to :output }
    end

    describe '#output' do
      let(:output) { extract.output }

      subject { output }

      it { is_expected.to match_yaml_schema 'map_extract/test_output' }
    end
  end
end
