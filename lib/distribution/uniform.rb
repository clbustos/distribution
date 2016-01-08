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
    # :singleton-method: pdf(x )

    ##
    # :singleton-method: cdf(x )
    
    ##
    # :singleton-method: p_value(pr )

  end
end
