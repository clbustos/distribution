require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
include ExampleWithGSL
# Need to test:
# * that Fixnum fast_choose returns same as choose
# * that pdf and exact_pdf return the same value in Ruby_
# * that cdf in Ruby_ returns the same value as cdf in GSL_

describe Distribution::Hypergeometric do
  describe Distribution::Hypergeometric::Ruby_ do
    before do
      @engine=Distribution::Hypergeometric::Ruby_
    end
    it_only_with_gsl "pdf_fast should return same as pdf" do
      pending("Not working yet")
      if @engine.respond_to? :pdf
        [1,2,4,8,16].each do |k|
          
          @engine.pdf_aprox(k, 80, 100, 1000).should be_within(1e-8).of(GSL::Ran::hypergeometric_pdf(k, 80, 920, 100))
        end
      else
        pending("No #{@engine}.pdf")
      end
    end
    require 'ruby-prof'
    it_only_with_gsl "should return correct pdf" do
      #RubyProf.start
      
      if @engine.respond_to? :pdf
        [1,2,4,8,16].each do |k|
          @engine.pdf(k, 80, 100, 10000).should be_within(1e-8).of(GSL::Ran::hypergeometric_pdf(k, 80, 9920, 100))
      end
      #result = RubyProf.stop
      
      # Print a flat profile to text
      #printer = RubyProf::FlatPrinter.new(result)
      #printer.print(STDOUT)
        
      else
        pending("No #{@engine}.pdf")
      end
    end
  end

end