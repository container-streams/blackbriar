require "spec_helper"

module Blackbriar
  RSpec.describe Node, type: :model do
    let(:map) do
      {
        moved: {
          root: "json_path:$.root"
        },
        some_value: "json_path:$.some.arbitrary.value"
      }
    end

    let(:json) do
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

    let(:provider) { ValueProvider.new(json) }

    let(:node) { described_class.new(map["moved"], provider ) }

    subject { node }

    it { is_expected.to respond_to :resolve }

    describe '#resolve' do
      let(:output) do
        map.to_a.map do |key, value|
          Node.new({key => value}, provider).resolve
        end.reduce(&:merge)
      end

      describe 'output format' do
        subject { output }

        it { is_expected.to be_kind_of Hash }

        describe "moved" do
          subject { output[:moved] }

          it { is_expected.to eq root: "element" }
        end

        describe "some_value" do
          subject { output[:some_value] }
          it { is_expected.to eq "Hello World" }
        end
      end
    end
  end
end
