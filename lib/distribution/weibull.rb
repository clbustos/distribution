require 'distribution/weibull/ruby'
require 'distribution/weibull/gsl'

module Distribution
  module Weibull
    SHORTHAND = 'weibull'
    extend Distributable
    create_distribution_methods
  end
end
