module Distribution
  module Normal
    module Statistics2_
      class << self
        def cdf(x)
          Statistics2.normaldist(x)
        end
        def p_value(pr)
         Statistics2.pnormaldist(pr)
        end
      end
    end
  end
end
