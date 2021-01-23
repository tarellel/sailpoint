# frozen_string_literal: true

require 'sailpoint/version'
require 'sailpoint/core_ext/blank'
require 'sailpoint/core_ext/escape_str'
require 'sailpoint/rest'
require 'sailpoint/scim'

module Sailpoint
  require 'sailpoint/helpers' # To override defaults and adding global helper functions
  require 'sailpoint/configuration'

  # When generating a Standard Exception error
  class Error < StandardError; end
  class << self
    def config
      @config ||= Configuration.new
    end

    # Used to memorize and create a Mutex to keep config in sync across running threads
    #
    # @return [Mutex]
    def mutex
      @mutex ||= Mutex.new
    end

    # If a valid username and URL have been supplied a lookup requests will be send to determine if the user exists in the specified interface
    # @param username [String] - the username that we are going to valid exists in the IdentityIQ listing
    # @return [Hash] - If a user is found, it will return all the that identities attributes
    def get_user(username = '')
      raise ArgumentError, 'An invalid user lookup was specified.' if username.blank?
      raise ArgumentError, 'Please specify a valid HOST/Interface before attemping a lookup.' unless valid_url?
      raise ArgumentError, 'Valid credentials are required before attempting an API request.' unless valid_credentials?
      raise ArgumentError, 'Invalid interface type' unless valid_interface_type?(config.interface)

      if config.interface.blank?
        Sailpoint::Scim.get_user(username)
      else
        Object.const_get("Sailpoint::#{config.interface&.capitalize}").get_user(username)
      end
    end

    # Used to verify if any credentails were supplied for the API request
    # @return [Boolean] if credentials were supplied or not
    def valid_credentials?
      return false if Sailpoint.config.username.blank? && Sailpoint.config.password.blank?

      !Sailpoint.config.hashed_credentials.blank?
    end

    # Used to verify if the specifed interface type is valid for the Sailpoint API
    # @param interface [String] - A specified API interface endpoint, that can either be `Rest` or `Scim`
    # @return [Boolean] - Returns weither the specifed interface is a a valid type allowed by the API.
    def valid_interface_type?(interface = nil)
      return false if interface.blank?

      Sailpoint::Configuration::ALLOWED_INTERFACES.include?(interface)
    end

    # Used to verify if the URL string is blank or a URL was supplied
    # @return [Boolean] - if a url for the API endpoint was supplied or not
    def valid_url?
      !Sailpoint.config.url.blank?
    end

    def configure
      self.config ||= config
      yield(config)
    end
  end
end
