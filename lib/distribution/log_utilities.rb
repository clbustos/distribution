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
        # \log(1+x)-x for x > -1
        # gsl_sf_log_1plusx_mx_e
        def log_1plusx_minusx x, with_error = false
          raise(ArgumentError, "Range error: x must be > -1") if x <= -1
          #return with_error ? [-1/0.0, 0] : -1/0.0 if x == 0.0 # -Infinity: For Ruby.

          result = nil
          error  = nil
          if x.abs < Math::ROOT5_FLOAT_EPSILON
            result = x*x * (C1 + x*(C2 + x*(C3 + x*(C4 + x*begin
              C5 + x*(C6 + x*(C7 + x*(C8 + x*C9))) # formerly t = this
            end))))
            error = Float::EPSILON * result.abs
          elsif x.abs < 0.5
            t = (8*x + 1).quo(2*x+4)
            c = ChebyshevSeries.evaluate(:lopxmx, t, with_error)
            return with_error ? [x*x*c.first, x*x*c.last] : x*x*c
          else
            lterm = Math.log(1.0+x)
            error = Float::EPSILON * (lterm.abs + x.abs) if with_error
            result = lterm - x
          end

          with_error ? [result, error] : result
        end
      end
    end
  end
end
