require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
include ExampleWithGSL
describe Distribution::MathExtension do
  it "binomial coefficient should be correctly calculated" do
    
    n=50
    n.times do |k|
      Math.binomial_coefficient(n,k).should eq(Math.factorial(n).quo(Math.factorial(k)*Math.factorial(n-k)))
    end
  end

  it "ChebyshevSeries for :sin should return correct values" do
    #Math::SIN_CS.evaluate()
  end

  it "log_1plusx_minusx should return correct values" do
    # Tests from GSL-1.9
    Math::Log.log_1plusx_minusx(1.0e-10).should be_within(1e-10).of(-4.999999999666666667e-21)
    Math::Log.log_1plusx_minusx(1.0e-8).should  be_within(1e-10).of(-4.999999966666666917e-17)
    Math::Log.log_1plusx_minusx(1.0e-4).should  be_within(1e-10).of(-4.999666691664666833e-09)
    Math::Log.log_1plusx_minusx(0.1).should     be_within(1e-10).of(-0.004689820195675139956)
    Math::Log.log_1plusx_minusx(0.49).should    be_within(1e-10).of(-0.09122388004263222704)

    Math::Log.log_1plusx_minusx(-0.49).should   be_within(1e-10).of(-0.18334455326376559639)
    Math::Log.log_1plusx_minusx(1.0).should     be_within(1e-10).of(Math::LN2 - 1.0)
    Math::Log.log_1plusx_minusx(-0.99).should   be_within(1e-10).of(-3.615170185988091368)
  end

  it "log_1plusx should return correct values" do
    # Tests from GSL-1.9
    Math::Log.log_1plusx(1.0e-10).should be_within(1e-10).of(9.999999999500000000e-11)
    Math::Log.log_1plusx(1.0e-8).should  be_within(1e-10).of(9.999999950000000333e-09)
    Math::Log.log_1plusx(1.0e-4).should  be_within(1e-10).of(0.00009999500033330833533)
    Math::Log.log_1plusx(0.1).should     be_within(1e-10).of(0.09531017980432486004)
    Math::Log.log_1plusx(0.49).should    be_within(1e-10).of(0.3987761199573677730)

    Math::Log.log_1plusx(-0.49).should   be_within(1e-10).of(-0.6733445532637655964)
    Math::Log.log_1plusx(1.0).should     be_within(1e-10).of(Math::LN2)
    Math::Log.log_1plusx(-0.99).should   be_within(1e-10).of(-4.605170185988091368)
  end

  it "log_beta should return correct values" do
    Math::Beta.log_beta(1.0e-8, 1.0e-8).first.should be_within(1e-10).of(19.113827924512310617)
    Math::Beta.log_beta(1.0e-8, 0.01).first.should be_within(1e-10).of(18.420681743788563403)
    Math::Beta.log_beta(1.0e-8, 1.0).first.should be_within(1e-10).of(18.420680743952365472)
    Math::Beta.log_beta(1.0e-8, 10.0).first.should be_within(1e-10).of(18.420680715662683009)
    Math::Beta.log_beta(1.0e-8, 1000.0).first.should be_within(1e-10).of(18.420680669107656949)
    Math::Beta.log_beta(0.1, 0.1).first.should be_within(1e-10).of(2.9813614810376273949)
    Math::Beta.log_beta(0.1, 1.0).first.should be_within(1e-10).of(2.3025850929940456840)
    Math::Beta.log_beta(0.1, 100.0).first.should be_within(1e-10).of(1.7926462324527931217)
    Math::Beta.log_beta(0.1, 1000).first.should be_within(1e-10).of(1.5619821298353164928)
    Math::Beta.log_beta(1.0, 1.00025).first.should be_within(1e-10).of(-0.0002499687552073570)
    Math::Beta.log_beta(1.0, 1.01).first.should be_within(1e-10).of(-0.009950330853168082848)
    Math::Beta.log_beta(1.0, 1000.0).first.should be_within(1e-10).of(-6.907755278982137052)
    Math::Beta.log_beta(100.0, 100.0).first.should be_within(1e-10).of(-139.66525908670663927)
    Math::Beta.log_beta(100.0, 1000.0).first.should be_within(1e-10).of(-336.4348576477366051)
    Math::Beta.log_beta(100.0, 1.0e+8).first.should be_within(1e-10).of(-1482.9339185256447309)
  end

  it "regularized_beta should return correct values" do
    Math.regularized_beta(0.0,1.0, 1.0).should be_within(1e-10).of(0.0)
    Math.regularized_beta(1.0, 1.0, 1.0).should be_within(1e-10).of(1.0)
    Math.regularized_beta(1.0, 0.1, 0.1).should be_within(1e-10).of(1.0)
    Math.regularized_beta(0.5, 1.0,  1.0).should be_within(1e-10).of(0.5)
    Math.regularized_beta(0.5, 0.1,  1.0).should be_within(1e-10).of(0.9330329915368074160)
    Math.regularized_beta(0.5, 10.0,  1.0).should be_within(1e-10).of(0.0009765625000000000000)
    Math.regularized_beta(0.5, 50.0,  1.0).should be_within(1e-10).of(8.881784197001252323e-16)
    Math.regularized_beta(0.5, 1.0,  0.1).should be_within(1e-10).of(0.06696700846319258402)
    Math.regularized_beta(0.5, 1.0, 10.0).should be_within(1e-10).of(0.99902343750000000000)
    Math.regularized_beta(0.5, 1.0, 50.0).should be_within(1e-10).of(0.99999999999999911180)
    Math.regularized_beta(0.1, 1.0,  1.0).should be_within(1e-10).of(0.10)
    Math.regularized_beta(0.1, 1.0,  2.0).should be_within(1e-10).of(0.19)
    Math.regularized_beta(0.9, 1.0,  2.0).should be_within(1e-10).of(0.99)
    Math.regularized_beta(0.5, 50.0, 60.0).should be_within(1e-10).of(0.8309072939016694143)
    Math.regularized_beta(0.5, 90.0, 90.0).should be_within(1e-10).of(0.5)
    Math.regularized_beta(0.5, 500.0,  500.0).should be_within(1e-10).of(0.5)
    Math.regularized_beta(0.4, 5000.0, 5000.0).should be_within(1e-10).of(4.518543727260666383e-91)
    Math.regularized_beta(0.6, 5000.0, 5000.0).should be_within(1e-10).of(1.0)
    Math.regularized_beta(0.6, 5000.0, 2000.0).should be_within(1e-10).of(8.445388773903332659e-89)
  end
  it_only_with_gsl "incomplete_beta should return correct values" do
    
    a=rand()*10+1
    b=rand()*10+1
    ib = GSL::Function.alloc { |t|  t**(a-1)*(1-t)**(b-1)}
    w = GSL::Integration::Workspace.alloc(1000)
    1.upto(10) {|x|
      inte=ib.qag([0,x / 10.0],w)
      Math.incomplete_beta(x/10.0, a ,b).should be_within(1e-10).of(inte[0])
    }
  end

  it "gammastar should return correct values" do
    # Tests from GSL-1.9
    Math::Gammastar.evaluate(1.0e-08).should        be_within(1e-10).of(3989.423555759890865)
    Math::Gammastar.evaluate(1.0e-05).should        be_within(1e-10).of(126.17168469882690233)
    Math::Gammastar.evaluate(0.001).should          be_within(1e-10).of(12.708492464364073506)
    Math::Gammastar.evaluate(1.5).should            be_within(1e-10).of(1.0563442442685598666)
    Math::Gammastar.evaluate(3.0).should            be_within(1e-10).of(1.0280645179187893045)
    Math::Gammastar.evaluate(9.0).should            be_within(1e-10).of(1.0092984264218189715)
    Math::Gammastar.evaluate(11.0).should           be_within(1e-10).of(1.0076024283104962850)
    Math::Gammastar.evaluate(100.0).should          be_within(1e-10).of(1.0008336778720121418)
    Math::Gammastar.evaluate(1.0e+05).should        be_within(1e-10).of(1.0000008333336805529)
    Math::Gammastar.evaluate(1.0e+20).should        be_within(1e-10).of(1.0)
  end

  it "erfc_e should return correct values" do
    # From GSL-1.9. For troubleshooting gammq.
    Math::erfc_e(-10.0).should be_within(1e-10).of(2.0)
    Math::erfc_e(-5.0000002).should be_within(1e-10).of(1.9999999999984625433)
    Math::erfc_e(-5.0).should be_within(1e-10).of(1.9999999999984625402)
    Math::erfc_e(-1.0).should be_within(1e-10).of(1.8427007929497148693)
    Math::erfc_e(-0.5).should be_within(1e-10).of(1.5204998778130465377)
    Math::erfc_e(1.0).should be_within(1e-10).of(0.15729920705028513066)
    Math::erfc_e(3.0).should be_within(1e-10).of(0.000022090496998585441373)
    Math::erfc_e(7.0).should be_within(1e-10).of(4.183825607779414399e-23)
    Math::erfc_e(10.0).should be_within(1e-10).of(2.0884875837625447570e-45)
  end


  it "unnormalized_incomplete_gamma with x=0 should return correct values" do
    Math.unnormalized_incomplete_gamma(-1.5, 0).should be_within(1e-10).of(4.0*Math.sqrt(Math::PI) / 3.0)
    Math.unnormalized_incomplete_gamma(-0.5, 0).should be_within(1e-10).of(-2*Math.sqrt(Math::PI))
    Math.unnormalized_incomplete_gamma(0.5, 0).should be_within(1e-10).of(Math.sqrt(Math::PI))
    Math.unnormalized_incomplete_gamma(1.0, 0).should eq 1.0
    Math.unnormalized_incomplete_gamma(1.5, 0).should be_within(1e-10).of(Math.sqrt(Math::PI) / 2.0)
    Math.unnormalized_incomplete_gamma(2.0, 0).should eq 1.0
    Math.unnormalized_incomplete_gamma(2.5, 0).should be_within(1e-10).of(0.75*Math.sqrt(Math::PI))
    
    Math.unnormalized_incomplete_gamma(3.0, 0).should be_within(1e-12).of(2.0)
    
    Math.unnormalized_incomplete_gamma(3.5, 0).should be_within(1e-10).of(15.0*Math.sqrt(Math::PI) / 8.0)
    Math.unnormalized_incomplete_gamma(4.0, 0).should be_within(1e-12).of(6.0)
  end

  it "incomplete_gamma should return correct values" do
    # Tests from GSL-1.9
    Math.incomplete_gamma(1e-100, 0.001).should be_within(1e-10).of(1.0)
    Math.incomplete_gamma(0.001, 0.001).should be_within(1e-10).of(0.9936876467088602902)
    Math.incomplete_gamma(0.001, 1.0).should be_within(1e-10).of(0.9997803916424144436)
    Math.incomplete_gamma(0.001, 10.0).should be_within(1e-10).of(0.9999999958306921828)
    Math.incomplete_gamma(1.0, 0.001).should be_within(1e-10).of(0.0009995001666250083319)
    Math.incomplete_gamma(1.0, 1.01).should be_within(1e-10).of(0.6357810204284766802)
    Math.incomplete_gamma(1.0, 10.0).should be_within(1e-10).of(0.9999546000702375151)
    Math.incomplete_gamma(10.0, 10.01).should be_within(1e-10).of(0.5433207586693410570)
    Math.incomplete_gamma(10.0, 20.0).should be_within(1e-10).of(0.9950045876916924128)
    Math.incomplete_gamma(1000.0, 1000.1).should be_within(1e-10).of(0.5054666401440661753)
    Math.incomplete_gamma(1000.0, 2000.0).should be_within(1e-10).of(1.0)

    # designed to trap the a-x=1 problem
    # These next two are 1e-7 because they give the same output as GSL, but GSL is apparently not totally accurate here.
    # It's a problem with log_1plusx_mx (log_1plusx_minusx in my code)
    Math.incomplete_gamma(100,  99.0).should be_within(1e-7).of(0.4733043303994607)
    Math.incomplete_gamma(200, 199.0).should be_within(1e-7).of(0.4811585880878718)

    # Test for x86 cancellation problems
    Math.incomplete_gamma(5670, 4574).should be_within(1e-10).of(3.063972328743934e-55)
  end

  it "gammq should return correct values" do
    # Tests from GSL-1.9
    Math.gammq(0.0, 0.001).should be_within(1e-10).of(0.0)
    Math.gammq(0.001, 0.001).should be_within(1e-10).of(0.006312353291139709793)
    Math.gammq(0.001, 1.0).should be_within(1e-10).of(0.00021960835758555639171)
    Math.gammq(0.001, 2.0).should be_within(1e-10).of(0.00004897691783098147880)
    Math.gammq(0.001, 5.0).should be_within(1e-10).of(1.1509813397308608541e-06)
    Math.gammq(1.0, 0.001).should be_within(1e-10).of(0.9990004998333749917)
    Math.gammq(1.0, 1.01).should be_within(1e-10).of(0.3642189795715233198)
    Math.gammq(1.0, 10.0).should be_within(1e-10).of(0.00004539992976248485154)
    Math.gammq(10.0, 10.01).should be_within(1e-10).of(0.4566792413306589430)
    Math.gammq(10.0, 100.0).should be_within(1e-10).of(1.1253473960842733885e-31)
    Math.gammq(1000.0, 1000.1).should be_within(1e-10).of(0.4945333598559338247)
    Math.gammq(1000.0, 2000.0).should be_within(1e-10).of(6.847349459614753180e-136)

    # designed to trap the a-x=1 problem
    Math.gammq(100,  99.0).should be_within(1e-10).of(0.5266956696005394)
    Math.gammq(200, 199.0).should be_within(1e-10).of(0.5188414119121281)
  
    # Test for x86 cancellation problems
    Math.gammq(5670, 4574).should be_within(1e-10).of(1.0000000000000000)


    # test suggested by Michel Lespinasse [gsl-discuss Sat, 13 Nov 2004]
    Math.gammq(1.0e+06-1.0, 1.0e+06-2.0).should be_within(1e-10).of(0.50026596175224547004)

    # tests in asymptotic regime related to Lespinasse test
    Math.gammq(1.0e+06+2.0, 1.0e+06+1.0).should be_within(1e-10).of(0.50026596135330304336)
    Math.gammq(1.0e+06, 1.0e+06-2.0).should be_within(1e-10).of(0.50066490399940144811)
    Math.gammq(1.0e+07, 1.0e+07-2.0).should be_within(1e-10).of(0.50021026104978614908)
  end


  it "rising_factorial should return correct values" do
    
    x=rand(10)+1
    Math.rising_factorial(x,0).should eq 1
    Math.rising_factorial(x,1).should eq x
    Math.rising_factorial(x,2).should eq x**2+x
    Math.rising_factorial(x,3).should eq x**3+3*x**2+2*x
    Math.rising_factorial(x,4).should eq x**4+6*x**3+11*x**2+6*x

  end
  
  it "permutations should return correct values" do
    n=rand(50)+50
    10.times { |k|
      Math.permutations(n,k).should eq(Math.factorial(n) / Math.factorial(n-k))
    }
    
    
    Math.permutations(n,n).should eq(Math.factorial(n) / Math.factorial(n-n))
  end
  
  
  it "exact regularized incomplete beta should behave properly" do

    Math.exact_regularized_beta(0.5,5,5).should be_within(1e-6).of(0.5)
    Math.exact_regularized_beta(0.5,5,6).should be_within(1e-6).of(0.6230469)
    Math.exact_regularized_beta(0.5,5,7).should  be_within(1e-6).of(0.725586)
    
    a=5
    b=5
    Math.exact_regularized_beta(0,a,b).should eq 0
    Math.exact_regularized_beta(1,a,b).should eq 1
    x=rand()
    
    Math.exact_regularized_beta(x,a,b).should be_within(1e-6). of(1-Math.regularized_beta(1-x,b,a))
    
    
  end
  
  it "binomial coefficient(gamma) with n<=48 should be correct " do
    
    [1,5,10,25,48].each {|n|
      k=(n/2).to_i
      Math.binomial_coefficient_gamma(n,k).round.should eq(Math.binomial_coefficient(n,k))
    }
  end
  
  it "binomial coefficient(gamma) with 48<n<1000 should have 11 correct digits" do 
    
    [50,100,200,1000].each {|n|
      k=(n/2).to_i
      obs=Math.binomial_coefficient_gamma(n, k).to_i.to_s[0,11]
      exp=Math.binomial_coefficient(n, k).to_i.to_s[0,11]
      
      obs.should eq(exp)
    }
  end
  
  describe Distribution::MathExtension::SwingFactorial do

    it "Math.factorial should return correct values x<20" do
      ac=3628800 # 10!
      11.upto(19).each do |i|
        ac*=i
        Math.factorial(i).should eq(ac)
      end
    end
    
    it "Math.factorial should return correct values for values 21<x<33" do
      
      ac=2432902008176640000 # 20!
      21.upto(33).each do |i|
        ac*=i
        Math.factorial(i).should eq(ac)
      end
      
    end
    
    it "Math.factorial should return correct values for values x>33" do
      
      ac=8683317618811886495518194401280000000 # 33!
      Math.factorial(33).should eq ac
      34.upto(40).each do |i|
        ac*=i
        Math.factorial(i).should eq(ac)
      end
    
    end
  end
end
