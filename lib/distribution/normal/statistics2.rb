module Distribution
  module Normal
    module Statistics2_
      class << self
        def cdf(x)
          Statistics2.normaldist(x)
        end

        def quantile(pr)
          Statistics2.pnormaldist(pr)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
