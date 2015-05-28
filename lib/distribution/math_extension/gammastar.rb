# Added by John O. Woods, SciRuby project.
# Derived from GSL-1.9 source files in the specfunc/ dir.

module Distribution
  module MathExtension
    # Derived from GSL-1.9.
    module Gammastar
      C0 =  1.quo(12)
      C1 = -1.quo(360)
      C2 =  1.quo(1260)
      C3 = -1.quo(1680)
      C4 =  1.quo(1188)
      C5 = -691.quo(360_360)
      C6 =  1.quo(156)
      C7 = -3617.quo(122_400)

      class << self
        def series(x, with_error = false)
          # Use the Stirling series for the correction to Log(Gamma(x)),
          # which is better behaved and easier to compute than the
          # regular Stirling series for Gamma(x).
          y      = 1.quo(x * x)
          ser    = C0 + y * (C1 + y * (C2 + y * (C3 + y * (C4 + y * (C5 + y * (C6 + y * C7))))))
          result = Math.exp(ser / x)
          with_error ? [result, 2.0 * Float::EPSILON * result * [1, ser / x].max] : result
        end

        def evaluate(x, with_error = false)
          fail(ArgumentError, 'x must be positive') if x <= 0
          if x < 0.5
            STDERR.puts("Warning: Don't know error on lg_x, error for this function will be incorrect") if with_error
            lg = Math.lgamma(x).first
            lg_err = Float::EPSILON # Guess
            lx = Math.log(x)
            c    = 0.5 * (LN2 + LNPI)
            lnr_val = lg - (x - 0.5) * lx + x - c
            lnr_err = lg_err + 2.0 * Float::EPSILON * ((x + 0.5) * lx.abs + c)
            with_error ? exp_err(lnr_val, lnr_err) : Math.exp(lnr_val)
          elsif x < 2.0
            t = 4.0 / 3.0 * (x - 0.5) - 1.0
            ChebyshevSeries.evaluate(:gstar_a, t, with_error)
          elsif x < 10.0
            t = 0.25 * (x - 2.0) - 1.0
            c = ChebyshevSeries.evaluate(:gstar_b, t, with_error)
            c, c_err = c if with_error

            result      = c / (x * x) + 1.0 + 1.0 / (12.0 * x)
            with_error ? [result, c_err / (x * x) + 2.0 * Float::EPSILON * result.abs] : result
          elsif x < 1.0 / Math::ROOT4_FLOAT_EPSILON
            series x, with_error
          elsif x < 1.0 / Float::EPSILON # Stirling
            xi = 1.0 / x
            result = 1.0 + xi / 12.0 * (1.0 + xi / 24.0 * (1.0 - xi * (139.0 / 180.0 + 571.0 / 8640.0 * xi)))
            result_err = 2.0 * Float::EPSILON * result.abs
            with_error ? [result, result_err] : result
          else
            with_error ? [1.0, 1.0 / x] : 1.0
          end
        end
      end
    end
  end
end
