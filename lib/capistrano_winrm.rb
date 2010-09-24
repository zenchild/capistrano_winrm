module CapistranoWinRM
  def self.included(base)
    base.send(:alias_method, :winrm, :winrm_run)
  end

  def winrm_run(cmd, options={}, &block)
    set :winrm_running, true
    options[:shell] = false
    block ||= self.class.default_io_proc
    tree = Capistrano::Command::Tree.new(self) { |t| t.else(cmd, &block) }
    run_tree(tree, options)
    set :winrm_running, false
  end
end # CapistranoWinRM

Capistrano::Configuration.send(:include, CapistranoWinRM)

require 'winrm_connection'
require 'capistrano_winrm/command'
require 'capistrano_winrm/configuration/connections'
