require 'distribution/exponential/ruby'
require 'distribution/exponential/gsl'
# require 'distribution/exponential/java'

module Distribution
  # From Wikipedia:
  #   In probability theory and statistics, the exponential distribution
  #   (a.k.a. negative exponential distribution) is a family of continuous
  #   probability distributions. It describes the time between events in a
  #   Poisson process, i.e. a process in which events occur continuously
  #   and independently at a constant average rate.
  #
  # Parameter +l+ is the rate parameter, the number of occurrences/unit time.
  module Exponential
    SHORTHAND = 'expo'
    extend Distributable
    create_distribution_methods
    ##
    # :singleton-method: rng(l)
    # Returns a lambda, which generates exponential variates
    # with +l+ as rate parameter

    ##
    # :singleton-method: pdf(x,l)
    # PDF of exponential distribution, with parameters +x+ and +l+.
    # +l+ is rate parameter

    ##
    # :singleton-method: cdf(x,l)
    # CDF of exponential distribution, with parameters +x+ and +l+.
    # +l+ is rate parameter
    ##
    # :singleton-method: p_value(pr,l)
    # Inverse CDF of exponential distribution, with parameters +pr+ and +l+.
    # +l+ is rate parameter
  end
end
