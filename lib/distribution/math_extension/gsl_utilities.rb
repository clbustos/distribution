# Added by John O. Woods, SciRuby project.
# Derived from GSL-1.9 source files, mostly in the specfunc/ dir.

module Distribution
  module MathExtension
    LNPI                = 1.14472988584940017414342735135
    LN2                 = 0.69314718055994530941723212146
    SQRT2               = 1.41421356237309504880168872421
    SQRTPI              = 1.77245385090551602729816748334

    ROOT3_FLOAT_MIN     = Float::MIN**(1 / 3.0)
    ROOT3_FLOAT_EPSILON = Float::EPSILON**(1 / 3.0)
    ROOT4_FLOAT_MIN     = Float::MIN**(1 / 4.0)
    ROOT4_FLOAT_EPSILON = Float::EPSILON**(1 / 4.0)
    ROOT5_FLOAT_MIN     = Float::MIN**(1 / 5.0)
    ROOT5_FLOAT_EPSILON = Float::EPSILON**(1 / 5.0)
    ROOT6_FLOAT_MIN     = Float::MIN**(1 / 6.0)
    ROOT6_FLOAT_EPSILON = Float::EPSILON**(1 / 6.0)
    LOG_FLOAT_MIN       = Math.log(Float::MIN)
    EULER               = 0.57721566490153286060651209008

    # e^x taking into account the error thus far (I think)
    # gsl_sf_exp_err_e
    def exp_err(x, dx)
      adx = dx.abs
      fail('Overflow Error in exp_err: x + adx > LOG_FLOAT_MAX') if x + adx > LOG_FLOAT_MAX
      fail('Underflow Error in exp_err: x - adx < LOG_FLOAT_MIN') if x - adx < LOG_FLOAT_MIN
      [Math.exp(x), Math.exp(x) * [Float::EPSILON, Math.exp(adx) - 1.0 / Math.exp(adx)] + 2.0 * Float::EPSILON * Math.exp(x).abs]
    end
  end
end
