require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
include ExampleWithGSL
# Need to test:
# * that Fixnum fast_choose returns same as choose
# * that pdf and exact_pdf return the same value in Ruby_
# * that cdf in Ruby_ returns the same value as cdf in GSL_

describe Distribution::Hypergeometric do
  shared_examples_for "Hypergeometric engine(with pdf)" do
    it_only_with_gsl "should return correct pdf" do
      if @engine.respond_to? :pdf
        [1,2,4,8,16].each do |k|
          @engine.pdf(k, 80, 100, 10000).should be_within(1e-8).of(GSL::Ran::hypergeometric_pdf(k, 80, 9920, 100))
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
  end


  describe Distribution::Hypergeometric::Ruby_ do
    before do
      @engine=Distribution::Hypergeometric::Ruby_
    end
    it_should_behave_like "Hypergeometric engine(with pdf)"
  end
  describe Distribution::Hypergeometric::GSL_ do
    before do
      @engine=Distribution::Hypergeometric::GSL_
    end
    it_should_behave_like "Hypergeometric engine(with pdf)"
  end
end