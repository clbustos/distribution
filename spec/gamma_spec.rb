require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
include ExampleWithGSL
describe Distribution::Gamma do

shared_examples_for "Gamma engine(with pdf)" do
    it_only_with_gsl "should return correct pdf" do
      if @engine.respond_to? :pdf
        1.upto(101) do |x|
          a=rand * x
          b=1 + rand * 5
          g=GSL::Ran.gamma_pdf(x,a,b)
          @engine.pdf(x,a,b).should be_within(1e-10).of(g)
        end
      else
        pending("No #{@engine}.pdf")
      end
    end

end
  
shared_examples_for "Gamma engine" do

  it_only_with_gsl "should return correct cdf" do
    if @engine.respond_to? :cdf
      1.upto(101) do |x|
        a=rand * x
        b=1 + rand * 5
        g=GSL::Cdf::gamma_P(x,a,b)
        @engine.cdf(x,a,b).should be_within(1e-10).of(g)
      end
    else
      pending("No #{@engine}.cdf")
    end
  end
  it "should return correct p_value" do
    if @engine.respond_to? :p_value
      1.upto(101) do |x|
        a=rand * x
        b=1 + rand * 5
        pr=@engine.cdf(x,a,b)
        @engine.p_value(pr,a,b).should be_within(1e-4).of(x)
       end
    else
      pending("No #{@engine}.p_value")
    end
  end
end

  describe "singleton" do
    before do
      @engine=Distribution::Gamma
    end
    it_should_behave_like "Gamma engine"
    it_should_behave_like "Gamma engine(with pdf)"
  end
  
  describe Distribution::Gamma::Ruby_ do
    before do
      @engine=Distribution::Gamma::Ruby_
    end
    it_should_behave_like "Gamma engine"
    it_should_behave_like "Gamma engine(with pdf)"
  end
  if Distribution.has_gsl?
    describe Distribution::Gamma::GSL_ do
      before do
        @engine=Distribution::Gamma::GSL_
      end
    it_should_behave_like "Gamma engine"
    it_should_behave_like "Gamma engine(with pdf)"
    end
  end
  if Distribution.has_java?
    describe Distribution::Gamma::Java_ do
      before do
        @engine=Distribution::Gamma::Java_
      end
    it_should_behave_like "Gamma engine"
    it_should_behave_like "Gamma engine(with pdf)"
    end  
  end
  
end
