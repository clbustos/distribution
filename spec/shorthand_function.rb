require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution::Function do
  it "should correct factorial" do
    Distribution::Function.factorial(5).should eq(5*4*3*2*1)
  end
end
