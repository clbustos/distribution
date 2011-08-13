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
        # Adapted the function itself from GSL-1.9 in rng/gamma.c: gsl_ran_gamma_pdf
        #
        # ==References
        # * http://www.gnu.org/software/gsl/manual/html_node/The-Gamma-Distribution.html
        # * http://en.wikipedia.org/wiki/Gamma_distribution
        def pdf(x,a,b)
          return 0 if x < 0
          if x == 0
            return 1.quo(b) if a == 1
            return 0
          elsif a == 1
            Math.exp(-x/b.to_f) / b
          else
            Math.exp((a-1)*Math.log(x/b.to_f) - x/b.to_f - Math.lgamma(a).first)/b
          end
        end

        # Gamma cumulative distribution function
        def cdf(x,a,b)
          return 0.0 if x <= 0.0

          y = x.quo(b)
          return (1-Math::IncompleteGamma.q(a, y)) if y > a
          return (Math::IncompleteGamma.p(a, y))
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
