require "spec_helper"

RSpec.describe "json schema matchers", type: :model do
  let(:valid_json) do
    {
      data: {
        aribitrary: {
          json: {
            array: [1,2,3,4]
          }
        }
      }
    }.deep_stringify_keys
  end

  let(:invalid_json) do
    {
      invalid: {
        json: {
          data: "here"
        }
      }
    }.deep_stringify_keys
  end

  describe "match_yaml_schema" do
    let(:schema) { "some_schema" }

    context 'with valid data' do
      subject { valid_json }
      it { is_expected.to match_yaml_schema schema }
    end

    context 'with invalid json' do
      subject { invalid_json }
      it { is_expected.not_to match_yaml_schema schema }
      it { is_expected.to not_match_yaml_schema schema }
    end
  end

  describe 'match_json_schema' do
    context 'when provided a hash value' do
      let(:schema) do
        {
          type: "object",
          properties: {
            data: {
              type: "object"
            }
          },
          required: ["data"],
          additionalProperties: false
        }.deep_stringify_keys
      end

      context 'with valid json' do
        subject { valid_json }
        it { is_expected.to match_json_schema schema }
      end

      context 'with invalid json' do
        subject { invalid_json }
        it { is_expected.to not_match_json_schema schema }
        it { is_expected.not_to match_json_schema schema}
      end
    end
  end

  describe 'have_errors_at' do
    let(:data) do
      {
        some: {
          arbitrary: {
            json: {
              errors: [
                {id: "some error"}
              ]
            }
          }
        },
        errors: [
          {another: 'kind of error'}
        ]
      }
    end

    subject { data }

    it { is_expected.to have_errors_at "json_path:$.some.arbitrary.json" }
    it { is_expected.to not_have_errors_at "json_path:$.some.arbitrary" }
    it { is_expected.to have_errors_at "json_path:$." }
    it { is_expected.to not_have_errors_at "json_path:$.some.arbitrary.json.errors[0]" }
  end
end
