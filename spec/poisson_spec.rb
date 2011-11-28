require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  include ExampleWithGSL
describe Distribution::Poisson do
    
  shared_examples_for "poisson engine" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
        [0.5,1,1.5].each {|l|
          1.upto(5) {|k|
            @engine.pdf(k,l).should be_within(1e-10).of( (l**k*Math.exp(-l)).quo(Math.factorial(k)) )
          }
        }
      else
        pending("No #{@engine}.pdf")
      end
    end
    
    it_only_with_gsl "should return correct cdf" do
      if @engine.respond_to? :cdf
        [0.5,1,1.5,4,10].each {|l|
          1.upto(5) {|k|
            @engine.cdf(k,l).should be_within(1e-10).of(GSL::Cdf.poisson_P(k,l))
          }
        }
        
      else
        pending("No #{@engine}.cdf")
      end
    end
    
    
  
    
    it "should return correct p_value" do
      pending("No exact p_value")
      if @engine.respond_to? :p_value
         [0.1,1,5,10].each {|l|
          1.upto(20) {|k|
            pr=@engine.cdf(k,l)
            @engine.p_value(pr,l).should eq(k)
          }
        }
      else
        pending("No #{@engine}.p_value")
      end
    end
  end
  

  describe "singleton" do
    before do
      @engine=Distribution::Poisson
    end
    it_should_behave_like "poisson engine"
  end
  
  describe Distribution::Poisson::Ruby_ do
    before do
      @engine=Distribution::Poisson::Ruby_
    end
    it_should_behave_like "poisson engine"
    
  end
  if Distribution.has_gsl?
    describe Distribution::Poisson::GSL_ do
      before do
        @engine=Distribution::Poisson::GSL_
      end
      it_should_behave_like "poisson engine"
      
    end
  end
  if Distribution.has_java?
    describe Distribution::Poisson::Java_ do
      before do
        @engine=Distribution::Poisson::Java_
      end
      it_should_behave_like "poisson engine"
      
      
      it "should return correct cdf" do
        [0.5,1,1.5,4,10].each {|l|
          1.upto(5) {|k|
            @engine.cdf(k,l).should be_within(1e-10).of(Distribution::Poisson::Ruby_.cdf(k,l))
          }
        }
      end

      
    end
  end
end
