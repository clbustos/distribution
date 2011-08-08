# require "statsample"

# Derived from GSL-1.9 source files in specfunc dir.
module Distribution
module MathExtension
  LNPI                = 1.14472988584940017414342735135
  LN2                 = 0.69314718055994530941723212146
  SQRT2               = 1.41421356237309504880168872421
  SQRTPI              = 1.77245385090551602729816748334
  
  ROOT3_FLOAT_MIN     = Float::MIN ** (1/3.0)
  ROOT3_FLOAT_EPSILON = Float::EPSILON ** (1/3.0)
  ROOT4_FLOAT_MIN     = Float::MIN ** (1/4.0)
  ROOT4_FLOAT_EPSILON = Float::EPSILON ** (1/4.0)
  ROOT5_FLOAT_MIN     = Float::MIN ** (1/5.0)
  ROOT5_FLOAT_EPSILON = Float::EPSILON ** (1/5.0)
  ROOT6_FLOAT_MIN     = Float::MIN ** (1/6.0)
  ROOT6_FLOAT_EPSILON = Float::EPSILON ** (1/6.0)
  LOG_FLOAT_MIN       = Math.log(Float::MIN)
  EULER               = 0.57721566490153286060651209008

  class ChebyshevSeries
    DATA = {:lopx => [  2.16647910664395270521272590407,
                       -0.28565398551049742084877469679,
                        0.01517767255690553732382488171,
                       -0.00200215904941415466274422081,
                        0.00019211375164056698287947962,
                       -0.00002553258886105542567601400,
                        2.9004512660400621301999384544e-06,
                       -3.8873813517057343800270917900e-07,
                        4.7743678729400456026672697926e-08,
                       -6.4501969776090319441714445454e-09,
                        8.2751976628812389601561347296e-10,
                       -1.1260499376492049411710290413e-10,
                        1.4844576692270934446023686322e-11,
                       -2.0328515972462118942821556033e-12,
                        2.7291231220549214896095654769e-13,
                       -3.7581977830387938294437434651e-14,
                        5.1107345870861673561462339876e-15,
                       -7.0722150011433276578323272272e-16,
                        9.7089758328248469219003866867e-17,
                       -1.3492637457521938883731579510e-17,
                        1.8657327910677296608121390705e-18  ],
      :lopxmx => [ -1.12100231323744103373737274541,
                    0.19553462773379386241549597019,
                   -0.01467470453808083971825344956,
                    0.00166678250474365477643629067,
                   -0.00018543356147700369785746902,
                    0.00002280154021771635036301071,
                   -2.8031253116633521699214134172e-06,
                    3.5936568872522162983669541401e-07,
                   -4.6241857041062060284381167925e-08,
                    6.0822637459403991012451054971e-09,
                   -8.0339824424815790302621320732e-10,
                    1.0751718277499375044851551587e-10,
                   -1.4445310914224613448759230882e-11,
                    1.9573912180610336168921438426e-12,
                   -2.6614436796793061741564104510e-13,
                    3.6402634315269586532158344584e-14,
                   -4.9937495922755006545809120531e-15,
                    6.8802890218846809524646902703e-16,
                   -9.5034129794804273611403251480e-17,
                    1.3170135013050997157326965813e-17],
      :gstar_a => [   2.16786447866463034423060819465,
                     -0.05533249018745584258035832802,
                      0.01800392431460719960888319748,
                     -0.00580919269468937714480019814,
                      0.00186523689488400339978881560,
                     -0.00059746524113955531852595159,
                      0.00019125169907783353925426722,
                     -0.00006124996546944685735909697,
                      0.00001963889633130842586440945,
                     -6.3067741254637180272515795142e-06,
                      2.0288698405861392526872789863e-06,
                     -6.5384896660838465981983750582e-07,
                      2.1108698058908865476480734911e-07,
                     -6.8260714912274941677892994580e-08,
                      2.2108560875880560555583978510e-08,
                     -7.1710331930255456643627187187e-09,
                      2.3290892983985406754602564745e-09,
                     -7.5740371598505586754890405359e-10,
                      2.4658267222594334398525312084e-10,
                     -8.0362243171659883803428749516e-11,
                      2.6215616826341594653521346229e-11,
                     -8.5596155025948750540420068109e-12,
                      2.7970831499487963614315315444e-12,
                     -9.1471771211886202805502562414e-13,
                      2.9934720198063397094916415927e-13,
                     -9.8026575909753445931073620469e-14,
                      3.2116773667767153777571410671e-14,
                     -1.0518035333878147029650507254e-14,
                      3.4144405720185253938994854173e-15,
                     -1.0115153943081187052322643819e-15 ],
        :gstar_b => [ 0.0057502277273114339831606096782,
                      0.0004496689534965685038254147807,
                     -0.0001672763153188717308905047405,
                      0.0000615137014913154794776670946,
                     -0.0000223726551711525016380862195,
                      8.0507405356647954540694800545e-06,
                     -2.8671077107583395569766746448e-06,
                      1.0106727053742747568362254106e-06,
                     -3.5265558477595061262310873482e-07,
                      1.2179216046419401193247254591e-07,
                     -4.1619640180795366971160162267e-08,
                      1.4066283500795206892487241294e-08,
                     -4.6982570380537099016106141654e-09,
                      1.5491248664620612686423108936e-09,
                     -5.0340936319394885789686867772e-10,
                      1.6084448673736032249959475006e-10,
                     -5.0349733196835456497619787559e-11,
                      1.5357154939762136997591808461e-11,
                     -4.5233809655775649997667176224e-12,
                      1.2664429179254447281068538964e-12,
                     -3.2648287937449326771785041692e-13,
                      7.1528272726086133795579071407e-14,
                     -9.4831735252566034505739531258e-15,
                     -2.3124001991413207293120906691e-15,
                      2.8406613277170391482590129474e-15,
                     -1.7245370321618816421281770927e-15,
                      8.6507923128671112154695006592e-16,
                     -3.9506563665427555895391869919e-16,
                      1.6779342132074761078792361165e-16,
                     -6.0483153034414765129837716260e-17 ],
        :e11 => [  -16.11346165557149402600,
                    7.79407277874268027690,
                   -1.95540581886314195070,
                    0.37337293866277945612,
                   -0.05692503191092901938,
                    0.00721107776966009185,
                   -0.00078104901449841593,
                    0.00007388093356262168,
                   -0.00000620286187580820,
                    0.00000046816002303176,
                   -0.00000003209288853329,
                    0.00000000201519974874,
                   -0.00000000011673686816,
                    0.00000000000627627066,
                   -0.00000000000031481541,
                    0.00000000000001479904,
                   -0.00000000000000065457,
                    0.00000000000000002733,
                   -0.00000000000000000108],
        :e12 => [  -0.03739021479220279500,
                     0.04272398606220957700,
                    -0.13031820798497005440,
                     0.01441912402469889073,
                    -0.00134617078051068022,
                     0.00010731029253063780,
                    -0.00000742999951611943,
                     0.00000045377325690753,
                    -0.00000002476417211390,
                     0.00000000122076581374,
                    -0.00000000005485141480,
                     0.00000000000226362142,
                    -0.00000000000008635897,
                     0.00000000000000306291,
                    -0.00000000000000010148,
                     0.00000000000000000315 ],
        :ae11 => [   0.121503239716065790,
                    -0.065088778513550150,
                     0.004897651357459670,
                    -0.000649237843027216,
                     0.000093840434587471,
                     0.000000420236380882,
                    -0.000008113374735904,
                     0.000002804247688663,
                     0.000000056487164441,
                    -0.000000344809174450,
                     0.000000058209273578,
                     0.000000038711426349,
                    -0.000000012453235014,
                    -0.000000005118504888,
                     0.000000002148771527,
                     0.000000000868459898,
                    -0.000000000343650105,
                    -0.000000000179796603,
                     0.000000000047442060,
                     0.000000000040423282,
                    -0.000000000003543928,
                    -0.000000000008853444,
                    -0.000000000000960151,
                     0.000000000001692921,
                     0.000000000000607990,
                    -0.000000000000224338,
                    -0.000000000000200327,
                    -0.000000000000006246,
                     0.000000000000045571,
                     0.000000000000016383,
                    -0.000000000000005561,
                    -0.000000000000006074,
                    -0.000000000000000862,
                     0.000000000000001223,
                     0.000000000000000716,
                    -0.000000000000000024,
                    -0.000000000000000201,
                    -0.000000000000000082,
                     0.000000000000000017],
        :ae12 => [   0.582417495134726740,
                    -0.158348850905782750,
                    -0.006764275590323141,
                     0.005125843950185725,
                     0.000435232492169391,
                    -0.000143613366305483,
                    -0.000041801320556301,
                    -0.000002713395758640,
                     0.000001151381913647,
                     0.000000420650022012,
                     0.000000066581901391,
                     0.000000000662143777,
                    -0.000000002844104870,
                    -0.000000000940724197,
                    -0.000000000177476602,
                    -0.000000000015830222,
                     0.000000000002905732,
                     0.000000000001769356,
                     0.000000000000492735,
                     0.000000000000093709,
                     0.000000000000010707,
                    -0.000000000000000537,
                    -0.000000000000000716,
                    -0.000000000000000244,
                    -0.000000000000000058],
        :ae13 => [  -0.605773246640603460,
                    -0.112535243483660900,
                     0.013432266247902779,
                    -0.001926845187381145,
                     0.000309118337720603,
                    -0.000053564132129618,
                     0.000009827812880247,
                    -0.000001885368984916,
                     0.000000374943193568,
                    -0.000000076823455870,
                     0.000000016143270567,
                    -0.000000003466802211,
                     0.000000000758754209,
                    -0.000000000168864333,
                     0.000000000038145706,
                    -0.000000000008733026,
                     0.000000000002023672,
                    -0.000000000000474132,
                     0.000000000000112211,
                    -0.000000000000026804,
                     0.000000000000006457,
                    -0.000000000000001568,
                     0.000000000000000383,
                    -0.000000000000000094,
                     0.000000000000000023],
        :ae14 => [  -0.18929180007530170,
                    -0.08648117855259871,
                     0.00722410154374659,
                    -0.00080975594575573,
                     0.00010999134432661,
                    -0.00001717332998937,
                     0.00000298562751447,
                    -0.00000056596491457,
                     0.00000011526808397,
                    -0.00000002495030440,
                     0.00000000569232420,
                    -0.00000000135995766,
                     0.00000000033846628,
                    -0.00000000008737853,
                     0.00000000002331588,
                    -0.00000000000641148,
                     0.00000000000181224,
                    -0.00000000000052538,
                     0.00000000000015592,
                    -0.00000000000004729,
                     0.00000000000001463,
                    -0.00000000000000461,
                     0.00000000000000148,
                    -0.00000000000000048,
                     0.00000000000000016,
                    -0.00000000000000005]
    

    }

    def initialize coefficients, expansion_order, lower_interval_point, upper_interval_point, single_precision_order
      @coefficients = coefficients.is_a?(Symbol) ? DATA[coefficients] : coefficients
      @order        = expansion_order
      @lower_interval_point = lower_interval_point
      @upper_interval_point = upper_interval_point
      @single_precision_order = single_precision_order
    end
    #double * c;   /* coefficients                */
    #int order;    /* order of expansion          */
    #double a;     /* lower interval point        */
    #double b;     /* upper interval point        */
    #int order_sp; /* effective single precision order */

    attr_reader :lower_interval_point, :upper_interval_point, :single_precision_order, :order, :coefficients
    def a; @lower_interval_point; end
    def b; @upper_interval_point; end
    def order_sp; @single_precision_order; end
    def c(idx); @coefficients[idx]; end

    class << self
      def eval x, series = :lopx, with_error = false
        series_obj = Math.const_get "#{series.to_s.upcase}_CS"

        d  = 0.0
        dd = 0.0
        y  = (2.0*x - series_obj.a - series_obj.b) / (series_obj.b - series_obj.a)
        y2 = 2.0 * y

        e  = 0.0

        series_obj.order.downto(1) do |j|
          temp = d
          d    = y2*d - dd + series_obj.c(j)
          e   += (y2*temp).abs + dd.abs + series_obj.c(j).abs
          dd   = temp
        end

        begin
          temp = d
          d    = y*d - dd + 0.5 * series_obj.c(0)
          e   += (y*temp).abs + dd.abs + 0.5*series_obj.c(0).abs
        end

        with_error ? [d, Float::EPSILON*e + (series_obj.c(series_obj.order))] : d
      end
    end

  end

  LOPX_CS     = ChebyshevSeries.new(:lopx, 20, -1, 1, 10)
  LOPXMX_CS   = ChebyshevSeries.new(:lopxmx, 19, -1, 1, 9)
  GSTAR_A_CS  = ChebyshevSeries.new(:gstar_a, 29, -1, 1, 17)
  GSTAR_B_CS  = ChebyshevSeries.new(:gstar_b, 29, -1, 1, 18)
  E11_CS      = ChebyshevSeries.new(:e11, 18, -1, 1, 13)
  E12_CS      = ChebyshevSeries.new(:e12, 15, -1, -1, 10)
  AE11_CS     = ChebyshevSeries.new(:ae11, 38, -1, -1, 20)
  AE12_CS     = ChebyshevSeries.new(:ae12, 24, -1, -1, 15)
  AE13_CS     = ChebyshevSeries.new(:ae13, 24, -1, -1, 15)
  AE14_CS     = ChebyshevSeries.new(:ae14, 25, -1, 1, 13)
  

  module ExponentialIntegral
    class << self
      def first_order x, scale = 0, with_error = false
        xmaxt = -Math::LOG_FLOAT_MIN
        xmax  = xmaxt - Math.log(xmaxt)
        result = nil
        error  = with_error ? nil : 0.0

        if x < -xmax && !scale
          raise("Overflow Error")
        elsif x <= -10.0
          s = 1.0 / x * ( scale ? 1.0 : Math.exp(-x))
          result_c = ChebyshevSeries.eval(20.0/x+1.0, :ae11, with_error)
          result_c, result_c_err = result_c if with_error
          result   = s * (1.0 + result_c)
          error  ||= (s * result_c_err) + 2.0*Float::EPSILON * (x.abs + 1.0) * result.abs
        elsif x <= -4.0
          s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
          result_c = ChebyshevSeries.eval((40.0/x+7.0)/3.0, :ae12, with_error)
          result_c, result_c_err = result_c if with_error
          result   = s * (1.0 + result_c)
          error  ||= (s * result_c_err) + 2.0*Float::EPSILON * result.abs
        elsif x <= -1.0
          ln_term = - Math.log(x.abs)
          scale_factor = scale ? Math.exp(x) : 1.0
          result_c = ChebyshevSeries.eval((2.0*x+5.0)/3.0, :e11, with_error)
          result_c, result_c_err = result_c if with_error
          result   = scale_factor * (ln_term + result_c)
          error  ||= scale_factor * (result_c_err + Float::EPSILON * ln_term.abs) + 2.0*Float::EPSILON*result.abs
        elsif x == 0.0
          raise(ArgumentError, "Domain Error")
        elsif x <= 1.0
          ln_term = - Math.log(x.abs)
          scale_factor = scale ? Math.exp(x) : 1.0
          result_c = ChebyshevSeries.eval(x, :e12, with_error)
          result_c, result_c_err = result_c if with_error
          result   = scale_factor * (ln_term - 0.6875 + x + result_c)
          error  ||= scale_factor * (result_c_err + Float::EPSILON * ln_term.abs) + 2.0*Float::EPSILON*result.abs
        elsif x <= 4.0
          s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
          result_c = ChebyshevSeries.eval((8.0/x-5.0)/3.0, :ae13, with_error)
          result_c, result_c_err = result_c if with_error
          result   = s * (1.0 + result_c)
          error  ||= (s * result_c_err) + 2.0*Float::EPSILON * result.abs
        elsif x <= xmax || scale
          s = 1.0 / x * (scale ? 1.0 : Math.exp(-x))
          result_c = ChebyshevSeries.eval(8.0/x-1.0, :ae14, with_error)
          result_c, result_c_err = result_c if with_error
          result   = s * (1.0 + result_c)
          error  ||= s * (Float::EPSILON + result_c_err) + 2.0*(x+1.0)*Float::EPSILON * result.abs
          raise("Underflow Error") if result == 0.0
        else
          raise("Underflow Error")
        end
        with_error ? [result, error] : result
      end
    end
  end

  module Log
    C1 = -0.5
    C2 =  1.0/3.0
    C3 = -1.0/4.0
    C4 =  1.0/5.0
    C5 = -1.0/6.0
    C6 =  1.0/7.0
    C7 = -1.0/8.0
    C8 =  1.0/9.0
    C9 = -1.0/10.0
    class << self
      # \log(1+x)-x for x > -1
      # gsl_sf_log_1plusx_mx_e
      def log_1plusx_minusx x, with_error = false
        raise(ArgumentError, "Range error: x must be > -1") unless x > -1
        #return with_error ? [-1/0.0, 0] : -1/0.0 if x == 0.0 # -Infinity: For Ruby.

        result = nil
        error  = nil
        if x.abs < Math::ROOT6_FLOAT_EPSILON
          t = C5 + x*(C6 + x*(C7 + x*(C8 + x*C9)))
          result = x * (1.0 + x*(C1 + x*(C2 + x*(C3 + x*(C4 + x*t)))))
          error = Float::EPSILON * result.abs
        elsif x.abs < 0.5
          t = 0.5*(8.0*x + 1.0)/(x+2.0)
          c = ChebyshevSeries.eval(t, :lopxmx, with_error)
          return with_error ? [x*x*c.first, x*x*c.last] : x*x*c
        else
          lterm = Math.log(1.0+x)
          error = Float::EPSILON * (lterm.abs + x.abs) if with_error
          result = lterm - x
        end

        with_error ? [result, error] : result
      end
    end
  end


  module Gammastar
    C0 =  1.0/12.0
    C1 = -1.0/360.0
    C2 =  1.0/1260.0
    C3 = -1.0/1680.0
    C4 =  1.0/1188.0
    C5 = -691.0/360360.0
    C6 =  1.0/156.0
    C7 = -3617.0/122400.0

    class << self
      def series x, with_error = false
        # Use the Stirling series for the correction to Log(Gamma(x)),
        # which is better behaved and easier to compute than the
        # regular Stirling series for Gamma(x).
        y      = 1.0/(x*x);
        ser    = C0 + y*(C1 + y*(C2 + y*(C3 + y*(C4 + y*(C5 + y*(C6 + y*C7))))))
        result = Math.exp(ser/x)
        with_error ? [result, 2.0 * Float::EPSILON * result * [1.0, ser/x].max] : result
      end

      def eval x, with_error = false
        raise(ArgumentError, "x must be positive") unless x > 0.0
        if x < 0.5
          STDERR.puts("Warning: Don't know error on lg_x, error for this function will be incorrect") if with_error
          lg_x = Math.loggamma(x)
          lg_x_error = Float::EPSILON # Guess
          ln_x = Math.log(x)
          c    = 0.5 * (LN2+LNPI)
          lnr_val = lg_x - (x-0.5)*ln_x + x - c
          lnr_err = lg_x_error + 2.0*Float::EPSILON * ((x+0.5)*ln_x.abs + c)
          with_error ? [lnr_val, lnr_err] : lnr_val
        elsif x < 2.0
          t = 4.0/3.0*(x-0.5) - 1.0
          ChebyshevSeries.eval(t, :gstar_a, with_error)
        elsif x < 10.0
          t = 0.25*(x-2.0) - 1.0
          c = ChebyshevSeries.eval(t, :gstar_b, with_error)
          c, c_err = c if with_error

          result      = c / (x*x) + 1.0 + 1.0/(12.0*x)
          with_error ? [result, c_err / (x*x) + 2.0*Float::EPSILON*result.abs] : result
        elsif x < 1.0/Math::ROOT4_FLOAT_EPSILON
          series x, with_error
        elsif x < 1.0 / Float::EPSILON # Stirling
          xi = 1.0 / x
          result = 1.0 + xi/12.0*(1.0 + xi/24.0*(1.0 - xi*(139.0/180.0 + 571.0/8640.0*xi)))
          result_err = 2.0 * Float::EPSILON * result.abs
          with_error ? [result,result_err] : result
        else
          with_error ? [1.0,1.0/x] : 1.0
        end
      end
    end
  end

  module IncompleteGamma
    NMAX  = 5000
    SMALL = Float::EPSILON ** 3
    PG21  = -2.404113806319188570799476 # PolyGamma[2,1]
      
    class << self

      # Helper function for plot
      #def range_to_array r
      #  r << (r.last - r.first)/100.0 if r.size == 2 # set dr as Dr/100.0
      #  arr = []
      #  pos = r[0]
      #  while pos <= r[1]
      #    arr << pos
      #    pos += r[2]
      #  end
      #  arr
      #end
      #
      #def plot a, x_range, fun = :p
      #  x_range = range_to_array(x_range) if x_range.is_a?(Array)
      #  y_range = x_range.collect { |x| self.send(fun, a, x) }
      #  graph = Statsample::Graph::Scatterplot.new x_range.to_scale, y_range.to_scale
      #  f = File.new("test.svg", "w")
      #  f.puts(graph.to_svg)
      #  f.close
      #  `google-chrome test.svg`
      #end

      # The dominant part, D(a,x) := x^a e^(-x) / Gamma(a+1)
      # gamma_inc_D in GSL-1.9.
      def d a, x, with_error = false
        error = nil
        if a < 10.0
          puts "A"
          ln_a = Math.loggamma(a+1.0)
          lnr  = a * Math.log(x) - x - ln_a
          result = Math.exp(lnr)
          error = 2.0 * Float::EPSILON * (lnr.abs + 1.0) + result.abs if with_error
          with_error ? [result,error] : result
        else
          ln_term = ln_term_error = nil
          if x < 0.5*a
            puts "B"
            u       = x/a.to_f
            ln_u    = Math.log(u)
            ln_term = ln_u - u + 1.0
            ln_term_error = (ln_u.abs + u.abs + 1.0) * Float::EPSILON if with_error
          else
            puts "C"
            mu      = (x-a)/a.to_f
            ln_term = Log::log_1plusx_minusx(mu, with_error)
            ln_term, ln_term_error = ln_term if with_error
          end
          gstar = Gammastar.eval(a, with_error)
          gstar,gstar_error = gstar if with_error
          term1 = Math.exp(a*ln_term) / Math.sqrt(2.0*Math::PI*a)
          result = term1/gstar
          error  = 2.0*Float::EPSILON*((a*ln_term).abs+1.0) * result.abs + gstar_error/gstar.abs * result.abs if with_error
          with_error ? [result,error] : result
        end
      end

      # gamma_inc_P_series
      def p_series(a,x,with_error=false)
        d = d(a,x,with_error)
        d, d_err = d if with_error
        sum      = 1.0
        term     = 1.0
        n        = 1
        1.upto(NMAX-1) do |n|
          term *= x / (a+n).to_f
          sum  += term
          break if (term/sum).abs < Float::EPSILON
        end

        result   = d * sum

        if n == NMAX
          STDERR.puts("Error: n reached NMAX in p series")
        else
          return with_error ? [result,d_err * sum.abs + (1.0+n)*Float::EPSILON * result.abs] : result
        end
      end

      # This function does not exist in GSL, but is nonetheless GSL code. It's for calculating two specific ranges of p.
      def q_asymptotic_uniform_complement a,x,with_error=false
        q = q_asymptotic_uniform(a, x, with_error)
        q,q_err = q if with_error
        result = 1.0 - q
        return with_error ? [result, q_err + 2.0*Float::EPSILON*result.abs] : result
      end

      def q_continued_fraction_complement a,x,with_error=false
        q = q_continued_fraction(a,x,with_error)
        return with_error ? [1.0 - q.first, q.last + 2.0*Float::EPSILON*(1.0-q.first).abs] : 1.0 - q
      end

      def q_large_x_complement a,x,with_error=false
        q = q_large_x(a,x,with_error)
        return with_error ? [1.0 - q.first, q.last + 2.0*Float::EPSILON*(1.0-q.first).abs] : 1.0 - q
      end

      # The incomplete gamma function.
      # gsl_sf_gamma_inc_P_e
      def p a,x,with_error=false
        raise(ArgumentError, "Range Error: a must be positive, x must be non-negative") if a <= 0.0 || x < 0.0
        if x == 0.0
          puts "1"
          return with_error ? [0.0, 0.0] : 0.0
        elsif x < 20.0 || x < 0.5*a
          puts "2"
          return p_series(a, x, with_error)
        elsif a > 1e6 && (x-a)*(x-a) < a
          puts "3"
          return q_asymptotic_uniform_complement a, x, with_error
        elsif a <= x
          if a > 0.2*x
            puts "4"
            return q_continued_fraction_complement(a, x, with_error)
          else
            puts "5"
            return q_large_x_complement(a, x, with_error)
          end
        elsif (x-a)*(x-a) < a
          puts "6"
          return q_asymptotic_uniform_complement a, x, with_error
        else
          puts "7"
          return p_series(a, x, with_error)
        end
      end

      # gamma_inc_Q_e
      def q a,x,with_error=false
        raise(ArgumentError, "Range Error: a and x must be non-negative") if (a < 0.0 || x < 0.0)
        if x == 0.0
          return with_error ? [1.0, 0.0] : 1.0
        elsif a == 0.0
          return with_error ? [0.0, 0.0] : 0.0
        elsif x <= 0.5*a
          # If series is quick, do that.
          p = p_series(a,x, with_error)
          p,p_err = p if with_error
          result  = 1.0 - p
          return with_error ? [result, p_err + 2.0*Float::EPSILON*result.abs] : result
        elsif a >= 1.0e+06 && (x-a)*(x-a) < a # difficult asymptotic regime, only way to do this region
          return q_asymptotic_uniform(a, x, with_error)
        elsif a < 0.2 && x < 5.0
          return q_series(a,x, with_error)
        elsif a <= x
          return x <= 1.0e+06 ? q_continued_fraction(a, x, with_error) : q_large_x(a, x, with_error)
        else
          if x > a-Math.sqrt(a)
            return q_continued_fraction(a, x, with_error)
          else
            p = p_series(a, x, with_error)
            p, p_err = p if with_error
            result = 1.0 - p
            return with_error ? [result, p_err + 2.0*Float::EPSILON*result.abs] : result
          end
        end
      end

      # gamma_inc_Q_CF
      def q_continued_fraction a, x, with_error=false
        d = d(a, x, with_error)
        f = f_continued_fraction(a, x, with_error)

        if with_error
          [d.first*(a/x).to_f*f.first, d.last * ((a/x).to_f*f.first).abs + (d.first*a/x*f.last).abs]
        else
          d * (a/x).to_f * f
        end
      end

      # gamma_inc_Q_large_x in GSL-1.9
      def q_large_x a,x,with_error=false
        d = d(a,x,with_error)
        d,d_err = d if with_error
        sum  = 1.0
        term = 1.0
        last = 1.0
        n    = 1
        1.upto(NMAX-1).each do |n|
          term *= (a-n)/x
          break if (term/last).abs > 1.0
          break if (term/sum).abs < Float::EPSILON
          sum  += term
          last  = term
        end

        result = d*(a/x)*sum
        error  = d_err * (a/x).abs * sum if with_error
        
        if n == NMAX
          STDERR.puts("Error: n reached NMAX in q_large_x")
        else
          return with_error ? [result,error] : result
        end
      end

      # Uniform asymptotic for x near a, a and x large
      # gamma_inc_Q_asymp_unif
      def q_asymptotic_uniform(a, x, with_error = false)
        rta = Math.sqrt(a)
        eps = (x-a)/a.to_f

        ln_term = Log::log_1plusx_minusx(eps, with_error)
        ln_term, ln_term_err = ln_term if with_error

        eta     = (eps >= 0.0 ? 1 : -1) * Math.sqrt(-2.0*ln_term)

        erfc    = Math.erfc(eta*rta/SQRT2)
        STDERR.puts("Warning: Don't know error for Math.erfc, error will be incorrect'") if with_error
        erfc_err= Float::EPSILON # Guess
        
        c0 = c1 = nil
        if eps.abs < ROOT5_FLOAT_EPSILON
          c0 = -1.0/3.0 + eps*(1.0/12.0 - eps*(23.0/540.0 - eps*(353.0/12960.0 - eps*589.0/30240.0)))
          c1 = -1.0/540.0 - eps/288.0
        else
          rt_term = Math.sqrt(-2.0 * ln_term/(eps*eps))
          lam     = x/a
          c0      = (1.0 - 1.0/rt_term)/eps
          c1      = -(eta**3 * (lam*lam + 10.0*lam + 1.0) - 12.0 * eps**3) / (12.0 * eta**3 * eps**3)
        end

        r = Math.exp(-0.5*a*eta*eta) / (SQRT2*SQRTPI*rta) * (c0 + c1/a)

        result = 0.5 * erfc + r
        with_error ? [result, Float::EPSILON + (r*0.5*a*eta*eta).abs + 0.5*erfc_err + 2.0*Float::EPSILON + result.abs] : result
      end

      # gamma_inc_F_CF
      def f_continued_fraction a, x, with_error = false
        hn = 1.0 # convergent
        cn = 1.0 / SMALL
        dn = 1.0
        n  = 2
        2.upto(NMAX-1).each do |n|
          an = n.odd? ? 0.5*(n-1)/x : (0.5*n-a)/x
          dn = 1.0 + an * dn
          dn = SMALL if dn.abs < SMALL
          cn = 1.0 + an / cn
          cn = SMALL if cn.abs < SMALL
          dn = 1.0 / dn
          delta = cn * dn
          hn *= delta
          break if (delta-1.0).abs < Float::EPSILON
        end

        if n == NMAX
          STDERR.puts("Error: n reached NMAX in f continued fraction")
        else
          with_error ? [hn,2.0*Float::EPSILON * hn.abs + Float::EPSILON*(2.0+0.5*n) * hn.abs] : hn
        end
      end

      def q_series(a,x,with_error=false)
        term1 = nil
        sum   = nil
        term2 = nil
        begin
          lnx  = Math.log(x)
          el   = EULER + lnx
          c1   = -el
          c2   = Math::PI * Math::PI / 12.0 - 0.5*el*el
          c3   = el*(Math::PI*Math::PI/12.0 - el*el/6.0) + PG21/6.0
          c4   = -0.04166666666666666667 *
                    (-1.758243446661483480 + lnx) *
                    (-0.764428657272716373 + lnx) *
                    ( 0.723980571623507657 + lnx) *
                    ( 4.107554191916823640 + lnx)
          c5 = -0.0083333333333333333 *
                     (-2.06563396085715900 + lnx) *
                     (-1.28459889470864700 + lnx) *
                     (-0.27583535756454143 + lnx) *
                     ( 1.33677371336239618 + lnx) *
                     ( 5.17537282427561550 + lnx)
          c6 = -0.0013888888888888889 *
                       (-2.30814336454783200 + lnx) *
                       (-1.65846557706987300 + lnx) *
                       (-0.88768082560020400 + lnx) *
                       ( 0.17043847751371778 + lnx) *
                       ( 1.92135970115863890 + lnx) *
                       ( 6.22578557795474900 + lnx)
          c7 = -0.00019841269841269841
                       (-2.5078657901291800 + lnx) *
                       (-1.9478900888958200 + lnx) *
                       (-1.3194837322612730 + lnx) *
                       (-0.5281322700249279 + lnx) *
                       ( 0.5913834939078759 + lnx) *
                       ( 2.4876819633378140 + lnx) *
                       ( 7.2648160783762400 + lnx)
          c8 = -0.00002480158730158730 *
                       (-2.677341544966400 + lnx) *
                       (-2.182810448271700 + lnx) *
                       (-1.649350342277400 + lnx) *
                       (-1.014099048290790 + lnx) *
                       (-0.191366955370652 + lnx) *
                       ( 0.995403817918724 + lnx) *
                       ( 3.041323283529310 + lnx) *
                       ( 8.295966556941250 + lnx) *
          c9 = -2.75573192239859e-6 *
                       (-2.8243487670469080 + lnx) *
                       (-2.3798494322701120 + lnx) *
                       (-1.9143674728689960 + lnx) *
                       (-1.3814529102920370 + lnx) *
                       (-0.7294312810261694 + lnx) *
                       ( 0.1299079285269565 + lnx) *
                       ( 1.3873333251885240 + lnx) *
                       ( 3.5857258865210760 + lnx) *
                       ( 9.3214237073814600 + lnx) *
          c10 = -2.75573192239859e-7 *
                       (-2.9540329644556910 + lnx) *
                       (-2.5491366926991850 + lnx) *
                       (-2.1348279229279880 + lnx) *
                       (-1.6741881076349450 + lnx) *
                       (-1.1325949616098420 + lnx) *
                       (-0.4590034650618494 + lnx) *
                       ( 0.4399352987435699 + lnx) *
                       ( 1.7702236517651670 + lnx) *
                       ( 4.1231539047474080 + lnx) *
                       ( 10.342627908148680 + lnx)
          term1 = a*(c1+a*(c2+a*(c3+a*(c4+a*(c5+a*(c6+a*(c7+a*(c8+a*(c9+a*c10)))))))))
        end

        n   = 1
        begin
          t   = 1.0
          sum = 1.0
          1.upto(NMAX-1).each do |n|
            t   *= -x/(n+1.0)
            sum += (a+1.0) / (a+n+1.0) * t
            break if (t/sum).abs < Float::EPSILON
          end
        end

        if n == NMAX
          STDERR.puts("Error: n reached NMAX in q_series")
        else
          term2 = (1.0 - term1) * a/(a+1.0) * x * sum
          result = term1+term2
          with_error ? [result, Float::EPSILON*term1.abs + 2.0*term2.abs + 2.0*Float::EPSILON*result.abs] : result
        end
      end

      # gamma_inc_series
      def series a,x,with_error = false
        q = q_series(a,x,with_error)
        g = Math.gamma(a)
        STDERR.puts("Warning: Don't know error for Math.gamma. Error will be incorrect") if with_error
        # When we get the error from Gamma, switch the comment on the next to lines
        # with_error ? [q.first*g.first, (q.first*g.last).abs + (q.last*g.first).abs + 2.0*Float::EPSILON*(q.first*g.first).abs] : q*g
        with_error ? [q.first*g, (q.first*Float::EPSILON).abs + (q.last*g.first).abs + 2.0*Float::EPSILON(q.first*g).abs] : q*g
      end

      # gamma_inc_a_gt_0
      def a_greater_than_0 a, x, with_error = false
        q       = q(a,x,with_error)
        q,q_err = q if with_error
        g       = Math.gamma(a)
        STDERR.puts("Warning: Don't know error for Math.gamma. Error will be incorrect") if with_error
        g_err   = Float::EPSILON
        result  = g*q
        error   = (g*q_err).abs + (g_err*q).abs if with_error
        with_error ? [result,error] : result
      end

      # gamma_inc_CF
      def continued_fraction a,x, with_error=false
        f = f_continued_fraction(a,x,with_error)
        f,f_error = f if with_error
        pre = Math.exp((a-1.0)*Math.log(x) - x)
        STDERR.puts("Warning: Don't know error for Math.exp. Error will be incorrect") if with_error
        pre_error = Float::EPSILON
        result    = f*pre
        if with_error
          error     = (f_error*pre).abs + (f*pre_error) + (2.0+a.abs)*Float::EPSILON*result.abs
          [result,error]
        else
          result
        end
      end

      # Unnormalized incomplete gamma function.
      # gsl_sf_gamma_inc_e
      def unnormalized a,x,with_error = false
        raise(ArgumentError, "x cannot be negative") if x < 0.0

        if x == 0.0
          result  = Math.gamma(a.to_f)
          STDERR.puts("Warning: Don't know error for Math.gamma. Error will be incorrect") if with_error
          return with_error ? [result, Float::EPSILON] : result
        elsif a == 0.0
          return ExponentialIntegral.first_order(x.to_f, with_error)
        elsif a > 0.0
          return a_greater_than_0(a.to_f, x.to_f, with_error)
        elsif x > 0.25
          # continued fraction seems to fail for x too small
          return continued_fraction(a.to_f, x.to_f, with_error)
        elsif a.abs < 0.5
          return series(a.to_f,x.to_f,with_error)
        else
          fa = a.floor.to_f
          da = a - fa
          g_da = da > 0.0 ? a_greater_than_0(da, x.to_f, with_error) : ExponentialIntegral.first_order(x.to_f, with_error)
          g_da, g_da_err = g_da if with_error
          alpha = da
          gax = g_da

          # Gamma(alpha-1,x) = 1/(alpha-1) (Gamma(a,x) - x^(alpha-1) e^-x)
          begin
            shift  = Math.exp(-x + (alpha-1.0)*Math.log(x))
            gax    = (gax-shift) / (alpha-1.0)
            alpha -= 1.0
          end while alpha > a

          result = gax
          return with_error ? [result, 2.0*(1.0 + a.abs) * Float::EPSILON*gax.abs] : result
        end
      end

    end
  end
end
end