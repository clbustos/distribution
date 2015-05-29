module Distribution
  module Poisson
    module Ruby_
      class << self
        def pdf(k, l)
          (l**k * Math.exp(-l)).quo(Math.factorial(k))
        end

        def cdf(k, l)
          Math.exp(-l) * (0..k).inject(0) { |ac, i| ac + (l**i).quo(Math.factorial(i)) }
        end

        def quantile(prob, l)
          ac = 0
          (0..100).each do |i|
            ac += pdf(i, l)
            return i if prob <= ac
          end
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
