# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sailpoint::Helpers do
  context 'when string assigned empty values' do
    it { expect(''.blank?).to eq(true) }
    it { expect(''.present?).to eq(false) }
  end

  context 'when nil' do
    it { expect(nil.blank?).to eq(true) }
    it { expect(nil.present?).to eq(false) }
  end

  context 'when numeric' do
    it { expect(1.blank?).to eq(false) }
    it { expect(1.present?).to eq(true) }
  end

  context 'when hash' do
    it { expect({}.present?).to eq(false) }
    it { expect({}.blank?).to eq(true) }
  end

  context 'when array' do
    it { expect([].blank?).to eq(true) }
    it { expect(%w[abc 123].blank?).to eq(false) }
  end

  context 'when printing exception' do
    it { expect { described_class.print_exception('FooBar') }.to output.to_stdout }
  end

  context 'when AuthenticationException' do
    let!(:auth) do
      Sailpoint::Helpers::AuthenticationException.new('foobar')
    end

    it { expect(auth.data).to eq('foobar') }
    it { expect(auth.message).to eq('foobar') }
  end
end
