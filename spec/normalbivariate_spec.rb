require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  
describe Distribution::NormalBivariate do
  shared_examples_for "all normal bivariates engines" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
        10.times do |i|
          x=(i-5)/2.0
          pdf=(1.0 / Distribution::SQ2PI)*Math::exp(-(x**2/2.0))
          
          @engine.pdf(x,x,0).should be_within(1e-10).of(pdf*pdf)
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
    it "should return correct cdf" do
    end
  end
  describe "singleton" do
    before do
      @engine=Distribution::NormalBivariate
    end
    it_should_behave_like "all normal bivariates engines"    
  end
  
  describe Distribution::Normal::Ruby_ do
    before do
      @engine=Distribution::NormalBivariate::Ruby_
    end
    it_should_behave_like "all normal bivariates engines"
  end
  
end
