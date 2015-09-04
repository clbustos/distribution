require 'distribution/lognormal/gsl'
require 'distribution/lognormal/ruby'

module Distribution
  # From Wikipedia:
  #    In probability theory, a log-normal distribution is a probability
  #    distribution of a random variable whose logarithm is normally
  #    distributed. If X is a random variable with a normal distribution, then
  #    Y = exp(X) has a log-normal distribution; likewise, if Y is
  #    log-normally distributed, then X = log(Y) is normally distributed. (This
  #    is true regardless of the base of the logarithmic function: if loga(Y) is
  #    normally distributed, then so is logb(Y), for any two positive numbers
  #    a, b ≠ 1.)
  #
  # This module calculates the pdf, cdf and inverse cdf for the Lognormal distribution.
  #
  module LogNormal
    extend Distributable
    SHORTHAND = 'lognormal'
    create_distribution_methods

    ##
    # :singleton-method: pdf(x,u,s)
    # Returns the PDF of the Lognormal distribution of x with parameters u (position) and
    # s (deviation)

    ##
    # :singleton-method: cdf(x,u,s)
    # Returns the CDF of the Lognormal distribution of x with parameters u (position) and
    # s(deviation)

    ##
    # :singleton-method: p_value(pr,u,s)
    # Return the quantile of the corresponding integral +pr+
    # on a lognormal distribution's cdf with parameters z and s
  end
end
