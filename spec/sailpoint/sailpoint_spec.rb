# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sailpoint do
  before do
    described_class.config.host = nil
    described_class.config.username = nil
    described_class.config.password = nil
  end

  context 'when setting credentails' do
    describe 'with valid credentails' do
      before do
        described_class.configure do |config|
          config.username = 'admin'
          config.password = 'password'
        end
      end

      it { expect(described_class.config.username).to eq('admin') }
      it { expect(described_class.valid_credentials?).to eq(true) }
    end

    describe 'with blank values' do
      before do
        described_class.config.username = ''
        described_class.config.password = ''
      end

      it { expect(described_class.valid_credentials?).to eq(false) }
    end
  end

  context 'when setting host' do
    describe 'when invalid' do
      it { expect(described_class.config.host).to be_falsey }
    end

    describe 'when valid' do
      before { described_class.config.host = 'http://example.com/' }

      it { expect(described_class.config.host).to eq('http://example.com') }
    end
  end

  context 'when validate credentails' do
    describe 'when valid credentials are set' do
      before do
        described_class.configure do |config|
          config.username = 'admin'
          config.password = 'password'
        end
      end

      it { expect(described_class.config.username).to eq('admin') }
      it { expect(described_class.config.password).to eq('password') }
      it { expect(described_class.valid_credentials?).to eq(true) }
    end

    describe 'when invalid credentails are set' do
      before do
        described_class.config.username = nil
        described_class.config.password = nil
      end

      it { expect(described_class.valid_credentials?).to eq(false) }
    end
  end

  describe 'validate URL' do
    subject { described_class.valid_url? }

    it { is_expected.to eq(false) }

    it 'when valid' do
      described_class.config.host = 'http://example.com'
      expect(described_class.valid_url?).to eq(true)
    end
  end

  context 'when validating interface type' do
    describe 'when SCIM' do
      it { expect(described_class.valid_interface_type?('scim')).to eq(true) }
    end

    describe 'when Invalid match' do
      it { expect(described_class.valid_interface_type?('foobar')).to eq(false) }
    end
  end

  context 'when calling get_user' do
    describe 'when invalidate arguements' do
      it { expect { described_class.get_user }.to raise_error(ArgumentError) }
      it { expect { described_class.get_user('foobar') }.to raise_error(ArgumentError) }
    end
  end
end
