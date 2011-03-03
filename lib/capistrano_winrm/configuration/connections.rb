module Capistrano
  class Configuration
    module Connections
      class WinRMConnectionFactory #:nodoc:
        def initialize(options)
          @options = options
        end

        def connect_to(server)
          WINRM.new(server, @options)
        end
      end
      
      # Returns the object responsible for establishing new connections.
      # The factory will respond to #connect_to, which can be used to
      # establish connections to servers defined via ServerDefinition objects.
      def connection_factory
        @connection_factory ||= begin
          if exists?(:gateway)
            logger.debug "establishing connection to gateway `#{fetch(:gateway)}'"
            GatewayConnectionFactory.new(fetch(:gateway), self)
          elsif(exists?(:winrm_running))
            logger.debug "establishing connection to WinRM"
            WinRMConnectionFactory.new(self)
          else
            DefaultConnectionFactory.new(self)
          end
        end
      end

    end # Connections
  end # Configuration
end # Capistrano
