# Useful additions to Math
module Distribution
  module MathExtension
    # Factorial for n
    def factorial(n)
      sum=1
      2.upto(n) do |i|
        sum*=n
      end
      sum
    end
    
    # Beta function.
    # Source:
    # * http://mathworld.wolfram.com/BetaFunction.html
    def beta(x,y)
      (gamma(x)*gamma(y)).quo(gamma(x+y))
    end
    
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
    # From statistics2
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
    # Gamma function.
    # From statistics2    
    def gamma(x)
      if (x < 0.0)
        return Math::PI / (Math.sin(Math.PI * x) * Math.exp(loggamma(1 - x))) #/
      end
      Math.exp(loggamma(x))
    end
  end
end

module Math
  include Distribution::MathExtension
  module_function :factorial, :beta, :gamma
end

# Necessary on Ruby 1.9
module CMath # :nodoc:
  include Distribution::MathExtension
  module_function :factorial, :beta, :gamma  
end

