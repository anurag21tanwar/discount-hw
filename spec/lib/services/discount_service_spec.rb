# frozen_string_literal: true

require_relative '../../../spec/spec_helper'
require_relative '../../../lib/services/discount_service'

RSpec.describe DiscountService do
  let(:input) { %w[2021-01-01 S MR] }
  let(:max_discount) { 10 }
  let(:l_lp_count) { 0 }

  subject { described_class.new(input, max_discount, l_lp_count).call }

  it 'should return correct discount data, max_discount and l_lp_count' do
    expect(subject).to eq([[1.5, 0.5], 9.5, 0])
  end

  context 'when invalid package code' do
    let(:input) { '2021-01-01 X MR' }

    it 'should raise an exception' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  context 'when invalid carrier code' do
    let(:input) { '2021-01-01 S XX' }

    it 'should raise an exception' do
      expect { subject }.to raise_error(RuntimeError)
    end
  end

  describe 'discount for package S' do
    context 'when carrier is MR' do
      let(:input) { %w[2021-01-01 S MR] }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[1.5, 0.5], 9.5, 0])
      end
    end

    context 'when carrier is LP' do
      let(:input) { %w[2021-01-01 S LP] }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[1.5, '-'], 10, 0])
      end
    end

    context 'when max_discount already given' do
      let(:input) { %w[2021-01-01 S MR] }
      let(:max_discount) { 0 }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[2, '-'], 0, 0])
      end
    end
  end

  describe 'discount for package L' do
    context 'when carrier is MR' do
      let(:input) { %w[2021-01-01 L MR] }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[4.0, '-'], 10, 0])
      end
    end

    context 'when carrier is LP' do
      let(:input) { %w[2021-01-01 L LP] }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[6.9, '-'], 10, 1])
      end
    end

    context 'when third shipment' do
      let(:input) { %w[2021-01-01 L LP] }
      let(:l_lp_count) { 2 }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[0.0, 6.9], (10 - 6.9), 3])
      end
    end
  end

  describe 'discount for package M' do
    context 'when carrier is MR' do
      let(:input) { %w[2021-01-01 M MR] }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[3.0, '-'], 10, 0])
      end
    end

    context 'when carrier is LP' do
      let(:input) { %w[2021-01-01 M LP] }

      it 'should return correct discount data, max_discount and l_lp_count' do
        expect(subject).to eq([[4.9, '-'], 10, 0])
      end
    end
  end
end
