require 'spec_helper'

RSpec.describe Sailpoint do
  before(:each) do
    Sailpoint::Config.host = nil
    Sailpoint::Config.username = nil
    Sailpoint::Config.password = nil
  end

  context 'when setting credentails' do
    describe 'with valid credentails' do
      before(:each){ Sailpoint.set_credentials('admin', 'password') }

      it { expect(Sailpoint::Config.username).to eq('admin') }
      it { expect(Sailpoint.valid_credentials?).to eq(true) }
    end

    describe 'with blank values' do
      before(:each){ Sailpoint.set_credentials('', '') }

      it { expect(Sailpoint.valid_credentials?).to eq(false)}
    end
  end

  context 'when setting host' do
    describe 'when invalid' do
      before(:each) { Sailpoint.set_host('') }
      it { expect(Sailpoint::Config.host).to be_empty }
    end

    describe 'when valid' do
      before(:each) { Sailpoint.set_host('http://example.com/') }
      it { expect(Sailpoint::Config.host).to eq('http://example.com')}
    end
  end

  context 'validate credentails' do
    describe 'when valid credentials are set' do
      before(:each) { Sailpoint::Config.set_credentials('admin', 'password') }
      it { expect(Sailpoint::Config.username).to eq('admin') }
      it { expect(Sailpoint::Config.password).to eq('password') }
      it { expect(Sailpoint.valid_credentials?).to eq(true) }
    end

    describe ' when invalid credentails are set' do
      before(:each) { Sailpoint::Config.set_credentials('', nil) }
      it { expect(Sailpoint.valid_credentials?).to eq(false) }
    end
  end


  describe 'validate URL' do
    subject { Sailpoint.valid_url? }

    it { is_expected.to eq(false) }
    it 'when valid' do
      Sailpoint::Config.host = 'http://example.com'
      expect(Sailpoint.valid_url?).to eq(true)
    end
  end

  context 'validate interface type' do
    describe 'when SCIM' do
      it { expect(Sailpoint.valid_interface_type?('scim')).to eq(true) }
    end

    describe 'when Invalid match' do
      it { expect(Sailpoint.valid_interface_type?('foobar')).to eq(false) }
    end
  end

  context 'get_user' do
    describe 'when invalidate arguements' do
      it { expect { Sailpoint.get_user }.to raise_error(ArgumentError) }
      it { expect { Sailpoint.get_user('foobar') }.to raise_error(ArgumentError) }
    end
  end
end