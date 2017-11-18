# Project/Package organization

Two main repositories:

- blangDSL: strict minimum, just compilation of blang models into Java
- blangSDK: other core probabilistic modelling tools
- stuff in their own repositories
    - phylogenetics
    - Bayesian non-parametrics
    - SDEs
    - network models

Technical note: main reason for having two repositories (blangDSL and blangSDK): all imports of blangDSL need to be eclipse plugins, so that would exclude useful dependencies e.g. math commons, etc. So this forces us to keep blangDSL to the strict minimum.


## blangDSL

This contains several sub-projects (mandated by Xtend), but for blang development coding happens in subprojects ``ca.ubc.stat.blang`` and ``ca.ubc.stat.blang.parent``. Latter is just for the build file, former is organized into the following main packages:

- ``blang.core``: stuff imported by generated Java files.
- ``ca.ubc.stat.blang``
    - ``blangDsl.xtext``: the blang grammar
    - some xtext configurations
- ``ca.ubc.stat.blang.compiler``
    - ``BlangXbaseCompiler.xtend``: type conversion (see also ``BlangSynonymTypesProvider.xtend`` in a different package)
- ``ca.ubc.stat.blang.jvmmodel``: generation of Java files from a parsed blang model
    - ``SingleBlangModelInferrer.xtenx``: most of the work done here
    - ``BlangScope.xtext``, ``XExpressionProcessor.xtend`` support for XExpression processing
- ``ca.ubc.stat.blang.scoping``: automatic imports

## blangSDK

Core probabilistic modelling tools. Packages below marked with a star are automatically imported, the other ones require an ``import XXXX`` line right before the ``model { }`` block. The auto-import the package organization to be relatively flat. 

- ``blang.distributions``*: common distributions.
- ``blang.engines``: inference algorithms.
- ``blang.io``*: utilities for input/output.
- ``blang.mcmc``*: MCMC kernels.
- ``blang.runtime``: runtime for the language, i.e. code that constructs the factor graph from the model specification, and matches it to an engine.
- ``blang.types``: datatypes for random variables and model parameters along with some utilities to work with them.

Sub-packages of the form ``.internals`` contain supporting files which may be of less general interest. 

The choice of ``blang.*`` instead of ``ca.ubc.blang`` mirrors the ``java.*`` conventions of Java SDK.