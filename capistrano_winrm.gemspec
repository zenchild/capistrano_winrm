# -*- encoding: utf-8 -*-
require 'date'

version = File.read(File.expand_path("../VERSION", __FILE__)).strip

Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = 'capistrano_winrm'
  s.version = version
  s.date		= Date.today.to_s

  s.author = 'Dan Wanek'
  s.email = 'dan.wanek@gmail.com'
  s.homepage = "https://github.com/zenchild/capistrano_winrm"

  s.summary = "Extends Capistrano with WinRM support."
  s.description	= <<-EOF
    This gem extends Capistrano's base functionality to support WinRM which
    allows one to run commands across Windows boxes with the "winrm_run" method.
  EOF

  s.files = `git ls-files`.split(/\n/)
  s.require_path = "lib"
  s.rdoc_options	= %w(-x test/ -x examples/)
  s.extra_rdoc_files = %w(README)

  s.required_ruby_version	= '>= 1.9.0'
  s.add_runtime_dependency  'capistrano', '~> 2.14.1'
  s.add_runtime_dependency  'winrm', '~> 1.1.2'
end
