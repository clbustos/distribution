require 'distribution/beta/ruby'
require 'distribution/beta/gsl'
# no statistics2 functions for beta.
require 'distribution/beta/java'

module Distribution
  # Calculate cdf and inverse cdf for Beta Distribution.
  #
  module Beta
    extend Distributable
    SHORTHAND='beta'
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,a,b)
    # Returns PDF of of Beta distribution


    ##
    # :singleton-method: cdf(x,a,b)
    # Returns the integral of Beta distribution

    ##
    # :singleton-method: p_value(qn,a,b)
    # Return the P-value of the corresponding integral +qn+

  end
end
