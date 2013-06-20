lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'distribution/version'

Gem::Specification.new do |gem|
  gem.name = "distribution"
  gem.version = Distribution::VERSION
  gem.summary = "Statistical Distributions multi library wrapper."
  gem.description = <<BEGIN
Statistical Distributions library. Includes Normal univariate and bivariate, T, F, Chi Square, Binomial, Hypergeometric, Exponential, Poisson, Beta, LogNormal and Gamma.

Uses Ruby by default and C (statistics2/GSL) or Java extensions where available.

Includes code from statistics2 on Normal, T, F and Chi Square ruby code
BEGIN
  gem.homepage = 'http://sciruby.com'
  gem.authors = ['Claudio Bustos']
  gem.email =  ['clbustos at gmail dot com']

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  #gem.required_ruby_version = '>= 1.9.2'
  gem.add_development_dependency 'rake', '~>0.9'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rspec', '>=2.0'
  gem.add_development_dependency 'rubyforge'
end

