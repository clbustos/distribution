require 'rbconfig'
module Distribution
  module T
    module Statistics2_
      class << self
      # Return the P-value of the corresponding integral with 
      # k degrees of freedom
      def p_value(pr,k)
        Statistics2.ptdist(k, pr)
      end
      
       
      # There are some problem on i686 with t on statistics2
      if true or !RbConfig::CONFIG['arch']=~/i686/
        # T cumulative distribution function (cdf).
        # 
        # Returns the integral of t-distribution 
        # with n degrees of freedom over (-Infty, x].
        #
        def cdf(x,k)
          Statistics2.tdist(k,x)
        end
      end
      
      end
    end
  end
end