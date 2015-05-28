require 'distribution/bivariatenormal/ruby'
require 'distribution/bivariatenormal/gsl'
require 'distribution/bivariatenormal/java'
module Distribution
  # Calculate pdf and cdf for bivariate normal distribution.
  #
  # Pdf if easy to calculate, but CDF is not trivial. Several papers
  # describe methods to calculate the integral.
  module BivariateNormal
    SHORTHAND = 'bnor'

    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(k,n,prob)
    # Probability density function for exactly +k+ successes in +n+ trials
    # with success probability +prob+
    #

    ##
    # :singleton-method: cdf(k,n,prob)
    # Cumulative density function for +k+ or less successes in +n+ trials
    # with success probability +prob+
  end
end
