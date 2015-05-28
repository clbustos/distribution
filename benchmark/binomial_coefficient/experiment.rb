# This test create a database to adjust the best algorithm
# to use on correlation matrix
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + '/../../lib'))
require 'distribution'
require 'statsample'
require 'benchmark'

if !File.exist?('binomial_coefficient.ds') or File.mtime(__FILE__) > File.mtime('binomial_coefficient.ds')
  reps = 100 # number of repetitions
  ns = {
    5 => [1, 3],
    10 => [1, 3, 5],
    50 => [1, 3, 5, 10, 25],
    100 => [1, 3, 5, 10, 25, 50],
    500 => [1, 3, 5, 10, 25, 50, 100, 250],
    1000 => [1, 3, 5, 10, 25, 50, 100, 250, 500],
    5000 => [1, 3, 5, 10, 25, 50, 100, 250, 500, 1000, 2500],
    10_000 => [1, 3, 5, 10, 25, 50, 100, 250, 500, 1000, 2500, 5000]
  }

  rs = Statsample::Dataset.new(%w(n k mixed_factorial multiplicative))

  ns.each do |n, ks|
    ks.each do |k|
      time_factorial = Benchmark.realtime do
        reps.times {
          (((n - k + 1)..n).inject(1) { |ac, v| ac * v }).quo(Math.factorial(k))
        }
      end

      time_multiplicative = Benchmark.realtime do
        reps.times {
          (1..k).inject(1) { |ac, i| (ac * (n - k + i).quo(i)) }
        }
      end

      puts "n:#{n}, k:#{k} -> factorial:%0.3f | multiplicative: %0.3f " % [time_factorial, time_multiplicative]

      rs.add_case('n' => n, 'k' => k, 'mixed_factorial' => time_factorial, 'multiplicative' => time_multiplicative)
    end
  end

else
  rs = Statsample.load('binomial_coefficient.ds')
end

rs.fields.each { |f| rs[f].type = :scale }

rs.update_valid_data
rs.save('binomial_coefficient.ds')
Statsample::Excel.write(rs, 'binomial_coefficient.xls')
