module Distribution
  module Exponential
    module GSL_
      class << self
        def pdf(x, l)
          return 0 if x < 0
          GSL::Ran.exponential_pdf(x, 1 / l.to_f)
        end

        def cdf(x, l)
          return 0 if x < 0
          GSL::Cdf.exponential_P(x, 1 / l.to_f)
        end

        def quantile(pr, l)
          GSL::Cdf.exponential_Pinv(pr, 1 / l.to_f)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
