module Distribution
  module ChiSquare
    module Ruby_
      class <<self
      
        # Gamma function
        LOG_2PI = Math.log(2 * Math::PI)# log(2PI)
        N = 8
        B0  = 1.0
        B1  = -1.0 / 2.0
        B2  = 1.0 / 6.0
        B4  = -1.0 / 30.0
        B6  =  1.0 / 42.0
        B8  = -1.0 / 30.0
        B10 =  5.0 / 66.0
        B12 = -691.0 / 2730.0
        B14 =  7.0 / 6.0
        B16 = -3617.0 / 510.0

        def loggamma(x)
          v = 1.0
          while (x < N)
            v *= x
            x += 1.0
          end
          w = 1.0 / (x * x)
          ret = B16 / (16 * 15)
          ret = ret * w + B14 / (14 * 13)
          ret = ret * w + B12 / (12 * 11)
          ret = ret * w + B10 / (10 *  9)
          ret = ret * w + B8  / ( 8 *  7)
          ret = ret * w + B6  / ( 6 *  5)
          ret = ret * w + B4  / ( 4 *  3)
          ret = ret * w + B2  / ( 2 *  1)
          ret = ret / x + 0.5 * LOG_2PI - Math.log(v) - x + (x - 0.5) * Math.log(x)
          ret
        end

        def gamma(x)
          if (x < 0.0)
            return Math::PI / (Math.sin(Math.PI * x) * Math.exp(loggamma(1 - x))) #/
          end
          Math.exp(loggamma(x))
        end      
      
        def pdf(x,n)
          if n == 1
            1.0/Math.sqrt(2 * Math::PI * x) * Math::E**(-x/2.0)
          elsif n == 2
            0.5 * Math::E**(-x/2.0)
          else
            n = n.to_f
            n2 = n/2
            x = x.to_f
            1.0 / 2**n2 / gamma(n2) * x**(n2 - 1.0) * Math.exp(-x/2.0)
          end        
        end
        
        
        # CDF Inverse over [x, \infty)
        # Pr([x, \infty)) = y -> x
        def pchi2(n, y)
          if n == 1
          
          w = Distribution::Normal.p_value(1 - y/2) # = p1.0-Distribution::Normal.cdf(y/2)
          w * w
          elsif n == 2
          #      v = (1.0 / y - 1.0) / 33.0
          #      newton_a(y, v) {|x| [q_chi2(n, x), -chi2dens(n, x)] }
          -2.0 * Math.log(y)
          else
          eps = 1.0e-5
          v = 0.0
          s = 10.0
          loop do
          v += s
          if s <= eps then break end
          if (qe = q_chi2(n, v) - y) == 0.0 then break end
          if qe < 0.0
            v -= s
            s /= 10.0 #/
          end
          end
          v
          end
        end
        def p_value(pr,k)
          pchi2(k, 1.0-pr)
        end
        def cdf(x,k)
          1.0-q_chi2(k,x)
        end
        
        # chi-square distribution ([1])
        # Integral over [x, \infty)
        def q_chi2(df, chi2)
        chi2 = chi2.to_f
        if (df & 1) != 0
        chi = Math.sqrt(chi2)
        if (df == 1) then return 2 * (1.0-Distribution::Normal.cdf(chi)); end
        s = t = chi * Math.exp(-0.5 * chi2) / SQ2PI
        k = 3
        while k < df
        t *= chi2 / k;  s += t;
        k += 2
        end
        2 * (1.0-(Distribution::Normal.cdf(chi)) + s)
        else
        s = t = Math.exp(-0.5 * chi2)
        k = 2
        while k < df
        t *= chi2 / k;  s += t;
        k += 2
        end
        s
        end
        end
        
        
      end
    end
  end
end
