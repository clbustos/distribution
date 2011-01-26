require 'distribution/normal/ruby'
require 'distribution/normal/gsl'
require 'distribution/normal/statistics2'

module Distribution
  # From Wikipedia: 
  #   Continuous probability distribution that is often used as 
  #   a first approximation to describe real-valued random variables 
  #   that tend to cluster around a single mean value. 
  #   The graph of the associated probability density function is  “bell”-shaped
  module Normal
    SHORTHAND='norm'
    extend Distributable
    
    create_distribution_methods
    
    ##
    # :singleton-method: pdf(x)
    
    ##
    # :singleton-method: cdf(x)

    ##
    # :singleton-method: p_value(qn)
    
    ##
    # :singleton-method: rng

    
  end
end
