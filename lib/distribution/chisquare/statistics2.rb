module Distribution
  module ChiSquare
    module Statistics2_
      class << self
        # Chi-square cumulative distribution function (cdf).
        #
        # Returns the integral of Chi-squared distribution
        # with k degrees of freedom over [0, x]
        #
        def cdf(x, k)
          Statistics2.chi2dist(k.to_i, x)
        end

        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        def quantile(pr, k)
          Statistics2.pchi2X_(k.to_i, pr)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
