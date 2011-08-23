module Distribution
  module Beta
    module GSL_
      class << self
        def pdf(x,a,b)
          GSL::Ran::beta_pdf(x.to_f, a.to_f, b.to_f)
        end
        # Return the P-value of the corresponding integral with
        # k degrees of freedom
        def p_value(pr,a,b)
          GSL::Cdf::beta_Pinv(pr.to_f, a.to_f, b.to_f)
        end
        # Beta cumulative distribution function (cdf).
        #
        # Returns the integral of Beta distribution
        # with parameters +a+ and +b+ over [0, x]
        #
        def cdf(x,a,b)
          GSL::Cdf::beta_P(x.to_f, a.to_f, b.to_f)
        end
      end
    end
  end
end
