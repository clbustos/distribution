require 'distribution/poisson/ruby'
require 'distribution/poisson/gsl'
#require 'distribution/poisson/java'


module Distribution
  # From Wikipedia
  #  In probability theory and statistics, the Poisson distribution is 
  #  a discrete probability distribution that expresses the probability of 
  #  a number of events occurring in a fixed period of time if these 
  #  events occur with a known average rate and independently of the time 
  #  since the last event.
  module Poisson
    SHORTHAND='pois'
    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(x , l)

    ##
    # :singleton-method: cdf(x , l)
    
    # TODO: Not implemented yet
    # :singleton-method: p_value(pr , l)

  end
end
