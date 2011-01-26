= distribution

* https://github.com/clbustos/distribution

== DESCRIPTION:

Statistical Distributions multi library wrapper.
Uses Ruby by default and C (statistics2/GSL) or Java extensions where available.

Includes code from statistics2

== FEATURES/PROBLEMS:

* Base API
* Shorthand for easy use

== API structure

  Distribution::<name>.(cdf|pdf|p_value|rng)

module Distribution::Shorthand provides (you guess?) shortands method to call all methods

  <Distribution shortname>_(cdf|pdf|p|r)

Shortnames are:

* Normal: norm
* Bivariate Normal: bnor
* T: t
* F: f
* Chi Square: chisq

For example

  Distribution::T.rng

could be called after including Distribution::Shorthand

  t_r

== SYNOPSIS:
  # Returns Gaussian PDF for x
  pdf=Distribution::Normal.pdf(x)
  # Returns Gaussian CDF for x
  cdf=Distribution::Normal.cdf(x)
  # Returns inverse CDF (or p-value) for x
  pv =Distribution::Normal.p_value(x)
  
== REQUIREMENTS:

I try to provide a Ruby version for each method. But to increase (notably!) the speed, please install

* Ruby 1.8-1.9: gsl or statistics2
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
