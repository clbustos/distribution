# = distribution.rb - 
# Distribution - Statistical Distributions package for Ruby
# 
# Copyright (C) 2011  Claudio Bustos
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#
# == Other Sources
# 
# * Code of Ruby engines came from statistics2.rb, 
#   created by Shin-ichiro HARA(sinara@blade.nagaokaut.ac.jp).
#   Retrieve from http://blade.nagaokaut.ac.jp/~sinara/ruby/math/statistics2/
# 
# Specific notices will be placed where there are appropiate
# 




# Several distributions modules to calculate pdf, cdf, inverse cdf and generate
# pseudo-random numbers for several statistical distributions
# 
# == Usage:
#    Distribution::Normal.cdf(1.96)
#    => 0.97500210485178
#    Distribution::Normal.p_value(0.95)
#    => 1.64485364660836
module Distribution

  SQ2PI = Math.sqrt(2 * Math::PI)
  VERSION="0.0.1"
  # Create a method 'has_<library>' on Module
  # which require a library and return true or false
  # according to success of failure 
  def self.create_has_library(library) #:nodoc:
    define_singleton_method("has_#{library}?") do
      cv="@@#{library}"
      if !class_variable_defined? cv
        begin 
          require library.to_s
          class_variable_set(cv,true)
        rescue LoadError
          class_variable_set(cv,false)
        end
      end
      class_variable_get(cv)
    end
  end
  # Retrieves the libraries used to calculate 
  # distributions
  def self.libraries_order
    order=[:Ruby_]
    order.unshift(:Statistics2_) if has_statistics2?
    order.unshift(:GSL_) if has_gsl?
    order.unshift(:Java_) if has_java?
    order
  end
  create_has_library :gsl
  create_has_library :statistics2
  create_has_library :java
  
  # Magic module
  module Distributable #:nodoc:
    # Create methods for each module
    # Traverse Distribution.libraries_order adding
    # methods availables for each library on
    # the current library
    def create_distribution_methods()  
    Distribution.libraries_order.each do |l_name|
      
      if const_defined? l_name
        l =const_get(l_name)
        l.singleton_methods.each do |m|
          if !singleton_methods.include? m
            define_method(m) do |*args|
              l.send(m,*args)
            end
            module_function m
          end
        end
      end        
    end
    alias_method :inverse_cdf,:p_value if singleton_methods.include? :p_value
    end

  end

  autoload(:Normal, 'distribution/normal')  
  autoload(:ChiSquare, 'distribution/chisquare')
  autoload(:T, 'distribution/t')
  autoload(:F, 'distribution/f')
  autoload(:NormalBivariate, 'distribution/normalbivariate')
end



