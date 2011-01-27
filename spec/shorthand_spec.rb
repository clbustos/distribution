require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution::Shorthand do
  include Distribution::Shorthand
  it "should have basic methods for all distributions" do
    [:Normal,:ChiSquare, :F, :Hypergeometric, :T].each do |d|
      klass=Distribution.const_get(d)
      shortname=klass::SHORTHAND
      methods=[:pdf, :cdf, :p_value].map {|m| "#{shortname}_#{m}".to_sym}
      methods.each do |m| 
        Distribution::Shorthand.instance_methods.should include(m)
      end
    end
  end
  it "returns same values as long form" do
    x=rand()
    norm_cdf(x).should eql(Distribution::Normal.cdf(x))
    norm_pdf(x).should eql(Distribution::Normal.pdf(x))
    norm_p_value(x).should eql(Distribution::Normal.p_value(x))
  end
end
