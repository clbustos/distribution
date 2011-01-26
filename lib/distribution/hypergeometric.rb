require 'distribution/hypergeometric/ruby'
require 'distribution/hypergeometric/gsl'

module Distribution
  # From Wikipedia:
  #   In probability theory and statistics, the hypergeometric distribution is a discrete probability distribution that
  #   describes the number of successes in a sequence of n draws from a finite population without replacement, just as
  #   the binomial distribution describes the number of successes for draws with replacement.
  module Hypergeometric
    SHORTHAND='hypg'
    extend Distributable

    create_distribution_methods

    ##
    # :singleton-method: pdf(k,m,n,total)

    ##
    # :singleton-method: cdf(k,m,n,total)

    ##
    # :singleton-method: p_value(k,m,n,total)

  end
end
