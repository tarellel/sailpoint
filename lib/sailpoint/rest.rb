# frozen_string_literal: true

require 'httparty'
require 'json'

# Used for creating Sailpoint RESTS requests
module Sailpoint
  # Used for created REST API calls to the organizations IdentityIQ source
  class Rest
    EMPTY_RESPONSE = '{}'
    EMPTY_HASH = {}.freeze

    # Used to verify if the supplied credentials are valid
    # @return [Hash] - The responses body as a JSON hash
    def self.authenticate
      set_rest_interface
      response = HTTParty.get([Sailpoint.config.url, 'authentication'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response)
    end

    # Verify if the user has any policies set within the specified roles
    # @param identity [String] - The user in which you are requesting data for
    # @param roles [String, Array] - Roles specified to validate against (either: <code>role</code> or <code>['role1','role2']</code>)
    # @return [Hash] - Return data associated with there users roles
    def self.check_roles(identity, roles)
      # Values for both attributes are required in order to create the request
      # And verify the user exists before attempting to create the request (this prevents IdentityIQ from making a long last query looking for a non-existant user)
      return EMPTY_HASH if identity.blank? || roles.blank? || get_user(identity).empty?

      set_rest_interface
      # the roles attribute should either be 'Contractor,Assistant' or ['Contractor', 'Assistant']
      roles = roles.join(',') if roles.is_a?(Array)
      response = HTTParty.get([Sailpoint.config.url, "policies/checkRolePolicies?identity=#{identity&.escape_str}&roles=#{roles}"].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Used to fetch the specified user identiy from the REST API interface
    # @param identity [String] - The user in which you are requesting data for
    # @return [Hash] - If no user if found an empty hash will be returned. If a a user is found, their parsed JSON will be returned as a result
    def self.get_identity(identity)
      set_rest_interface
      response = HTTParty.get([Sailpoint.config.url, 'identities', identity&.escape_str, 'managedIdentities'].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      return [].freeze if response.code == '500'

      JSON.parse(response&.body || EMPTY_RESPONSE).first
    end

    # Used to fetch the specified users associated data
    # @param identity [String] - The user in which you are requesting data for
    # @return [Hash] - If no user if found an empty hash will be returned. If a a user is found, their parsed JSON will be returned as a result
    def self.get_user(identity)
      set_rest_interface
      response = HTTParty.get([Sailpoint.config.url, 'identities', identity&.escape_str].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      raise Sailpoint::Helpers::AuthenticationException, 'Invalid credentials, please try again.' if response.code == 401

      JSON.parse(response&.body || EMPTY_RESPONSE)
    end

    # Get a users roles within the Organization
    # @return [Hash] - The users roles associated within the Organization
    def self.permitted_roles(identity = '')
      # Before requesting a users roles we need to verify if the identiy matches a valid user first
      return EMPTY_HASH if identity.blank? || get_user(identity).blank?

      set_rest_interface
      response = HTTParty.get([Sailpoint.config.url, "roles/assignablePermits/?roleMode=assignable&identity=#{identity&.escape_str}"].join('/'),
                              headers: Sailpoint.config.auth_header,
                              output: 'json', timeout: 10)
      response_body = JSON.parse(response&.body || EMPTY_RESPONSE)
      return response_body['objects'].map { |role| role['name'] } if response['status'].present? && response['status'] == 'success'

      response_body
    rescue
      EMPTY_HASH
    end

    # Used to verify your credentials are valid and IdentityIQ reource is properly responding
    # @return [Hash] - The head and body of the response
    def self.ping
      set_rest_interface
      HTTParty.get([Sailpoint.config.url, 'ping'].join('/'),
                   headers: Sailpoint.config.auth_header,
                   output: 'json', timeout: 10)
    rescue
      false
    end

    def self.set_rest_interface
      Sailpoint.config.interface = 'rest'
    end

    private_class_method :set_rest_interface
  end
end
