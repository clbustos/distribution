module Distribution
  module Hypergeometric
    module GSL_
      class << self
        def pdf(k, m, n, total)  # :nodoc:
          GSL::Ran.hypergeometric_pdf(k, m, total - m, n)
        end
        # The GSL::Cdf function for hypergeometric
        #
        def cdf(k, m, n, total) # :nodoc:
          GSL::Cdf.hypergeometric_P(k, m, total - m, n)
        end
      end
    end
  end
end
