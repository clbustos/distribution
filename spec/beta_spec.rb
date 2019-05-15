require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::Beta do
  shared_examples_for 'Beta engine' do
    it_only_with_gsl 'should return correct pdf' do
      if @engine.respond_to? :pdf
        1.upto(101) do |x|
          a = rand * x
          b = 1 + rand * 5
          g = GSL::Ran.beta_pdf(x, a, b)
          @engine.pdf(x, a, b).should be_within(1e-09).of(g)
        end
      else
        skip("No #{@engine}.pdf")
      end
    end

    it_only_with_gsl 'should return correct cdf' do
      if @engine.respond_to? :cdf
        # From GSL-1.9.
        tol = 1_048_576.0 * Float::EPSILON
        @engine.cdf(0.0, 1.2, 1.3).should eq(0.0)
        @engine.cdf(1e-100, 1.2, 1.3).should be_within(tol).of(1.34434944656489596e-120)
        @engine.cdf(0.001, 1.2, 1.3).should be_within(tol).of(3.37630042504535813e-4)
        @engine.cdf(0.01, 1.2, 1.3).should be_within(tol).of(5.34317264038929473e-3)
        @engine.cdf(0.1, 1.2, 1.3).should be_within(tol).of(8.33997828306748346e-2)
        @engine.cdf(0.325, 1.2, 1.3).should be_within(tol).of(3.28698654180583916e-1)
        @engine.cdf(0.5, 1.2, 1.3).should be_within(tol).of(5.29781429451299081e-1)
        @engine.cdf(0.9, 1.2, 1.3).should be_within(tol).of(9.38529397224430659e-1)
        @engine.cdf(0.99, 1.2, 1.3).should be_within(tol).of(9.96886438341254380e-1)
        @engine.cdf(0.999, 1.2, 1.3).should be_within(tol).of(9.99843792833067634e-1)
        @engine.cdf(1.0, 1.2, 1.3).should be_within(tol).of(1.0)
      else
        skip("No #{@engine}.cdf")
      end
    end
    it 'should return correct p_value' do
      if @engine.respond_to? :p_value
        2.upto(99) do |x|
          a = rand * x
          b = 1 + rand * 5
          pr = @engine.cdf(x / 100.0, a, b)
          @engine.p_value(pr, a, b).should be_within(1e-09).of(x / 100.0)
        end
      else
        skip("No #{@engine}.p_value")
      end
    end

    it 'should return correct quantile' do
      if @engine.respond_to? :quantile
        tol = 1_048_576.0 * Float::EPSILON
        @engine.quantile(0.86, 1076, 1).should be_within(tol).of(0.9998598398514792)
        @engine.quantile(0.3, 10_000, 10_000).should be_within(tol).of(0.4981459474049274)
      else
        skip("No #{@engine}.quantile")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Beta
    end
    it_should_behave_like 'Beta engine'
  end

  describe Distribution::Beta::Ruby_ do
    before do
      @engine = Distribution::Beta::Ruby_
    end
    it_should_behave_like 'Beta engine'
  end
  if Distribution.has_gsl?
    describe Distribution::Beta::GSL_ do
      before do
        @engine = Distribution::Beta::GSL_
      end
      it_should_behave_like 'Beta engine'
    end
  end
  if Distribution.has_java?
    describe Distribution::Beta::Java_ do
      before do
        @engine = Distribution::Beta::Java_
      end
      it_should_behave_like 'Beta engine'
    end
  end
end
