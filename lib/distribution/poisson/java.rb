$:.unshift(File.dirname(__FILE__)+"/../../../java_lib")
require 'java'
require 'commons-math-2.2.jar'

java_import 'org.apache.commons.math.distribution.PoissonDistributionImpl'

module Distribution
  module Poisson
    module Java_
      
      #==
      # Create the PoissonDistributionImpl object for use in calculations
      # with mean of l
      def create_distribution(l)
        PoissonDistributionImpl.new(l)
      end
      
      #==
      # 
      def pdf(k,l)
        dist = create_distribution(l)
        dist.pdf(k)
      end
      
      def cdf(k,l)
        dist = create_distribution(l)
        dist.pdf(k)
      end
      
#      def p_value(pr,l)
#        dist = create_distribution(l)
#        dist.inverseCumulativeProbability(pr)
#      end
      
    end
  end
end