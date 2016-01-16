require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

describe Distribution::Uniform do
    
  shared_examples_for "uniform engine with rng" do
    
    it "should return correct rng" do
      samples = 100
      sum = 0
      ss = 0
      lower = 0
      upper = rand(20)
      
      # Expectations
      exp_mean = (upper + lower) / 2
      exp_variance = (upper - lower) ** 2 / 12
      rng = @engine.rng(exp_lower, exp_upper)
      
      # Calculate the chi-squared test statistic
      samples.times do
        v = rng.call
        sum += v
        ss += (v - exp_mean) ** 2
      end
      
      mean = sum.to_f / samples
      variance = ss.to_f / samples
      mean.should be_within(1e-5).of(exp_mean)
      variance.should be_within(1e-5).of(exp_variance)
    end
    
    it "rng with a specified seed should be reproducible" do
      seed = Random.new_seed
      rng1 = @engine.rng(0, 1, seed) 
      rng2 = @engine.rng(0, 1, seed)
      
      (rng1.call).should eq(rng2.call)
    end
    
  shared_examples_for "uniform engine with pdf" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf

      else
        pending("No #{@engine}.pdf")
      end
    end
  end  
    it "should return correct cdf" do
      if @engine.respond_to? :cdf
      else
        pending("No #{@engine}.cdf")
      end
    end
  
    
    it "should return correct p_value" do
      if @engine.respond_to? :p_value
      else
        pending("No #{@engine}.p_value")
      end
    end
  end
  

  describe "singleton" do
    before do
      @engine=Distribution::Uniform
    end
    it_should_behave_like "uniform engine"
  end
  
  describe Distribution::Uniform::Ruby_ do
    before do
      @engine=Distribution::Uniform::Ruby_
    end
    it_should_behave_like "uniform engine"
    
  end
  
  if Distribution.has_gsl?
    describe Distribution::Uniform::GSL_ do
      before do
        @engine=Distribution::Uniform::GSL_
      end
      it_should_behave_like "uniform engine"
    end
  end
  
  
end
