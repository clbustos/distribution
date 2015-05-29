module Distribution
  # Magic module
  module Distributable #:nodoc:
    # Create methods for each module and add methods to
    # Distribution::Shorthand.
    #
    # Traverse Distribution.libraries_order adding
    # methods availables for each engine module on
    # the current library
    #
    # Kids: Metaprogramming trickery! Don't do at work.
    # This section was created between a very long reunion
    # and a 456 Km. travel
    def create_distribution_methods
      Distribution.libraries_order.each do |l_name|
        if const_defined? l_name
          l = const_get(l_name)
          # Add methods from engine to base base, if not yet included
          l.singleton_methods.each do |m|
            unless singleton_methods.include? m
              define_method(m) do |*args|
                l.send(m, *args)
              end
              # Add method to Distribution::Shorthand
              sh = const_get(:SHORTHAND)
              Distribution::Shorthand.add_shortcut(sh, m) do |*args|
                l.send(m, *args)
              end

              module_function m
            end
          end
        end
      end

      # create alias for common methods
      alias_method :inverse_cdf, :p_value if singleton_methods.include? :p_value
    end
  end
end
