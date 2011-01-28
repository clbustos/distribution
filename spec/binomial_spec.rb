require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  
describe Distribution::Binomial do
  
shared_examples_for "binomial engine" do
  it "should return correct pdf" do
    [10,100,1000].each do |n|
      [0.25,0.5,0.75].each do |pr|
        [0, 1,n/2,n-1].each do |x| 
          exp=Math.binomial_coefficient(n,x)*pr**x*(1-pr)**(n-x)
          obs=@engine.pdf(x,n,pr)
          obs.should be_within(1e-5).of(exp), "For pdf(#{x},#{n},#{pr}) expected #{exp}, obtained #{obs}"
          
        end
      end
    end
  end
  it "should return correct cdf for n<=100" do
    [10,100].each do |n|
      [0.25,0.5,0.75].each do |pr|
        [1,n/2,n-1].each do |x| 
          exp=GSL::Cdf.binomial_P(x,pr,n)
          obs=@engine.cdf(x,n,pr)
          exp.should be_within(1e-5).of(obs), "For cdf(#{x},#{n},#{pr}) expected #{exp}, obtained #{obs}"
        end
      end
    end
  end

  
  
end

  describe "singleton" do
    before do
      @engine=Distribution::Binomial
    end
    it_should_behave_like "binomial engine"
  end
  
  describe Distribution::Binomial::Ruby_ do
    before do
      @engine=Distribution::Binomial::Ruby_
    end
    it_should_behave_like "binomial engine"
    
    it "should return correct cdf for n>100" do
      pending("incomplete beta function is slow. Should be replaced for a faster one")
    end
    
    it "should return correct p_value for n<=100" do
      pending("Can't calculate with precision x using p")
    [10,100].each do |n|
      [0.25,0.5,0.75].each do |pr|
        [n/2].each do |x| 
          cdf=@engine.cdf(x,n,pr)
          p_value=@engine.p_value(cdf,n,pr)
          
          p_value.should eq(x), "For p_value(#{cdf},#{n},#{pr}) expected #{x}, obtained #{p_value}"
        end
      end
    end
    end
    
  end
  if Distribution.has_gsl?
    describe Distribution::Binomial::GSL_ do
      before do
        @engine=Distribution::Binomial::GSL_
      end
    it_should_behave_like "binomial engine"
    end
  end
  #if Distribution.has_statistics2?
  #  describe Distribution::Binomial::Statistics2_ do
  #    
  #    before do
  #      @engine=Distribution::Binomial::Statistics2_
  #    end
    #it_should_behave_like "binomial engine"
  #  end  
  #end
  
  if Distribution.has_java?
    describe Distribution::Binomial::Java_ do
      before do
        @engine=Distribution::Binomial::Java_
      end
    it_should_behave_like "binomial engine"
    end  
  end
  
end
