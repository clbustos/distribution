module Distribution
  module BivariateNormal
    module GSL_
      class <<self
        def pdf(x, y, rho, s1 = 1.0, s2 = 1.0)
          GSL::Ran.bivariate_gaussian_pdf(x, y, s1, s2, rho)
        end
      end
    end
  end
end
