module Distribution
  module LogNormal
    module Ruby_
      class << self
        
        def pdf(x,u,s)
          raise "x should be > 0 " if x < 0
          (1.0/(x*s*Math.sqrt(2*Math::PI)))*Math.exp(-((Math.log(x)-u)**2 / (2*s**2)))
        end

        #def p_value(pr,u,s)
        #end

        def cdf(x,u,s)
          Distribution::Normal.cdf((Math.log(x)-u) / s)
        end
      end
    end
  end
end
