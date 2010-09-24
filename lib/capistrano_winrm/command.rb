module Capistrano
  class Command
    # Processes the command in parallel on all specified hosts. If the command
    # fails (non-zero return code) on any of the hosts, this will raise a
    # Capistrano::CommandError.
    def process!
      if(@tree.configuration.variables[:winrm_running])
        @channels.each do |ch|
          ch.process_data do |c, stream, data|
            c[:branch].callback[c, stream, data]
          end
        end
      else
        loop do
          break unless process_iteration { @channels.any? { |ch| !ch[:closed] } }
        end
      end

      logger.trace "command finished" if logger

      if (failed = @channels.select { |ch| ch[:status] != 0 }).any?
        commands = failed.inject({}) { |map, ch| (map[ch[:command]] ||= []) << ch[:server]; map }
        message = commands.map { |command, list| "#{command.inspect} on #{list.join(',')}" }.join("; ")
        error = CommandError.new("failed: #{message}")
        error.hosts = commands.values.flatten
        raise error
      end

      self
    end

  end # end Command
end # end Capistrano
