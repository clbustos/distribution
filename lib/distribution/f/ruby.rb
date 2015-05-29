module Distribution
  module F
    # Continuous random number distributions are defined by a probability density function, p(x), such that the probability of x occurring in the infinitesimal range x to x+dx is p dx.

    # The cumulative distribution function for the lower tail P(x) is defined by the integral,

    # P(x) = \int_{-\infty}^{x} dx' p(x')
    # and gives the probability of a variate taking a value less than x.

    # The cumulative distribution function for the upper tail Q(x) is defined by the integral,

    # Q(x) = \int_{x}^{+\infty} dx' p(x')
    # and gives the probability of a variate taking a value greater than x.

    # The upper and lower cumulative distribution functions are related by P(x) + Q(x) = 1 and satisfy 0 <= P(x) <= 1, 0 <= Q(x).
    module Ruby_
      extend Distribution::MathExtension

      # functions needed:
      # - pdf
      # - cdf (lower cumulative function, P(x))
      # - Q(x), upper cumulative function
      # - mean
      # - mode
      # - kurtosis
      # - skewness
      # - entropy
      # - "fit" (maximum likelihood?)
      # - expected value (given a function)
      # - lower-tail quantile -> P
      # - upper tail quantile -> Q

      class << self
        # F Distribution (Ruby) -- Probability Density Function
        def pdf(x, n, m)
          x = x.to_f
          numerator = ((n * x)**n * (m**m)) / (n * x + m)**(n + m)
          denominator = x * Math.beta(n / 2.0, m / 2.0)

          Math.sqrt(numerator) / denominator
        end

        # Cumulative Distribution Function.
        def cdf(x, n, m)
          x = x.to_f
          xx = (x * n).to_f / (x * n + m).to_f
          regularized_beta(xx, n / 2.0, m / 2.0)
        end

        # Upper cumulative function.
        #
        # If cdf(x, n, m) = p, then q(x, n, m) = 1 - p
        def q(x, n, m)
          1.0 - cdf(x, n, m)
        end

        # Return the F value corresponding to `probability` with degrees of
        # freedom `n` and `m`.
        #
        # If x = quantile(p, n, m), then cdf(x, n, m) = p.
        #
        # Taken from:
        # https://github.com/JuliaLang/Rmath-julia/blob/master/src/qf.c
        def quantile(probability, n, m)
          return Float::NAN if n <= 0.0 || m <= 0.0

          if n == Float::INFINITY || n == -Float::INFINITY || m == Float::INFINITY || m == -Float::INFINITY
            return 1.0
          end

          if n <= m && m > 4e5
            return Distribution::ChiSquare.p_value(probability, n) / n.to_f
          elsif n > 4e5 # thus n > m
            return m.to_f / Distribution::ChiSquare.p_value(1.0 - probability, m)
          else
            # O problema está aqui.
            tmp = Distribution::Beta.p_value(1.0 - probability, m.to_f / 2, n.to_f / 2)
            value = (1.0 / tmp - 1.0) * (m.to_f / n.to_f)
            return value.nan? ? Float::NAN : value
          end
        end

        alias_method :p_value, :quantile

        # Complementary quantile function.
        #
        # def cquantile(prob, n, m)
        #   quantile(1.0 - probability, n, m)
        # end

        # Return the corresponding F value for a p-value `y` with `n` and `m`
        # degrees of freedom.
        #
        # @param y [Float] Value corresponding to the desired p-value. Between 0 and 1.
        # @param n [Float] Degree of freedom of the first random variable.
        # @param m [Float] Degree of freedom of the second random variable.
        # @return [Float] Value of the F distribution that gives a p-value of `y`.

        def mean
        end

        def mode
        end

        def skewness
        end

        def kurtosis
        end

        def entropy
        end
      end
    end
  end
end
