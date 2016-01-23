module Distribution
  module Weibull
    module Ruby_
      class << self
        def pdf(x, k, lam)
          if x < 0.0
            0.0
          else
            a = (k.to_f / lam.to_f)
            b = (x.to_f / lam.to_f)
            c = (k - 1.0)
            d = Math.exp(-(x.to_f / lam.to_f)**k)
            (a * b**c) * d
          end
        end

        # Returns the integral of the Weibull distribution from [-Inf to x]
        def cdf(x, k, lam)
          return 0.0 if x < 0.0
          1.0 - Math.exp(-(x.to_f / lam.to_f)**k)
        end

        # Returns the P-value of weibull
        def quantile(y, k, lam)
          return 1.0 if y > 1.0
          return 0.0 if y < 0.0
          -lam * (Math.log(1.0 - y))**(1.0 / k)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
