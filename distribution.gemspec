$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'date'
require 'distribution/version'

Gem::Specification.new do |s|
  s.name = "distribution"
  s.version = Distribution::VERSION
  s.date = Date.today.to_s
  s.homepage = "https://github.com/sciruby/distribution"

  s.authors = ['Claudio Bustos', 'Carlos Agarie']
  s.email = ['clbustos@gmail.com', 'carlos.agarie@gmail.com']
  s.platform = Gem::Platform::RUBY
  s.summary = "Distribution"
  s.description = "Distribution is a gem with several probabilistic distributions. Pure Ruby is used by default, C (GSL) or Java extensions are used if available"

  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rake'
  s.add_development_dependency "rspec", '~> 3.2'
end
