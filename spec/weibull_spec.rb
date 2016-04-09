require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')

include ExampleWithGSL

describe Distribution::Weibull do
  # shared_examples for "Weibull engine" do
  it 'should return correct pdf' do
    expect(Distribution::Weibull.pdf(2, 1, 1)).to be_within(1e-3).of(0.13533)
  end
  it 'should return correct cdf' do
    expect(Distribution::Weibull.cdf(2, 1, 1)).to be_within(1e-3).of(0.86466)
  end
  it 'should return correct p-value' do
    expect(Distribution::Weibull.p_value(0.86466, 1, 1)).to be_within(1e-3).of(2.0)
  end
  # end
end
