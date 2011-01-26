require 'distribution/f/ruby'
require 'distribution/f/gsl'
require 'distribution/f/statistics2'
module Distribution
  # Calculate cdf and inverse cdf for Chi Square Distribution.
  # 
  module F
    SHORTHAND='f'  
    extend Distributable
    create_distribution_methods
    
    ##
    # :singleton-method: cdf(x,k)
    # Returns the integral of Chi-squared distribution 
    # with +k+ degrees of freedom over [0, +x+]    

    ##
    # :singleton-method: p_value(qn, k)
    # Return the P-value of the corresponding integral +qn+ with 
    # +k+ degrees of freedom    
  end
end
