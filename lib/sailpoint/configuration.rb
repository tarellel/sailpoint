# frozen_string_literal: true

require 'base64'
require 'sailpoint/helpers'

# Used for setting you Sailpoint API configuration and credentials
module Sailpoint
  # Used for setting API configuration before creating API Requests
  # Configuration can include: <code>username, password, interface, host, url</code>
  class Configuration
    ALLOWED_INTERFACES = %w[rest scim].freeze

    attr_accessor :password, :username

    # Variables used for storing values for host= and interface=
    attr_accessor :host_val, :interface_val

    def initialize
      reload_config
    end

    def host=(val = nil)
      self.host_val = trim_host(val)
    end

    def host
      host_val
    end

    def interface=(val = nil)
      val = val&.to_s&.strip unless val.blank?
      self.interface_val = begin
        if val.blank? || !ALLOWED_INTERFACES.include?(val)
          'scim'
        else
          val
        end
      end
    end

    def interface
      interface_val
    end

    # SailPoints auth requires a Base64 string of (username:password)
    # This is how most BasicAuth authentication methods work
    # @return [String] - It will either return an empty string or a Base64.encoded hash for the the API credentials (BasicAuth requires Base64)
    def hashed_credentials
      return '' if username.blank? && password.blank?

      Base64.encode64("#{username}:#{password}").strip
    end

    # Used for fetching the API interface_path based on the API interface specification
    # @return [String] - Returns the API's interface path, based on interface type
    def interface_path
      return 'scim' if interface.blank? || !ALLOWED_INTERFACES.include?(interface)

      interface
    end

    # Used for fetching the requesting users entire URL (Host+Interface)
    # @return [String] - Returns the entire requesting URL (based on host and interface type)
    def url
      return '' if host.blank? || interface.blank?

      full_host(interface)
    end

    def full_host(interface = '')
      (interface.blank? ? [host, 'identityiq', interface_path].join('/') : [host, 'identityiq', interface].join('/'))
    end

    # Used for fetching the API credentials when setting API requests headers
    # @return [String] - Return a hash of the current API credentils (for validation purposes)
    def credentials
      { username: username, password: password }.freeze
    end

    # Used for generating the API BasicAuth Header when creating an API request
    # @return [String] - Return the API Authorization header for the making API requests
    def auth_header
      return {}.freeze if username.blank? && password.blank?

      { 'Authorization' => "Basic #{hashed_credentials}" }.freeze
    end

    private

    def reload_config
      ::Sailpoint.mutex.synchronize do
        self.interface ||= 'scim'
        self.host ||= nil
        self.password ||= nil
        self.username ||= nil
      end
    end

    # Remove trailing forward slashes from the end of the Host, that way hosts and interfaces can be properly joined
    # => I also did this because you'd get the same results if something supplied `http://example.com` or `https://example.com/`
    # @return [String] - Returns a cleaned up and trimmed host with trailing slashs removed
    def trim_host(str = nil)
      return nil if str.blank?

      str&.strip&.downcase&.gsub(%r{/?++$}, '')
    end
  end
end
