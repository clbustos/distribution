require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  
describe Distribution::Normal do
shared_examples_for "all gaussian engines" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
        10.times do |i|
          x=(i-5)/2.0
          pdf=(1.0 / Distribution::SQ2PI)*Math::exp(-(x**2/2.0))
          @engine.pdf(x).should be_within(1e-10).of(pdf)
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
    it "should return correct cdf" do
      @engine.cdf(1.96).should be_within(1e-10).of(0.97500210485178)
      @engine.cdf(0).should be_within(1e-10).of(0.5)
    end
    it "should return correct p_value" do
      if @engine.respond_to? :p_value
        @engine.p_value(0.5).should be_within(1e-3).of(0)
        10.times do |i|
          x=(i-5)/2.0
          cdf=@engine.cdf(x)
          @engine.p_value(cdf).should be_within(1e-6).of(x)
        end
      else
        pending("No #{@engine}.p_value")
      end
    end
  end

  describe "singleton" do
    before do
      @engine=Distribution::Normal
    end
    it_should_behave_like "all gaussian engines"    
  end
  
  describe Distribution::Normal::Ruby_ do
    before do
      @engine=Distribution::Normal::Ruby_
    end
    it_should_behave_like "all gaussian engines"
  end
  if Distribution.has_gsl?
    describe Distribution::Normal::GSL_ do
      before do
        @engine=Distribution::Normal::GSL_
      end
      it_should_behave_like "all gaussian engines"
    end
  end  
  if Distribution.has_statistics2?
    describe Distribution::Normal::Statistics2_ do
      before do
        @engine=Distribution::Normal::Statistics2_
      end
      it_should_behave_like "all gaussian engines"
    end  
  end
  
  if Distribution.has_java?
    describe Distribution::Normal::Java_ do
      before do
        @engine=Distribution::Normal::Java_
      end
      it_should_behave_like "all gaussian engines"
    end  
  end
  
end
