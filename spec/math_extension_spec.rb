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
