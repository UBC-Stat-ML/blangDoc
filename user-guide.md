# User guide

- Writing and running a simple model
    - quick overview of features and examples (+ phylo, NPB)
    - running 
        - online/command line/eclipse (later: R?)
        - tidy output
        - Z estimates
- Core blang concepts (+ Bayes primer)
    - random/param
    - loops (and conditionals?)
    - invoking distribution
- Blang SDK
    - Plate
    - xtend primer
    - SDK types
        - RealVar, IntVar, type conversion
        - xlinear (example, square root imp for units, matrix)
        - simplex, etc
    - SDK distributions
    - SDK functions
    - SDK engines
- Writing and invoking your own distribution
    - logf
    - indicator
    - generate
    - distributions that are special case of another (e.g. Exp Gamma)
- Complex dependencies: HMM example
    - Factor graphs under the hood
    - Plotting graph analysis, factor graph
- New types (example: phylo and BNP)
    - MH moves
    - inits primer
    - tidy output
    - other samplers
        - how the models are just java classes under hood
    - xtend, continued
    - advanced object graph analysis
        - skipping
        - exploration rules
- Testing and debug
- Amazon/cluster execution
- Distributed execution


## Core language concepts

### A model

A Blang model specifies a probability distribution over one or several random variables. Since Bayesian models consist in probability distributions over the known and unknown quantities, this makes it a suitable tool for doing Bayesian analysis (hence the B in Blang).

Textbooks often insist on priors and likelihood, and indeed, it is often convenient to use chain rule and express the probability as a distribution on the unknowns (the prior) times a conditional probability of the knowns given the unknowns (the likelihood). But in complex models this can become an artificial view so we will instead focus on the view of building joint distributions over knowns and unknowns.

Blang models specify distributions using the following general structure, illustrated here with a very simple model for the Doomsday problem:


```
model Doomsday { 
  
  // Declaration of parameters and random variables
  random RealVar z 
  random RealVar y
  
  param RealVar rate
    
  laws {
    // Specification of the distributions (laws) 
    // on the random variables
    z | rate ~ Exponential(rate) 
    y | z ~ ContinuousUniform(0.0, z)    
  }
}
```

Here Doomsday is a just a name we give to this model. As a convention, we encourage users to capitalize model names (Blang is case-sensitive).

An important feature of Blang models is that they can be composed. For example, in the model above, both ``Exponential`` and ``ContinuousUniform`` are themselves blang models that follow the same structure. In fact, if you are using the Eclipse IDE, and click on the word ``Exponential`` while clicking on the command key, you will be taken to the definition of that model (from the Blang Software Development Kit (SDK)).

In the next sections we will go over each part in more detail.


### Random variables

A second important feature of Blang is that the type system is open. Instead of having to use a predefined list of data-types for random variables, you are free to create new ones. We will cover how to create new types later in this tutorial. This is very useful in many areas of application.  For example, computational biology uses phylogenetic trees, pedigrees, and a myriad of kinds of networks and graphs. Bayesian non-parametric uses partitions, hierarchical clusterings and various structured binary matrices. 

Variables need to specify their **type**, e.g.:

```
random RealVar z
```

is of type ``RealVar`` and we give it the name ``z``. Here ``random`` is a Blang keyword. 

As a convention, types are capitalized, variable names are not.

### Laws, part one

The section ``laws { ... }`` defines distribution and conditional distributions on the random variables. The syntax is the same as the notation used in probability theory. For example, ``y | z ~ ContinuousUniform(0.0, z)`` means that the conditional distribution of ``y`` given ``z`` is uniformly distributed between zero and ``z``.

In contrast to the BUGS syntax and its descendants, we require the specification of the conditioning. There are two reasons for that. First, to keep the notation consistent with the probability notation (e.g. when the language is used for teaching). Second, we later extend the conditioning to perform pre-computation.  


### Model parameters and model composition

Notice also in the ``Doomsday`` example above that we used the keyword ``param`` for the variable ``rate``. This means that we won't give a distribution to this variable in the context of the ``Doomsday`` model. However, if the model is invoked by another model, in that context the parent model might still provide a distribution to that variable and make it random. 

Here is a concrete example, where we create a new model which invoke the ``Doomsday`` model, make the rate random with an exponential distribution on it (not a very smart model, but illustrates the point).  

```
model RandomRateDoomsday {

  random RealVar top, middle, bottom
  
  laws {
  
    top ~ Exponential(1.0)
    middle, bottom | top ~ Doomsday(top)
  
  }

}
```

The order of ``middle, bottom`` is the same as the order they are declared in ``Doomsday`` and matched to ``z, y`` respectively. 

Similarly, if there would have been more than one parameters, the order of the arguments in ``Doomsday(...)`` would have matched the order of the ``random`` variables. 

The declared ``random`` and ``param`` can be interleaved (order among each category is what matters), but this may make the code less readable so should be avoided if possible.

If on the other hand we used model ``Doomsday`` directly, we would have to specify a constant value for the ``rate`` variable, for example as a command line argument or configuration file. More on that soon.


### More on model composition

When we build models from constituent sub-models as above,

```
middle, bottom | top ~ Doomsday(top)
```

it is often desired to use transformations of random variables as parameters. For example, if we want the rate to be given by the square of the top random variable, we write

```
middle, bottom | top ~ Doomsday(top ** 2)
```

The statement ``top ** 2`` is an example of an XExpression, which admits a rich and concise, Turing-complete syntax. We will talk more about it later on. 

As the MCMC or SMC algorithm explores the space, the expression ``top ** 2`` is re-evaluated every time the top node changes. 

Using a different construct, it is also possible to precompute certain expressions only once. This is done as follows:

```
middle, bottom | top, double constant = PI ** 2 ~ Doomsday(top ** 2 + constant)
```

We give a more interesting example in the next section of how such pre-computation can be very useful.


### Elementary models 

So far we have built models from other models. Sometimes you also just want to build a model by providing a density. 

Look at the laws defined for the Normal distribution for example:

```
  laws {  
    
    logf() {
      - log(2*PI) / 2.0
    }
    
    logf(variance) {
      - 0.5 * log(variance)
    }
    
    logf(mean, variance, realization)  {
      check(variance > 0)
      return - 0.5 * ((mean - realization) ** 2) / variance
    }
  }
``` 

The density will just be the product of these three XExpressions. Breaking them in this fashion can speed up inference by informing blang for example that the normalization constant needs not be re-computed if only the realization has changed. 


### Loops: building high-dimensional models

Loops, based on the ``for`` keyword, allow us to build more interesting models. To illustrate how for loops work in blang, let us look in detail at the syntax of a Markov model:   

```
model MarkovModel {  
  
  param Simplex initialDistribution
  param TransitionMatrix transitionProbabilities 
   
  random List<IntVar> chain
   
  laws { 
    // Initial distribution:
    chain.get(0) | initialDistribution ~ Categorical(initialDistribution)
    
    // Transitions: 
    for (int step : 1 ..< chain.size) {
      chain.get(step) |
        IntVar previous = chain.get(step - 1),
        transitionProbabilities
        ~ Categorical(transitionProbabilities.row(previous)) 
    }
  }
}
```

The for loop itself is pretty self-explanatory. The range of the variable ``1 ..< chain.size`` is another example of an XExpression, which again we will cover in more detail later on. For now, suffices to note that ``..<`` specifies an interval of integers with the left included and right excluded. We start at one because index 0 is defined via an initial distribution, not because of 1-indexing. Blang is zero-indexed. 

Notice that we used the pre-computation construct, namely

```
IntVar previous = chain.get(step - 1)
```  

Accessing an array is not so much expensive, so you may wonder why we bothered pre-computing this. It turns out there is actually an important speed gain to be made, of the order of the length of the chain. Why?

To understand, we need to outline how the blang inference engines work under the hood. Most of these engines exploit cases where conditional distributions only depend on subsets of the variables. To do so, blang inspects the model constituents (for example the ``Categorical`` constituents) to infer what is the *scope* of the constituent. A scope is simply the subset of the variables available at a given location of the code (e.g. the code in one function cannot access the local variables declared in another function, they are *out of scope*). So coming back to the HMM example, this means that by passing in the precomputed ``chain.get(step - 1)`` rather than all the latent variables, we make it possible for blang engines to infer that each time step in the HMM only have interdependence with the previous and next state rather than all states. In graphical model parlance, this means sparsity patterns in the graphical model are inferred.

For efficiency reason, the structure of the inferred sparsity is currently pre-computed and fixed. The main implication is that the range of for loops in blang models should be deterministic. However the user is still free to design data types of random dimensionality, provided a custom sampler is provided for that infinite dimensional data type.  

Nested loops are permitted and function the same way they do in any reasonable existing programming language. 
 

### Plates





                 