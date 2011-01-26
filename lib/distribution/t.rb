require 'distribution/t/ruby'
require 'distribution/t/gsl'
require 'distribution/t/statistics2'
module Distribution

    # Calculate cdf and inverse cdf for T Distribution.
    # Uses Statistics2 Module.
    module T
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
