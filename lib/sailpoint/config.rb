require 'base64'
require 'sailpoint/helpers'

# Used for setting you Sailpoint API configuration and credentials
module Sailpoint
  # Used for setting API configuration before creating API Requests
  # Configuration can include: <code>username, password, interface, host, url</code>
  class Config
    attr_accessor :username, :password, :interface, :url

    @username = nil
    @password = nil
    @interface = 'rest' # By default lets resort to using the Rest interface
    @host = nil         # Where the SailPoint server is hosted

    class << self
      attr_writer :username, :password, :interface, :host, :url

      # Used to set the API requests BasicAuth credentails
      # @param username [String] - Username for the API request
      # @param password [String] - Password for the API request
      def set_credentials(username, password)
        @username = username unless username.nil?
        @password = password unless password.nil?
      end

      # Used for setting if the interface type is Rest || SCIM
      # @return [String] - Returns either the specified interface (Default: <code>rest</code>)
      def interface
        (@interface ||= 'rest')
      end

      # Used for fetching the API interface_path based on the API interface specification
      # @return [String] - Returns the API's interface path, based on interface type
      def interface_path
        (@interface == 'scim' ? 'scim' : 'rest')
      end

      # Used to fetch the host for the API request
      # @return [String] - If a valid host was specified, it will returned a trimmed string with trailing whitespaces and slashes removed
      def host
        return '' if @host.blank?

        trimmed_host
      end

      # Used for fetching the requesting users entire URL (Host+Interface)
      # @param interface [String] - used for when the user is specicically calling an API such as <code>Unmh::Sailpoint::Scim.get_user('brhicks')</code>
      # @return [String] - Returns the entire requesting URL (based on host and interface type)
      def url(interface = '')
        return '' if @host.blank? || @interface.blank?

        full_host(interface)
      end

      def full_host(interface = '')
        interface.blank? ? [trimmed_host, 'identityiq', interface_path].join('/') : [trimmed_host, 'identityiq', interface].join('/')
      end

      # Used for fetching credentails username (if it has been set)
      # @return [String] - The credentails username
      def username
        @username || ''
      end

      # Used for fetching the requesting users credentials password (if it has been set)
      # @return [String] - The password for the API credentials
      def password
        @password || ''
      end

      # Used for fetching the API credentials when setting API requests headers
      # @return [String] - Return a hash of the current API credentils (for validation purposes)
      def credentials
        { username: @username, password: @password }
      end

      # Remove trailing forward slashes from the end of the Host, that way hosts and interfaces can be properly joined
      # => I also did this because you'd get the same results if something supplied `http://example.com` or `https://example.com/`
      # @return [String] - Returns a cleaned up and trimmed host with trailing slashs removed
      def trimmed_host
        return '' if @host.blank?

        @host.strip.gsub!(%r{\/?++$}, '')
      end

      # SailPoints auth requires a Base64 string of (username:password)
      # This is how most BasicAuth authentication methods work
      # @return [String] - It will either return an empty string or a Base64.encoded hash for the the API credentials (BasicAuth requires Base64)
      def hashed_credentials
        return '' if @username.blank? && @password.blank?

        Base64.encode64("#{@username}:#{@password}").strip
      end

      # Used for generating the API BasicAuth Header when creating an API request
      # @return [String] - Return the API Authorization header for the making API requests
      def auth_header
        return '' if @username.blank? && @password.blank?

        { 'Authorization' => "Basic #{Sailpoint::Config.hashed_credentials}" }
      end
    end
  end
end
