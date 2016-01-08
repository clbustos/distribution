require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  
describe Distribution::Uniform do
    
  shared_examples_for "uniform engine" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
      else
        pending("No #{@engine}.pdf")
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
        pending("No #{@engine}.cdf")
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
