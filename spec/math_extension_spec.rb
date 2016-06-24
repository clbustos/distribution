require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::MathExtension do
  it 'binomial coefficient should be correctly calculated' do
    n = 50
    n.times do |k|
      expect(Math.binomial_coefficient(n, k)).to eq(Math.factorial(n).quo(Math.factorial(k) * Math.factorial(n - k))), "not correct for k=#{k}"
    end
  end

  it 'ChebyshevSeries for :sin should return correct values' do
    # Math::SIN_CS.evaluate()
  end

  it 'log_1plusx_minusx should return correct values' do
    # Tests from GSL-1.9
    expect(Math::Log.log_1plusx_minusx(1.0e-10)).to be_within(1e-10).of(-4.999999999666666667e-21)
    expect(Math::Log.log_1plusx_minusx(1.0e-8)).to be_within(1e-10).of(-4.999999966666666917e-17)
    expect(Math::Log.log_1plusx_minusx(1.0e-4)).to be_within(1e-10).of(-4.999666691664666833e-09)
    expect(Math::Log.log_1plusx_minusx(0.1)).to be_within(1e-10).of(-0.004689820195675139956)
    expect(Math::Log.log_1plusx_minusx(0.49)).to be_within(1e-10).of(-0.09122388004263222704)

    expect(Math::Log.log_1plusx_minusx(-0.49)).to be_within(1e-10).of(-0.18334455326376559639)
    expect(Math::Log.log_1plusx_minusx(1.0)).to be_within(1e-10).of(Math::LN2 - 1.0)
    expect(Math::Log.log_1plusx_minusx(-0.99)).to be_within(1e-10).of(-3.615170185988091368)
  end

  it 'log_1plusx should return correct values' do
    # Tests from GSL-1.9
    expect(Math::Log.log_1plusx(1.0e-10)).to be_within(1e-10).of(9.999999999500000000e-11)
    expect(Math::Log.log_1plusx(1.0e-8)).to be_within(1e-10).of(9.999999950000000333e-09)
    expect(Math::Log.log_1plusx(1.0e-4)).to be_within(1e-10).of(0.00009999500033330833533)
    expect(Math::Log.log_1plusx(0.1)).to be_within(1e-10).of(0.09531017980432486004)
    expect(Math::Log.log_1plusx(0.49)).to be_within(1e-10).of(0.3987761199573677730)

    expect(Math::Log.log_1plusx(-0.49)).to be_within(1e-10).of(-0.6733445532637655964)
    expect(Math::Log.log_1plusx(1.0)).to be_within(1e-10).of(Math::LN2)
    expect(Math::Log.log_1plusx(-0.99)).to be_within(1e-10).of(-4.605170185988091368)
  end

  it 'log_beta should return correct values' do
    expect(Math::Beta.log_beta(1.0e-8, 1.0e-8).first).to be_within(1e-10).of(19.113827924512310617)
    expect(Math::Beta.log_beta(1.0e-8, 0.01).first).to be_within(1e-10).of(18.420681743788563403)
    expect(Math::Beta.log_beta(1.0e-8, 1.0).first).to be_within(1e-10).of(18.420680743952365472)
    expect(Math::Beta.log_beta(1.0e-8, 10.0).first).to be_within(1e-10).of(18.420680715662683009)
    expect(Math::Beta.log_beta(1.0e-8, 1000.0).first).to be_within(1e-10).of(18.420680669107656949)
    expect(Math::Beta.log_beta(0.1, 0.1).first).to be_within(1e-10).of(2.9813614810376273949)
    expect(Math::Beta.log_beta(0.1, 1.0).first).to be_within(1e-10).of(2.3025850929940456840)
    expect(Math::Beta.log_beta(0.1, 100.0).first).to be_within(1e-10).of(1.7926462324527931217)
    expect(Math::Beta.log_beta(0.1, 1000).first).to be_within(1e-10).of(1.5619821298353164928)
    expect(Math::Beta.log_beta(1.0, 1.00025).first).to be_within(1e-10).of(-0.0002499687552073570)
    expect(Math::Beta.log_beta(1.0, 1.01).first).to be_within(1e-10).of(-0.009950330853168082848)
    expect(Math::Beta.log_beta(1.0, 1000.0).first).to be_within(1e-10).of(-6.907755278982137052)
    expect(Math::Beta.log_beta(100.0, 100.0).first).to be_within(1e-10).of(-139.66525908670663927)
    expect(Math::Beta.log_beta(100.0, 1000.0).first).to be_within(1e-10).of(-336.4348576477366051)
    expect(Math::Beta.log_beta(100.0, 1.0e+8).first).to be_within(1e-10).of(-1482.9339185256447309)
  end

  it 'regularized_beta should return correct values' do
    expect(Math.regularized_beta(0.0, 1.0, 1.0)).to be_within(1e-10).of(0.0)
    expect(Math.regularized_beta(1.0, 1.0, 1.0)).to be_within(1e-10).of(1.0)
    expect(Math.regularized_beta(1.0, 0.1, 0.1)).to be_within(1e-10).of(1.0)
    expect(Math.regularized_beta(0.5, 1.0,  1.0)).to be_within(1e-10).of(0.5)
    expect(Math.regularized_beta(0.5, 0.1,  1.0)).to be_within(1e-10).of(0.9330329915368074160)
    expect(Math.regularized_beta(0.5, 10.0,  1.0)).to be_within(1e-10).of(0.0009765625000000000000)
    expect(Math.regularized_beta(0.5, 50.0,  1.0)).to be_within(1e-10).of(8.881784197001252323e-16)
    expect(Math.regularized_beta(0.5, 1.0,  0.1)).to be_within(1e-10).of(0.06696700846319258402)
    expect(Math.regularized_beta(0.5, 1.0, 10.0)).to be_within(1e-10).of(0.99902343750000000000)
    expect(Math.regularized_beta(0.5, 1.0, 50.0)).to be_within(1e-10).of(0.99999999999999911180)
    expect(Math.regularized_beta(0.1, 1.0,  1.0)).to be_within(1e-10).of(0.10)
    expect(Math.regularized_beta(0.1, 1.0,  2.0)).to be_within(1e-10).of(0.19)
    expect(Math.regularized_beta(0.9, 1.0,  2.0)).to be_within(1e-10).of(0.99)
    expect(Math.regularized_beta(0.5, 50.0, 60.0)).to be_within(1e-10).of(0.8309072939016694143)
    expect(Math.regularized_beta(0.5, 90.0, 90.0)).to be_within(1e-10).of(0.5)
    expect(Math.regularized_beta(0.5, 500.0,  500.0)).to be_within(1e-10).of(0.5)
    expect(Math.regularized_beta(0.4, 5000.0, 5000.0)).to be_within(1e-10).of(4.518543727260666383e-91)
    expect(Math.regularized_beta(0.6, 5000.0, 5000.0)).to be_within(1e-10).of(1.0)
    expect(Math.regularized_beta(0.6, 5000.0, 2000.0)).to be_within(1e-10).of(8.445388773903332659e-89)
  end
  it_only_with_gsl 'incomplete_beta should return correct values' do
    a = rand * 10 + 1
    b = rand * 10 + 1
    ib = GSL::Function.alloc { |t|  t**(a - 1) * (1 - t)**(b - 1) }
    w = GSL::Integration::Workspace.alloc(1000)
    1.upto(10) {|x|
      inte = ib.qag([0, x / 10.0], w)
      expect(Math.incomplete_beta(x / 10.0, a, b)).to be_within(1e-10).of(inte[0])
    }
  end

  it 'gammastar should return correct values' do
    # Tests from GSL-1.9
    expect(Math::Gammastar.evaluate(1.0e-08)).to be_within(1e-10).of(3989.423555759890865)
    expect(Math::Gammastar.evaluate(1.0e-05)).to be_within(1e-10).of(126.17168469882690233)
    expect(Math::Gammastar.evaluate(0.001)).to be_within(1e-10).of(12.708492464364073506)
    expect(Math::Gammastar.evaluate(1.5)).to be_within(1e-10).of(1.0563442442685598666)
    expect(Math::Gammastar.evaluate(3.0)).to be_within(1e-10).of(1.0280645179187893045)
    expect(Math::Gammastar.evaluate(9.0)).to be_within(1e-10).of(1.0092984264218189715)
    expect(Math::Gammastar.evaluate(11.0)).to be_within(1e-10).of(1.0076024283104962850)
    expect(Math::Gammastar.evaluate(100.0)).to be_within(1e-10).of(1.0008336778720121418)
    expect(Math::Gammastar.evaluate(1.0e+05)).to be_within(1e-10).of(1.0000008333336805529)
    expect(Math::Gammastar.evaluate(1.0e+20)).to be_within(1e-10).of(1.0)
  end

  it 'erfc_e should return correct values' do
    # From GSL-1.9. For troubleshooting gammq.
    expect(Math.erfc_e(-10.0)).to be_within(1e-10).of(2.0)
    expect(Math.erfc_e(-5.0000002)).to be_within(1e-10).of(1.9999999999984625433)
    expect(Math.erfc_e(-5.0)).to be_within(1e-10).of(1.9999999999984625402)
    expect(Math.erfc_e(-1.0)).to be_within(1e-10).of(1.8427007929497148693)
    expect(Math.erfc_e(-0.5)).to be_within(1e-10).of(1.5204998778130465377)
    expect(Math.erfc_e(1.0)).to be_within(1e-10).of(0.15729920705028513066)
    expect(Math.erfc_e(3.0)).to be_within(1e-10).of(0.000022090496998585441373)
    expect(Math.erfc_e(7.0)).to be_within(1e-10).of(4.183825607779414399e-23)
    expect(Math.erfc_e(10.0)).to be_within(1e-10).of(2.0884875837625447570e-45)
  end

  it 'unnormalized_incomplete_gamma with x=0 should return correct values' do
    expect(Math.unnormalized_incomplete_gamma(-1.5, 0)).to be_within(1e-10).of(4.0 * Math.sqrt(Math::PI) / 3.0)
    expect(Math.unnormalized_incomplete_gamma(-0.5, 0)).to be_within(1e-10).of(-2 * Math.sqrt(Math::PI))
    expect(Math.unnormalized_incomplete_gamma(0.5, 0)).to be_within(1e-10).of(Math.sqrt(Math::PI))
    expect(Math.unnormalized_incomplete_gamma(1.0, 0)).to eq 1.0
    expect(Math.unnormalized_incomplete_gamma(1.5, 0)).to be_within(1e-10).of(Math.sqrt(Math::PI) / 2.0)
    expect(Math.unnormalized_incomplete_gamma(2.0, 0)).to eq 1.0
    expect(Math.unnormalized_incomplete_gamma(2.5, 0)).to be_within(1e-10).of(0.75 * Math.sqrt(Math::PI))

    expect(Math.unnormalized_incomplete_gamma(3.0, 0)).to be_within(1e-12).of(2.0)

    expect(Math.unnormalized_incomplete_gamma(3.5, 0)).to be_within(1e-10).of(15.0 * Math.sqrt(Math::PI) / 8.0)
    expect(Math.unnormalized_incomplete_gamma(4.0, 0)).to be_within(1e-12).of(6.0)
  end

  it 'incomplete_gamma should return correct values' do
    # Tests from GSL-1.9
    expect(Math.incomplete_gamma(1e-100, 0.001)).to be_within(1e-10).of(1.0)
    expect(Math.incomplete_gamma(0.001, 0.001)).to be_within(1e-10).of(0.9936876467088602902)
    expect(Math.incomplete_gamma(0.001, 1.0)).to be_within(1e-10).of(0.9997803916424144436)
    expect(Math.incomplete_gamma(0.001, 10.0)).to be_within(1e-10).of(0.9999999958306921828)
    expect(Math.incomplete_gamma(1.0, 0.001)).to be_within(1e-10).of(0.0009995001666250083319)
    expect(Math.incomplete_gamma(1.0, 1.01)).to be_within(1e-10).of(0.6357810204284766802)
    expect(Math.incomplete_gamma(1.0, 10.0)).to be_within(1e-10).of(0.9999546000702375151)
    expect(Math.incomplete_gamma(10.0, 10.01)).to be_within(1e-10).of(0.5433207586693410570)
    expect(Math.incomplete_gamma(10.0, 20.0)).to be_within(1e-10).of(0.9950045876916924128)
    expect(Math.incomplete_gamma(1000.0, 1000.1)).to be_within(1e-10).of(0.5054666401440661753)
    expect(Math.incomplete_gamma(1000.0, 2000.0)).to be_within(1e-10).of(1.0)

    # designed to trap the a-x=1 problem
    # These next two are 1e-7 because they give the same output as GSL, but GSL is apparently not totally accurate here.
    # It's a problem with log_1plusx_mx (log_1plusx_minusx in my code)
    expect(Math.incomplete_gamma(100,  99.0)).to be_within(1e-7).of(0.4733043303994607)
    expect(Math.incomplete_gamma(200, 199.0)).to be_within(1e-7).of(0.4811585880878718)

    # Test for x86 cancellation problems
    expect(Math.incomplete_gamma(5670, 4574)).to be_within(1e-10).of(3.063972328743934e-55)
  end

  it 'gammq should return correct values' do
    # Tests from GSL-1.9
    expect(Math.gammq(0.0, 0.001)).to be_within(1e-10).of(0.0)
    expect(Math.gammq(0.001, 0.001)).to be_within(1e-10).of(0.006312353291139709793)
    expect(Math.gammq(0.001, 1.0)).to be_within(1e-10).of(0.00021960835758555639171)
    expect(Math.gammq(0.001, 2.0)).to be_within(1e-10).of(0.00004897691783098147880)
    expect(Math.gammq(0.001, 5.0)).to be_within(1e-10).of(1.1509813397308608541e-06)
    expect(Math.gammq(1.0, 0.001)).to be_within(1e-10).of(0.9990004998333749917)
    expect(Math.gammq(1.0, 1.01)).to be_within(1e-10).of(0.3642189795715233198)
    expect(Math.gammq(1.0, 10.0)).to be_within(1e-10).of(0.00004539992976248485154)
    expect(Math.gammq(10.0, 10.01)).to be_within(1e-10).of(0.4566792413306589430)
    expect(Math.gammq(10.0, 100.0)).to be_within(1e-10).of(1.1253473960842733885e-31)
    expect(Math.gammq(1000.0, 1000.1)).to be_within(1e-10).of(0.4945333598559338247)
    expect(Math.gammq(1000.0, 2000.0)).to be_within(1e-10).of(6.847349459614753180e-136)

    # designed to trap the a-x=1 problem
    expect(Math.gammq(100,  99.0)).to be_within(1e-10).of(0.5266956696005394)
    expect(Math.gammq(200, 199.0)).to be_within(1e-10).of(0.5188414119121281)

    # Test for x86 cancellation problems
    expect(Math.gammq(5670, 4574)).to be_within(1e-10).of(1.0000000000000000)

    # test suggested by Michel Lespinasse [gsl-discuss Sat, 13 Nov 2004]
    expect(Math.gammq(1.0e+06 - 1.0, 1.0e+06 - 2.0)).to be_within(1e-10).of(0.50026596175224547004)

    # tests in asymptotic regime related to Lespinasse test
    expect(Math.gammq(1.0e+06 + 2.0, 1.0e+06 + 1.0)).to be_within(1e-10).of(0.50026596135330304336)
    expect(Math.gammq(1.0e+06, 1.0e+06 - 2.0)).to be_within(1e-10).of(0.50066490399940144811)
    expect(Math.gammq(1.0e+07, 1.0e+07 - 2.0)).to be_within(1e-10).of(0.50021026104978614908)
  end

  it 'rising_factorial should return correct values' do
    x = rand(10) + 1
    expect(Math.rising_factorial(x, 0)).to eq 1
    expect(Math.rising_factorial(x, 1)).to eq x
    expect(Math.rising_factorial(x, 2)).to eq x**2 + x
    expect(Math.rising_factorial(x, 3)).to eq x**3 + 3 * x**2 + 2 * x
    expect(Math.rising_factorial(x, 4)).to eq x**4 + 6 * x**3 + 11 * x**2 + 6 * x
  end

  it 'permutations should return correct values' do
    n = rand(50) + 50
    10.times { |k|
      expect(Math.permutations(n, k)).to eq(Math.factorial(n) / Math.factorial(n - k))
    }

    expect(Math.permutations(n, n)).to eq(Math.factorial(n) / Math.factorial(n - n))
  end

  it 'exact regularized incomplete beta should behave properly' do
    expect(Math.exact_regularized_beta(0.5, 5, 5)).to be_within(1e-6).of(0.5)
    expect(Math.exact_regularized_beta(0.5, 5, 6)).to be_within(1e-6).of(0.6230469)
    expect(Math.exact_regularized_beta(0.5, 5, 7)).to be_within(1e-6).of(0.725586)

    a = 5
    b = 5
    expect(Math.exact_regularized_beta(0, a, b)).to eq 0
    expect(Math.exact_regularized_beta(1, a, b)).to eq 1
    x = rand

    expect(Math.exact_regularized_beta(x, a, b)).to be_within(1e-6). of(1 - Math.regularized_beta(1 - x, b, a))
  end

  it 'binomial coefficient(gamma) with n<=48 should be correct ' do
    [1, 5, 10, 25, 48].each {|n|
      k = (n / 2).to_i
      expect(Math.binomial_coefficient_gamma(n, k).round).to eq(Math.binomial_coefficient(n, k))
    }
  end

  it 'binomial coefficient(gamma) with 48<n<1000 should have 11 correct digits' do
    [50, 100, 200, 1000].each {|n|
      k = (n / 2).to_i
      obs = Math.binomial_coefficient_gamma(n, k).to_i.to_s[0, 11]
      exp = Math.binomial_coefficient(n, k).to_i.to_s[0, 11]

      expect(obs).to eq(exp)
    }
  end

  describe Distribution::MathExtension::SwingFactorial do
    it 'Math.factorial should return correct values x<20' do
      ac = 3_628_800 # 10!
      11.upto(19).each do |i|
        ac *= i
        expect(Math.factorial(i)).to eq(ac)
      end
    end

    it 'Math.factorial should return correct values for values 21<x<33' do
      ac = 2_432_902_008_176_640_000 # 20!
      21.upto(33).each do |i|
        ac *= i
        expect(Math.factorial(i)).to eq(ac)
      end
    end

    it 'Math.factorial should return correct values for values x>33' do
      ac = 8_683_317_618_811_886_495_518_194_401_280_000_000 # 33!
      expect(Math.factorial(33)).to eq ac
      34.upto(40).each do |i|
        ac *= i
        expect(Math.factorial(i)).to eq(ac)
      end
    end
  end
end
