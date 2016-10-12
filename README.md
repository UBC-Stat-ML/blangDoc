# Documentation for blang 3

Blang is a probabilistic programming language with the following objectives in mind:

- **Complex state spaces:** support for models built from both real random variables and discrete/combinatorial random variables such as partitions, trees, matchings, etc. Such state spaces are quite useful in applications such as phylogenetics or Bayesian non-parametrics.
- **Extensibility:** ability to create arbitrary types, distributions, and samplers. In particular, the standard library is written in blang.
- **Ease of use:** the language is based on the familiar BUGS language and we provide two IDEs, one web IDE especially useful in a teaching context, featuring cloud MCMC execution and no installation requirement, as well a desktop IDE featuring auto-complete, linking, etc, based on static type analysis.
- **Efficiency:** based on a portfolio of sampling techniques, in particular, the [Bouncy Particle Sampler](https://arxiv.org/abs/1510.02451), as well as Just-in-Time (JIT) compilation.


## Description

Documentation and various natural language documents for blang3 

- [Getting started](https://github.com/UBC-Stat-ML/blangDoc/blob/master/getting-started.md).
- [A more interesting example demonstrating more advanced features](https://github.com/UBC-Stat-ML/blangDoc/blob/master/examples/hmm.md).



## Repos being documented here

- [BlangDoc](https://github.com/UBC-Stat-ML/blangDoc) (this) 
- [BlangSDK](https://github.com/UBC-Stat-ML/blangSDK/) (main one users will interact with) [![Build Status](https://travis-ci.org/UBC-Stat-ML/blangSDK.png?branch=master)](https://travis-ci.org/UBC-Stat-ML/blangSDK)
- [BlangDSL](https://github.com/UBC-Stat-ML/blangDSL/) (low-level) [![Build Status](https://travis-ci.org/UBC-Stat-ML/blangDSL.png?branch=master)](https://travis-ci.org/UBC-Stat-ML/blangDSL.png) 

Other related repos:

- [xlinear](https://github.com/alexandrebouchard/xlinear) (provides linear algebra) [![Build Status](https://travis-ci.org/alexandrebouchard/xlinear.png?branch=master)](https://api.travis-ci.org/alexandrebouchard/xlinear) 
- [inits](https://github.com/UBC-Stat-ML/inits/) (used to get data into blang) [![Build Status](https://travis-ci.org/UBC-Stat-ML/inits.png?branch=master)](https://travis-ci.org/UBC-Stat-ML/inits) 
