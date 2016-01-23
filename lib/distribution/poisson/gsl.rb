module Distribution
  module Poisson
    module GSL_
      class << self
        def pdf(k, l)
          return 0 if k < 0
          GSL::Ran.poisson_pdf(k, l.to_f)
        end

        def cdf(k, l)
          return 0 if k < 0
          GSL::Cdf.poisson_P(k, l.to_f)
        end
      end
    end
  end
end
