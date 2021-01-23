
# Sailpoint

![Gem Version](https://img.shields.io/gem/v/sailpoint "SailPoint Gem version")  [![MIT license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)


This is an unofficial tool for interactiving with Sailpoints [IdentityIQ's](https://www.sailpoint.com/solutions/identityiq/?elqct=Website&elqchannel=OrganicDirect) API interface. This gem assumes your IdenityIQ API is setup to authenticate using [BasicAuth](https://developer.sailpoint.com/SCIM/index.html#authentication) headers. If you require credentials for your SailPoint (IdenitityIQ) interface, I suggest contacting your system administrator before continuing any farther.

**Note:** This gem doesn't include all possible IdentityIQ API requests, primarmly due to last of authorization to access much else. If you happen to have additional access to an IdentitiyIQ API it would be very much appreciated if you contributed any additional API requests.

## Installation

Add this line to your application's Gemfile:

```ruby
# Gemfile
gem 'sailpoint'
```

And then execute:

`bundle install`

## Usage

Before attempting to use the Sailpoint API you'll need to contact your system admin and get a set of API credentials. Every application should have a unique set of credentials, that way if any one application is compromised you don't have to roll the credentials on a number of applications. I would also suggest setting these credentials in your rails encrypted credentials as the following.

```yaml
sailpoint:
  username: sample_user
  password: sample_password
```

To access these credentials throughout the application you can access them with the following references:

```ruby
Rails.application.credentials[:sailpoint][:username]
Rails.application.credentials[:sailpoint][:password]
```

### Running as a ruby script

If running from `irb` or wanting to call the IdentityIQ API from a ruby script use the following method to access the IdentityIQ API

```ruby
require 'sailpoint'

# In order to make any API requests you need to specify the IdentityIQ API Host and set you API credentials
Sailpoint.configure do |config|
  config.username = 'api_username'
  config.password = 'api_password'
  config.host = 'https://example.com'
end
```

By default this will pull users from the REST API
If you want to pull from the SCIM API there are a number of ways to do this as well

```ruby
# First method
Sailpoint.get_user('sample_user')

# Second method
# Note: When reassigning the API interface future queries will hit the new API endpoint unless specified
Sailpoint::Rest.get_user('sample_user')

# Third method (and my personal favorite to use without assigning the interface)
Sailpoint::Scim.get_user('sample_user')
```

### Using this gem with Rails

Lets first start by creating an initializer so you don't have to set the API configuration every time you want to make an API request.

```ruby
# config/initializers/sailpoint.rb
if defined?(Sailpoint)
  Sailpoint.configure do |config|
    config.username = 'api_username'
    config.password = 'api_password'
    config.host = 'https://example.com'
  end
end
```

# If you're using encrypted credentials

```ruby
if defined?(Sailpoint)
  Sailpoint.configure do |config|
    config.username = Rails.application.credentials[:sailpoint][:username]
    config.password = Rails.application.credentials[:sailpoint][:password]
    config.host = 'https://example.com'
  end
end
```

Now in your controller or models you should be able to make an API request with the following command

```ruby
Sailpoint.get_user('sample_user')
```

## General function calls

* `Sailpoint.get_user(identity)` - Search the API resources for the specified user identity

## Configuration

* `Sailpoint.config.auth_header` - Returns the BasicAuth Header for creating and API request (if the username/password have been set)
* `Sailpoint.config.credentials` - A hash containing the API credentials when setting API requests headers
* `Sailpoint.config.hashed_credentials` - A Base64 encoded string for the API request
* `Sailpoint.config.host` - Returns the API base host
* `Sailpoint.config.interface` - Returns the specified API interface (REST || SCIM)
* `Sailpoint.config.interface_path` - Returns the API path dependant on the interface
* `Sailpoint.config.password` - Returns the API password specified
* `Sailpoint.config.url` - Returns the full API URL based on the `host+interface`
* `Sailpoint.config.username` - If set, it returns the username credentials for API

## Interface specific function calls

### SCIM

* `Sailpoint::Scim.accounts` - Returns a massive list of all account entries in the IdeneityIQ sources
* `Sailpoint::Scim.appliations` - Returnsa list of all Applications and their associated attributes
* `Sailpoint::Scim.get_user(identity)` - Used to fetch the specified users associated data
* `Sailpoint::Scim.resource_types` - Fetch all resource types associated with the IdentityIQ API
* `Sailpoint::Scim.schemas` - Fetch the schemas for all resources types assocaited with the API's returning data
* `Sailpoint::Scim.service_providers` - Fetch a list of all ServiceProviders associated with the data being served by the API
* `Sailpoint::Scim.users` - Returns a list of all users from the associated organizations
* `Sailpoint::Scim.user_resource_types` - Returns a list of data attributes for the ResourceType -> Users

### REST

* `Sailpoint::Rest.authenticate` - Used to verify if the supplied credentials are valid
* `Sailpoint::Rest.check_roles` - Verify if the user has any policies set within the specified roles
* `Sailpoint::Rest.get_identity` - Used to fetch the specified user identiy from the REST API interface
* `Sailpoint::Rest.get_user(identity)` - Used to fetch the specified users associated data
* `Sailpoint::Rest.permitted_roles(identity)` - Get a users roles within the Organization
* `Sailpoint::Rest.ping` - Used to verify your credentials are valid and IdentityIQ reource is properly responding

```shell
# Rebuilding the gem to test in a required IRB term
gem uninstall sailpoint; rm -rf sailpoint-0.1.0.gem; gem build; gem install sailpoint
```

## API Documentation

* [IdentityNow](https://api.identitynow.com/)
* [API Reference (SCIM)](https://developer.sailpoint.com/SCIM/index.html)
* [Admin Guide](https://myaccess.supervalu.com/identityiq/doc/pdf/7_0_IdentityIQ_Administration_Guide.pdf)

## Contributing

Bug reports and pull requests are welcome on Github at https://github.com/tarellel/sailpoint

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
