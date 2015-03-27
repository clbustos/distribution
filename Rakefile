$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'bundler'
require 'bundler/gem_tasks'
require 'distribution'
require 'rake'

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
