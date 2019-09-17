require 'spec_helper'

RSpec.describe 'Helper Functions' do
  context 'when string' do
    it 'when assigned empty' do
      expect(''.blank?).to eq(true)
      expect(''.present?).to eq(true)
    end
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
    it { expect(['abc', '123'].blank?).to eq(false) }
  end

  context 'when printing exception' do
    it { expect { print_exception('FooBar') }.to output.to_stdout }
  end

  context 'when AuthenticationException' do
    before(:each){ @auth =  AuthenticationException.new('foobar') }

    it { expect(@auth.data).to eq('foobar') }
    it { expect(@auth.message).to eq('foobar') }
  end
end