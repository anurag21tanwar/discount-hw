# frozen_string_literal: true

require_relative '../../../spec/spec_helper'
require_relative '../../../lib/services/formatter_service'

RSpec.describe FormatterService::InputData do
  let(:input) { '2021-01-01 S MR' }

  subject { described_class.new(input).call }

  it 'should split input with whitespace' do
    expect(subject.size).to eq(3)
  end
end

RSpec.describe FormatterService::OutputData do
  let(:input_data) { %w[2021-01-01 S MR] }
  let(:discount_data) { [1.5, 0.5] }

  subject { described_class.new(input_data, discount_data).call(false) }

  it 'should return formatted output string' do
    expect(subject).to eq('2021-01-01 S MR 1.50 0.50')
  end

  context 'when ignored discount data' do
    let(:discount_data) { ['Ignored'] }

    it 'should return formatted output string' do
      expect(subject).to eq('2021-01-01 S MR Ignored')
    end
  end
end
