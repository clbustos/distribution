require 'distribution/bivariatenormal/ruby'
require 'distribution/bivariatenormal/gsl'
module Distribution
  # Calculate pdf and cdf for bivariate normal distribution.
  #
  # Pdf if easy to calculate, but CDF is not trivial. Several papers
  # describe methods to calculate the integral.
  module BivariateNormal
    SHORTHAND='bnor'

    extend Distributable
    create_distribution_methods
    
    ##
    # :singleton-method: pdf(x,y, rho, s1=1.0, s2=1.0)
    # Probability density function for a given x, y and rho value.
    # 
    
    ##
    # :singleton-method: cdf(x,y,rho)
    # CDF for a given x, y and rho value.
    #
    
  end
end
