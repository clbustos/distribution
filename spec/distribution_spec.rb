require File.expand_path(File.dirname(__FILE__)+"/spec_helper.rb")
describe Distribution do
  it "should respond to has_gsl?" do
    lambda {Distribution.has_gsl?}.should_not raise_exception
    if Distribution.has_gsl?
      defined?(GSL).should be_true
    else
      defined?(GSL).should be_false
    end 
  end
  it "should respond to has_statistics2?" do
    lambda {Distribution.has_statistics2?}.should_not raise_exception
    if Distribution.has_statistics2?
      defined?(Statistics2).should be_true
    else
      defined?(Statistics2).should be_false
    end 
  end
end
