= distribution

* https://github.com/clbustos/distribution

== DESCRIPTION:

Statistical Distributions library. Includes Normal univariate and bivariate, T, F, Chi Square, Binomial, Hypergeometric, Exponential, Poisson, Beta, LogNormal and Gamma.

Uses Ruby by default and C (statistics2/GSL) or Java extensions where available.

Includes code from statistics2 on Normal, T, F and Chi Square ruby code [http://blade.nagaokaut.ac.jp/~sinara/ruby/math/statistics2] 

== FEATURES/PROBLEMS:

* Very fast ruby 1.8.7/1.9.+ implementation, with improved method to calculate factorials and others common functions
* All methods tested on several ranges. See spec/
* On Jruby and Rubinius, BivariateNormal returns incorrect pdf

== API structure

  Distribution::<name>.(cdf|pdf|p_value|rng)

On discrete distributions, exact Ruby implementations of pdf, cdf and p_value could be provided, using

  Distribution::<name>.exact_(cdf|pdf|p_value)

module Distribution::Shorthand provides (you guess?) shortands method to call all methods

  <Distribution shortname>_(cdf|pdf|p|r)

On discrete distributions, exact cdf, pdf and p_value are

  <Distribution shortname>_(ecdf|epdf|ep)
  
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

* Ruby 1.8-1.9: gsl (prefered) or statistics2
* Java: Not yet implemented

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

If you want to provide a new distribution, /lib/distribution run

  $ distribution --new your_distribution
  
This should create the main distribution file, the directory with ruby and gsl engines and the rspec on /spec directory.

== LICENSE:

Copyright (c) 2011-2012, Claudio Bustos
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the copyright holder nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
