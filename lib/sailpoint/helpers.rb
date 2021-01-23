# frozen_string_literal: true

module Sailpoint
  class Helpers
    # Used to printout a [Red] message to STDOUT in case you want to print a message without causing an Exception.
    # @param msg [String] - The excpetion message that should be printed out
    def self.print_exception(msg = '')
      puts "\e[31m#{msg}\e[0m"
    end

    # Used to generate an Exception error hen invalid credentails have been supplied
    class AuthenticationException < StandardError
      attr_reader :data

      # Used to generate an ExceptionError message when Authenication has failed
      # @param data [String] - The message in which you wish to send to STDOUT for the exception error
      def initialize(data = 'An API Authentication error has occured.')
        super
        @data = data
      end

      # Specify the attribute in which to push to STDOUT when generating a Ruby ExceptionError
      def message
        @data
      end
    end
  end
end
