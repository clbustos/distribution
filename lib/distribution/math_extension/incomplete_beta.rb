# Added by John O. Woods, SciRuby project.
# Derived from GSL-1.9 source files in the specfunc/ dir.

module Distribution
  module MathExtension
    module Beta
      class << self
        # Based on gsl_sf_lnbeta_e and gsl_sf_lnbeta_sgn_e
        # Returns result and sign in an array. If with_error is specified, also returns the error.
        def log_beta(x, y, with_error = false)
          sign = nil

          fail(ArgumentError, 'x and y must be nonzero') if x == 0.0 || y == 0.0
          fail(ArgumentError, 'not defined for negative integers') if [x, y].any? { |v| v < 0 }

          # See if we can handle the positive case with min/max < 0.2
          if x > 0 && y > 0
            min, max = [x, y].minmax
            ratio    = min.quo(max)

            if ratio < 0.2
              gsx   = Gammastar.evaluate(x, with_error)
              gsy   = Gammastar.evaluate(y, with_error)
              gsxy  = Gammastar.evaluate(x + y, with_error)
              lnopr = Log.log_1plusx(ratio, with_error)

              gsx, gsx_err, gsy, gsy_err, gsxy, gsxy_err, lnopr, lnopr_err = [gsx, gsy, gsxy, lnopr].flatten if with_error

              lnpre = Math.log((gsx * gsy).quo(gsxy) * Math::SQRT2 * Math::SQRTPI)
              lnpre_err = gsx_err.quo(gsx) + gsy_err(gsy) + gsxy_err.quo(gsxy) if with_error

              t1    = min * Math.log(ratio)
              t2    = 0.5 * Math.log(min)
              t3    = (x + y - 0.5) * lnopr

              lnpow       = t1 - t2 - t3
              lnpow_err   = Float::EPSILON * (t1.abs + t2.abs + t3.abs) + (x + y - 0.5).abs * lnopr_err if with_error

              result      = lnpre + lnpow
              error       = lnpre_err + lnpow_err + 2.0 * Float::EPSILON * result.abs if with_error

              return with_error ? [result, 1.0, error] : [result, 1.0]
            end
          end

          # General case: fallback
          lgx, sgx   = Math.lgamma(x)
          lgy, sgy   = Math.lgamma(y)
          lgxy, sgxy = Math.lgamma(x + y)
          sgn        = sgx * sgy * sgxy

          fail('Domain error: sign is -') if sgn == -1

          result = lgx + lgy - lgxy
          if with_error
            lgx_err, lgy_err, lgxy_err = begin
              STDERR.puts('Warning: Error is unknown for Math::lgamma, guessing.')
              [Math::EPSILON, Math::EPSILON, Math::EPSILON]
            end

            error  = lgx_err + lgy_err + lgxy_err + Float::EPSILON * (lgx.abs + lgy.abs + lgxy.abs) + 2.0 * (Float::EPSILON) * result.abs
            return [result, sgn, error]
          else
            return [result, sgn]
          end
        end
      end
    end
    # Calculate regularized incomplete beta function
    module IncompleteBeta
      MAX_ITER = 512
      CUTOFF   = 2.0 * Float::MIN

      class << self
        # Evaluate aa * beta_inc(a,b,x) + yy
        #
        # No error mode available.
        #
        # From GSL-1.9: cdf/beta_inc.c, beta_inc_AXPY
        def axpy(aa, yy, a, b, x)
          return aa * 0 + yy if x == 0.0
          return aa * 1 + yy if x == 1.0

          ln_beta   = Math.logbeta(a, b)
          ln_pre    = -ln_beta + a * Math.log(x) + b * Math::Log.log1p(-x)
          prefactor = Math.exp(ln_pre)

          if x < (a + 1).quo(a + b + 2)
            # Apply continued fraction directly
            epsabs  = yy.quo((aa * prefactor).quo(a)).abs * Float::EPSILON
            cf      = continued_fraction(a, b, x, epsabs)
            return  aa * (prefactor * cf).quo(a) + yy
          else
            # Apply continued fraction after hypergeometric transformation
            epsabs = (aa + yy).quo((aa * prefactor).quo(b)) * Float::EPSILON
            cf     = continued_fraction(b, a, 1 - x, epsabs)
            term   = (prefactor * cf).quo(b)
            return aa == -yy ? -aa * term : aa * (1 - term) + yy
          end
        end

        # Evaluate the incomplete beta function
        # gsl_sf_beta_inc_e
        def evaluate(a, b, x, with_error = false)
          fail(ArgumentError, "Domain error: a(#{a}), b(#{b}) must be positive; x(#{x}) must be between 0 and 1, inclusive") if a <= 0 || b <= 0 || x < 0 || x > 1
          if x == 0
            return with_error ? [0.0, 0.0] : 0.0
          elsif x == 1
            return with_error ? [1.0, 0.0] : 1.0
          else

            ln_beta = Beta.log_beta(a, b, with_error)
            ln_1mx  = Log.log_1plusx(-x, with_error)
            ln_x    = Math.log(x)

            ln_beta, ln_beta_err, ln_1mx, ln_1mx_err, ln_x_err = begin
              # STDERR.puts("Warning: Error is unknown for Math::log, guessing.")
              [ln_beta, ln_1mx, Float::EPSILON].flatten
            end

            ln_pre      = -ln_beta + a * ln_x + b * ln_1mx
            ln_pre_err  = ln_beta_err + (a * ln_x_err).abs + (b * ln_1mx_err).abs if with_error

            prefactor, prefactor_err   = begin
              if with_error
                exp_err(ln_pre, ln_pre_err)
              else
                [Math.exp(ln_pre), nil]
              end
            end

            if x < (a + 1).quo(a + b + 2)
              # Apply continued fraction directly

              cf      = continued_fraction(a, b, x, nil, with_error)
              cf, cf_err = cf if with_error
              result  = (prefactor * cf).quo(a)
              return with_error ? [result, ((prefactor_err * cf).abs + (prefactor * cf_err).abs).quo(a)] : result
            else
              # Apply continued fraction after hypergeometric transformation

              cf      = continued_fraction(b, a, 1 - x, nil)
              cf, cf_err = cf if with_error
              term    = (prefactor * cf).quo(b)
              result  = 1 - term

              return with_error ? [result, (prefactor_err * cf).quo(b) + (prefactor * cf_err).quo(b) + 2.0 * Float::EPSILON * (1 + term.abs)] : result
            end

          end
        end

        def continued_fraction_cutoff(epsabs)
          return CUTOFF if epsabs.nil?
          0.0 / 0 # NaN
        end

        # Continued fraction calculation of incomplete beta
        # beta_cont_frac from GSL-1.9
        #
        # If epsabs is set, will execute the version of the GSL function in the cdf folder. Otherwise, does the
        # basic one in specfunc.
        def continued_fraction(a, b, x, epsabs = nil, with_error = false)
          num_term = 1
          den_term = 1 - (a + b) * x.quo(a + 1)
          k        = 0

          den_term = continued_fraction_cutoff(epsabs) if den_term.abs < CUTOFF
          den_term = 1.quo(den_term)
          cf       = den_term

          1.upto(MAX_ITER) do |k|
            coeff      = k * (b - k) * x.quo(((a - 1) + 2 * k) * (a + 2 * k)) # coefficient for step 1
            delta_frac = nil
            2.times do
              den_term    = 1 + coeff * den_term
              num_term    = 1 + coeff.quo(num_term)

              den_term = continued_fraction_cutoff(epsabs) if den_term.abs < CUTOFF
              num_term = continued_fraction_cutoff(epsabs) if num_term.abs < CUTOFF

              den_term = 1.quo(den_term)

              delta_frac  = den_term * num_term
              cf *= delta_frac

              coeff = -(a + k) * (a + b + k) * x.quo((a + 2 * k) * (a + 2 * k + 1)) # coefficient for step 2
            end

            break if (delta_frac - 1).abs < 2.0 * Float::EPSILON
            break if !epsabs.nil? && (cf * (delta_frac - 1).abs < epsabs)
          end

          if k > MAX_ITER
            fail('Exceeded maximum number of iterations') if epsabs.nil?
            return with_error ? [0.0 / 0, 0] : 0.0 / 0 # NaN if epsabs is set
          end

          with_error ? [cf, k * 4 * Float::EPSILON * cf.abs] : cf
        end
      end
    end
  end
end
