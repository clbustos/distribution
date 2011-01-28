= distribution

* https://github.com/clbustos/distribution

== DESCRIPTION:

Statistical Distributions multi library wrapper.
Uses Ruby by default and C (statistics2/GSL) or Java extensions where available.

Includes code from statistics2

== FEATURES/PROBLEMS:

* Very fast ruby 1.8.7/1.9.+ implementation, with improved method to calculate factorials and others common functions
* All methods tested on several ranges. See spec/
* On Jruby, BivariateNormal returns incorrect pdf

== API structure

  Distribution::<name>.(cdf|pdf|p_value|rng)

On discrete distributions, exact Ruby implementations of pdf, cdf and p_value could be provided, using

  Distribution::<name>.exact_(cdf|pdf|p_value)

module Distribution::Shorthand provides (you guess?) shortands method to call all methods

  <Distribution shortname>_(cdf|pdf|p|r)

On discrete distributions, exact cdf, pdf and p_value are

  <Distribution shortname>_(ecdf|epdf|ep)
  
Shortnames are:

* Normal: norm
* Bivariate Normal: bnor
* T: tdist
* F: fdist
* Chi Square: chisq
* Binomial: bino
* Hypergeometric: hypg

For example

  Distribution::T.cdf

could be called after including Distribution::Shorthand
  
  tdist_cdf
  

== SYNOPSIS:
  # Returns Gaussian PDF for x
  pdf=Distribution::Normal.pdf(x)
  # Returns Gaussian CDF for x
  cdf=Distribution::Normal.cdf(x)
  # Returns inverse CDF (or p-value) for x
  pv =Distribution::Normal.p_value(x)
  
== REQUIREMENTS:

I try to provide a Ruby version for each method. To increase (notably!) the speed, please install

* Ruby 1.8-1.9: gsl or statistics2
* Java: Apache Math (not yet implemented)

== INSTALL:

  gem install distribution

To speep up
  
  gem install gsl
  gem install statistics
  
== DEVELOPERS:

After checking out the source, run:

  $ rake newb

This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

== LICENSE:

GPL V2
