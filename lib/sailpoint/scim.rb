# frozen_string_literal: true

require 'httparty'
require 'json'

# Used for creating Sailpoint SCIM requests
module Sailpoint
  # Used for created SCIM API calls to the organizations IdentityIQ source
  class Scim
    EMPTY_RESPONSE = '{}'

    # Returns a massive list of all account entries in the IdeneityIQ sources
    # @return [Hash] - A hashed list of all IdenityIQ accounts [Service and User accounts]
    def self.accounts
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/Accounts'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Used to fetch a list of all Applications and their associated attributes
    # @return [Hash] - A hash of all avaialble applications and their associated MetaData attributes
    def self.applications
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/Applications'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Used to fetch the specified users associated data
    # @return [Hash] - The users hashed data attributes
    def self.get_user(identity)
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/Users', identity].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      # NOTE: If invalid credentials are supplied or the user could not be found response bodies contain a status code.
      # => But if a a user if found, a status code isn't returned, but all of their data attributes are returned instead.
      raise Sailpoint::Helpers::AuthenticationException, 'Invalid credentials, please try again.' if response.body['status'] && response.body['status'] == '401'
      return [].freeze if response.body && response.body['status'] && response.body['status'] == '404'

      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Fetch all resource types associated with the IdentityIQ API
    # @return [Hash] - A hash of all resources types [Users, Applications, Accounts, Roles, etc.]
    def self.resource_types
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/ResourceTypes'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Fetch the schemas for all resources types assocaited with the API's returning data
    # @return [Hash] - A hash of all all ResourceType Schemas
    def self.schemas
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/Schemas'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Fetch a list of all ServiceProviders associated with the data being served by the API
    # @return [Hash] - A hashed list of SailPoint service providers associated with the IdentityIQ Instance
    def self.service_providers
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/ServiceProviderConfig'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Returns a list of all users from the associated organizations
    # @return [Hash] - All users entries from the organizations sources
    def self.users
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/Users'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Returns a list of data attributes for the ResourceType -> Users
    # @return [Hash] - A hash to describe the user schema attributes
    def self.user_resource_types
      set_scim_interface
      response = HTTParty.get([Sailpoint.config.url, 'v2/ResourceTypes/User'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    def self.set_scim_interface
      Sailpoint.config.interface = 'scim'
    end

    private_class_method :set_scim_interface
  end
end
