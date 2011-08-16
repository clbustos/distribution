require 'distribution/gamma/ruby'
require 'distribution/gamma/gsl'
# no statistics2 functions for gamma.
require 'distribution/gamma/java'

module Distribution
  # Calculate cdf and inverse cdf for Gamma Distribution.
  #
  module Gamma
    extend Distributable
    SHORTHAND='gamma'
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,a,b)
    # Returns PDF of of Gamma distribution


    ##
    # :singleton-method: cdf(x,a,b)
    # Returns the integral of Gamma distribution

    ##
    # :singleton-method: p_value(qn,a,b)
    # Return the P-value of the corresponding integral +qn+

  end
end
