require 'distribution/f/ruby'
require 'distribution/f/gsl'
require 'distribution/f/statistics2'
require 'distribution/f/java'
module Distribution
  # Calculate cdf and inverse cdf for F Distribution.
  #
  module F
    SHORTHAND = 'fdist'
    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,k1,k2)
    # Returns the PDF of F distribution
    # with +k1+ and +k2+ degrees of freedom over [0, +x+]

    ##
    # :singleton-method: p_value(qn, k1, k2)
    # Return the P-value of the corresponding integral +qn+ with
    # +k1+ and +k2+ degrees of freedom

    ##
    # :singleton-method: cdf(x,k1,k2)
    # Returns the integral of F distribution
    # with +k1+ and +k2+ degrees of freedom over [0, +x+]
  end
end
