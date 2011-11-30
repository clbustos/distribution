module Distribution
  module Lognormal
    module GSL_
      class << self
        def pdf(x,z,s)
          GSL::Ran::lognormal_pdf(x.to_f, z.to_f, s.to_f)
        end

        def p_value(pr,a,b)
          GSL::Cdf::lognormal_Pinv(pr.to_f, z.to_f, s.to_f)
        end

        def cdf(x,z,s)
          GSL::Cdf::lognormal_P(x.to_f, z.to_f, s.to_f)
        end
      end
    end
  end
end
