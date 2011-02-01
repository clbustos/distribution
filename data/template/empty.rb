require 'distribution/<DISTRIBUTION>/ruby'
require 'distribution/<DISTRIBUTION>/gsl'
#require 'distribution/<DISTRIBUTION>/java'


module Distribution

  module <DISTRIBUTION>
    SHORTHAND='<DISTRIBUTION_SHORT>'
    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(<PARAMS>)

    ##
    # :singleton-method: cdf(<PARAMS>)
    
    ##
    # :singleton-method: p_value(<PARAMS>)

  end
end
