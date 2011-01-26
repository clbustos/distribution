module Distribution
  module F
    module Ruby_
        class << self

      def c_pdf(f,df)
        Distribution::ChiSquare.pdf(f,df)
      end
      def pdf(x,d1,d2)
        Math.sqrt(((d1*x)**d1*(d2**d2)).quo((d1*x+d2)**(d1+d2))).quo( x*Math.beta(d1/2.0, d2/2.0))
      end
      # F-distribution ([1])
      # Integral over [x, \infty) 
      def q_f(df1, df2, f)
      if (f <= 0.0) then return 1.0; end
      if (df1 % 2 != 0 && df2 % 2 == 0)
      return 1.0 - q_f(df2, df1, 1.0 / f)
      end
      cos2 = 1.0 / (1.0 + df1.to_f * f / df2.to_f)
      sin2 = 1.0 - cos2

      if (df1 % 2 == 0)
      prob = cos2 ** (df2.to_f / 2.0)
      temp = prob
      i = 2
      while i < df1
        temp *= (df2.to_f + i - 2) * sin2 / i
        prob += temp
        i += 2
      end
      return prob
      end
      prob = Math.atan(Math.sqrt(df2.to_f / (df1.to_f * f)))
      temp = Math.sqrt(sin2 * cos2)
      i = 3
      while i <= df1
      prob += temp
      temp *= (i - 1).to_f * sin2 / i.to_f;
      i += 2.0
      end
      temp *= df1.to_f
      i = 3
      while i <= df2
      prob -= temp
      temp *= (df1.to_f + i - 2) * cos2 / i.to_f
      i += 2
      end
      prob * 2.0 / Math::PI
      end

      # inverse of F-distribution ([2])
      def pfsub(x, y, z)
      (Math.sqrt(z) - y) / x / 2.0
      end

      # Inverse CDF
      # [x, \infty)
      def pf(q, n1, n2)
        if(q < 0.0 || q > 1.0 || n1 < 1 || n2 < 1)
        $stderr.printf("Error : Illegal parameter in pf()!\n")
        return 0.0
      end

      if n1 <= 240 || n2 <= 240
      eps = 1.0e-5
      if(n2 == 1) then eps = 1.0e-4 end
      fw = 0.0
      s = 1000.0
      loop do
      fw += s
      if s <= eps  then return fw end
      if (qe = q_f(n1, n2, fw) - q) == 0.0 then return fw end
      if qe < 0.0
        fw -= s
        s /= 10.0 #/
      end
      end
      end

      eps = 1.0e-6
      qn = q
      if q < 0.5 then qn = 1.0 - q
      u = pnorm(qn)
      w1 = 2.0 / n1 / 9.0
      w2 = 2.0 / n2 / 9.0
      w3 = 1.0 - w1
      w4 = 1.0 - w2
      u2 = u * u
      a = w4 * w4 - u2 * w2
      b = -2. * w3 * w4
      c = w3 * w3 - u2 * w1
      d = b * b - 4 * a * c
      if(d < 0.0)
      fw = pfsub(a, b, 0.0)
      else
      if(a.abs > eps)
        fw = pfsub(a, b, d)
      else
        if(b.abs > eps) then return -c / b end
        fw = pfsub(a, b, 0.0)
      end
      end
      fw * fw * fw
      end
      end
      # F-distribution interface
      def cdf(f,n1, n2)
        1.0 - q_f(n1, n2, f)
      end
      def p_value(y, n1, n2)
        pf(1.0 - y, n1, n2)
      end
      
      end
    end
  end
end
