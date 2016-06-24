require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Distribution::Logistic do
  shared_examples_for 'logistic engine' do
    it 'should return correct pdf' do
      if @engine.respond_to? :pdf
        1.upto(10) {
          u = rand
          s = rand + 1
          x = rand * 100 - 50
          exp = Math.exp(-(x - u) / s) / (s * (1 + Math.exp(-(x - u) / s)**2))
          expect(@engine.pdf(x, u, s)).to eq(exp)
        }
      else
        pending("No #{@engine}.pdf")
       end
    end

    it 'should return correct cdf' do
      if @engine.respond_to? :cdf
        1.upto(100) {
          u = rand
          s = rand * 100
          x = rand * 100 - 50
          exp = 1 / (1 + Math.exp(-(x - u) / s))

          expect(@engine.cdf(x, u, s)).to eq(exp)
        }

      else
        pending("No #{@engine}.cdf")
      end
    end

    it 'should return correct p_value' do
      if @engine.respond_to? :p_value
        1.upto(9) {|i|
          u = rand
          s = rand * 100
          x = @engine.p_value(i / 10.0, u, s)
          expect(@engine.cdf(x, u, s)).to be_within(1e-10).of(i / 10.0)
        }
      else
        pending("No #{@engine}.cdf")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Logistic
    end
    it_should_behave_like 'logistic engine'
  end

  describe Distribution::Logistic::Ruby_ do
    before do
      @engine = Distribution::Logistic::Ruby_
    end
    it_should_behave_like 'logistic engine'
  end
end
