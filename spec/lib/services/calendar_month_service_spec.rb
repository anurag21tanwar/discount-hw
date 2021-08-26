# frozen_string_literal: true

require_relative '../../../spec/spec_helper'
require_relative '../../../lib/services/calendar_key_service'

RSpec.describe CalendarKeyService do
  let(:input) { ['2021-01-01'] }

  subject { described_class.new(input).call }

  it 'should return year-month info for a date' do
    expect(subject).to eq('2021-1')
  end

  context 'when invalid date' do
    let(:input) { '2015-02-29' }

    it 'should raise an exception' do
      expect { subject }.to raise_error(Date::Error)
    end
  end
end
