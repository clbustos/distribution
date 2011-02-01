require 'distribution/<%= distribution.downcase %>/ruby'
require 'distribution/<%= distribution.downcase %>/gsl'
#require 'distribution/<%= distribution.downcase %>/java'


module Distribution

  module <%= distribution %>
    SHORTHAND='<%= distribution.downcase[0,4] %>'
    extend Distributable
    create_distribution_methods

    ##
    # :singleton-method: pdf(x <%= parameters %>)

    ##
    # :singleton-method: cdf(x <%= parameters %>)
    
    ##
    # :singleton-method: p_value(pr <%= parameters %>)

  end
end
