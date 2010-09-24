require 'rubygems'
require 'rake/clean'
require 'rake/gempackagetask'
require 'date'

CLEAN.include("pkg")
CLEAN.include("doc")

GEMSPEC = Gem::Specification.new do |gem|
  gem.name = "capistrano_winrm"
  gem.version = File.open('VERSION').readline.chomp
  gem.date		= Date.today.to_s
  gem.platform = Gem::Platform::RUBY
  gem.rubyforge_project  = nil

  gem.author = "Dan Wanek"
  gem.email = "dan.wanek@gmail.com"
  gem.homepage = "http://github.com/zenchild/capistrano_winrm"

  gem.summary = 'WinRM extensions for Capistrano'
  gem.description	= <<-EOF
    WinRM extensions for Capistrano
  EOF

  gem.files = %w{ lib/capistrano_winrm.rb lib/capistrano_winrm/command.rb lib/capistrano_winrm/configuration/connections.rb lib/winrm_connection.rb }
  gem.require_path = "lib"
  gem.rdoc_options	= %w(-x test/ -x examples/)
  gem.extra_rdoc_files = %w(README)

  gem.required_ruby_version	= '>= 1.8.7'
  gem.add_runtime_dependency  'capistrano'
  gem.add_runtime_dependency  'winrm', '>=0.0.4'
end
 
Rake::GemPackageTask.new(GEMSPEC) do |pkg|
  pkg.need_tar = true
end

task :default => [:buildgem]

desc "Build the gem without a version change"
task :buildgem => [:clean, :repackage]

desc "Build the gem, but increment the version first"
task :newrelease => [:versionup, :clean, :repackage]


desc "Increment the version by 1 minor release"
task :versionup do
	ver = up_min_version
	puts "New version: #{ver}"
end


def up_min_version
	f = File.open('VERSION', 'r+')
	ver = f.readline.chomp
	v_arr = ver.split(/\./).map do |v|
		v.to_i
	end
	v_arr[2] += 1
	ver = v_arr.join('.')
	f.rewind
	f.write(ver)
	ver
end
