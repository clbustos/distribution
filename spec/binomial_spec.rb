require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::Binomial do
  shared_examples_for 'binomial engine' do
    it '.rng should have mean and variance within acceptable limits of the theoretical estimates' do
      seed = Random.new_seed.modulo 100_000_007
      n = 100
      p = 0.67
      prng = @engine.rng(n, p, seed)
      samples = Array.new(10_000) { prng.call }
      
      expected_mean = n * p
      expected_variance = n * p * (1 - p)
      
      mean = samples.reduce(:+) / samples.count.to_f
      variance = samples.map {|s| (s - mean) ** 2}.reduce(:+) / (samples.count - 1).to_f
      
      # These are very crude estimates
      mean.should be_within(1.0).of(expected_mean)
      variance.should be_within(1.0).of(expected_variance)
      
    end
    
    it '.rng should return a repeatable PRNG when initialized similarly' do
      seed = Random.new_seed.modulo 100_000_007
      prng1 = @engine.rng(100, 0.67, seed)
      prng2 = @engine.rng(100, 0.67, seed)
      
      (prng1.call).should eq(prng2.call)
    end
    
    it '.pdf should return correct pdf' do
      if @engine.respond_to? :pdf
        [10, 100, 1000].each do |n|
          [1.quo(4), 1.quo(2), 3.quo(4)].each do |pr|
            [0, 1, n / 2, n - 1].each do |x|
              exp = Math.binomial_coefficient(n, x) * pr**x * (1 - pr)**(n - x)
              obs = @engine.pdf(x, n, pr)
              obs.should be_within(1e-5).of(exp), "For pdf(#{x},#{n},#{pr}) expected #{exp}, obtained #{obs}"
            end
          end
        end
      else
        skip("No #{@engine}.pdf")
      end
    end

    it_only_with_gsl '.cdf should return correct cdf for n<=100' do
      if @engine.respond_to? :pdf
        [10, 100].each do |n|
          [0.25, 0.5, 0.75].each do |pr|
            [1, n / 2, n - 1].each do |x|
              exp = GSL::Cdf.binomial_P(x, pr, n)
              obs = @engine.cdf(x, n, pr)
              exp.should be_within(1e-5).of(obs), "For cdf(#{x},#{n},#{pr}) expected #{exp}, obtained #{obs}"
            end
          end
        end
      else
        skip("No #{@engine}.cdf")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Binomial
    end

    it_should_behave_like 'binomial engine'

    it { @engine.should respond_to(:exact_pdf) }

    it {
      pending('No exact_p_value')
      @engine.should respond_to(:exact_p_value)
    }

    it 'exact_cdf should return same values as cdf for n=50' do
      pr = rand * 0.8 + 0.1
      n = rand(10) + 10
      [1, (n / 2).to_i, n - 1].each do |k|
        @engine.exact_cdf(k, n, pr).should be_within(1e-10).of(@engine.cdf(k, n, pr))
      end
    end

    it 'exact_pdf should not return a Float if not float is used as parameter' do
      @engine.exact_pdf(1, 1, 1).should_not be_a(Float)
      @engine.exact_pdf(16, 80, 1.quo(2)).should_not be_a(Float)
    end
  end

  describe Distribution::Binomial::Ruby_ do
    before do
      @engine = Distribution::Binomial::Ruby_
    end
    it_should_behave_like 'binomial engine'

    it 'should return correct cdf for n>100' do
      [500, 1000].each do |n|
        [0.5, 0.6].each do |pr|
          [n / 2].each do |x|
            cdf = @engine.exact_cdf(x, n, pr)
            p_value = @engine.p_value(cdf, n, pr)
            msg = "For p_value(#{cdf},#{n},#{pr}) expected #{x}, obtained #{p_value}"

            p_value.should eq(x), msg
          end
        end
      end
    end

    it 'should return correct p_value for n<=100' do
      pending("Can't calculate with precision x using p")

      [10, 100].each do |n|
        [0.25, 0.5, 0.75].each do |pr|
          [n / 2].each do |x|
            cdf = @engine.cdf(x, n, pr)
            p_value = @engine.p_value(cdf, n, pr)

            msg = "For p_value(#{cdf},#{n},#{pr}) expected #{x}, obtained #{p_value}"
            p_value.should eq(x), msg
          end
        end
      end
    end
  end

  if Distribution.has_gsl?
    describe Distribution::Binomial::GSL_ do
      before do
        @engine = Distribution::Binomial::GSL_
      end

      it_should_behave_like 'binomial engine'
    end
  end

  if Distribution.has_java?
    describe Distribution::Binomial::Java_ do
      before do
        @engine = Distribution::Binomial::Java_
      end

      it_should_behave_like 'binomial engine'
    end
  end
end
