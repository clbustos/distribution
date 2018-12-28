# [Distribution](https://github.com/sciruby/distribution)

[![Build Status](https://travis-ci.org/SciRuby/distribution.svg?branch=master)](https://travis-ci.org/SciRuby/distribution)
[![Code Climate](https://codeclimate.com/github/SciRuby/distribution/badges/gpa.svg)](https://codeclimate.com/github/SciRuby/distribution)

Distribution is a gem with several probabilistic distributions. Pure Ruby is used by default, C (GSL) or Java extensions are used if available. Some facts:

- Very fast ruby 1.9.3+ implementation, with improved method to calculate factorials and other common functions.
- All methods tested on several ranges. See `spec/`.
- Code for normal, Student's t and chi square is lifted from the [statistics2 gem](https://rubygems.org/gems/statistics2). Originally at [this site](http://blade.nagaokaut.ac.jp/~sinara/ruby/math/statistics2).
- The code for some functions and RNGs was lifted from Julia's [Rmath-julia](https://github.com/JuliaLang/Rmath-julia), a patched version of R's standalone math library.

The following table lists the available distributions and the methods available for each one. If a field is marked with an *x*, that distribution doesn't have that method implemented.

| Distribution     | PDF | CDF | Quantile | RNG | Mean | Mode | Variance | Skewness | Kurtosis | Entropy |
| :--------------- | :-: | :-: | :------: | :-: | :--: | :--: | :------: | :------: | :------: | :-----: |
| Uniform          |     |     |          |     | x    | x    | x        | x        | x        | x       |
| Normal           |     |     |          |     | x    | x    | x        | x        | x        | x       |
| Lognormal        |     |     | x        | x   | x    | x    | x        | x        | x        | x       |
| Bivariate Normal |     |     | x        | x   | x    | x    | x        | x        | x        | x       |
| Exponential      |     |     |          |     | x    | x    | x        | x        | x        | x       |
| Logistic         |     |     |          |     | x    | x    | x        | x        | x        | x       |
| Student's T      |     |     |          | x   | x    | x    | x        | x        | x        | x       |
| Chi Square       |     |     |          |     | x    | x    | x        | x        | x        | x       |
| Fisher-Snedecor  |     |     |          | x   | x    | x    | x        | x        | x        | x       |
| Beta             |     |     |          | x   | x    | x    | x        | x        | x        | x       |
| Gamma            |     |     | x        | x   | x    | x    | x        | x        | x        | x       |
| Weibull          |     |     |          | x   | x    | x    | x        | x        | x        | x       |
| Binomial         |     |     |          | x   | x    | x    | x        | x        | x        | x       |
| Poisson          |     |     |          |     | x    | x    | x        | x        | x        | x       |
| Hypergeometric   |     |     |          | x   | x    | x    | x        | x        | x        | x       |

## Installation

```
$ gem install distribution
```

You can install GSL for better performance:

* For Mac OS X: `brew install gsl`
* For Ubuntu / Debian: `sudo apt-get install libgsl0-dev`

After successfully installing the library:

```bash
$ gem install rb-gsl
```

## Examples

You can find automatically generated documentation on [RubyDoc](http://www.rubydoc.info/github/sciruby/distribution/master).

```
# Returns Gaussian PDF for x.
pdf = Distribution::Normal.pdf(x)

# Returns Gaussian CDF for x.
cdf = Distribution::Normal.cdf(x)

# Returns inverse CDF (or p-value) for x.
pv = Distribution::Normal.p_value(x)

# API.

# You would normally use the following
p = Distribution::T.cdf(x)

# to get the cumulative probability of `x`. However, you can also:

include Distribution::Shorthand
tdist_cdf(x)
```

## API Structure

```ruby
Distribution::<name>.(cdf|pdf|p_value|rng)
```

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
  * Uniform: unif

## Roadmap

This gem wasn't updated for a long time before I started working on it, so there are a lot of work to do. The first priority is cleaning the interface and removing cruft whenever possible. After that, I want to implement more distributions and make sure that each one has a RNG.

### Short-term

- Define a minimal interface for continuous and discrete distributions (e.g. mean, variance, mode, skewness, kurtosis, pdf, cdf, quantile, cquantile).
- Implement `Distribution::Uniform` with the default Ruby `Random`.
- Clean up the implementation of normal distribution. Implement the necessary functions.
- The same for Student's t, chi square, Fisher-Snedecor, beta, gamma, lognormal, logistic.
- The same for discrete distributions: binomial, hypergeometric, bernoulli (still missing), etc.

### Medium-term

- Implement [DSFMT](http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/SFMT/) for the uniform random generator.
- Cauchy distribution.

### Long-term

- Implementing everything in the distributions x functions table above.

## Issues

* On JRuby and Rubinius, BivariateNormal returns incorrect pdf

For current issues see the [issue tracker pages](https://github.com/sciruby/distribution/issues).

## OMG! I want to help!

Everyone is welcome to help! Please, test these distributions with your own use
cases and give a shout on the issue tracker if you find a problem or something
is strange or hard to use. Documentation pull requests are totally welcome.
More generally, any ideas or suggestions are welcome -- even by private e-mail.

If you want to provide a new distribution, run `lib/distribution`:

```
$ distribution --new your_distribution
```

This should create the main distribution file, the directory with Ruby and GSL engines and specs on the spec/ directory.
