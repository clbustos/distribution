require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
include ExampleWithGSL
# require 'ruby-prof'

# Need to test:
# * that Fixnum fast_choose returns same as choose
# * that pdf and exact_pdf return the same value in Ruby_
# * that cdf in Ruby_ returns the same value as cdf in GSL_

describe Distribution::Hypergeometric do
  describe Distribution::Hypergeometric::GSL_ do
    before do
      @ruby = Distribution::Hypergeometric::Ruby_
      @engine = Distribution::Hypergeometric::GSL_
    end
    it_only_with_gsl 'cdf should return values near to exact Ruby calculations' do
      # RubyProf.start

      if @engine.respond_to? :cdf
        # [2].each do |k|
        [0, 1, 2, 4, 8, 16].each do |k|
          expect(@engine.cdf(k, 80, 100, 10_000)).to be_within(1e-10).of(@ruby.cdf(k, 80, 100, 10_000))
        end
      # result = RubyProf.stop

      # Print a flat profile to text
      # printer = RubyProf::FlatPrinter.new(result)
      # printer.print(STDOUT)

      else
        pending("No #{@engine}.pdf")
      end
    end
  end
  describe Distribution::Hypergeometric::Ruby_ do
    before do
      @engine = Distribution::Hypergeometric::Ruby_
    end
    it_only_with_gsl 'pdf_fast should return same as pdf' do
      pending("Aprox. factorial doesn't work right")
      if @engine.respond_to? :pdf
        [0, 1, 2, 4, 8, 16].each do |k|
          expect(@engine.pdf_aprox(k, 80, 100, 1000)).to be_within(1e-8).of(GSL::Ran.hypergeometric_pdf(k, 80, 920, 100))
        end
      else
        pending("No #{@engine}.pdf")
      end
    end

    it_only_with_gsl 'should return correct pdf' do
      # RubyProf.start

      if @engine.respond_to? :pdf
        # [2].each do |k|
        [0, 1, 2, 4, 8, 16].each do |k|
          # puts "k:#{k}->#{@engine.pdf(k, 80, 100, 10000).to_f}"
          expect(@engine.pdf(k, 80, 100, 10_000).to_f).to be_within(1e-8).of(GSL::Ran.hypergeometric_pdf(k, 80, 9920, 100))
        end
      # result = RubyProf.stop

      # Print a flat profile to text
      # printer = RubyProf::FlatPrinter.new(result)
      # printer.print(STDOUT)

      else
        pending("No #{@engine}.pdf")
      end
    end

    it 'should return correct cdf' do
      total = rand(5) + 3000
      n = rand(10) + 15
      m = rand(10) + 5
      ac = 0
      0.upto(m) do |i|
        ac += @engine.pdf(i, m, n, total)
        expect(@engine.cdf(i, m, n, total)).to eq(ac)
      end
    end

    it 'should return correct p_value' do
      # 0.upto(10) do |i|
      #  puts "#{i}:#{@engine.pdf(i,5,7,10)}"
      # end
      total = rand(5) + 3000
      n = rand(10) + 15
      m = rand(10) + 5
      ac = 0
      0.upto(m) do |k|
        ac += @engine.pdf(k, m, n, total)
        expect(@engine.p_value(ac, m, n, total)).to eq(k)
      end
    end
  end
  describe Distribution::Hypergeometric do
    before do
      @engine = Distribution::Hypergeometric
    end
    it { expect(@engine).to respond_to(:exact_pdf) }
    it { expect(@engine).to respond_to(:exact_cdf) }
    it { expect(@engine).to respond_to(:exact_p_value) }
    it 'exact pdf should return a Rational' do
      expect(@engine.exact_pdf(1, 1, 1, 1)).not_to be_a(Float)
      expect(@engine.exact_pdf(16, 80, 100, 10_000)).not_to be_a(Float)
    end
  end
end
