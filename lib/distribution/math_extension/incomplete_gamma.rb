# Added by John O. Woods, SciRuby project.
# Derived from GSL-1.9 source files in the specfunc/ dir.

# require "statsample"

module Distribution
  module MathExtension
    module IncompleteGamma
      NMAX  = 5000
      SMALL = Float::EPSILON**3
      PG21  = -2.404113806319188570799476 # PolyGamma[2,1]

      class << self
        # Helper function for plot
        # def range_to_array r
        #  r << (r.last - r.first)/100.0 if r.size == 2 # set dr as Dr/100.0
        #  arr = []
        #  pos = r[0]
        #  while pos <= r[1]
        #    arr << pos
        #    pos += r[2]
        #  end
        #  arr
        # end
        #
        # def plot a, x_range, fun = :p
        #  x_range = range_to_array(x_range) if x_range.is_a?(Array)
        #  y_range = x_range.collect { |x| self.send(fun, a, x) }
        #  graph = Statsample::Graph::Scatterplot.new x_range.to_scale, y_range.to_scale
        #  f = File.new("test.svg", "w")
        #  f.puts(graph.to_svg)
        #  f.close
        #  `google-chrome test.svg`
        # end

        # The dominant part, D(a,x) := x^a e^(-x) / Gamma(a+1)
        # gamma_inc_D in GSL-1.9.
        def d(a, x, with_error = false)
          error = nil
          if a < 10.0
            ln_a = Math.lgamma(a + 1.0).first
            lnr  = a * Math.log(x) - x - ln_a
            result = Math.exp(lnr)
            error = 2.0 * Float::EPSILON * (lnr.abs + 1.0) + result.abs if with_error
            with_error ? [result, error] : result
          else
            ln_term = ln_term_error = nil
            if x < 0.5 * a
              u       = x / a.to_f
              ln_u    = Math.log(u)
              ln_term = ln_u - u + 1.0
              ln_term_error = (ln_u.abs + u.abs + 1.0) * Float::EPSILON if with_error
            else
              mu      = (x - a) / a.to_f
              ln_term = Log.log_1plusx_minusx(mu, with_error)
              ln_term, ln_term_error = ln_term if with_error
            end
            gstar = Gammastar.evaluate(a, with_error)
            gstar, gstar_error = gstar if with_error
            term1 = Math.exp(a * ln_term) / Math.sqrt(2.0 * Math::PI * a)
            result = term1 / gstar
            error  = 2.0 * Float::EPSILON * ((a * ln_term).abs + 1.0) * result.abs + gstar_error / gstar.abs * result.abs if with_error
            with_error ? [result, error] : result
          end
        end

        # gamma_inc_P_series
        def p_series(a, x, with_error = false)
          d = d(a, x, with_error)
          d, d_err = d if with_error
          sum      = 1.0
          term     = 1.0
          n        = 1
          1.upto(NMAX - 1) do |n|
            term *= x / (a + n).to_f
            sum += term
            break if (term / sum).abs < Float::EPSILON
          end

          result   = d * sum

          if n == NMAX
            STDERR.puts('Error: n reached NMAX in p series')
          else
            return with_error ? [result, d_err * sum.abs + (1.0 + n) * Float::EPSILON * result.abs] : result
          end
        end

        # This function does not exist in GSL, but is nonetheless GSL code. It's for calculating two specific ranges of p.
        def q_asymptotic_uniform_complement(a, x, with_error = false)
          q = q_asymptotic_uniform(a, x, with_error)
          q, q_err = q if with_error
          result = 1.0 - q
          with_error ? [result, q_err + 2.0 * Float::EPSILON * result.abs] : result
        end

        def q_continued_fraction_complement(a, x, with_error = false)
          q = q_continued_fraction(a, x, with_error)
          with_error ? [1.0 - q.first, q.last + 2.0 * Float::EPSILON * (1.0 - q.first).abs] : 1.0 - q
        end

        def q_large_x_complement(a, x, with_error = false)
          q = q_large_x(a, x, with_error)
          with_error ? [1.0 - q.first, q.last + 2.0 * Float::EPSILON * (1.0 - q.first).abs] : 1.0 - q
        end

        # The incomplete gamma function.
        # gsl_sf_gamma_inc_P_e
        def p(a, x, with_error = false)
          fail(ArgumentError, 'Range Error: a must be positive, x must be non-negative') if a <= 0.0 || x < 0.0
          if x == 0.0
            return with_error ? [0.0, 0.0] : 0.0
          elsif x < 20.0 || x < 0.5 * a
            return p_series(a, x, with_error)
          elsif a > 1e6 && (x - a) * (x - a) < a
            return q_asymptotic_uniform_complement a, x, with_error
          elsif a <= x
            if a > 0.2 * x
              return q_continued_fraction_complement(a, x, with_error)
            else
              return q_large_x_complement(a, x, with_error)
            end
          elsif (x - a) * (x - a) < a
            return q_asymptotic_uniform_complement a, x, with_error
          else
            return p_series(a, x, with_error)
          end
        end

        # gamma_inc_Q_e
        def q(a, x, with_error = false)
          fail(ArgumentError, 'Range Error: a and x must be non-negative') if a < 0.0 || x < 0.0
          if x == 0.0
            return with_error ? [1.0, 0.0] : 1.0
          elsif a == 0.0
            return with_error ? [0.0, 0.0] : 0.0
          elsif x <= 0.5 * a
            # If series is quick, do that.
            p = p_series(a, x, with_error)
            p, p_err = p if with_error
            result  = 1.0 - p
            return with_error ? [result, p_err + 2.0 * Float::EPSILON * result.abs] : result
          elsif a >= 1.0e+06 && (x - a) * (x - a) < a # difficult asymptotic regime, only way to do this region
            return q_asymptotic_uniform(a, x, with_error)
          elsif a < 0.2 && x < 5.0
            return q_series(a, x, with_error)
          elsif a <= x
            return x <= 1.0e+06 ? q_continued_fraction(a, x, with_error) : q_large_x(a, x, with_error)
          else
            if x > a - Math.sqrt(a)
              return q_continued_fraction(a, x, with_error)
            else
              p = p_series(a, x, with_error)
              p, p_err = p if with_error
              result = 1.0 - p
              return with_error ? [result, p_err + 2.0 * Float::EPSILON * result.abs] : result
            end
          end
        end

        # gamma_inc_Q_CF
        def q_continued_fraction(a, x, with_error = false)
          d = d(a, x, with_error)
          f = f_continued_fraction(a, x, with_error)

          if with_error
            [d.first * (a / x).to_f * f.first, d.last * ((a / x).to_f * f.first).abs + (d.first * a / x * f.last).abs]
          else
            d * (a / x).to_f * f
          end
        end

        # gamma_inc_Q_large_x in GSL-1.9
        def q_large_x(a, x, with_error = false)
          d = d(a, x, with_error)
          d, d_err = d if with_error
          sum  = 1.0
          term = 1.0
          last = 1.0
          n    = 1
          1.upto(NMAX - 1).each do |n|
            term *= (a - n) / x
            break if (term / last).abs > 1.0
            break if (term / sum).abs < Float::EPSILON
            sum += term
            last  = term
          end

          result = d * (a / x) * sum
          error  = d_err * (a / x).abs * sum if with_error

          if n == NMAX
            STDERR.puts('Error: n reached NMAX in q_large_x')
          else
            return with_error ? [result, error] : result
          end
        end

        # Uniform asymptotic for x near a, a and x large
        # gamma_inc_Q_asymp_unif
        def q_asymptotic_uniform(a, x, with_error = false)
          rta = Math.sqrt(a)
          eps = (x - a).quo(a)

          ln_term = Log.log_1plusx_minusx(eps, with_error)
          ln_term, ln_term_err = ln_term if with_error

          eta     = (eps >= 0 ? 1 : -1) * Math.sqrt(-2 * ln_term)

          erfc    = Math.erfc_e(eta * rta / SQRT2, with_error)
          erfc, erfc_err = erfc if with_error

          c0 = c1 = nil
          if eps.abs < ROOT5_FLOAT_EPSILON
            c0 = -1.quo(3) + eps * (1.quo(12) - eps * (23.quo(540) - eps * (353.quo(12_960) - eps * 589.quo(30_240))))
            c1 = -1.quo(540) - eps.quo(288)
          else
            rt_term = Math.sqrt(-2 * ln_term.quo(eps * eps))
            lam     = x.quo(a)
            c0      = (1 - 1 / rt_term) / eps
            c1      = -(eta**3 * (lam * lam + 10 * lam + 1) - 12 * eps**3).quo(12 * eta**3 * eps**3)
          end

          r = Math.exp(-0.5 * a * eta * eta) / (SQRT2 * SQRTPI * rta) * (c0 + c1.quo(a))

          result = 0.5 * erfc + r
          with_error ? [result, Float::EPSILON + (r * 0.5 * a * eta * eta).abs + 0.5 * erfc_err + 2.0 * Float::EPSILON + result.abs] : result
        end

        # gamma_inc_F_CF
        def f_continued_fraction(a, x, with_error = false)
          hn = 1.0 # convergent
          cn = 1.0 / SMALL
          dn = 1.0
          n  = 2
          2.upto(NMAX - 1).each do |n|
            an = n.odd? ? 0.5 * (n - 1) / x : (0.5 * n - a) / x
            dn = 1.0 + an * dn
            dn = SMALL if dn.abs < SMALL
            cn = 1.0 + an / cn
            cn = SMALL if cn.abs < SMALL
            dn = 1.0 / dn
            delta = cn * dn
            hn *= delta
            break if (delta - 1.0).abs < Float::EPSILON
          end

          if n == NMAX
            STDERR.puts('Error: n reached NMAX in f continued fraction')
          else
            with_error ? [hn, 2.0 * Float::EPSILON * hn.abs + Float::EPSILON * (2.0 + 0.5 * n) * hn.abs] : hn
          end
        end

        def q_series(a, x, with_error = false)
          term1 = nil
          sum   = nil
          term2 = nil
          begin
            lnx  = Math.log(x)
            el   = EULER + lnx
            c1   = -el
            c2   = Math::PI * Math::PI / 12.0 - 0.5 * el * el
            c3   = el * (Math::PI * Math::PI / 12.0 - el * el / 6.0) + PG21 / 6.0
            c4   = -0.04166666666666666667 *
                   (-1.758243446661483480 + lnx) *
                   (-0.764428657272716373 + lnx) *
                   (0.723980571623507657 + lnx) *
                   (4.107554191916823640 + lnx)
            c5 = -0.0083333333333333333 *
                 (-2.06563396085715900 + lnx) *
                 (-1.28459889470864700 + lnx) *
                 (-0.27583535756454143 + lnx) *
                 (1.33677371336239618 + lnx) *
                 (5.17537282427561550 + lnx)
            c6 = -0.0013888888888888889 *
                 (-2.30814336454783200 + lnx) *
                 (-1.65846557706987300 + lnx) *
                 (-0.88768082560020400 + lnx) *
                 (0.17043847751371778 + lnx) *
                 (1.92135970115863890 + lnx) *
                 (6.22578557795474900 + lnx)
            c7 = -0.00019841269841269841
            (-2.5078657901291800 + lnx) *
              (-1.9478900888958200 + lnx) *
              (-1.3194837322612730 + lnx) *
              (-0.5281322700249279 + lnx) *
              (0.5913834939078759 + lnx) *
              (2.4876819633378140 + lnx) *
              (7.2648160783762400 + lnx)
            c8 = -0.00002480158730158730 *
                 (-2.677341544966400 + lnx) *
                 (-2.182810448271700 + lnx) *
                 (-1.649350342277400 + lnx) *
                 (-1.014099048290790 + lnx) *
                 (-0.191366955370652 + lnx) *
                 (0.995403817918724 + lnx) *
                 (3.041323283529310 + lnx) *
                 (8.295966556941250 + lnx) *
                 c9 = -2.75573192239859e-6 *
                      (-2.8243487670469080 + lnx) *
                      (-2.3798494322701120 + lnx) *
                      (-1.9143674728689960 + lnx) *
                      (-1.3814529102920370 + lnx) *
                      (-0.7294312810261694 + lnx) *
                      (0.1299079285269565 + lnx) *
                      (1.3873333251885240 + lnx) *
                      (3.5857258865210760 + lnx) *
                      (9.3214237073814600 + lnx) *
                      c10 = -2.75573192239859e-7 *
                            (-2.9540329644556910 + lnx) *
                            (-2.5491366926991850 + lnx) *
                            (-2.1348279229279880 + lnx) *
                            (-1.6741881076349450 + lnx) *
                            (-1.1325949616098420 + lnx) *
                            (-0.4590034650618494 + lnx) *
                            (0.4399352987435699 + lnx) *
                            (1.7702236517651670 + lnx) *
                            (4.1231539047474080 + lnx) *
                            (10.342627908148680 + lnx)
            term1 = a * (c1 + a * (c2 + a * (c3 + a * (c4 + a * (c5 + a * (c6 + a * (c7 + a * (c8 + a * (c9 + a * c10)))))))))
          end

          n   = 1
          begin
            t   = 1.0
            sum = 1.0
            1.upto(NMAX - 1).each do |n|
              t *= -x / (n + 1.0)
              sum += (a + 1.0) / (a + n + 1.0) * t
              break if (t / sum).abs < Float::EPSILON
            end
          end

          if n == NMAX
            STDERR.puts('Error: n reached NMAX in q_series')
          else
            term2 = (1.0 - term1) * a / (a + 1.0) * x * sum
            result = term1 + term2
            with_error ? [result, Float::EPSILON * term1.abs + 2.0 * term2.abs + 2.0 * Float::EPSILON * result.abs] : result
          end
        end

        # gamma_inc_series
        def series(a, x, with_error = false)
          q = q_series(a, x, with_error)
          g = Math.gamma(a)
          STDERR.puts("Warning: Don't know error for Math.gamma. Error will be incorrect") if with_error
          # When we get the error from Gamma, switch the comment on the next to lines
          # with_error ? [q.first*g.first, (q.first*g.last).abs + (q.last*g.first).abs + 2.0*Float::EPSILON*(q.first*g.first).abs] : q*g
          with_error ? [q.first * g, (q.first * Float::EPSILON).abs + (q.last * g.first).abs + 2.0 * Float::EPSILON(q.first * g).abs] : q * g
        end

        # gamma_inc_a_gt_0
        def a_greater_than_0(a, x, with_error = false)
          q       = q(a, x, with_error)
          q, q_err = q if with_error
          g       = Math.gamma(a)
          STDERR.puts("Warning: Don't know error for Math.gamma. Error will be incorrect") if with_error
          g_err   = Float::EPSILON
          result  = g * q
          error   = (g * q_err).abs + (g_err * q).abs if with_error
          with_error ? [result, error] : result
        end

        # gamma_inc_CF
        def continued_fraction(a, x, with_error = false)
          f = f_continued_fraction(a, x, with_error)
          f, f_error = f if with_error
          pre = Math.exp((a - 1.0) * Math.log(x) - x)
          STDERR.puts("Warning: Don't know error for Math.exp. Error will be incorrect") if with_error
          pre_error = Float::EPSILON
          result    = f * pre
          if with_error
            error     = (f_error * pre).abs + (f * pre_error) + (2.0 + a.abs) * Float::EPSILON * result.abs
            [result, error]
          else
            result
          end
        end

        # Unnormalized incomplete gamma function.
        # gsl_sf_gamma_inc_e
        def unnormalized(a, x, with_error = false)
          fail(ArgumentError, 'x cannot be negative') if x < 0.0

          if x == 0.0
            result  = Math.gamma(a.to_f)
            STDERR.puts("Warning: Don't know error for Math.gamma. Error will be incorrect") if with_error
            return with_error ? [result, Float::EPSILON] : result
          elsif a == 0.0
            return ExponentialIntegral.first_order(x.to_f, with_error)
          elsif a > 0.0
            return a_greater_than_0(a.to_f, x.to_f, with_error)
          elsif x > 0.25
            # continued fraction seems to fail for x too small
            return continued_fraction(a.to_f, x.to_f, with_error)
          elsif a.abs < 0.5
            return series(a.to_f, x.to_f, with_error)
          else
            fa = a.floor.to_f
            da = a - fa
            g_da = da > 0.0 ? a_greater_than_0(da, x.to_f, with_error) : ExponentialIntegral.first_order(x.to_f, with_error)
            g_da, g_da_err = g_da if with_error
            alpha = da
            gax = g_da

            # Gamma(alpha-1,x) = 1/(alpha-1) (Gamma(a,x) - x^(alpha-1) e^-x)
            begin
              shift  = Math.exp(-x + (alpha - 1.0) * Math.log(x))
              gax    = (gax - shift) / (alpha - 1.0)
              alpha -= 1.0
            end while alpha > a

            result = gax
            return with_error ? [result, 2.0 * (1.0 + a.abs) * Float::EPSILON * gax.abs] : result
          end
        end
      end
    end
  end
end
