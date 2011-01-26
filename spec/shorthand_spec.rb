require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution::Shorthand do
  include Distribution::Shorthand
  it "should have normal methods" do
    Distribution::Shorthand.instance_methods.map{|v| v.to_sym}.should include(:norm_pdf, :norm_cdf, :norm_rng,:norm_p_value)
  end
  it "returns same values as long form" do
    x=rand()
    norm_cdf(x).should eql(Distribution::Normal.cdf(x))
    norm_pdf(x).should eql(Distribution::Normal.pdf(x))
    norm_p_value(x).should eql(Distribution::Normal.p_value(x))
    
  end
end
