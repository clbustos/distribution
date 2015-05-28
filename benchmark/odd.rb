
require 'bench_press'

extend BenchPress

name 'n&1==1 vs n%2==1 to detect odd numbers'
author 'Claudio Bustos'
date '2011-01-28'
summary "
Which is faster, n%1==1 or n%2==1
"

reps 10_000 # number of repetitions
n = 100_000
measure 'Using &' do
  n % 1 == 1
end

measure 'Using %' do
  n.odd?
end
