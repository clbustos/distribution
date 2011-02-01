module Distribution
  module <%= distribution %>
    module GSL_
      class << self
        def pdf(x <% parameters %>)
        end
        def cdf(x <% parameters %>)
        end
        def p_value(pr <% parameters %>)
        end
      end
    end
  end
end