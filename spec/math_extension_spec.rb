require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution::MathExtension do
  it "binomial coefficient should be correctly calculated" do
    n=50
    n.times do |k|
      Math.binomial_coefficient(n,k).should eq(Math.factorial(n).quo(Math.factorial(k)*Math.factorial(n-k)))
    end
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
