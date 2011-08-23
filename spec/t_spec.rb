require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

include ExampleWithGSL

describe Distribution::T do
shared_examples_for "T engine(with rng)" do
  it "should return correct rng" do
  pending()
  end
end

shared_examples_for "T engine(cdf with fractional df)" do
  it "should return correct cdf with fractional df" do
    @engine.cdf(1,2.5).should be_within(1e-6).of(0.7979695)
    @engine.cdf(2,3.5).should be_within(1e-6).of(0.9369307)
    @engine.cdf(3,4.5).should be_within(1e-6).of(0.9828096)
    
  end
end

shared_examples_for "T engine" do
  it_only_with_gsl "should return correct pdf" do
    if @engine.respond_to? :pdf
      [-2,0.1,0.5,1,2].each{|t|
        [2,5,10].each{|n|
          @engine.pdf(t,n).should be_within(1e-6).of(GSL::Ran.tdist_pdf(t,n))
          @engine.pdf(t,n.to_f).should be_within(1e-6).of(@engine.pdf(t,n))

        }
      }
    else
      pending("No #{@engine}.pdf")
    end
  end
  it_only_with_gsl "should return correct cdf" do
    if @engine.respond_to? :cdf
      # Testing with R values
      @engine.cdf(1,2).should be_within(1e-7).of(0.7886751)
      @engine.cdf(1,2.0).should be_within(1e-7).of(0.7886751)
      @engine.cdf(1,3.0).should be_within(1e-7).of(0.8044989)
      
      [-2,0.1,0.5,1,2].each{|t|
        [2,5,10].each{|n|
          @engine.cdf(t,n).should be_within(1e-4).of(GSL::Cdf.tdist_P(t,n))
          @engine.cdf(t,n).should be_within(1e-4).of(@engine.cdf(t,n.to_f))
          
        }
      }
    else
      pending("No #{@engine}.cdf")
    end
  
  end
  it_only_with_gsl "should return correct p_value" do
    if @engine.respond_to? :p_value
   [-2,0.1,0.5,1,2].each{|t|
        [2,5,10].each{|n|
          area=Distribution::T.cdf(t,n)
          @engine.p_value(area,n).should be_within(1e-4).of(GSL::Cdf.tdist_Pinv(area,n))
    }
    }
    else
      pending("No #{@engine}.p_value")
    end
  end
end

  describe "singleton" do
    before do
      @engine=Distribution::T
    end
    it_should_behave_like "T engine"    
  end
  
  describe Distribution::T::Ruby_ do
    before do
      @engine=Distribution::T::Ruby_
    end
    it_should_behave_like "T engine"    
    it_should_behave_like "T engine(cdf with fractional df)"
    
  end
  if Distribution.has_gsl?
    describe Distribution::T::GSL_ do
      before do
        @engine=Distribution::T::GSL_
      end
    it_should_behave_like "T engine"    
    it_should_behave_like "T engine(cdf with fractional df)"    
    end
  end
=begin
  if Distribution.has_statistics2?
    describe Distribution::T::Statistics2_ do
      before do
        @engine=Distribution::T::Statistics2_
      end
    it_should_behave_like "T engine"    
    end  
  end
=end  
  if Distribution.has_java?
    describe Distribution::T::Java_ do
      before do
        @engine=Distribution::T::Java_
      end
    it_should_behave_like "T engine"    
    end  
  end
  
end
