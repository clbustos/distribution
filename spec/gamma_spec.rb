require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::Gamma do
  shared_examples_for 'Gamma engine' do
    it_only_with_gsl 'should return correct pdf' do
      if @engine.respond_to? :pdf
        1.upto(101) do |x|
          a = rand * x
          b = 1 + rand * 5
          g = GSL::Ran.gamma_pdf(x, a, b)
          expect(@engine.pdf(x, a, b)).to be_within(1e-10).of(g)
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
    it_only_with_gsl 'should return correct cdf' do
      if @engine.respond_to? :cdf
        # From GSL-1.9.
        tol = 1_048_576.0 * Float::EPSILON
        expect(@engine.cdf(0.0, 1.0, 1.0)).to eq(0.0)
        expect(@engine.cdf(1e-100, 1.0, 1.0)).to be_within(tol).of(1e-100)
        expect(@engine.cdf(0.001, 1.0, 1.0)).to be_within(tol).of(9.99500166625008332e-4)
        expect(@engine.cdf(0.01, 1.0, 1.0)).to be_within(tol).of(9.95016625083194643e-3)
        expect(@engine.cdf(0.1, 1.0, 1.0)).to be_within(tol).of(9.51625819640404268e-2)
        expect(@engine.cdf(0.325, 1.0, 1.0)).to be_within(tol).of(2.77472646357927811e-1)
        expect(@engine.cdf(1.0, 1.0, 1.0)).to be_within(tol).of(6.32120558828557678e-1)
        expect(@engine.cdf(1.5, 1.0, 1.0)).to be_within(tol).of(7.76869839851570171e-1)
        expect(@engine.cdf(2.0, 1.0, 1.0)).to be_within(tol).of(8.64664716763387308e-1)
        expect(@engine.cdf(10.0, 1.0, 1.0)).to be_within(tol).of(9.99954600070237515e-1)
        expect(@engine.cdf(20.0, 1.0, 1.0)).to be_within(tol).of(9.99999997938846378e-1)
        expect(@engine.cdf(100.0, 1.0, 1.0)).to be_within(tol).of(1e0)
        expect(@engine.cdf(1000.0, 1.0, 1.0)).to be_within(tol).of(1e0)
        expect(@engine.cdf(10_000.0, 1.0, 1.0)).to be_within(tol).of(1e0)
      else
        pending("No #{@engine}.cdf")
      end
    end
    it 'should return correct p_value' do
      if @engine.respond_to? :p_value
        1.upto(20) do |x|
          a = rand * 0.5
          b = 1 + rand * 5
          pr = @engine.cdf(x, a, b)
          expect(@engine.p_value(pr, a, b)).to be_within(1e-3).of(x)
        end
      else
        skip("No #{@engine}.p_value")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Gamma
    end
    it_should_behave_like 'Gamma engine'
  end

  describe Distribution::Gamma::Ruby_ do
    before do
      @engine = Distribution::Gamma::Ruby_
    end
    it_should_behave_like 'Gamma engine'
  end
  if Distribution.has_gsl?
    describe Distribution::Gamma::GSL_ do
      before do
        @engine = Distribution::Gamma::GSL_
      end
      it_should_behave_like 'Gamma engine'
    end
  end
  if Distribution.has_java?
    describe Distribution::Gamma::Java_ do
      before do
        @engine = Distribution::Gamma::Java_
      end
      it_should_behave_like 'Gamma engine'
    end
  end
end
