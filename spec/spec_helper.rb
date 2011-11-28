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
require 'distribution'

module ExampleWithGSL
  def it_only_with_gsl(name,&block)
    it(name) do
      if Distribution.has_gsl?
        instance_eval(&block)
      else
        pending("Requires GSL")  
      end
    end
  end
  
  def it_only_with_java(name,&block)
    it(name) do
      if Distribution.has_java?
        instance_eval(&block)
      else
        pending("Requires Java")  
      end
    end
  end
  
end
