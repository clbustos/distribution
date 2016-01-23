require 'distribution/uniform/ruby'
require 'distribution/uniform/gsl'
#require 'distribution/uniform/java'


module Distribution
  # Expresses the uniformly spread probability over a finite interval
  module Uniform
    SHORTHAND='unif'
    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(x, lower, upper)
    # Returns the uniform PDF

    ##
    # :singleton-method: cdf(x, lower, upper)
    # Returns the uniform CDF
    
    ##
    # :singleton-method: quantile(qn, lower, upper)
    # Returns the uniform inverse CDF or P-value

  end
end
