require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::BivariateNormal do
  shared_examples_for 'all pdf normal capables engines' do
    it_only_with_gsl 'should return correct pdf' do
      if @engine.respond_to? :pdf
        [0.2, 0.4, 0.6, 0.8, 0.9, 0.99, 0.999, 0.999999].each {|rho|
          expect(@engine.pdf(0, 0, rho, 1, 1)).to be_within(1e-8).of(GSL::Ran.bivariate_gaussian_pdf(0, 0, 1, 1, rho))
        }
      else
        pending("No #{@engine}.pdf")
      end
    end
  end

  shared_examples_for 'all cdf normal capables engines' do
    it 'should return correct cdf' do
      if @engine.respond_to? :cdf
        expect(@engine.cdf(2, 0.5, 0.5)).to be_within(1e-3).of(0.686)
        expect(@engine.cdf(2, 0.0, 0.5)).to be_within(1e-3).of(0.498)
        expect(@engine.cdf(1.5, 0.5, 0.5)).to be_within(1e-3).of(0.671)
        v = rand
        expect(@engine.cdf(10, 0, v)).to be_within(1e-3).of(Distribution::Normal.cdf(0))
      else
        pending("No #{@engine}.cdf")

      end
    end
  end
  describe 'singleton' do
    before do
      @engine = Distribution::BivariateNormal
    end
    it_should_behave_like 'all pdf normal capables engines'
    it_should_behave_like 'all cdf normal capables engines'
  end

  describe Distribution::Normal::Ruby_ do
    before do
      @engine = Distribution::BivariateNormal::Ruby_
    end
    it_should_behave_like 'all pdf normal capables engines'
    it_should_behave_like 'all cdf normal capables engines'
    it 'Ganz method should return similar method to Hull one' do
      [-3, -2, -1, 0, 1, 1.5].each {|x|
        expect(@engine.cdf_hull(x, x, 0.5)).to be_within(0.001).of(@engine.cdf_genz(x, x, 0.5))
      }
    end
  end
  describe Distribution::Normal::GSL_ do
    before do
      @engine = Distribution::BivariateNormal::GSL_
    end
    it_should_behave_like 'all pdf normal capables engines'
  end
end
