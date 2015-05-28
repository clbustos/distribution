module Distribution
  module MathExtension
    # From GSL-1.9.
    module ExponentialIntegral
      class << self
        def first_order(x, scale = 0, with_error = false)
          xmaxt = -Math::LOG_FLOAT_MIN
          xmax  = xmaxt - Math.log(xmaxt)
          result = nil
          error  = with_error ? nil : 0.0

          if x < -xmax && !scale
            fail('Overflow Error')
          elsif x <= -10.0
            s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
            result_c = ChebyshevSeries.eval(20.0 / x + 1.0, :ae11, with_error)
            result_c, result_c_err = result_c if with_error
            result   = s * (1.0 + result_c)
            error ||= (s * result_c_err) + 2.0 * Float::EPSILON * (x.abs + 1.0) * result.abs
          elsif x <= -4.0
            s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
            result_c = ChebyshevSeries.eval((40.0 / x + 7.0) / 3.0, :ae12, with_error)
            result_c, result_c_err = result_c if with_error
            result   = s * (1.0 + result_c)
            error ||= (s * result_c_err) + 2.0 * Float::EPSILON * result.abs
          elsif x <= -1.0
            ln_term = - Math.log(x.abs)
            scale_factor = scale ? Math.exp(x) : 1.0
            result_c = ChebyshevSeries.eval((2.0 * x + 5.0) / 3.0, :e11, with_error)
            result_c, result_c_err = result_c if with_error
            result   = scale_factor * (ln_term + result_c)
            error ||= scale_factor * (result_c_err + Float::EPSILON * ln_term.abs) + 2.0 * Float::EPSILON * result.abs
          elsif x == 0.0
            fail(ArgumentError, 'Domain Error')
          elsif x <= 1.0
            ln_term = - Math.log(x.abs)
            scale_factor = scale ? Math.exp(x) : 1.0
            result_c = ChebyshevSeries.eval(x, :e12, with_error)
            result_c, result_c_err = result_c if with_error
            result   = scale_factor * (ln_term - 0.6875 + x + result_c)
            error ||= scale_factor * (result_c_err + Float::EPSILON * ln_term.abs) + 2.0 * Float::EPSILON * result.abs
          elsif x <= 4.0
            s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
            result_c = ChebyshevSeries.eval((8.0 / x - 5.0) / 3.0, :ae13, with_error)
            result_c, result_c_err = result_c if with_error
            result   = s * (1.0 + result_c)
            error ||= (s * result_c_err) + 2.0 * Float::EPSILON * result.abs
          elsif x <= xmax || scale
            s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
            result_c = ChebyshevSeries.eval(8.0 / x - 1.0, :ae14, with_error)
            result_c, result_c_err = result_c if with_error
            result   = s * (1.0 + result_c)
            error ||= s * (Float::EPSILON + result_c_err) + 2.0 * (x + 1.0) * Float::EPSILON * result.abs
            fail('Underflow Error') if result == 0.0
          else
            fail('Underflow Error')
          end
          with_error ? [result, error] : result
        end
      end
    end
  end
end
