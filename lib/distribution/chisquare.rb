require 'distribution/chisquare/ruby'
require 'distribution/chisquare/gsl'
require 'distribution/chisquare/statistics2'
module Distribution
  # Calculate cdf and inverse cdf for Chi Square Distribution.
  # 
  module ChiSquare
    extend Distributable
    create_distribution_methods
    
    ##
    # :singleton-method: pdf(x)
    
    ##
    # :singleton-method: cdf(x,k)
    # Returns the integral of Chi-squared distribution 
    # with +k+ degrees of freedom over [0, +x+]    

    ##
    # :singleton-method: p_value(qn, k)
    # Return the P-value of the corresponding integral +qn+ with 
    # +k+ degrees of freedom
    
    ##
    # :singleton-method: rng
  end
end
