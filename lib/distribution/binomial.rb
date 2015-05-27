require 'distribution/binomial/ruby'
require 'distribution/binomial/gsl'
require 'distribution/binomial/java'
module Distribution
  # Calculate statisticals for Binomial Distribution.
  module Binomial
    SHORTHAND = 'bino'

    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,k)
    # Returns the integral of T distribution
    # with +k+ degrees of freedom over [0, +x+]

    ##
    # :singleton-method: p_value(qn, k)
    # Return the P-value of the corresponding integral +qn+ with
    # +k+ degrees of freedom

    ##
    # :singleton-method: cdf(x,k)
    # Returns the integral of T distribution
    # with +k+ degrees of freedom over [0, +x+]
  end
end
