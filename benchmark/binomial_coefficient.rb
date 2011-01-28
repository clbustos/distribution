$:.unshift(File.dirname(__FILE__)+"/../lib")
require 'distribution'
require 'bench_press'

extend BenchPress

name 'binomial coefficient: multiplicative, factorial and optimized factorial methods'
author 'Claudio Bustos'
date '2011-01-27'
summary "Binomial Coefficient could be obtained using multiplicative, pure factorial or optimized factorial algorithm. 
Which one is faster?

Lower k is the best for all 
k=n/2 is the worst case for optimized algorithm
k near n is the worst for multiplicative

The factorial method uses the fastest Swing Prime Algorithm."

reps 100 #number of repetitions

x=100

n=100
k=50

samples=[10,100,1000]



measure "Multiplicative" do
  samples.each do |n|
    [5,n/2,n-1].each do |k|
      (1..k).inject(1) {|ac, i| (ac*(n-k+i).quo(i))}
    end
  end
end

measure "Factorial" do
  samples.each do |n|
    [5,n/2,n-1].each do |k|
      Math.factorial(n).quo(Math.factorial(k) * Math.factorial(n - k))
    end
  end
end

measure "Optimized Factorial" do
  samples.each do |n|
    [5,n/2,n-1].each do |k|
      den_max=[k, n-k].max
      den_min=[k, n-k].min
      (((den_max+1)..n).inject(1) {|ac,v| ac * v}).quo(Math.factorial(den_min))
    end
  end
end


measure "Gamma" do
  samples.each do |n|
    [5,n/2,n-1].each do |k|
      Math.gamma(n+1) / (Math.gamma(k+1)*Math.gamma(n-k+1))
    end
  end
end
