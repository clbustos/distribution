module Distribution
  module ChiSquare
    module Ruby_
      class << self
        include Math
        def pdf(x, n)
          if n == 1
            1.0 / Math.sqrt(2 * Math::PI * x) * Math::E**(-x / 2.0)
          elsif n == 2
            0.5 * Math::E**(-x / 2.0)
          else
            n = n.to_f
            n2 = n / 2
            x = x.to_f
            1.0 / 2**n2 / gamma(n2) * x**(n2 - 1.0) * Math.exp(-x / 2.0)
          end
        end

        # CDF Inverse over [x, \infty)
        # Pr([x, \infty)) = y -> x
        def pchi2(n, y)
          if n == 1
            w = Distribution::Normal.p_value(1 - y / 2) # = p1.0-Distribution::Normal.cdf(y/2)
            w * w
          elsif n == 2
            #      v = (1.0 / y - 1.0) / 33.0
            #      newton_a(y, v) {|x| [q_chi2(n, x), -chi2dens(n, x)] }
            -2.0 * Math.log(y)
          else
            eps = 1.0e-5
            v = 0.0
            s = 10.0
            loop do
              v += s
              break if s <= eps
              if (qe = q_chi2(n, v) - y) == 0.0 then break end
              if qe < 0.0
                v -= s
                s /= 10.0
              end
            end

            v
          end
        end

        def cdf(x, k)
          1.0 - q_chi2(k, x)
        end

        # chi-square distribution ([1])
        # Integral over [x, \infty)
        def q_chi2(df, chi2)
          chi2 = chi2.to_f
          if (df & 1) != 0
            chi = Math.sqrt(chi2)

            return 2 * (1.0 - Distribution::Normal.cdf(chi)) if (df == 1)
            s = t = chi * Math.exp(-0.5 * chi2) / SQ2PI
            k = 3

            while k < df
              t *= chi2 / k;  s += t
              k += 2
            end

            2 * (1.0 - (Distribution::Normal.cdf(chi)) + s)

          else
            s = t = Math.exp(-0.5 * chi2)
            k = 2

            while k < df
              t *= chi2 / k;  s += t
              k += 2
            end
            s
          end
        end

        def quantile(pr, k)
          pchi2(k, 1.0 - pr)
        end

        alias_method :p_value, :quantile
      end
    end
  end
end
