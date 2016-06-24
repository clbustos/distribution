require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Distribution::LogNormal do
  shared_examples_for 'log-normal engine' do
    it 'should return correct pdf' do
      if @engine.respond_to? :pdf
        1.upto(10) {
          u = rand
          s = rand * 100
          x = rand * 50
          exp = (1.0 / (x * s * Math.sqrt(2 * Math::PI))) * Math.exp(-((Math.log(x) - u)**2 / (2 * s**2)))
          expect(@engine.pdf(x, u, s)).to be_within(1e-10).of(exp)
        }
      else
        pending("No #{@engine}.pdf")
       end
    end
    it 'should return correct cdf' do
      if @engine.respond_to? :cdf
        1.upto(10) {
          u = rand
          s = rand * 100
          x = rand * 50
          exp = Distribution::Normal.cdf((Math.log(x) - u) / s)
          expect(@engine.cdf(x, u, s)).to be_within(1e-10).of(exp)
        }
      else
        pending("No #{@engine}.cdf")
       end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::LogNormal
    end
    it_should_behave_like 'log-normal engine'
  end

  describe Distribution::LogNormal::Ruby_ do
    before do
      @engine = Distribution::LogNormal::Ruby_
    end
    it_should_behave_like 'log-normal engine'
  end
  if Distribution.has_gsl?
    describe Distribution::LogNormal::GSL_ do
      before do
        @engine = Distribution::LogNormal::GSL_
      end
      it_should_behave_like 'log-normal engine'
    end
  end
end
