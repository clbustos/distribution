require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

describe Distribution::Normal do
  shared_examples_for 'gaussian engine(with rng)' do
    it 'should return correct rng' do
      samples = 100
      sum = 0
      ss = 0
      exp_mean = rand(10) - 5
      exp_sd = 1
      rng = @engine.rng(exp_mean, exp_sd)

      samples.times do
        v = rng.call
        sum += v
        ss += (v - exp_mean)**2
      end

      mean = sum.to_f / samples
      sd = Math.sqrt(ss.to_f / samples)
      expect(mean).to be_within(0.5).of(exp_mean)
      expect(sd).to be_within(0.3).of(exp_sd)
    end
  end

  shared_examples_for 'gaussian engine(with rng)' do
    it 'rng with a specified seed should be reproducible' do
      seed = rand(10)
      rng1 = @engine.rng(0, 1, seed)
      rng2 = @engine.rng(0, 1, seed)
      expect((rng1.call)).to eq(rng2.call)
    end
  end

  shared_examples_for 'gaussian engine(with pdf)' do
    it 'should return correct pdf' do
      if @engine.respond_to? :pdf
        10.times do |i|
          x = (i - 5) / 2.0
          pdf = (1.0 / Distribution::SQ2PI) * Math.exp(-(x**2 / 2.0))
          expect(@engine.pdf(x)).to be_within(1e-10).of(pdf)
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
  end

  shared_examples_for 'gaussian engine' do
    it 'should return correct cdf' do
      if @engine.respond_to? :cdf
        expect(@engine.cdf(1.96)).to be_within(1e-10).of(0.97500210485178)
        expect(@engine.cdf(0)).to be_within(1e-10).of(0.5)
      else
        pending("No #{@engine}.cdf")
      end
    end
    it 'should return correct p_value' do
      if @engine.respond_to? :p_value
        expect(@engine.p_value(0.5)).to be_within(1e-3).of(0)
        10.times do |i|
          x = (i - 5) / 2.0
          cdf = @engine.cdf(x)
          expect(@engine.p_value(cdf)).to be_within(1e-6).of(x)
        end
      else
        pending("No #{@engine}.p_value")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Normal
    end
    it_should_behave_like 'gaussian engine'
    it_should_behave_like 'gaussian engine(with rng)'
    it_should_behave_like 'gaussian engine(with pdf)'
  end

  describe Distribution::Normal::Ruby_ do
    before do
      @engine = Distribution::Normal::Ruby_
    end
    it_should_behave_like 'gaussian engine'
    it_should_behave_like 'gaussian engine(with rng)'
    it_should_behave_like 'gaussian engine(with pdf)'
  end
  if Distribution.has_gsl?
    describe Distribution::Normal::GSL_ do
      before do
        @engine = Distribution::Normal::GSL_
      end
      it_should_behave_like 'gaussian engine'
      it_should_behave_like 'gaussian engine(with rng)'
      it_should_behave_like 'gaussian engine(with pdf)'
    end
  end
  if Distribution.has_statistics2?
    describe Distribution::Normal::Statistics2_ do
      before do
        @engine = Distribution::Normal::Statistics2_
      end
      it_should_behave_like 'gaussian engine'
    end
  end

  if Distribution.has_java?
    describe Distribution::Normal::Java_ do
      before do
        @engine = Distribution::Normal::Java_
      end
      it_should_behave_like 'gaussian engine'
    end
  end
end
