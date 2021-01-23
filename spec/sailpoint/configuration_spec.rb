# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Sailpoint::Configuration do
  # Setup to default config values everytime a test is run
  before do
    Sailpoint.configure do |config|
      config.username = nil
      config.password = nil
      config.host = nil
    end
    # Sailpoint.config.interface = nil
  end

  describe 'setting interface' do
    subject { Sailpoint.config.interface }

    it { is_expected.to eq('scim') }

    it 'when set as nil' do
      Sailpoint.config.interface = nil
      expect(Sailpoint.config.interface).to eq('scim')
    end
  end

  # URL is made up of host+interface (https://url.com/interface/)
  describe 'url' do
    subject { Sailpoint.config.url }

    it { is_expected.to be_empty }

    it 'valid with a host' do
      Sailpoint.config.host = 'https://fakeURL.com'
      expect(Sailpoint.config.url).to eq('https://fakeurl.com/identityiq/scim')
    end
  end

  describe 'interface_path' do
    subject { Sailpoint.config.interface_path }

    it { is_expected.to eq('scim') }

    it 'assigned to scim' do
      Sailpoint.config.interface = 'scim'
      expect(Sailpoint.config.interface_path).to eq('scim')
    end

    it 'assigned to rest' do
      Sailpoint.config.interface = 'rest'
      expect(Sailpoint.config.interface_path).to eq('rest')
    end

    it 'assigned disallowed interface' do
      Sailpoint.config.interface = nil
      expect(Sailpoint.config.interface_path).to eq('scim')
    end
  end

  context 'when hashed_credentials' do
    subject { Sailpoint.config.hashed_credentials }

    describe 'when not set' do
      it { is_expected.to be_empty }
    end

    describe 'when set' do
      it 'is valid' do
        Sailpoint.config.username = 'admin'
        Sailpoint.config.password = 'password'
        expect(Sailpoint.config.hashed_credentials).to eq('YWRtaW46cGFzc3dvcmQ=')
      end
    end
  end

  describe 'host' do
    subject { Sailpoint.config.host }

    it { is_expected.to be_falsy }

    it 'will return a URL' do
      Sailpoint.configure do |config|
        config.host = 'https://fakeURL.com'
        config.interface = nil
      end
      expect(Sailpoint.config.url).to eq('https://fakeurl.com/identityiq/scim')
    end

    it 'will return a trimmed URL' do
      Sailpoint.config.host = '  https://fakeurl.com   '
      expect(Sailpoint.config.host).to eq('https://fakeurl.com')
    end
  end

  describe 'when setting credentials' do
    subject { Sailpoint.config.credentials }

    it { is_expected.to eq({ username: nil, password: nil }) }

    it 'when values are assigned' do
      Sailpoint.config.username = 'admin'
      Sailpoint.config.password = 'password'
      expect(Sailpoint.config.credentials).to eq({ username: 'admin', password: 'password' })
    end
  end

  describe 'auth_header' do
    subject { Sailpoint.config.auth_header }

    it { is_expected.to be_empty }

    it 'if credentials set' do
      Sailpoint.config.username = 'admin'
      Sailpoint.config.password = 'password'
      expect(Sailpoint.config.auth_header).to eq({ 'Authorization' => 'Basic YWRtaW46cGFzc3dvcmQ=' })
    end
  end
end
