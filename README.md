# [Distribution](https://github.com/clbustos/distribution) Quick Start

```
git clone https://github.com/sciruby/distribution
```

## Description:

Statistical Distributions library. Includes Normal univariate and bivariate, T, F, Chi Square, Binomial, Hypergeometric, Exponential, Poisson, Beta, LogNormal and Gamma.

Uses Ruby by default and C (statistics2/GSL) or Java extensions where available.

Includes code from statistics2 on Normal, T, F and Chi Square ruby code [http://blade.nagaokaut.ac.jp/~sinara/ruby/math/statistics2]

## Synopsis:
  * Returns Gaussian PDF for x
  pdf=Distribution::Normal.pdf(x)
  * Returns Gaussian CDF for x
  cdf=Distribution::Normal.cdf(x)
  * Returns inverse CDF (or p-value) for x
  pv=Distribution::Normal.p_value(x)

## System Requirements:

To increase (notably!) the speed, please install

* Ruby 1.9-2.1: rb-gsl
* Java: Not yet implemented

## User Installation:
```
  gem install distribution
```
To speep up
```
  gem install gsl
```

## Developers:

After checking out the source, run:
```
  $ rake newb
```
This task will install any missing dependencies, run the tests/specs,
and generate the RDoc.

If you want to provide a new distribution, /lib/distribution run
```
  $ distribution --new your_distribution
```
This should create the main distribution file, the directory with ruby and gsl engines and the rspec on /spec directory.

### API Structure

  Distribution::<name>.(cdf|pdf|p_value|rng)

On discrete distributions, exact Ruby implementations of pdf, cdf and p_value could be provided, using
```
  Distribution::<name>.exact_(cdf|pdf|p_value)
```
module Distribution::Shorthand provides (you guess?) shortands method to call all methods
```
  <Distribution shortname>_(cdf|pdf|p|r)
```
On discrete distributions, exact cdf, pdf and p_value are
```
  <Distribution shortname>_(ecdf|epdf|ep)
```
Shortnames for distributions:

  * Normal: norm
  * Bivariate Normal: bnor
  * T: tdist
  * F: fdist
  * Chi Square: chisq
  * Binomial: bino
  * Hypergeometric: hypg
  * Exponential: expo
  * Poisson: pois
  * Beta: beta
  * Gamma: gamma
  * LogNormal: lognormal

### API Structure Example

```
  Distribution::T.cdf
```
could be called after including Distribution::Shorthand
```
  tdist_cdf
```

## Features

* Very fast ruby 1.8.7/1.9.+ implementation, with improved method to calculate factorials and others common functions
* All methods tested on several ranges. See spec/

## Issues

* On Jruby and Rubinius, BivariateNormal returns incorrect pdf

For current issues see the [issue tracker pages](https://github.com/clbustos/distribution/issues)
