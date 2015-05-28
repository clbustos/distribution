require 'distribution/hypergeometric/ruby'
require 'distribution/hypergeometric/gsl'
require 'distribution/hypergeometric/java'

module Distribution
  # From Wikipedia:
  #   In probability theory and statistics, the hypergeometric distribution is a discrete probability distribution that
  #   describes the number of successes in a sequence of n draws from a finite population without replacement, just as
  #   the binomial distribution describes the number of successes for draws with replacement.
  module Hypergeometric
    SHORTHAND = 'hypg'
    extend Distributable

    create_distribution_methods

    ##
    # :singleton-method: pdf(k,m,n,total)
    # This function computes the probability p(k) of obtaining k
    # from a hypergeometric distribution with parameters
    # m, n t.
    # * m: number of elements with desired attribute on population
    # * n: sample size
    # * t: population size

    ##
    # :singleton-method: cdf(k,m,n,total)
    # These functions compute the cumulative distribution function P(k)
    # for the hypergeometric distribution with parameters m, n and t.
    # * m: number of elements with desired attribute on population
    # * n: sample size
    # * t: population size

    ##
    # :singleton-method: p_value(k,m,n,total)
  end
end
