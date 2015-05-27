module Distribution
  module Binomial
    module GSL_
      class << self
        def pdf(k, n, prob)
          GSL::Ran.binomial_pdf(k, prob, n)
        end

        def cdf(k, n, prob)
          GSL::Cdf.binomial_P(k, prob, n)
        end
      end
    end
  end
end
