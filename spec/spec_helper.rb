$:.unshift(File.dirname(__FILE__)+"/../lib")
begin
  require 'simplecov'
  SimpleCov.start do
    add_filter "/spec/"
    add_group "Libraries", "lib"
  end
rescue LoadError
end
require 'rspec'
#require 'spec/autorun'
require 'distribution'
