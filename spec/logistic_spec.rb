require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  
describe Distribution::LogNormal do
    
  shared_examples_for "log-normal engine" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
        1.upto(10) {
          u=rand()
          s=rand()*100
          x=rand()*50
          exp=(1/(x*s*Math.sqrt(2*Math::PI)))*Math.exp(-(Math.log(x)-u)**2 / (2*s**2))
          @engine.pdf(x,u,s).should eq(exp)
        }
      else
        pending("No #{@engine}.pdf")
       end
    end
  end
  describe "singleton" do
    before do
      @engine=Distribution::LogNormal
    end
    it_should_behave_like "log-normal engine"
  end
  
  describe Distribution::Logistic::Ruby_ do
    before do
      @engine=Distribution::Logistic::Ruby_
    end
    it_should_behave_like "log-normal engine"
    
  end
  if Distribution.has_gsl?
    describe Distribution::Normal::GSL_ do
      before do
        @engine=Distribution::Normal::GSL_
      end
    it_should_behave_like "log-normal engine"     
    end
  end  

  
    
end
