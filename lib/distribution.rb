# = distribution.rb -
# Distribution - Statistical Distributions package for Ruby
#
# Copyright (c) 2011-2012, Claudio Bustos
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the copyright holder nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
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
