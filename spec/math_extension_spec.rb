require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution::MathExtension do
  it "fast_factorial should return 11 valid digits" do
    pending("Doesn't worth the effort")
    valid=11
    (2..10).each {|i|
      n=2**i
      aprox=Math.fast_factorial(n).round.to_s[0,valid]
      exact=Math.factorial(n).to_s[0,valid]
      aprox.should eq exact
      
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
