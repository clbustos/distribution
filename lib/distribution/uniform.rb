require 'distribution/uniform/ruby'
require 'distribution/uniform/gsl'
#require 'distribution/uniform/java'


module Distribution
  # TODO: Document this Distribution
  module Uniform
    SHORTHAND='unif'
    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(x)
    # Returns the uniform PDF

    ##
    # :singleton-method: cdf(x)
    # Returns the uniform CDF
    
    ##
    # :singleton-method: quantile(qn)
    # Returns the uniform inverse CDF or P-value

  end
end
