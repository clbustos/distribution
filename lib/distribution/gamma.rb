require 'distribution/gamma/ruby'
require 'distribution/gamma/gsl'
# no statistics2 functions for gamma.
require 'distribution/gamma/java'

module Distribution
  # Calculate cdf and inverse cdf for Chi Square Distribution.
  #
  module Gamma
    extend Distributable
    SHORTHAND='gamma'
    create_distribution_methods

    ##
    # :singleton-method: pdf(x)
    # Returns PDF of of Chi-squared distribution
    # with +k+ degrees of freedom


    ##
    # :singleton-method: cdf(x,k)
    # Returns the integral of Chi-squared distribution
    # with +k+ degrees of freedom over [0, +x+]

    ##
    # :singleton-method: p_value(qn, k)
    # Return the P-value of the corresponding integral +qn+ with
    # +k+ degrees of freedom

  end
end
