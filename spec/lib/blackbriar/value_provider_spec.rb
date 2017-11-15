require "spec_helper"

module Blackbriar
  RSpec.describe ValueProvider, type: :model do
    let(:json) do
      {
        some: {
          aribtrary: {
            value: "Something special here"
          }
        },
        root: "value",
        nested: {
          array: [
            {value: "one"},
            {value: "two"}
          ]
        }
      }.deep_stringify_keys
    end

    let(:provider) { described_class.new(json) }

    describe 'retrieving a value from the provider' do
      subject { provider.resolve(path) }

      context "when the value is at the root" do
        let(:path) { 'json_path:$.root' }

        it { is_expected.to eq json["root"] }
        it { is_expected.to eq "value" }
      end

      context "when the value is nested" do
        let(:path) { "json_path:$.some.arbitrary" }
        it { is_expected.to eq json["some"]["arbitrary"] }
      end

      context "when the value is an object" do
        let(:path) { "json_path:$.some" }
        it { is_expected.to eq json["some"] }
      end

      context "when the value is an array" do
        let(:path) { "json_path:$.nested.array" }
        it { is_expected.to eq json["nested"]["array"] }
        it { is_expected.to have_count_of 2 }
      end
    end
  end
end
