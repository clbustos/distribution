module Distribution
  module Logistic
    module Ruby_
      class << self
        def rng(u, s)
          -> { p_value(rand, u, s) }
        end

        def pdf(x, u, s)
          (Math.exp(-(x - u) / s)) / (s * (1 + Math.exp(-(x - u) / s)**2))
        end

        def cdf(x, u, s)
          1 / (1 + Math.exp(-(x - u) / s))
        end

        def quantile(pr, u, s)
          u + s * Math.log(pr / (1 - pr))
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
