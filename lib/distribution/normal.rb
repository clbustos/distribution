require 'distribution/normal/ruby'
require 'distribution/normal/gsl'
require 'distribution/normal/statistics2'
require 'distribution/normal/java'

module Distribution
  # From Wikipedia:
  #   Continuous probability distribution that is often used as
  #   a first approximation to describe real-valued random variables
  #   that tend to cluster around a single mean value.
  #   The graph of the associated probability density function is "bell-shaped.
  module Normal
    SHORTHAND = 'norm'
    extend Distributable

    create_distribution_methods

    ##
    # :singleton-method: pdf(x)
    # Returns PDF of Normal distribution

    ##
    # :singleton-method: p_value(qn)
    # Return the P-value of the corresponding integral +qn+

    ##
    # :singleton-method: cdf(x)
    # Returns the integral of Normal distribution over [0, +x+]

    ##
    # :singleton-method: rng
    # Returns a lambda which returns a random number from
    # X ~ N(0,1)
  end
end
