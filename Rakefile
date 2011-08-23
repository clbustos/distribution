# -*- ruby -*-
$:.unshift(File.expand_path(File.dirname(__FILE__)+"/lib/"))
require 'rubygems'
require 'hoe'
require 'distribution'
require 'rubyforge'
# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
 Hoe.plugin :git
# Hoe.plugin :inline
# Hoe.plugin :racc
 Hoe.plugin :rubyforge

Hoe.spec 'distribution' do
  self.developer('Claudio Bustos', 'clbustos_at_gmail.com')
  self.version=Distribution::VERSION
  self.extra_dev_deps << ["rspec",">=2.0"] << ["rubyforge",">=0"]

end
# git log --pretty=format:"*%s[%cn]" v0.5.0..HEAD >> History.txt
desc "Open an irb session preloaded with distribution"
task :console do
  sh "irb -rubygems -I lib -r distribution.rb"
end

# vim: syntax=ruby
