module Distribution
  module T
    module Ruby_
      class << self
        def pdf(t, v)
          ((Math.gamma((v + 1) / 2.0)) / (Math.sqrt(v * Math::PI) * Math.gamma(v / 2.0))) * ((1 + (t**2 / v.to_f))**(-(v + 1) / 2.0))
        end

        # Returns the integral of t-distribution with n degrees of freedom over (-Infty, x].
        def cdf(t, n)
          p_t(n, t)
        end

        # t-distribution ([1])
        # (-\infty, x]
        def p_t(df, t)
          if df.to_i != df
            x = (t + Math.sqrt(t**2 + df)) / (2 * Math.sqrt(t**2 + df))
            return Math.regularized_beta(x, df / 2.0, df / 2.0)
          end
          df = df.to_i
          c2 = df.to_f / (df + t * t)
          s = Math.sqrt(1.0 - c2)
          s = -s if t < 0.0
          p = 0.0
          i = df % 2 + 2
          while i <= df
            p += s
            s *= (i - 1) * c2 / i
            i += 2
          end

          if df.is_a?(Float) || df & 1 != 0
            0.5 + (p * Math.sqrt(c2) + Math.atan(t / Math.sqrt(df))) / Math::PI
          else
            (1.0 + p) / 2.0
          end
        end

        # inverse of t-distribution ([2])
        # (-\infty, -q/2] + [q/2, \infty)
        def ptsub(q, n)
          q = q.to_f
          if n == 1 && 0.001 < q && q < 0.01
            eps = 1.0e-4
          elsif n == 2 && q < 0.0001
            eps = 1.0e-4
          elsif n == 1 && q < 0.001
            eps = 1.0e-2
          else
            eps = 1.0e-5
          end
          s = 10_000.0
          w = 0.0
          loop do
            w += s
            return w if (s <= eps)
            if ((qe = 2.0 - p_t(n, w) * 2.0 - q) == 0.0) then return w end
            if qe < 0.0
              w -= s
              s /= 10.0 # /
            end
          end
        end

        def pt(q, n)
          q = q.to_f
          if q < 1.0e-5 || q > 1.0 || n < 1
            $stderr.printf("Error : Illegal parameter in pt()!\n")
            return 0.0
          end

          return ptsub(q, n) if (n <= 5)
          return ptsub(q, n) if q <= 5.0e-3 && n <= 13

          f1 = 4.0 * (f = n.to_f)
          f5 = (f4 = (f3 = (f2 = f * f) * f) * f) * f
          f2 *= 96.0
          f3 *= 384.0
          f4 *= 92_160.0
          f5 *= 368_640.0
          u = Normal.p_value(1.0 - q / 2.0)

          w0 = (u2 = u * u) * u
          w1 = w0 * u2
          w2 = w1 * u2
          w3 = w2 * u2
          w4 = w3 * u2
          w = (w0 + u) / f1
          w += (5.0 * w1 + 16.0 * w0 + 3.0 * u) / f2
          w += (3.0 * w2 + 19.0 * w1 + 17.0 * w0 - 15.0 * u) / f3
          w += (79.0 * w3 + 776.0 * w2 + 1482.0 * w1 - 1920.0 * w0 - 9450.0 * u) / f4
          w += (27.0 * w4 + 339.0 * w3 + 930.0 * w2 - 1782.0 * w1 - 765.0 * w0 + 17_955.0 * u) / f5
          u + w
        end

        # Returns the P-value of tdist().
        def quantile(y, n)
          if y > 0.5
            pt(2.0 - y * 2.0, n)
          else
            - pt(y * 2.0, n)
          end
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
