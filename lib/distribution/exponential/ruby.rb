module Distribution
  module Exponential
    module Ruby_
      class << self
        def rng(l, opts = {})
          rng = opts[:random] || Random
          lambda {p_value(rng.rand,l)}
        end
        def pdf(x,l)
          return 0 if x<0
          l*Math.exp(-l*x)
        end
        def cdf(x,l)
          return 0 if x<0
          1-Math.exp(-l*x)
        end
        def p_value(pr,l)
          (-Math.log(1-pr)).quo(l)
        end
      end
    end
  end
end
