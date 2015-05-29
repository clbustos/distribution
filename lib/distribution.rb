# = distribution.rb -
# Distribution - Statistical Distributions package for Ruby
#
# Copyright (C) 2011-2014  Claudio Bustos
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
# * Code of several Ruby engines came from statistics2.rb,
#   created by Shin-ichiro HARA(sinara@blade.nagaokaut.ac.jp).
#   Retrieve from http://blade.nagaokaut.ac.jp/~sinara/ruby/math/statistics2/
# * Code of Beta and Gamma distribution came from GSL project.
#   Ported by John O. Woods
# Specific notices will be placed where there are appropiate
#

require 'distribution/math_extension'
require 'distribution/shorthand'
require 'distribution/distributable'
require 'distribution/version'

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

  class << self
    # Create a method 'has_<library>' on Module
    # which require a library and return true or false
    # according to success of failure
    def create_has_library(library) #:nodoc:
      define_singleton_method("has_#{library}?") do
        cv = "@@#{library}"
        unless class_variable_defined? cv
          begin
            require library.to_s
            class_variable_set(cv, true)
          rescue LoadError
            class_variable_set(cv, false)
          end
        end
        class_variable_get(cv)
      end
    end

    # Retrieves the libraries used to calculate
    # distributions
    def libraries_order
      order = [:Ruby_]
      order.unshift(:Statistics2_) if has_statistics2?
      order.unshift(:GSL_) if has_gsl?
      order.unshift(:Java_) if has_java?
      order
    end

    def init_java
      $LOAD_PATH.unshift File.expand_path('../../vendor/java', __FILE__)
      require 'commons-math-2.2.jar'
      java_import 'org.apache.commons.math.distribution.NormalDistributionImpl'
      java_import 'org.apache.commons.math.distribution.PoissonDistributionImpl'
    end
  end

  create_has_library :gsl
  create_has_library :statistics2
  create_has_library :java

  require 'distribution/normal'
  require 'distribution/chisquare'
  require 'distribution/gamma'
  require 'distribution/beta'
  require 'distribution/t'
  require 'distribution/f'
  require 'distribution/bivariatenormal'
  require 'distribution/binomial'
  require 'distribution/hypergeometric'
  require 'distribution/exponential'
  require 'distribution/poisson'
  require 'distribution/logistic'
  require 'distribution/lognormal'
  require 'distribution/weibull'

  init_java if has_java?
end
