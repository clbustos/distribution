# Added by John O. Woods, SciRuby project.

# Extensions to Fixnum for Hypergeometric calculations in pure Ruby.
# ==Reference
# * http://bluebones.net/2007/09/combinatorics-in-ruby/
# * http://mathworld.wolfram.com/StirlingsApproximation.html
class Fixnum
  # +k+-combination of a set of size +self+
  def choose(k)
    Math.factorial(self) / (Math.factorial(k) * Math.factorial(self - k))
  end

  # Fast combination calculation using Gosper's approximation of factorials.
  def fast_choose(k)
    Math.fast_factorial(self).quo(Math.fast_factorial(self - k) * Math.fast_factorial(k))
  end
end

module Distribution
  module Hypergeometric
    module Ruby_
      class << self
        # Calculates PDF quickly. Not guaranteed to produce any accuracy, since it uses Stirling's approximation.
        # This can be improved, most likely, by writing specific cases of when to use fast_choose and when to use
        # choose.
        def pdf_aprox(k, m, n, total)
          m.fast_choose(k) * (total-m).fast_choose(n-k).quo( total.fast_choose(n))
        end

        # Hypergeometric probability density function
        #
        # Probability p(+k+, +m+, +n+, +total+) of drawing sets of size +m+ and +n+ with an intersection of size +k+
        # from a total pool of size +total+, without replacement.
        #
        # ==References
        # * http://www.gnu.org/software/gsl/manual/html_node/The-Hypergeometric-Distribution.html
        # * http://en.wikipedia.org/wiki/Hypergeometric_distribution
        def pdf(k, m, n, total)
          min_m_n=m<n ? m : n
          max_t=[0,m+n-total].max
          return 0 if k>min_m_n or k<max_t
          m.choose(k) * (total-m).choose(n-k) / total.choose(n).to_f
        end

        # p-value: 
       
        def p_value(pr, m, n, total)
          ac=0
          (0..total).each do |i|
            ac+=pdf(i,m,n,total)
            return i if ac>=pr
          end
        end

        # Cumulative distribution function.
        # The probability of obtain, from a sample of
        # size +n+, +k+ or less elements
        # in a population size +total+ with +m+ interesting elements.
        # 
        # Slow, but secure
        def cdf(k, m, n, total)
          raise "k>m" if k>m
          raise "k>n" if k>n
          (0..k).collect { |ki| pdf(ki,m,n,total) }.inject { |sum,v| sum+v}
        end
      end
    end
  end
end