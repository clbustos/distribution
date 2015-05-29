require 'rbconfig'
module Distribution
  module T
    module Statistics2_
      class << self
        # There are some problem on i686 with t on statistics2
        if true || !RbConfig::CONFIG['arch'] =~ /i686/
          # T cumulative distribution function (cdf).
          #
          # Returns the integral of t-distribution
          # with n degrees of freedom over (-Infty, x].
          #
          def cdf(x, k)
            Statistics2.tdist(k, x)
          end

          # Return the P-value of the corresponding integral with
          # k degrees of freedom
          def quantile(pr, k)
            Statistics2.ptdist(k, pr)
          end

          alias_method :p_value, :quantile
        end
      end
    end
  end
end
