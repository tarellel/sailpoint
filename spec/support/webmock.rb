require 'webmock/rspec'
include WebMock::API

# Disable actual API requests
# => https://github.com/bblimke/webmock#real-requests-to-network-can-be-allowed-or-disabled
WebMock.disable_net_connect!(allow_localhost: true)