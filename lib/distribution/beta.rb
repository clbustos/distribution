require 'distribution/beta/ruby'
require 'distribution/beta/gsl'
# no statistics2 functions for beta.
require 'distribution/beta/java'

module Distribution
  # From Wikipedia:
  #    In probability theory and statistics, the beta distribution
  #    is a family of continuous probability distributions defined
  #    on the interval (0, 1) parameterized by two positive shape
  #    parameters, typically denoted by alpha and beta.
  # This module calculate cdf and inverse cdf for Beta Distribution.
  #
  module Beta
    extend Distributable
    SHORTHAND = 'beta'
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,a,b)
    # Returns PDF of of Beta distribution with parameters a and b

    ##
    # :singleton-method: cdf(x,a,b)
    # Returns the integral of Beta distribution with parameters a and b

    ##
    # :singleton-method: p_value(qn,a,b)
    # Return the quantile of the corresponding integral +qn+
    # on a beta distribution's cdf with parameters a and b
  end
end
