require File.expand_path(File.dirname(__FILE__) + '/spec_helper.rb')
describe Distribution::Shorthand do
  include Distribution::Shorthand
  it 'should have basic methods for all distributions' do
    [:Normal, :ChiSquare, :F, :Hypergeometric, :Binomial, :T].each do |d|
      klass = Distribution.const_get(d)
      shortname = klass::SHORTHAND
      methods = [:pdf, :cdf, :p_value].map { |m| "#{shortname}_#{m}".to_sym }
      methods.each do |m|
        expect(Distribution::Shorthand.instance_methods.map(&:to_sym)).to include(m)
      end
    end
  end
  it 'should have exact methods discrete distributions' do
    [:Hypergeometric, :Binomial].each do |d|
      klass = Distribution.const_get(d)
      shortname = klass::SHORTHAND
      methods = [:epdf, :ecdf].map { |m| "#{shortname}_#{m}".to_sym }
      methods.each do |m|
        expect(Distribution::Shorthand.instance_methods.map(&:to_sym)).to include(m)
      end
    end
  end

  it 'returns same values as long form' do
    x = rand
    expect(norm_cdf(x)).to eql(Distribution::Normal.cdf(x))
    expect(norm_pdf(x)).to eql(Distribution::Normal.pdf(x))
    expect(norm_p_value(x)).to eql(Distribution::Normal.p_value(x))
  end
end
