require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Distribution::Exponential do
  shared_examples_for 'exponential engine' do
    it 'should return correct pdf' do
      if @engine.respond_to? :pdf
        [0.5, 1, 1.5].each {|l|
          1.upto(5) {|x|
            expect(@engine.pdf(x, l)).to be_within(1e-10).of(l * Math.exp(-l * x))
          }
        }
      else
        pending("No #{@engine}.pdf")
      end
    end

    it 'should return correct cdf' do
      if @engine.respond_to? :cdf
        [0.5, 1, 1.5].each {|l|
          1.upto(5) {|x|
            expect(@engine.cdf(x, l)).to be_within(1e-10).of(1 - Math.exp(-l * x))
          }
        }
      else
        pending("No #{@engine}.cdf")
      end
    end

    it 'should return correct p_value' do
      if @engine.respond_to? :p_value
        [0.5, 1, 1.5].each {|l|
          1.upto(5) {|x|
            pr = @engine.cdf(x, l)
            expect(@engine.p_value(pr, l)).to be_within(1e-10).of(x)
          }
        }
      else
        pending("No #{@engine}.p_value")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Exponential
    end
    it_should_behave_like 'exponential engine'
  end

  describe Distribution::Exponential::Ruby_ do
    before do
      @engine = Distribution::Exponential::Ruby_
    end
    it_should_behave_like 'exponential engine'
  end

  if Distribution.has_gsl?
    describe Distribution::Exponential::GSL_ do
      before do
        @engine = Distribution::Exponential::GSL_
      end
      it_should_behave_like 'exponential engine'
    end
  end

  #  if Distribution.has_java?
  #    describe Distribution::Exponential::Java_ do
  #      before do
  #        @engine=Distribution::Exponential::Java_
  #      end
  #    it_should_behave_like "exponential engine"
  #
  #    end
  #  end
  describe 'rng' do
    it 'should default to Kernel#rand if no :random is given' do
      allow(Random).to receive(:rand).and_return(0.5)
      rng = Distribution::Exponential.rng 1.0
      rng.call
    end

    it 'should use a given rng if one is passed during construction' do
      random = double('random')
      allow(random).to receive(:rand).and_return(0.5)
      rng = Distribution::Exponential.rng 1.0, random: random
      rng.call
    end
  end
end
