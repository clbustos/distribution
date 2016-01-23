module Distribution
  module Shorthand
    EQUIVALENCES = { p_value: :p, cdf: :cdf, pdf: :pdf, rng: :r,
                     exact_pdf: :epdf, exact_cdf: :ecdf, exact_p_value: :ep }

    def self.add_shortcut(shortcut, method, &block)
      if EQUIVALENCES.include? method.to_sym
        name = shortcut + "_#{method}"
        define_method(name, &block)

        name = shortcut + "_#{EQUIVALENCES[method.to_sym]}"
        define_method(name, &block)

      end
    end
  end
end
