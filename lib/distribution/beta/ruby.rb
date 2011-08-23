# Added by John O. Woods, SciRuby project.
module Distribution
  module Beta
    module Ruby_
      class << self

        include Math
        # Beta distribution probability density function
        #
        # Adapted from GSL-1.9 (apparently by Knuth originally), found in randist/beta.c
        #
        # Form: p(x) dx = (Gamma(a + b)/(Gamma(a) Gamma(b))) x^(a-1) (1-x)^(b-1) dx
        #
        # == References
        # * http://www.gnu.org/s/gsl/manual/html_node/The-Gamma-Distribution.html
        def pdf(x,a,b)
          return 0 if x < 0 || x > 1

          gab = Math.lgamma(a+b).first
          ga  = Math.lgamma(a).first
          gb  = Math.lgamma(b).first

          if x == 0.0 || x == 1.0
            Math.exp(gab - ga - gb) * x**(a-1) * (1-x)**(b-1)
          else
            Math.exp(gab - ga - gb + Math.log(x)*(a-1) + Math::Log.log1p(-x)*(b-1))
          end
        end

        # Gamma cumulative distribution function
        # Translated from GSL-1.9: cdf/beta.c gsl_cdf_beta_P
        def cdf(x,a,b)
          return 0.0 if x <= 0.0
          return 1.0 if x >= 1.0
          Math::IncompleteBeta.axpy(1.0, 0.0, a,b,x)
        end


      end
    end
  end
end
