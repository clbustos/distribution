module Distribution  
  module Normal
    module Ruby_
      class << self
        
        # random number within a gaussian distribution X ~ N(0,1)
        def rngu
          rng(0,1,nil)
        end
        # Return a proc which return a random number within a 
        # gaussian distribution X ~ N(+mean+,+sigma+^2)
        # +seed+ feed the  
        # == Reference:
        # * http://www.taygeta.com/random/gaussian.html
        def rng(mean=0,sigma=1,seed=nil)
          returned,y1,y2=0,0,0
          lambda {
            if returned==0
              begin
                x1 = 2.0 * rand - 1.0
                x2 = 2.0 * rand - 1.0
                w = x1 * x1 + x2 * x2
              end while ( w >= 1.0 )
              w = Math::sqrt( (-2.0 * Math::log( w ) ) / w )
              y1 = x1 * w
              y2 = x2 * w
              returned=1
              y1*sigma + mean
            else
              returned=0
              y2 * sigma + mean
            end
          }
        
        end
        # Return the inverse CDF or P-value of the corresponding integral
        def p_value(qn)
          b = [1.570796288, 0.03706987906, -0.8364353589e-3,
          -0.2250947176e-3, 0.6841218299e-5, 0.5824238515e-5,
          -0.104527497e-5, 0.8360937017e-7, -0.3231081277e-8,
          0.3657763036e-10, 0.6936233982e-12]

          if(qn < 0.0 || 1.0 < qn)
          $stderr.printf("Error : qn <= 0 or qn >= 1  in pnorm()!\n")
          return 0.0;
          end
          qn == 0.5 and return 0.0

          w1 = qn
          qn > 0.5 and w1 = 1.0 - w1
          w3 = -Math.log(4.0 * w1 * (1.0 - w1))
          w1 = b[0]
          1.upto 10 do |i|
          w1 += b[i] * w3**i;
          end
          qn > 0.5 and return Math.sqrt(w1 * w3)
          -Math.sqrt(w1 * w3)

        end
        # Normal cumulative distribution function (cdf).
        # 
        # Returns the integral of  normal distribution 
        # over (-Infty, z].
        # 
        def cdf(z)
          0.0 if z < -12 
          1.0 if z > 12
          0.5 if z == 0.0 

          if z > 0.0
            e = true
          else
            e = false
            z = -z
          end
          z = z.to_f
          z2 = z * z
          t = q = z * Math.exp(-0.5 * z2) / SQ2PI

          3.step(199, 2) do |i|
            prev = q
            t *= z2 / i
            q += t
            if q <= prev
              return(e ? 0.5 + q : 0.5 - q)
            end
          end
          e ? 1.0 : 0.0
        end
        
        # Normal probability density function (pdf)
        # With x=0 and sigma=1
        def pdf(x)
          (1.0 / SQ2PI)*Math::exp(-(x**2/2.0))
        end
      end
    end
  end
end
