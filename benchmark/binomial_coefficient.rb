$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))
require 'distribution'
require 'bench_press'

extend BenchPress

samples = 10.times.map { |i| 2**(i + 1) }

name 'binomial coefficient: multiplicative, factorial and optimized factorial methods'
author 'Claudio Bustos'
date '2011-01-27'
summary "Exact calculation of Binomial Coefficient could be obtained using multiplicative, pure factorial or optimized factorial algorithm (failing + factorial).
Which one is faster?

Lower k is the best for all
k=n/2 is the worst case.

The factorial method uses the fastest Swing Prime Algorithm."

reps 10 # number of repetitions

x = 100

n = 100
k = 50

measure 'Multiplicative' do
  samples.each do |n|
    [5, n / 2].each do |k|
      k = [k, n - k].min
      (1..k).inject(1) { |ac, i| (ac * (n - k + i).quo(i)) }
    end
  end
end

measure 'Pure Factorial' do
  samples.each do |n|
    [5, n / 2].each do |k|
      k = [k, n - k].min
      Math.factorial(n).quo(Math.factorial(k) * Math.factorial(n - k))
    end
  end
end

measure 'Failing factorial + factorial' do
  samples.each do |n|
    [5, n / 2].each do |k|
      k = [k, n - k].min
      (((n - k + 1)..n).inject(1) { |ac, v| ac * v }).quo(Math.factorial(k))
    end
  end
end
