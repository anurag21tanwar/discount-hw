# frozen_string_literal: true

require_relative '../../../spec/spec_helper'
require_relative '../../../lib/services/process_data_service'

RSpec.describe ProcessDataService do
  let(:input) do
    ['2021-01-01 S MR', '2021-01-02 S LP', '2021-01-03 M MR', '2021-01-03 M LP', '2021-01-04 L MR', '2021-01-04 L LP']
  end

  subject { described_class.new(input).call(false) }

  it 'should return formatted output string with discount data' do
    expect(subject).to eq(['2021-01-01 S MR 1.50 0.50', '2021-01-02 S LP 1.50 -', '2021-01-03 M MR 3.00 -',
                           '2021-01-03 M LP 4.90 -', '2021-01-04 L MR 4.00 -', '2021-01-04 L LP 6.90 -'])
  end

  context 'when invalid date' do
    let(:input) { ['2021-13-01 S MR'] }

    it 'should raise an exception' do
      expect(subject).to eq(['2021-13-01 S MR Ignored'])
    end
  end
end
