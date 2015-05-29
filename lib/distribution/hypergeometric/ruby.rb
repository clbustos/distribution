# Added by John O. Woods, SciRuby project.
# Optimized by Claudio Bustos

module Distribution
  module Hypergeometric
    module Ruby_
      class << self
        def bc(n, k)
          Math.binomial_coefficient(n, k)
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
          min_m_n = m < n ? m : n
          max_t = [0, m + n - total].max
          return 0 if k > min_m_n || k < max_t
          (bc(m, k) * bc(total - m, n - k)).quo(bc(total, n))
        end

        alias_method :exact_pdf, :pdf

        def pdf_with_den(k, m, n, total, den)
          (bc(m, k) * bc(total - m, n - k)).quo(den)
        end

        # Cumulative distribution function.
        # The probability of obtain, from a sample of
        # size +n+, +k+ or less elements
        # in a population size +total+ with +m+ interesting elements.
        #
        # Slow, but secure
        def cdf(k, m, n, total)
          fail(ArgumentError, 'k>m') if k > m
          fail(ArgumentError, 'k>n') if k > n
          # Store the den
          den = bc(total, n)
          (0..k).collect { |ki| pdf_with_den(ki, m, n, total, den) }.inject { |sum, v| sum + v }
        end

        alias_method :exact_cdf, :cdf

        # p-value:
        def quantile(pr, m, n, total)
          ac = 0
          den = bc(total, n)

          (0..total).each do |i|
            ac += pdf_with_den(i, m, n, total, den)
            return i if ac >= pr
          end
        end

        alias_method :p_value, :quantile
        alias_method :exact_p_value, :p_value
      end
    end
  end
end
