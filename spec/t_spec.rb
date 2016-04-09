require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

include ExampleWithGSL

describe Distribution::T do
  shared_examples_for 'T engine(with rng)' do
    it 'should return correct rng' do
      pending
    end
  end

  shared_examples_for 'T engine(cdf with fractional df)' do
    it 'should return correct cdf with fractional df' do
      expect(@engine.cdf(1, 2.5)).to be_within(1e-6).of(0.7979695)
      expect(@engine.cdf(2, 3.5)).to be_within(1e-6).of(0.9369307)
      expect(@engine.cdf(3, 4.5)).to be_within(1e-6).of(0.9828096)
    end
  end

  shared_examples_for 'T engine' do
    it_only_with_gsl 'should return correct pdf' do
      if @engine.respond_to? :pdf
        [-2, 0.1, 0.5, 1, 2].each{|t|
          [2, 5, 10].each{|n|
            expect(@engine.pdf(t, n)).to be_within(1e-6).of(GSL::Ran.tdist_pdf(t, n))
            expect(@engine.pdf(t, n.to_f)).to be_within(1e-6).of(@engine.pdf(t, n))
          }
        }
      else
        pending("No #{@engine}.pdf")
      end
    end
    it_only_with_gsl 'should return correct cdf' do
      if @engine.respond_to? :cdf
        # Testing with R values
        expect(@engine.cdf(1, 2)).to be_within(1e-7).of(0.7886751)
        expect(@engine.cdf(1, 2.0)).to be_within(1e-7).of(0.7886751)
        expect(@engine.cdf(1, 3.0)).to be_within(1e-7).of(0.8044989)

        [-2, 0.1, 0.5, 1, 2].each{|t|
          [2, 5, 10].each{|n|
            expect(@engine.cdf(t, n)).to be_within(1e-4).of(GSL::Cdf.tdist_P(t, n))
            expect(@engine.cdf(t, n)).to be_within(1e-4).of(@engine.cdf(t, n.to_f))
          }
        }
      else
        pending("No #{@engine}.cdf")
      end
    end
    it_only_with_gsl 'should return correct p_value' do
      if @engine.respond_to? :p_value
        [-2, 0.1, 0.5, 1, 2].each{|t|
          [2, 5, 10].each{|n|
            area = Distribution::T.cdf(t, n)
            expect(@engine.p_value(area, n)).to be_within(1e-4).of(GSL::Cdf.tdist_Pinv(area, n))
          }
        }
      else
        pending("No #{@engine}.p_value")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::T
    end
    it_should_behave_like 'T engine'
  end

  describe Distribution::T::Ruby_ do
    before do
      @engine = Distribution::T::Ruby_
    end
    it_should_behave_like 'T engine'
    it_should_behave_like 'T engine(cdf with fractional df)'
  end

  if Distribution.has_gsl?
    describe Distribution::T::GSL_ do
      before do
        @engine = Distribution::T::GSL_
      end
      it_should_behave_like 'T engine'
      it_should_behave_like 'T engine(cdf with fractional df)'
    end
  end

  if Distribution.has_java?
    describe Distribution::T::Java_ do
      before do
        @engine = Distribution::T::Java_
      end
      it_should_behave_like 'T engine'
    end
  end
end
