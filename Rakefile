require 'bundler'
require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'

# Setup the necessary gems, specified in the gemspec.
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

desc "Open an irb session preloaded with distribution"
task :console do
  sh "irb -rubygems -I lib -r distribution.rb"
end

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
