# Added by John O. Woods, SciRuby project.
# Derived from GSL-1.9 source files in the specfunc/ dir.

module Distribution
  module MathExtension
    # Various logarithm shortcuts, adapted from GSL-1.9.
    module Log
      C1 = -1.quo(2)
      C2 =  1.quo(3)
      C3 = -1.quo(4)
      C4 =  1.quo(5)
      C5 = -1.quo(6)
      C6 =  1.quo(7)
      C7 = -1.quo(8)
      C8 =  1.quo(9)
      C9 = -1.quo(10)
      class << self
        # gsl_log1p from GSL-1.9 sys/log1p.c
        # log for very small x
        def log1p(x)
          # in C, this is volatile double y.
          # Not sure how to reproduce that in Ruby.
          y = 1 + x
          Math.log(y) - ((y - 1) - x).quo(y) # cancel errors with IEEE arithmetic
        end

        # \log(1+x) for x > -1
        # gsl_sf_log_1plusx_e
        def log_1plusx(x, with_error = false)
          fail(ArgumentError, 'Range error: x must be > -1') if x <= -1

          if x.abs < Math::ROOT6_FLOAT_EPSILON
            result = x * (1.0 + x * (C1 + x * (C2 + x * (C3 + x * (C4 + x * begin
              C5 + x * (C6 + x * (C7 + x * (C8 + x * C9))) # formerly t = this
            end)))))
            return with_error ? [result, Float::EPSILON * result.abs] : result
          elsif x.abs < 0.5
            c = ChebyshevSeries.evaluate(:lopx, (8 * x + 1).quo(2 * x + 4), with_error)
            return with_error ? [x * c.first, x * c.last] : x * c
          else
            result = Math.log(1 + x)
            return with_error ? [result, Float::EPSILON * result.abs] : result
          end
        end

        # \log(1+x)-x for x > -1
        # gsl_sf_log_1plusx_mx_e
        def log_1plusx_minusx(x, with_error = false)
          fail(ArgumentError, 'Range error: x must be > -1') if x <= -1

          if x.abs < Math::ROOT5_FLOAT_EPSILON
            result = x * x * (C1 + x * (C2 + x * (C3 + x * (C4 + x * begin
              C5 + x * (C6 + x * (C7 + x * (C8 + x * C9))) # formerly t = this
            end))))
            return with_error ? [result, Float::EPSILON * result.abs] : result
          elsif x.abs < 0.5
            c = ChebyshevSeries.evaluate(:lopxmx, (8 * x + 1).quo(2 * x + 4), with_error)
            return with_error ? [x * x * c.first, x * x * c.last] : x * x * c
          else
            lterm = Math.log(1.0 + x)
            error = Float::EPSILON * (lterm.abs + x.abs) if with_error
            result = lterm - x
            return with_error ? [result, error] : result
          end
        end

        protected

        # Abstracted from other log helper functions in GSL-1.9.
        def x_less_than_root_epsilon(x, with_error)
          result  = square_x ? x * x : x

          with_error ? [result, Float::EPSILON * result.abs] : result
        end
      end
    end
  end
end
