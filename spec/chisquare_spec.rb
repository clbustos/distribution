require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
  
describe Distribution::ChiSquare do
shared_examples_for "all chi-square engines" do
    it "should return correct pdf" do
      if @engine.respond_to? :pdf
        1.upto(10) do |k|
          v=1+rand(5)
          chi=GSL::Ran.chisq_pdf(v,k)
          @engine.pdf(v,k).should be_within(10e-10).of(chi)
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
    it "should return correct cdf" do
      if @engine.respond_to? :cdf
        1.upto(10) do |k|
          v=1+rand(5)
          chi=GSL::Cdf::chisq_P(v,k)
          @engine.cdf(v,k).should be_within(10e-10).of(chi)
        end
      else
        pending("No #{@engine}.cdf")
      end  
    end
    it "should return correct p_value" do
      if @engine.respond_to? :p_value
        1.upto(10) do |k|
          v=1+rand(5)
          pr=@engine.cdf(v,k)
          @engine.p_value(pr,k).should be_within(10e-4).of(v)
         end
      else
        pending("No #{@engine}.p_value")
      end
    end
  end

  describe "singleton" do
    before do
      @engine=Distribution::ChiSquare
    end
    it_should_behave_like "all chi-square engines"    
  end
  
  describe Distribution::ChiSquare::Ruby_ do
    before do
      @engine=Distribution::ChiSquare::Ruby_
    end
    it_should_behave_like "all chi-square engines"
  end
  if Distribution.has_gsl?
    describe Distribution::ChiSquare::GSL_ do
      before do
        @engine=Distribution::ChiSquare::GSL_
      end
      it_should_behave_like "all chi-square engines"
    end
  end  
  if Distribution.has_statistics2?
    describe Distribution::ChiSquare::Statistics2_ do
      before do
        @engine=Distribution::ChiSquare::Statistics2_
      end
      it_should_behave_like "all chi-square engines"
    end  
  end
  
  if Distribution.has_java?
    describe Distribution::ChiSquare::Java_ do
      before do
        @engine=Distribution::ChiSquare::Java_
      end
      it_should_behave_like "all gaussian engines"
    end  
  end
  
end
