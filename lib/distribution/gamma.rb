require 'distribution/gamma/ruby'
require 'distribution/gamma/gsl'
# no statistics2 functions for gamma.
require 'distribution/gamma/java'

module Distribution
  # From Wikipedia:
  #    The gamma distribution is a two-parameter family of
  #    continuous probability distributions. It has a scale parameter a
  #    and a shape parameter b.
  #
  # Calculate pdf, cdf and inverse cdf for Gamma Distribution.
  #
  module Gamma
    extend Distributable
    SHORTHAND = 'gamma'
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,a,b)
    # Returns PDF of of Gamma distribution with +a+ as scale
    # parameter and +b+ as shape parameter

    ##
    # :singleton-method: cdf(x,a,b)
    # Returns the integral of Gamma distribution with +a+ as scale
    # parameter and +b+ as shape parameter

    ##
    # :singleton-method: p_value(qn,a,b)
    # Return the upper limit for the integral of a
    # gamma distribution which returns +qn+
    # with scale +a+ and shape +b+
  end
end
