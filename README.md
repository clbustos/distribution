# [Distribution](https://github.com/sciruby/distribution)

[![Build Status](https://travis-ci.org/SciRuby/distribution.svg?branch=master)](https://travis-ci.org/SciRuby/distribution)
[![Code Climate](https://codeclimate.com/github/SciRuby/distribution/badges/gpa.svg)](https://codeclimate.com/github/SciRuby/distribution)

## Installation

```
$ gem install distribution
```

If you have GSL installed and want to speed things up, install `rb-gsl`:

```bash
$ gem install rb-gsl
```

## Description

Statistical Distributions library. Includes Normal univariate and bivariate, T, F, Chi Square, Binomial, Hypergeometric, Exponential, Poisson, Beta, LogNormal and Gamma.

Uses Ruby by default and C (statistics2/GSL) or Java extensions where available.

Includes code from statistics2 on Normal, T, F and Chi Square ruby code [http://blade.nagaokaut.ac.jp/~sinara/ruby/math/statistics2]

## Synopsis

* Returns Gaussian PDF for x

```
pdf=Distribution::Normal.pdf(x)
```

* Returns Gaussian CDF for x

```
cdf=Distribution::Normal.cdf(x)
```

* Returns inverse CDF (or p-value) for x

```
pv=Distribution::Normal.p_value(x)
```

## Developers

```
$ git clone https://github.com/SciRuby/distribution.git
```

If you want to provide a new distribution, run `lib/distribution`:

```
$ distribution --new your_distribution
```

This should create the main distribution file, the directory with Ruby and GSL engines and specs on the spec/ directory.

## API Structure

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

* On JRuby and Rubinius, BivariateNormal returns incorrect pdf

For current issues see the [issue tracker pages](https://github.com/sciruby/distribution/issues).
