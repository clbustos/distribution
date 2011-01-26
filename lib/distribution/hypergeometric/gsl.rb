module Distribution
  module Hypergeometric
    module GSL_
      class << self
        def pdf(k, m, n, total)  # :nodoc:
          GSL::Ran::hypergeometric_pdf k, m, total-m, n
        end
        def p_value(k, m, n, total) # :nodoc:
          max_k = m < n ? m : n
          (k..max_k).collect{ |ki| pdf(ki,m,n,total) }.inject { |sum,p| sum+p}
        end
        def cdf k, m, n, total # :nodoc:
          # The GSL::Cdf function for hypergeometric is broken:
          # GSL::Cdf::hypergeometric_P k, m, total-m, n
          (0..k).collect { |ki| pdf(ki,m,n,total) }.inject { |sum,p| sum+p}
        end
      end
    end
  end
end