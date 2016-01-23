$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../lib'))
require 'bench_press'
require 'distribution'
extend BenchPress

name 'calculate factorial vs looking on a Hash'
author 'Claudio Bustos'
date '2011-01-31'
summary "
Is better create a lookup table for factorial or just calculate it?
Distribution::MathExtension::SwingFactorial has a lookup table
for factorials n<20
"

reps 1000 # number of repetitions

measure 'Lookup' do
  Math.factorial(19)
end

measure 'calculate' do
  Distribution::MathExtension::SwingFactorial.naive_factorial(19)
end
