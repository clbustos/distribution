module Distribution
  module LogNormal
    module GSL_
      class << self
        def pdf(x, u, s)
          GSL::Ran.lognormal_pdf(x.to_f, u.to_f, s.to_f)
        end

        def cdf(x, u, s)
          GSL::Cdf.lognormal_P(x.to_f, u.to_f, s.to_f)
        end

        def quantile(pr, u, s)
          GSL::Cdf.lognormal_Pinv(pr.to_f, u.to_f, s.to_f)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
