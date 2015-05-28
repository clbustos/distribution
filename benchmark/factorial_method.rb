$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../lib')
require 'distribution'
require 'bench_press'

extend BenchPress

name 'aprox vs exact factorization method'
author 'Claudio Bustos'
date '2011-01-27'
summary "
Factorization requires a lot of processing, so approximation method could be  required. But for greats value, bigdecimal are required and things start to get harder.
* Approximation (fast_factorial): Luschny f.3
* Exact (factorial): Luschny Swing Prime
"

reps 10 # number of repetitions

x = 200

measure "Math.factorial(#{x})" do
  Math.factorial(x)
end

measure "Math.fast_factorial(#{x})" do
  Math.fast_factorial(x)
end
