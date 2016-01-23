$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
begin
  require 'simplecov'
  SimpleCov.start do
    add_filter '/spec/'
    add_group 'Libraries', 'lib'
  end
rescue LoadError
end
require 'rspec'
require 'distribution'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate
end

module ExampleWithGSL
  def it_only_with_gsl(name, opts = {}, &block)
    it(name, opts) do
      if Distribution.has_gsl?
        instance_eval(&block)
      else
        skip('Requires GSL')
      end
    end
  end

  def it_only_with_java(name, &block)
    it(name) do
      if Distribution.has_java?
        instance_eval(&block)
      else
        skip('Requires Java')
      end
    end
  end
end
