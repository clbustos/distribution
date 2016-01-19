require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
<<<<<<< HEAD

describe Distribution::Uniform do

  shared_examples_for "uniform engine" do

    it ".rng should generate sequences with the right mean & variance" do
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

    it ".rng with a specified seed should be reproducible" do
      seed = Random.new_seed
      gena = @engine.rng(0, 1, seed)
      genb = @engine.rng(0, 1, seed)

      (gena.call).should eq(genb.call)
    end

    it ".pdf should return correct pdf for values within the defined range" do
      if @engine.respond_to? :pdf
        10.times do
          low, width = rand, rand
          x = low + rand * width
          epdf = 1.0 / width
          @engine.pdf(x, low, low + width).should be_within(1e-10).of(epdf)
        end

      else
        pending("No #{@engine}.pdf")
      end
    end

    it ".pdf should return 0 for values outside the defined range" do
      if @engine.respond_to? :pdf
        10.times do
          low, width = rand, rand
          # x lies just outside of  where the pdf exists as a non-zero value
          # A small amount (1e-10) is removed from bad_x to ensure no overlap
          x = good_x - 2 * width - 1e-10
          @engine.pdf(x, low, low + width).should be_within(1e-10).of(0.0)
        end

=======
  
describe Distribution::Uniform do
    
  shared_examples_for "uniform engine" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
>>>>>>> 98c7ad8e4ab1dc53c1e664799c2a4545af56b11d
      else
        pending("No #{@engine}.pdf")
      end
    end
<<<<<<< HEAD


    it ".cdf should return 0 for values smaller than the lower bound" do
      if @engine.respond_to? :cdf
        low, width = rand, rand
        x = low - rand * width
        @engine.cdf(x, low, low + width).should be_within(1e-10).of(0.0)
      else
        pending("No #{@engine}.cdf")
      end
    end

    it ".cdf should return correct cdf for x within defined range" do
      if @engine.respond_to? :cdf
        low, width = rand, rand
        x = low + rand * width
        ecdf = (x - low) / width
        @engine.cdf(x, low, low + width).should be_within(1e-10).of(ecdf)
      else
        pending("No #{@engine}.cdf")
      end
    end

    it ".cdf should return 1 for values greater than the upper bound" do
      if @engine.respond_to? :cdf
        low, width = rand, rand
        x = low + rand * (2 * width)
        @engine.cdf(x, low, low + width).should be_within(1e-10).of(1.0)
=======
    
    it "should return correct cdf" do
      if @engine.respond_to? :cdf
>>>>>>> 98c7ad8e4ab1dc53c1e664799c2a4545af56b11d
      else
        pending("No #{@engine}.cdf")
      end
    end
<<<<<<< HEAD
    
    it ".quantile should return correct inverse cdf" do
      if @engine.respond_to? :quantile
        low, width = rand, rand
        scale = rand
        x = low + scale * width
        qn = (x - low) / width
        @engine.quantile(qn, low, low + width).should be_within(1e-10).of(scale)
      else
        pending("No #{@engine}.quantile")
      end
    end
    
    it ".p_value should return same result as .quantile" do
      if @engine.respond_to? :p_value and @engine.respond_to? :quantile
        low, width = rand, rand
        scale = rand
        x = low + scale * width
        qn = (x - low) / width
        
        @engine.quantile(qn, low, low + width).
          should eq(@engine.p_value(qn, low, low + width))
      else
        pending("No #{@engine}.p_value")
      end
    end
  end

=======
  
    
    it "should return correct p_value" do
      if @engine.respond_to? :p_value
      else
        pending("No #{@engine}.cdf")
      end
    end
  end
  
>>>>>>> 98c7ad8e4ab1dc53c1e664799c2a4545af56b11d

  describe "singleton" do
    before do
      @engine=Distribution::Uniform
    end
    it_should_behave_like "uniform engine"
  end
<<<<<<< HEAD

=======
  
>>>>>>> 98c7ad8e4ab1dc53c1e664799c2a4545af56b11d
  describe Distribution::Uniform::Ruby_ do
    before do
      @engine=Distribution::Uniform::Ruby_
    end
    it_should_behave_like "uniform engine"
<<<<<<< HEAD

  end

=======
    
  end
  
>>>>>>> 98c7ad8e4ab1dc53c1e664799c2a4545af56b11d
  if Distribution.has_gsl?
    describe Distribution::Uniform::GSL_ do
      before do
        @engine=Distribution::Uniform::GSL_
      end
      it_should_behave_like "uniform engine"
    end
  end
<<<<<<< HEAD


=======
  
  
>>>>>>> 98c7ad8e4ab1dc53c1e664799c2a4545af56b11d
end
