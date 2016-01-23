module Distribution
  module Weibull
    module GSL_
      class << self
        def pdf(x, k, lam)
          GSL::Ran.weibull_pdf(x, lam, k)
        end

        def cdf(x, k, lam)
          GSL::Cdf.weibull_P(x, lam, k)
        end

        def quantile(y, k, lam)
          GSL::Cdf.weibull_Pinv(y, lam, k)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
