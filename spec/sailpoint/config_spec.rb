require 'spec_helper'

RSpec.describe Sailpoint::Config do
  # Setup to default config values everytime a test is run
  before(:each) do
    Sailpoint::Config.username = nil
    Sailpoint::Config.password = nil
    Sailpoint::Config.host = nil
    Sailpoint::Config.interface = 'rest'
  end

  describe 'setting interface' do
    subject { Sailpoint::Config.interface }

    it { is_expected.to eq('rest') }
  end

  # URL is made up of host+interface (https://url.com/interface/)
  describe 'url' do
    subject { Sailpoint::Config.url }

    it { is_expected.to eq('') }
    it 'should be valid with a host' do
      Sailpoint::Config.host = 'https://fakeURL.com'
      expect(Sailpoint::Config.url).to eq('https://fakeURL.com/identityiq/rest')
    end
  end

  describe 'interface_path' do
    subject { Sailpoint::Config.interface_path }

    it { is_expected.to eq('rest') }
    it 'should be assigned to scim' do
      Sailpoint::Config.interface = 'scim'
      expect(Sailpoint::Config.interface_path).to eq('scim')
    end
  end

  describe 'hashed_credentials' do
    subject { Sailpoint::Config.hashed_credentials }

    it { is_expected.to be_empty }
    it 'should be valid' do
      Sailpoint::Config.set_credentials('admin', 'password')
      expect(Sailpoint::Config.hashed_credentials).to eq('YWRtaW46cGFzc3dvcmQ=')
    end
  end

  describe 'host' do
    subject { Sailpoint::Config.host }

    it { is_expected.to be_empty }
    it 'should return a URL' do
      Sailpoint::Config.host = 'https://fakeURL.com'
      expect(Sailpoint::Config.url).to eq('https://fakeURL.com/identityiq/rest')
    end

    it 'should return a trimmed URL' do
      Sailpoint::Config.host = '  https://fakeURL.com   '
      expect(Sailpoint::Config.host).to eq('https://fakeURL.com')
    end
  end

  describe 'when setting credentials' do
    subject { Sailpoint::Config.credentials }

    it { expect { Sailpoint::Config.set_credentials }.to raise_error(ArgumentError) }
    it { is_expected.to eq({ username: nil, password: nil })}
    it 'when values are assigned' do
      Sailpoint::Config.username = 'admin'
      Sailpoint::Config.password = 'password'
      # Sailpoint::Config.set_credentials('admin', 'password')
      expect(Sailpoint::Config.credentials).to eq({ username: 'admin', password: 'password' })
    end
  end
  
  describe 'auth_header' do
    subject { Sailpoint::Config.auth_header }

    it { is_expected.to be_empty }
    it 'if credentials set' do
      Sailpoint::Config.set_credentials('admin', 'password')
      expect(Sailpoint::Config.auth_header).to eq( { 'Authorization' => "Basic YWRtaW46cGFzc3dvcmQ=" } )
    end
  end
end