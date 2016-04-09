require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
describe Distribution::ChiSquare do
  shared_examples_for 'Chi-square engine(with pdf)' do
    it_only_with_gsl 'should return correct pdf' do
      if @engine.respond_to? :pdf
        1.upto(10) do |k|
          v = 1 + rand(5)
          chi = GSL::Ran.chisq_pdf(v, k)
          expect(@engine.pdf(v, k)).to be_within(10e-10).of(chi)
        end
      else
        skip("No #{@engine}.pdf")
      end
    end
  end

  shared_examples_for 'Chi-square engine' do
    it_only_with_gsl 'should return correct cdf' do
      if @engine.respond_to? :cdf
        1.upto(10) do |k|
          v = 1 + rand(5)
          chi = GSL::Cdf.chisq_P(v, k)
          expect(@engine.cdf(v, k)).to be_within(10e-10).of(chi)
        end
      else
        skip("No #{@engine}.cdf")
      end
    end

    it 'should return correct p_value' do
      if @engine.respond_to? :p_value
        1.upto(10) do |k|
          v = 1 + rand(5)
          pr = @engine.cdf(v, k)
          expect(@engine.p_value(pr, k)).to be_within(10e-4).of(v)
        end
      else
        skip("No #{@engine}.p_value")
      end
    end
  end

  describe 'singleton' do
    before do
      @engine = Distribution::ChiSquare
    end
    it_should_behave_like 'Chi-square engine'
    it_should_behave_like 'Chi-square engine(with pdf)'
  end

  describe Distribution::ChiSquare::Ruby_ do
    before do
      @engine = Distribution::ChiSquare::Ruby_
    end
    it_should_behave_like 'Chi-square engine'
    it_should_behave_like 'Chi-square engine(with pdf)'
  end
  if Distribution.has_gsl?
    describe Distribution::ChiSquare::GSL_ do
      before do
        @engine = Distribution::ChiSquare::GSL_
      end
      it_should_behave_like 'Chi-square engine'
      it_should_behave_like 'Chi-square engine(with pdf)'
    end
  end
  if Distribution.has_statistics2?
    describe Distribution::ChiSquare::Statistics2_ do
      before do
        @engine = Distribution::ChiSquare::Statistics2_
      end
      it_should_behave_like 'Chi-square engine'
    end
  end

  if Distribution.has_java?
    describe Distribution::ChiSquare::Java_ do
      before do
        @engine = Distribution::ChiSquare::Java_
      end
      it_should_behave_like 'Chi-square engine'
      it_should_behave_like 'Chi-square engine(with pdf)'
    end
  end
end
