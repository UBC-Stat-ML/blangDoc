# Getting started with Blang!

## Installation options

There are several options:

- Web: sign in or sign up at [http://54.201.228.108/users/sign_in](http://54.201.228.108/users/sign_in)
- Command line: [https://github.com/UBC-Stat-ML/blangDoc/blob/master/using-from-command-line.md](https://github.com/UBC-Stat-ML/blangDoc/blob/master/using-from-command-line.md)
- Eclipse (TODO: instructions)


## Creating your first model

- Create a file:
    - **Important:** the file name should end in ``.bl``.
    - We recommend to capitalize the model name as a convention.
    - Example: ``MyModel.bl``
- Paste the following template into the file, **replacing MyModel by your model name (without ``.bl``)**:


```
package blang.examples

import blang.types.*
import java.util.*
import xlinear.*

import static extension blang.utils.ExtensionUtils.* 
import static extension xlinear.MatrixExtensions.* 
import static blang.utils.StaticUtils.*
import static xlinear.MatrixOperations.* 

model MyModel { 

  // variable declarations go here
  
  laws {
  
    // laws go here
    
  }
}
```


## Running the model

- On the web
    - Click on the file name
    - Click on the home button to mark it as the file to run
    - Click on run
    - Output files appear on the bottom left
- Command line
    - See [https://github.com/UBC-Stat-ML/blangDoc/blob/master/using-from-command-line.md](https://github.com/UBC-Stat-ML/blangDoc/blob/master/using-from-command-line.md)
- Eclipse: TODO


## Building a non-trivial model

The model above provide no useful behaviour. Let's construct a non-trivial model. We still keep it small and simple to gently introduce the core blang concepts at the same time.


### Predicting the number of future members of the human species

Before creating new types of random variables, let us start with an example using
familiar, real-valued random variable to familiarize ourself with the main Blang
concepts. To do so, we will follow the lines of the most basic version of the 
[Doomsday argument](http://en.wikipedia.org/wiki/Doomsday_argument).


### Overview

Suppose you want to predict the number N of future members of the human species. 

From archaeological records, we know there are about 0.06 trillion humans have been 
born so far. Call this our observation Y. Let us assume that Y is uniformly 
distributed between 0 and N.

So if we put a prior on N, we can compute a posterior on the quantity of interest,
N - Y. Let us be optimistic, and let us put an exponential prior on N with a mean of
10.0 trillion humans.


### Blang model

Let us go over the corresponding blang model:

```
package blang.examples

import blang.types.*
import java.util.*
import xlinear.*

import static extension blang.utils.ExtensionUtils.* 
import static extension xlinear.MatrixExtensions.* 
import static blang.utils.StaticUtils.*
import static xlinear.MatrixOperations.* import blang.types.RealVar.RealScalar

model Doomsday { 
  
  random RealVar Y 
  random RealVar N          ?: realVar(Y.doubleValue + 1.0)
  
  param  RealVar priorRate  ?: realVar(1.0/10.0)
  
  laws {
    N | priorRate ~ Exponential(priorRate) 
    Y | N ~ ContinuousUniform([0.0], N)    
  }
}
```

As you can see, a model is specified by: 

- Declaration of variables (here two random variable and one parameter)
- Declaration of laws

We go over these, starting with laws.

### Laws

The notation for declaring laws,

```
    N | priorRate ~ Exponential(priorRate) 
    Y | N ~ ContinuousUniform([0.0], N) 
```

is virtually identical to the standard mathematical notation used to specified random variables via their (conditional) distributions. 


#### ``[...]`` notation

The only mysterious element is the brackets surrounding the first parameter of the ContinuousUniform, ``[0.0]``. This is because the two parameters of the uniform (min and max bounds) are of type RealVar. As in the mathematical formalisation of probability theory, a real number (a constant) is not the same as a real variable (a function). So the brackets convert the number 0.0 into the random variable that is constant at 0.0. (If you know Java and/or Xtend, this is possible because RealVar is a FunctionalInterface and [0.0] is just Xtend's lambda expression corresponding to Java's ``() -> 0.0``)


#### Looking up parameters

How to look up the number, type, and meaning of the parameters? E.g. how to know ``ContinuousUniform`` takes two arguments, min and max?

- First, get to the blang file declaring the distribution. 
    - If you are in eclipse, just click on the name while 
      holding the command key. 
    - Otherwise, go to [the github source](https://github.com/UBC-Stat-ML/blangSDK/tree/master/src/main/java/blang/distributions)
- Second, look at the subset of variables marked with the ``param`` keyword. Those are the expected arguments, appearing in the same order as in the distribution's blang file.

For example, the relevant chunk of ``ContinuousUniform.bl`` is:

```
  random RealVar realization
   
  param  RealVar min, 
                 max
```
implying that there are two parameters, first, ``min``, and second, ``max``.


#### Explicit conditioning is mandatory

In contrast to standard BUGS, the variables conditioned on are required. For example ``N ~ Exponential(priorRate)`` will lead to compile time error. This is done to stay closer to standard mathematical notation (as you will see later on, when going over the HMM example, the conditioning syntax is also useful for other purposes).


### Variables

#### Declaration of variables 

Variable need to be explicitly declared. Let us look how this is done in detail:

```
  random RealVar Y 
  random RealVar N          ?: realVar(Y.doubleValue + 1.0)
  
  param  RealVar priorRate  ?: realVar(1.0/10.0)
```

First a variable is either ``random`` or ``param``. 

- Those marked as ``random`` will be sampled, *unless* they are observed (more on how to define observation below).
- Those marked as ``param`` are fixed (not sampled), *unless* the model is used as part of a larger one (more on this later).

The variable is also given a type. This can be any Java class (although in some cases you may have to write a sampler for objects of that class, more on this later). But often you will be able to use a type provided by the SDK, for example:

- ``RealVar``: this is used to model real valued random variables (technically, Java's ``double``-valued r.v.s). (Note to Java programmer: this is different than ``Double`` since we need a mutable ``Double`` essentially)
- ``IntVar``: same for random integers (technically, Java's ``int``-valued r.v.s).
- ``Matrix``: used for random matrices and vectors (see more documentation [here](https://github.com/alexandrebouchard/xlinear)
- ``Simplex``: for random vectors summing to one
- ``TransitionMatrix``: for transition matrices (formed of rows of simplices).
- ``List<RealVar>``, ``List<IntVar>``, etc for lists of elements of various types. This highlights that many standard Java types can be used out of the box.

More examples are continuously added to the SDK, and will be found [here](https://github.com/UBC-Stat-ML/blangSDK/tree/master/src/main/java/blang/types). However, we emphasize that users are encouraged to create and publish their own data types, just as in regular programming languages. 


#### Loading data

If the model declared above is ran, both ``Y`` and ``N`` will be sampled. This does not correspond to what we want to do: we would like to condition on ``Y``. 

To do so, blang defines a command line argument for each variable in the model. For example, adding the switch ``--model.Y 0.06`` will set ``Y`` to 0.06 and keep it at this value throughout sampling. Note that the prefix ``model.`` in front of the variable name is required and used to differentiate options for model variable from e.g. options for the Monte Carlo simulation. 

To provide the command line option(s):

1. From the web interface, create a file named ``configuration.txt`` and paste ``--model.Y 0.06`` in it.
2. From the command line/eclipse, simply append ``--model.Y 0.06`` to the command line invocation the command line argument  (or use method 1., but do not mix the two).

For other types such as ``List<T>``, ``Matrix``, the command line argument for observations should point to a csv file. For example: 

- if there is a variable called ``List<RealVar> myVar``, 
- create a file called say ``my-observations.csv`` with contents 

```
0.2
0.1234
NA
-4.5e2
```

- and load it with ``--model.myVar.file my-observations.csv``. This will initialize ``myVar`` with a list of 4 real variables, where all of them except the third one are observed.

In general, to get instructions on how to load observation for all the variables in the model, provide a dummy command line argument such as ``--help`` to get instructions printed when you run the model. This is also useful to create a template for ``configuration.txt``.

When there are no command line argument provided, blang needs to know more information in order to initialize unobserved variables. For example, in order to initialize a latent matrix, its dimensions need to be specified. To do so, you should use the ``?:`` syntax, exemplified in ``?:  [1.0/10.0]``. The meaning of this expression is: if a command line argument is provided, use it to initialize the variable, if not, initialize the variable with the right hand side. The right hand side can be an arbitrary [Xtend expression](http://www.eclipse.org/xtend/documentation/203_xtend_expressions.html) (a superset of Java). The most common initialization functions can be found in [StaticUtils](https://github.com/UBC-Stat-ML/blangSDK/blob/master/src/main/java/blang/utils/StaticUtils.xtend).

Note: when creating a new types, if you want to be able to condition on the values of this new type, you will need to implement a simple parser to read the data in. How this is done is detailed in [this repository](https://github.com/UBC-Stat-ML/inits). 


### Running Monte Carlo simulation and using the posterior distribution

You may set the number of MCMC iterations using the command line argument ``--mcmc.nIterations``. 

Output is created in the folder ``results/latest``. Previous runs can be found in ``results/all``. Look in particular in the ``samples`` directory to find the Monte Carlo samples for each variable.

The format is in [tidy](http://vita.had.co.nz/papers/tidy-data.pdf) csv format. The first column is always the Monte Carlo iteration index, and the last one, the value at that iteration. List will have one intermediate column for the index in the list. Matrices will have two intermediate columns, one for the row followed by one for the column.  

If too much output is produced, the output can be thinned using ``--mcmc.thinningPeriod 10``, where 10 means to print sample only once every 10 passes on the data.
