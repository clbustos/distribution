require 'bench_press'
require 'bigdecimal'
extend BenchPress

name 'Float vs Rational power'
author 'Claudio Bustos'
date '2011-02-02'
summary "
On ruby, the maximum size of a float is #{Float::MAX}.
With Rational, we can raise to integer numbers and surpass Float maximum.
What is the speed reduction using Rational?"

reps 1000 # number of repetitions
int = 10
rat = 10.quo(1)
bd = BigDecimal('10')
measure 'Using float pow' do
  int**307
end

measure 'Using rational' do
  rat**307
end

measure 'Using big decimal pow' do
  bd**307
end
