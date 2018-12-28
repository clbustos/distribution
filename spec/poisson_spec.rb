require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::Poisson do
  shared_examples_for 'poisson engine(with rng)' do
    it 'should return correct rng' do
      # The expected rng output when 1 is set as the seed value
      exp_means = [1, 2, 2, 3, 4, 5, 6, 7, 8, 9]

      lambda_val = rand(10) + 1
      exp_mean = exp_means[lambda_val - 1]
      seed = 1

      rng = @engine.rng(lambda_val, seed)

      samples = 100
      sum = 0
      samples.times do
        v = rng.call
        sum += v
      end
      mean = sum / samples
      expect(mean.to_i).to be_within(1e-10).of(exp_mean)
    end
  end

  shared_examples_for 'poisson engine(with rng)' do
    it 'rng with a specified seed should be reproducible' do
      seed = 1
      rng1 = @engine.rng(3, seed)
      rng2 = @engine.rng(3, seed)
      expect((rng1.call)).to eq(rng2.call)
    end
  end


  shared_examples_for 'poisson engine' do
    it 'should return correct pdf' do
      if @engine.respond_to? :pdf
        [0.5, 1, 1.5].each {|l|
          1.upto(5) {|k|
            expect(@engine.pdf(k, l)).to be_within(1e-10).of((l**k * Math.exp(-l)).quo(Math.factorial(k)))
          }
        }
      else
        pending("No #{@engine}.pdf")
      end
    end

    it_only_with_gsl 'should return correct cdf' do
      if @engine.respond_to? :cdf
        [0.5, 1, 1.5, 4, 10].each {|l|
          1.upto(5) {|k|
            expect(@engine.cdf(k, l)).to be_within(1e-10).of(GSL::Cdf.poisson_P(k, l))
          }
        }

      else
        pending("No #{@engine}.cdf")
      end
    end

    it 'should return correct p_value' do
      pending('No exact p_value')
      if @engine.respond_to? :p_value
        [0.1, 1, 5, 10].each {|l|
          1.upto(20) {|k|
            pr = @engine.cdf(k, l)
            expect(@engine.p_value(pr, l)).to eq(k)
          }
        }
      else
        skip("No #{@engine}.p_value")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::Poisson
    end
    it_should_behave_like 'poisson engine'
  end

  describe Distribution::Poisson::Ruby_ do
    before do
      @engine = Distribution::Poisson::Ruby_
    end
    it_should_behave_like 'poisson engine'
  end
  if Distribution.has_gsl?
    describe Distribution::Poisson::GSL_ do
      before do
        @engine = Distribution::Poisson::GSL_
      end
      it_should_behave_like 'poisson engine'
    end
  end
  if Distribution.has_java?
    describe Distribution::Poisson::Java_ do
      before do
        @engine = Distribution::Poisson::Java_
      end
      it_should_behave_like 'poisson engine'

      it 'should return correct cdf' do
        [0.5, 1, 1.5, 4, 10].each {|l|
          1.upto(5) {|k|
            expect(@engine.cdf(k, l)).to be_within(1e-10).of(Distribution::Poisson::Ruby_.cdf(k, l))
          }
        }
      end
    end
  end
end
