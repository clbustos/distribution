require 'distribution/logistic/ruby'
# require 'distribution/logistic/gsl'
# require 'distribution/logistic/java'

module Distribution
  # From Wikipedia:
  # In probability theory and statistics, the logistic distribution is a continuous probability distribution. Its cumulative distribution function is the logistic function, which appears in logistic regression and feedforward neural networks. It resembles the normal distribution in shape but has heavier tails (higher kurtosis).
  module Logistic
    SHORTHAND = 'logis'
    extend Distributable
    create_distribution_methods
    ##
    # :singleton-method: rng(u,s)
    # Returns a proc, which returns a different logistic
    # variate each time is called
    # * u: mean
    # * s: variance related parameter
    ##
    # :singleton-method: pdf(x , u,s)
    # Returns the pdf for logistic distribution (f(x,u,s))
    # * u: mean
    # * s: variance related parameter

    ##
    # :singleton-method: cdf(x,u,s)
    # Returns the cdf for logistic distribution (F(x,u,s))
    # * u: mean
    # * s: variance related parameter

    ##
    # :singleton-method: p_value(pr , u,s)
    # Returns the inverse cdf for logistic distribution
    # (F^-1(pr,u,s))
    # * u: mean
    # * s: variance related parameter
  end
end
