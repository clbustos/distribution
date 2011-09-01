$:.unshift(File.dirname(__FILE__)+"/../../../java_lib")
require 'java'
require 'commons-math-2.2.jar'
java_import org.apache.commons.math.distribution.NormalDistributionImpl

module Distribution
  module Normal
    # TODO
    module Java_
      class << self
        def rng(mean=0,sigma=1,seed=nil)
          dist = NormalDistributionImpl.new(mean, sigma)
          lambda { dist.sample }
        end
        
        def p_value(qn)
          dist = NormalDistributionImpl.new
          dist.inverseCumulativeProbability(qn)
        end
        
        def cdf(x)
          dist = NormalDistributionImpl.new
          dist.cumulativeProbability(x)
        end
        
        def pdf(x)
          dist = NormalDistributionImpl.new
          dist.density(x)
        end
      
      end
    end
  end
end