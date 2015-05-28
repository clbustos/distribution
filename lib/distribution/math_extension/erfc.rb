# Added by John O. Woods, SciRuby project.
# Derived from GSL-1.9 source files in the specfunc/ dir.

module Distribution
  module MathExtension
    # Error function from GSL-1.9, with epsilon information. Access it using Math.erfc_e
    module Erfc
      P = [2.97886562639399288862,
           7.409740605964741794425,
           6.1602098531096305440906,
           5.019049726784267463450058,
           1.275366644729965952479585264,
           0.5641895835477550741253201704]
      Q = [3.3690752069827527677,
           9.608965327192787870698,
           17.08144074746600431571095,
           12.0489519278551290360340491,
           9.396034016235054150430579648,
           2.260528520767326969591866945,
           1.0]

      class << self
        # Estimates erfc(x) valid for 8 < x < 100
        # erfc8_sum from GSL-1.9
        def erfc8_sum(x)
          num = P[5]
          4.downto(0) { |i| num = x * num + P[i] }
          den = Q[6]
          5.downto(0) { |i| den = x * den + Q[i] }
          num / den
        end

        def erfc8(x)
          erfc8_sum(x) * Math.exp(-x * x)
        end

        # gsl_sf_erfc_e
        def evaluate(x, with_error = false)
          ax = x.abs
          e = nil

          if ax <= 1.0
            t = 2 * ax - 1
            e = ChebyshevSeries.evaluate(:erfc_xlt1, t, with_error)
          elsif ax <= 5.0
            ex2 = Math.exp(-x * x)
            t   = (ax - 3).quo(2)
            e   = ChebyshevSeries.evaluate(:erfc_x15, t, with_error)
            if with_error
              e[0] *= ex2
              e[1] = ex2 * (e[1] + 2 * x.abs * Float::EPSILON)
            else
              e *= ex2
            end
          elsif ax < 10.0
            exterm = Math.exp(-x * x) / ax
            t      = (2 * ax - 15).quo(5)
            e = ChebyshevSeries.evaluate(:erfc_x510, t, with_error)
            if with_error
              e[0] *= exterm
              e[1] = exterm * (e[1] + 2 * x.abs * Float::EPSILON + Float::EPSILON)
            else
              e *= exterm
            end
          else
            e8 = erfc8(ax)
            e = with_error ? [e8, (x * x + 1) * Float::EPSILON * e8.abs] : e8
          end

          result = x < 0 ? 2 - (with_error ? e.first : e) : (with_error ? e.first : e)
          with_error ? [result, e.last + 2 * Float::EPSILON * result.abs] : result
        end
      end
    end
  end
end
