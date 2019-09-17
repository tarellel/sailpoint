require 'spec_helper'

RSpec.describe Sailpoint::Rest do

  context 'get_user' do
    describe 'with valid paramters' do
      before(:each) do
        Sailpoint::Config.set_credentials('admin', 'password')
        Sailpoint::Config.host = 'http://example.com/'
        stub_request(:get, 'http://example.com/identityiq/rest/identities/sample_user')
          .with(headers: { 'Authorization'=>'Basic YWRtaW46cGFzc3dvcmQ=' })
          .to_return(status: 200, body: '{"name": "Foobar"}')
          # The user identity string is MASSIVE
      end
      it 'should respond with user entry' do
        response = Sailpoint::Rest.get_user('sample_user')
        # The JSON body should be returned as a parsed HASH
        expect(response).to eq({"name"=>"Foobar"})
      end
    end

    describe 'when no user found' do
      before(:each) do
        Sailpoint::Config.set_credentials('admin', 'password')
        Sailpoint::Config.host = 'http://example.com/'
        stub_request(:get, 'http://example.com/identityiq/rest/identities/another_sample_user')
          .with(headers: { 'Authorization'=>'Basic YWRtaW46cGFzc3dvcmQ=' })
          .to_return(status: 200, body: '{}')
      end
      it 'return empty hash' do
        response = Sailpoint::Rest.get_user('another_sample_user')
        expect(response).to eq({})
      end
    end
  end

  context 'when GET ping' do
    describe 'with valid credentails' do
      before(:each) do
        Sailpoint::Config.set_credentials('admin', 'password')
        Sailpoint::Config.host = 'http://example.com/'
        stub_request(:get, "http://example.com/identityiq/rest/ping").
          with(
            headers: {
            'Authorization'=>'Basic YWRtaW46cGFzc3dvcmQ='
            }).
          to_return(status: 200, body: 'IIQ JAX-RS is alive!')
      end
      it 'should respond cleaerly ' do
        response = Sailpoint::Rest.ping
        expect(response.code).to eq(200)
      end
    end

    describe 'with invalid credentails' do
      before(:each) do
        Sailpoint::Config.set_credentials('admin', 'invalidPassword')
        Sailpoint::Config.host = 'http://example.com/'
        stub_request(:get, "http://example.com/identityiq/rest/ping").
          with(
            headers: {
            'Authorization'=>'Basic YWRtaW46aW52YWxpZFBhc3N3b3Jk'
            }).
          to_return(status: 401, body: 'User is unauthorized to access: /identityiq/rest/ping' )
      end
      it 'should' do
        response = Sailpoint::Rest.ping
        expect(response.code).to eq(401)
      end
    end
  end
end