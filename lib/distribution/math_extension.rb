# The next few requires eventually probably need to go in their own gem. They're all functions and constants used by
# GSL-adapted pure Ruby math functions.
require "distribution/math_extension/chebyshev_series"
require "distribution/math_extension/erfc"
require "distribution/math_extension/exponential_integral"
require "distribution/math_extension/gammastar"
require "distribution/math_extension/gsl_utilities"
require "distribution/math_extension/incomplete_gamma"
require "distribution/math_extension/incomplete_beta"
require "distribution/math_extension/log_utilities"


if RUBY_VERSION<"1.9"
  require 'mathn'
  def Prime.each(upper,&block) 
    @primes=Prime.new
    @primes.each do |prime|
      break if prime > upper.to_i
      block.call(prime)
    end
  end
else
  require 'prime'
end

require 'bigdecimal'
require 'bigdecimal/math'

module Distribution
  # Extension for Ruby18
  # Includes gamma and lgamma
  module MathExtension18
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
        return Math::PI / (Math.sin(Math::PI * x) * Math.exp(loggamma(1 - x))) #/
      end
      Math.exp(loggamma(x))
    end
    def lgamma(x)
      [loggamma(x.abs), Math.gamma(x) < 0 ? -1 : 1]
    end
  end
  # Useful additions to Math
  module MathExtension
    # Factorization based on Prime Swing algorithm, by Luschny (the king of factorial numbers analysis :P )
    # == Reference
    # * The Homepage of Factorial Algorithms. (C) Peter Luschny, 2000-2010
    # == URL: http://www.luschny.de/math/factorial/csharp/FactorialPrimeSwing.cs.html
    class SwingFactorial
      attr_reader :result
      SmallOddSwing=[ 1, 1, 1, 3, 3, 15, 5, 35, 35, 315, 63, 693, 231, 3003, 429, 6435, 6435, 109395, 12155, 230945, 46189, 969969, 88179, 2028117, 676039, 16900975, 1300075, 35102025, 5014575,145422675, 9694845, 300540195, 300540195]
      SmallFactorial=[1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800, 39916800, 479001600, 6227020800, 87178291200, 1307674368000, 20922789888000, 355687428096000, 6402373705728000, 121645100408832000, 2432902008176640000]
      def bitcount(n)
        bc = n - ((n >> 1) & 0x55555555);
        bc = (bc & 0x33333333) + ((bc >> 2) & 0x33333333);
        bc = (bc + (bc >> 4)) & 0x0f0f0f0f;
        bc += bc >> 8;
        bc += bc >> 16;
        bc = bc & 0x3f;
        bc
      end
      def initialize(n)
        if (n<20)
          @result=SmallFactorial[n]
          #naive_factorial(n)
        else
        @prime_list=[]
        exp2 = n - bitcount(n);
        @result= recfactorial(n)<< exp2
        end
      end
      def recfactorial(n)
        return 1 if n<2
        (recfactorial(n/2)**2) * swing(n)
      end
      def swing(n)
        return SmallOddSwing[n] if (n<33)
        sqrtN = Math.sqrt(n).floor
        count=0
        
        Prime.each(n/3) do |prime|
          next if prime<3
          if (prime<=sqrtN)
            q=n
            _p=1
            
            while((q=(q/prime).truncate)>0) do
              if((q%2)==1)
                _p*=prime
              end
            end
            if _p>1
              @prime_list[count]=_p
              count+=1
            end
            
          else
            if ((n/prime).truncate%2==1)
              @prime_list[count]=prime
              count+=1
            end
          end
        end
        prod=get_primorial((n/2).truncate+1,n)
        prod * @prime_list[0,count].inject(1) {|ac,v| ac*v}
      end
      def get_primorial(low,up)
        prod=1;
        Prime.each(up) do |prime|
          next if prime<low
          prod*=prime
        end
        prod
      end
      def naive_factorial(n)
        @result=(self.class).naive_factorial(n)
      end
      def self.naive_factorial(n)
        (2..n).inject(1) { |f,nn| f * nn }
      end
    end
    # Module to calculate approximated factorial
    # Based (again) on Luschny formula, with 16 digits of precision
    # == Reference
    # * http://www.luschny.de/math/factorial/approx/SimpleCases.html
    module ApproxFactorial
      def self.stieltjes_ln_factorial(z)
       
        a0 = 1.quo(12); a1 = 1.quo(30); a2 = 53.quo(210); a3 = 195.quo(371);
        a4 = 22999.quo(22737); a5 = 29944523.quo(19733142);
        a6 = 109535241009.quo(48264275462);
        zz = z+1; 
        
        (1.quo(2))*Math.log(2*Math::PI)+(zz-1.quo(2))*Math.log(zz) - zz +
        a0.quo(zz+a1.quo(zz+a2.quo(zz+a3.quo(zz+a4.quo(zz+a5.quo(zz+a6.quo(zz))))))) 
      end
      
      def self.stieltjes_ln_factorial_big(z)
       
        a0 = 1/12.0; a1 = 1/30.0; a2 = 53/210.0; a3 = 195/371.0;
        a4 = 22999/22737.0; a5 = 29944523/19733142.0;
        a6 = 109535241009/48264275462.0;
        zz = z+1; 
        
        BigDecimal("0.5") * BigMath.log(BigDecimal("2")*BigMath::PI(20),20) + BigDecimal((zz - 0.5).to_s) * BigMath.log(BigDecimal(zz.to_s),20) - BigDecimal(zz.to_s) + BigDecimal( (
        a0 / (zz+a1/(zz+a2/(zz+a3/(zz+a4/(zz+a5/(zz+a6/zz))))))
        ).to_s)
        
      end
      # Valid upto 11 digits
      def self.stieltjes_factorial(x)
        y = x; _p = 1;
          while y < 8 do 
            _p = _p*y; y = y+1
          end
        lr= stieltjes_ln_factorial(y)
        r = Math.exp(lr)
        #puts "valid: #{5/2.0+(13/2.0)*Math::log(x)}" 
        if r.infinite?
          r=BigMath.exp(BigDecimal(lr.to_s),20)
          r = (r*x) / (_p*y) if x < 8
          r=r.to_i
        else
          r = (r*x) / (_p*y) if x < 8
        end
        r
       end
     end
     # Exact factorial. 
     # Use lookup on a Hash table on n<20
     # and Prime Swing algorithm for higher values.
    def factorial(n)
      SwingFactorial.new(n).result
    end
    # Approximate factorial, up to 16 digits
    # Based of Luschy algorithm
    def fast_factorial(n)
      ApproxFactorial.stieltjes_factorial(n)
    end
    
    # Beta function.
    # Source:
    # * http://mathworld.wolfram.com/BetaFunction.html
    def beta(x,y)
      (gamma(x)*gamma(y)).quo(gamma(x+y))
    end

    # Get pure-Ruby logbeta
    def logbeta(x,y)
      Beta.log_beta(x,y).first
    end

    # Log beta function conforming to style of lgamma (returns sign in second array index)
    def lbeta(x,y)
      Beta.log_beta(x,y)
    end

    # I_x(a,b): Regularized incomplete beta function
    # Fast version. For a exact calculation, based on factorial
    # use exact_regularized_beta_function
    def regularized_beta(x,a,b)
      return 1 if x==1
      IncompleteBeta.evaluate(a,b,x)
    end
    # I_x(a,b): Regularized incomplete beta function
    # TODO: Find a faster version.
    # Source:
    # * http://dlmf.nist.gov/8.17
    def exact_regularized_beta(x,a,b)
      return 1 if x==1
      m=a.to_i
      n=(b+a-1).to_i
      (m..n).inject(0) {|sum,j|
        sum+(binomial_coefficient(n,j)* x**j * (1-x)**(n-j))
      }

     end
    # 
    # Incomplete beta function: B(x;a,b)
    # +a+ and +b+ are parameters and +x+ is 
    # integration upper limit.
    def incomplete_beta(x,a,b)
      IncompleteBeta.evaluate(a,b,x)*beta(a,b)
      #Math::IncompleteBeta.axpy(1.0, 0.0, a,b,x)
    end
    
    # Rising factorial
    def rising_factorial(x,n)
      factorial(x+n-1).quo(factorial(x-1))
    end
   
    # Ln of gamma
    def loggamma(x)
      Math.lgamma(x).first
    end

    def incomplete_gamma(a, x = 0, with_error = false)
      IncompleteGamma.p(a,x, with_error)
    end
    alias :gammp :incomplete_gamma

    def gammq(a, x, with_error = false)
      IncompleteGamma.q(a,x,with_error)
    end

    def unnormalized_incomplete_gamma(a, x, with_error = false)
      IncompleteGamma.unnormalized(a, x, with_error)
    end

    # Not the same as erfc. This is the GSL version, which may have slightly different results.
    def erfc_e(x, with_error = false)
      Erfc.evaluate(x, with_error)
    end
    
    # Sequences without repetition. n^k'
    # Also called 'failing factorial'
    def permutations(n,k)
      return 1 if k==0
      return n if k==1
      return factorial(n) if k==n
      (((n-k+1)..n).inject(1) {|ac,v| ac * v})
      #factorial(x).quo(factorial(x-n))
    end
    
    # Binomial coeffients, or:
    # ( n )
    # ( k )
    #
    # Gives the number of *different* k size subsets of a set size n
    # 
    # Uses:
    #
    #  (n)   n^k'    (n)..(n-k+1)
    #  ( ) = ---- =  ------------
    #  (k)    k!          k!
    #
    def binomial_coefficient(n,k)
      return 1 if (k==0 or k==n)
      k=[k, n-k].min
      permutations(n,k).quo(factorial(k))
      # The factorial way is
      # factorial(n).quo(factorial(k)*(factorial(n-k)))
      # The multiplicative way is
      # (1..k).inject(1) {|ac, i| (ac*(n-k+i).quo(i))}
    end
    # Binomial coefficient using multiplicative algorithm
    # On benchmarks, is faster that raising factorial method
    # when k is little. Use only when you're sure of that.
    def binomial_coefficient_multiplicative(n,k)
      return 1 if (k==0 or k==n)
      k=[k, n-k].min
      (1..k).inject(1) {|ac, i| (ac*(n-k+i).quo(i))}
    end
    
    # Approximate binomial coefficient, using gamma function.
    # The fastest method, until we fall on BigDecimal!
    def binomial_coefficient_gamma(n,k)
      return 1 if (k==0 or k==n)
      k=[k, n-k].min      
      # First, we try direct gamma calculation for max precission

      val=gamma(n + 1).quo(gamma(k+1)*gamma(n-k+1))
      # Ups. Outside float point range. We try with logs
      if (val.nan?)
        #puts "nan"
        lg=loggamma( n + 1 ) - (loggamma(k+1)+ loggamma(n-k+1))
        val=Math.exp(lg)
        # Crash again! We require BigDecimals
        if val.infinite?
          #puts "infinite"
          val=BigMath.exp(BigDecimal(lg.to_s),16)
        end
      end
      val
    end
    alias :combinations :binomial_coefficient
  end
end

module Math
  include Distribution::MathExtension
  module_function :factorial, :beta, :loggamma, :erfc_e, :unnormalized_incomplete_gamma, :incomplete_gamma, :gammp, :gammq, :binomial_coefficient, :binomial_coefficient_gamma, :exact_regularized_beta, :incomplete_beta, :regularized_beta, :permutations, :rising_factorial , :fast_factorial, :combinations, :logbeta, :lbeta
end

# Necessary on Ruby 1.9
module CMath # :nodoc:
  include Distribution::MathExtension
  module_function :factorial, :beta, :loggamma, :unnormalized_incomplete_gamma, :incomplete_gamma, :gammp, :gammq, :erfc_e, :binomial_coefficient, :binomial_coefficient_gamma,  :incomplete_beta, :exact_regularized_beta, :regularized_beta, :permutations, :rising_factorial, :fast_factorial, :combinations, :logbeta, :lbeta
end

if RUBY_VERSION<"1.9"
  module Math
    remove_method :loggamma
    include Distribution::MathExtension18
    module_function :gamma, :loggamma, :lgamma
  end
end


