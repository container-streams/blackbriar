require "spec_helper"

module Blackbriar
  RSpec.describe Node, type: :model do
    let(:map) do
      {
        test: "json_path:$..arbitrary.value"
      }
    end

    let(:json) do
      {
        some: {
          arbitrary: {
            value: "Hello World"
          }
        }
      }
    end

    let(:provider) { ValueProvider.new(json) }

    let(:node) { described_class.new(map["weigh"], provider ) }

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

        it 'has the right output' do
          is_expected.to have_keys ["weigh", "sub_types"]
        end

        it 'matches the right schema' do
          is_expected.to match_yaml_schema 'payload/base_v1.0'
        end

        describe 'weigh' do
          subject { output["weigh"] }
          it { is_expected.to match_yaml_schema 'payload/weigh_v1.0' }
        end

        describe 'sub_types' do
          subject { output["sub_types"] }
          it { is_expected.to match_yaml_schema "payload/sub_types_v1.0" }
        end
      end
    end
  end
end
