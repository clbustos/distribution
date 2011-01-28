require 'prime'
require 'bigdecimal'
require 'bigdecimal/math'

# Useful additions to Math
module Distribution
  module MathExtension
    # Factorization based on Prime Swing algorithm, by Luschny (the king of factorial numbers analysis :P )
    # == Reference
    # * The Homepage of Factorial Algorithms. (C) Peter Luschny, 2000-2010
    # == URL: http://www.luschny.de/math/factorial/csharp/FactorialPrimeSwing.cs.html
    class SwingFactorial
      attr_reader :result
      SmallOddSwing=[ 1, 1, 1, 3, 3, 15, 5, 35, 35, 315, 63, 693, 231, 3003, 429, 6435, 6435, 109395, 12155, 230945, 46189, 969969, 88179, 2028117, 676039, 16900975, 1300075, 35102025, 5014575,145422675, 9694845, 300540195, 300540195]
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
          naive_factorial(n)
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
            while((q/=prime)>0) do
              if ((q&1)==1)
                _p*=prime
              end
            end
            
            if _p>1
              @prime_list[count]=_p
              count+=1
            end
            
          else
            if ((n/prime)&1==1)
              @prime_list[count]=prime
              count+=1
            end
          end
        end
        prod=get_primorial(n/2+1,n)
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
        (2..n).inject(1) { |f,n| f * n }
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
     # Use naive algorithm (iterative) on n<20
     # and Prime Swing algorithm for higher values
    def factorial(n)
      SwingFactorial.new(n).result
    end
    # Approximate factorial, up to 16 digits
    # Based of Luschy algorithm
    def fast_factorial(n)
      ApproxFactorial.stieltjes_factorial(n)
    end
       

    # Quick, accurate approximation of factorial for very small n. Special case, generally you want to use stirling instead.
    # ==Reference
    # * http://mathworld.wolfram.com/StirlingsApproximation.html
    def gosper(n)
      Math.sqrt( (2*n + 1/3.0) * Math::PI ) * (n/Math::E)**n
    end
    
    # Beta function.
    # Source:
    # * http://mathworld.wolfram.com/BetaFunction.html
    def beta(x,y)
      (gamma(x)*gamma(y)).quo(gamma(x+y))
    end
    # I_x(a,b): Regularized incomplete beta function
    #   
    # Source:
    #
    def regularized_beta_function(x,a,b)
      return 1 if x==1
      #incomplete_beta(x,a,b).quo(beta(a,b))
      m=a
      n=b+a-1
      (m..n).inject(0) {|sum,j|
        sum+(binomial_coefficient(n,j)* x**j * (1-x)**(n-j))
      }

      
    end
    # B_x(a,b) : Incomplete beta function
    # http://dlmf.nist.gov/8.17
    def incomplete_beta(x,a,b)
      return beta(a,b) if x==1
      
      ((x**a * (1-x)**b).quo(a)) * hyper_f(a+b,1,a+1,x)
    end
    def permutations(x,n)
      factorial(x).quo(factorial(x-n))
    end
    
    def rising_factorial(x,n)
      factorial(x+n-1).quo(factorial(x-1))
    end
    # http://dlmf.nist.gov/15.2#i
    def hyper_f(a,b,c,z)
      epsilon=1e-9
      ac=0
      v=epsilon+1
      s=0
      #raise "z>1" if z>1
      raise "c<=0" if c<=0
      while(v>epsilon or s<2 ) do
        #puts "a:#{a},b:#{b},c:#{c},z:#{z},s:#{s}"
        v=((permutations(a,s)*permutations(b,s)).quo(gamma(c+s)*factorial(s)))*(z**s)
        ac+=v
        #puts "v:#{v.to_f} -> ac:#{ac.to_f}"
        s+=1
      end
      ac
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
    # Binomial coeffients, or:
    # ( n )
    # ( k )
    # Gives the number of different k size subsets of a set size n
    # 
    # Replaces (n,k) for (n, n-k) if k>n-k
    #
    #  (n)   n^k'    (n)..(n-k+1)
    #  ( ) = ---- =  ------------
    #  (k)    k!          k!
    #
    def binomial_coefficient(n,k)
      return 1 if (k==0 or k==n)
      k=[k, n-k].min
      (((n-k+1)..n).inject(1) {|ac,v| ac * v}).quo(factorial(k))
      # Other way to calcule binomial is this: 
      # (1..k).inject(1) {|ac, i| (ac*(n-k+i).quo(i))}
    end
    # Approximate binomial coefficient, using gamma function.
    # The fastest method, until we fall on BigDecimal!
    def binomial_coefficient_gamma(n,k)
      return 1 if (k==0 or k==n)
      k=[k, n-k].min
      
      val=gamma(n+1) / (gamma(k+1)*gamma(n-k+1))
      if (val.nan?)
        lg=lgamma(n+1) - (lgamma(k+1)+lgamma(n-k+1))
        val=Math.exp(lg)
        # Crash again! We require BigDecimals
        if val.infinite?
          val=BigMath.exp(BigDecimal(lg.to_s),16)
        end
      end
      
      val
    end
  end
end

module Math
  include Distribution::MathExtension
  alias :lgamma :loggamma 

  module_function :factorial, :beta, :gamma, :gosper, :loggamma, :lgamma, :binomial_coefficient, :binomial_coefficient_gamma, :regularized_beta_function, :incomplete_beta, :hyper_f, :permutations, :rising_factorial
end

# Necessary on Ruby 1.9
module CMath # :nodoc:
  include Distribution::MathExtension
  module_function :factorial, :beta, :gosper, :loggamma,  :binomial_coefficient, :binomial_coefficient_gamma, :regularized_beta_function, :incomplete_beta, :hyper_f, :permutations, :rising_factorial
end

