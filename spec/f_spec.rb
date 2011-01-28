require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")

include ExampleWithGSL

describe Distribution::F do
shared_examples_for "F engine(with rng)" do
  it "should return correct rng" do
  pending()
  end
end

shared_examples_for "F engine(with pdf)" do
  it_only_with_gsl "should return correct pdf" do
    if @engine.respond_to? :pdf
      [0.1,0.5,1,2,10,20,30].each{|f|
      [2,5,10].each{|n2|
      [2,5,10].each{|n1|
      @engine.pdf(f,n1,n2).should be_within(1e-4).of(GSL::Ran.fdist_pdf(f,n1,n2))
      }
      }
      }
    else
      pending("No #{@engine}.pdf")
    end
  end
end

shared_examples_for "F engine" do
  
  it_only_with_gsl "should return correct cdf" do
    if @engine.respond_to? :cdf
      [0.1,0.5,1,2,10,20,30].each{|f|
      [2,5,10].each{|n2|
      [2,5,10].each{|n1|
      @engine.cdf(f,n1,n2).should be_within(1e-4).of(GSL::Cdf.fdist_P(f,n1,n2))
      
      }
      }
      }
    else
      pending("No #{@engine}.cdf")
    end
  
  end
  it_only_with_gsl "should return correct p_value" do
    if @engine.respond_to? :p_value
  
    [0.1,0.5,1,2,10,20,30].each{|f|
    [2,5,10].each{|n2|
    [2,5,10].each{|n1|
    area=@engine.cdf(f,n1,n2)
    @engine.p_value(area,n1,n2).should be_within(1e-4).of(GSL::Cdf.fdist_Pinv(area,n1,n2))
    }
    }
    }
  
    
    else
      pending("No #{@engine}.p_value")
    end
  end
end

  describe "singleton" do
    before do
      @engine=Distribution::F
    end
    it_should_behave_like "F engine"    
    it_should_behave_like "F engine(with pdf)"    
  end
  
  describe Distribution::F::Ruby_ do
    before do
      @engine=Distribution::F::Ruby_
    end
    it_should_behave_like "F engine"    
    it_should_behave_like "F engine(with pdf)"    
  end
  if Distribution.has_gsl?
    describe Distribution::F::GSL_ do
      before do
        @engine=Distribution::F::GSL_
      end
    it_should_behave_like "F engine"    
    it_should_behave_like "F engine(with pdf)"    
    end
  end  
  if Distribution.has_statistics2?
    describe Distribution::F::Statistics2_ do
      before do
        @engine=Distribution::F::Statistics2_
      end
    it_should_behave_like "F engine"    
    end  
  end
  
  if Distribution.has_java?
    describe Distribution::F::Java_ do
      before do
        @engine=Distribution::F::Java_
      end
    it_should_behave_like "F engine"    
    it_should_behave_like "F engine(with pdf)"    
    end  
  end
  
end
