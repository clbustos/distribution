# Added by John O. Woods, SciRuby project.
module Distribution
  module Gamma
    module Ruby_
      class << self

        include Math
        # Gamma distribution probability density function
        #
        # If you're looking at Wikipedia's Gamma distribution page, the arguments for this pdf function correspond
        # as follows:
        #
        # * +x+: same
        # * +a+: alpha or k
        # + +b+: theta or 1/beta
        #
        # This is confusing! But we're trying to most closely mirror the GSL function for the gamma distribution
        # (see references).
        #
        # ==References
        # * http://www.gnu.org/software/gsl/manual/html_node/The-Gamma-Distribution.html
        # * http://en.wikipedia.org/wiki/Gamma_distribution
        def pdf(x,a,b)
          if a == 1
            Math.exp(-x / b) / b
          else
            a = a.to_f
            b = b.to_f

            # Form of the Chisquare distribution PDF in this library is:
            ## 1.0 / 2**n2 / gamma(n2) * x**(n2 - 1.0) * Math.exp(-x/2.0)
            # Rather than troubleshooting rounding errors myself, I decided simply to order the operations
            # in the same way as for Chisquare.
            1.0 / b**a / gamma(a) * x**(a-1) * Math.exp(-x/b)
          end
        end

        # Gamma cumulative distribution function
        def cdf(x,a,b)
          # According to Numerical Recipes, we want Incomplete Gamma Function of a, x/b.
          # Not sure if this is actually implemented properly in Ruby 1.9 or Ruby 1.8, so I wrote
          # it into MathExtension.
          Math::IncompleteGamma.p(a,x/b)
        end

        # CDF Inverse over [x, \infty)
        # Pr([x, \infty)) = y -> x
        def inverse_cdf(p,a,b)
          Math.invgammp(p,a) * b
        end

        def p_value(pr,a,b)
          cdf(1.0-pr,a,b)
        end

      end
    end
  end
end
