# -*- ruby -*-
$:.unshift(File.expand_path(File.dirname(__FILE__)+"/lib/"))
require 'rubygems'
require 'distribution'
desc "Open an irb session preloaded with distribution"
task :console do
  sh "irb -rubygems -I lib -r distribution.rb"
end

require 'bundler'
Bundler::GemHelper.install_tasks

# vim: syntax=ruby
