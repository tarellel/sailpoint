require 'sailpoint/version'
require 'sailpoint/config'
require 'sailpoint/helpers' # To override defaults and adding global helper functions
require 'sailpoint/rest'
require 'sailpoint/scim'

# Sailpoint Module to allow for easily accessing the Sailpoint API
module Sailpoint
  # When generating a Standard Exception error
  class Error < StandardError; end

  # If a valid username and URL have been supplied a lookup requests will be send to determine if the user exists in the specified interface
  # @param username [String] - the username that we are going to valid exists in the IdentityIQ listing
  # @return [Hash] - If a user is found, it will return all the that identities attributes
  def self.get_user(username, interface: nil)
    raise ArgumentError, 'An invalid user lookup was specified.' if username.to_s.blank?
    raise ArgumentError, 'Please specify a valid HOST/Interface before attemping a lookup.' unless valid_url?
    raise ArgumentError, 'Valid credentials are required before attempting an API request.' unless valid_credentials?
    raise ArgumentError, 'Invalid method type' unless valid_interface_type?(interface) || valid_interface_type?(Sailpoint::Config.interface)

    if interface.nil?
      Object.const_get("Sailpoint::#{Sailpoint::Config.interface.capitalize}").get_user(username)
    elsif valid_interface_type?(interface)
      Object.const_get("Sailpoint::#{interface.capitalize}").get_user(username)
    end
  end

  # Assign the credentials for accessing the IdentityIQ API
  # @param username [String] - The Sailpoint username required for accessing the API
  # @param password [String] - The Sailpoint password required for accessing the API
  def self.set_credentials(username, password)
    Sailpoint::Config.set_credentials(username, password) unless username.nil? && password.nil?
  end

  # Assign the IdentityIQ API base URL
  # @param host [String] - The base URL in which the API calls will be built upon
  def self.set_host(host)
    Sailpoint::Config.host = host unless host.blank?
  end

  # Used to verify if any credentails were supplied for the API request
  # @return [Boolean] if credentials were supplied or not
  def self.valid_credentials?
    return false if Sailpoint::Config.username.blank? && Sailpoint::Config.password.blank?

    !Sailpoint::Config.hashed_credentials.blank?
  end

  # Used to verify if the specifed interface type is valid for the Sailpoint API
  # @param interface [String] - A specified API interface endpoint, that can either be `Rest` or `Scim`
  # @return [Boolean] - Returns weither the specifed interface is a a valid type allowed by the API.
  def self.valid_interface_type?(interface)
    %w[rest scim].include?(interface)
  end

  # Used to verify if the URL string is blank or a URL was supplied
  # @return [Boolean] - if a url for the API endpoint was supplied or not
  def self.valid_url?
    !Sailpoint::Config.url.blank?
  end
end
