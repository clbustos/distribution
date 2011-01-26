= distribution

* https://github.com/clbustos/distribution

== DESCRIPTION:

Statistical Distributions library. Use C (statistics2/GSL) and Java extensions where available.

Includes code from statistics2

== FEATURES/PROBLEMS:

* Base API
* Shorthand for easy use

== API structure

  Distribution::<name>.(cdf|pdf|p_value|rng)

module Distribution::Shorthand provides (you guess?) shortands method to call all methods

  <first 4 letters of name>_(cdf|pdf|pv|r)

For example

  Distribution::T.rng

could be called after including Distribution::Shorthand

  t_r

== SYNOPSIS:

  cdf=Distribution::Normal.cdf(x)
  

== REQUIREMENTS:

To speed methods

* Ruby 1.8-1.9: gsl or statistics
* Java: Apache Math

== INSTALL:

  gem install distribution

== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

GPL V2
