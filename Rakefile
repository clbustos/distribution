# -*- ruby -*-
# $:.unshift(File.expand_path(File.dirname(__FILE__)+"/lib/"))
require 'rubygems'
require 'bundler'
# require 'hoe'
# require 'distribution'
# require 'rubyforge'
# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :git
# Hoe.plugin :inline
# Hoe.plugin :racc
# Hoe.plugin :rubyforge

gemspec = eval(IO.read("distribution.gemspec"))

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "rake/gempackagetask"
Rake::GemPackageTask.new(gemspec).define

desc "install the gem locally"
task :install => [:package] do
  sh %{gem install pkg/distribution-#{Distribution::VERSION}.gem}
end

require 'rspec/core/rake_task'
require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

# git log --pretty=format:"*%s[%cn]" v0.5.0..HEAD >> History.txt
desc "Open an irb session preloaded with distribution"
task :console do
  sh "irb -rubygems -I lib -r distribution.rb"
end

desc "Open a pry session preloaded with distribution"
task :pry do
  sh "pry -I lib -r distribution.rb"
end

task :default => :spec

# vim: syntax=ruby
