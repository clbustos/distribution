require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution::MathExtension do
  it "binomial coefficient should be correctly calculated" do
    n=50
    n.times do |k|
      Math.binomial_coefficient(n,k).should eq(Math.factorial(n).quo(Math.factorial(k)*Math.factorial(n-k)))
    end
  end
  
  it "binomial coefficient(gamma) with n<=48 should be correct " do
    [1,5,10,25,48].each {|n|
      k=n/2
      Math.binomial_coefficient_gamma(n,k).round.should eq(Math.binomial_coefficient(n,k))
    }
  end
  it "rising_factorial should return correct values" do
    x=rand(10)+1
    Math.rising_factorial(x,0).should eq 1
    Math.rising_factorial(x,1).should eq x
    Math.rising_factorial(x,2).should eq x**2+x
    Math.rising_factorial(x,3).should eq x**3+3*x**2+2*x
    Math.rising_factorial(x,4).should eq x**4+6*x**3+11*x**2+6*x

  end
  it "incomplete beta function should return similar results to R" do
    pending("Not working yet")
    Math.incomplete_beta(0.5,5,6).should be_within(1e-6).of(Math.beta(5,6)*0.6230469)
    Math.incomplete_beta(0.6,5,6).should be_within(1e-6).of(Math.beta(5,6)*0.0006617154)
  end
  it "regularized incomplete beta should behave properly" do

    Math.regularized_beta_function(0.5,5,5).should eq 0.5
    Math.regularized_beta_function(0.5,5,6).should be_within(1e-6).of(0.6230469)
    Math.regularized_beta_function(0.5,5,7).should  be_within(1e-6).of(0.725586)
    
    a=5
    b=5
    Math.regularized_beta_function(0,a,b).should eq 0
    Math.regularized_beta_function(1,a,b).should eq 1
    x=rand()
    
    Math.regularized_beta_function(x,a,b).should be_within(1e-6). of(1-Math.regularized_beta_function(1-x,b,a))
    
    
  end
  it "binomial coefficient(gamma) with 48<n<1000 should have 12 correct digits" do 
    [50,100,1000].each {|n|
      k=n/2
      obs=Math.binomial_coefficient_gamma(n,k).to_i.to_s[0,12]
      exp=Math.binomial_coefficient(n,k).to_i.to_s[0,12]
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
