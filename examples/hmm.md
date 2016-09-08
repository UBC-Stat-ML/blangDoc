# HMM (Hidden Markov Model) example

## Abstract

In this tutorial, we will use an example of a widely used model, the HMM, to demonstrate some core blang concepts.

## Prerequisites

We assume the material of [getting started](../getting-started.md) has been covered. For convenience, here are the main resource links you may need here:

- [Available distributions](https://github.com/UBC-Stat-ML/blangSDK/tree/master/src/main/java/blang/distributions)
- [Available types](https://github.com/UBC-Stat-ML/blangSDK/tree/master/src/main/java/blang/types)
- [Utility functions, in particular, to instantiate variables](https://github.com/UBC-Stat-ML/blangSDK/blob/master/src/main/java/blang/utils/StaticUtils.xtend)

## Data and problem

Let's look at the texting habits data from [Cameron Davidson-Pilon's excellent book](http://nbviewer.jupyter.org/github/CamDavidsonPilon/Probabilistic-Programming-and-Bayesian-Methods-for-Hackers/blob/master/Chapter1_Introduction/Chapter1.ipynb):

![](hmm_files/texting.jpg)

[Raw data](hmm_files/texting-data.csv)

The question will be the same as in the above book, but we will use a different route: an HMM.


## Skeleton

Here is a skeleton to start from:

```
import blang.types.*
import java.util.*
import xlinear.*

import static extension blang.utils.ExtensionUtils.* 
import static extension xlinear.MatrixExtensions.* 
import static blang.utils.StaticUtils.*
import static xlinear.MatrixOperations.* 

model Texting {
  
  random List<IntVar>     data
  
  // TODO
    
  param  Simplex          initialDist   ?: simplex(2)
  param  TransitionMatrix transMtx      ?: 
    transitionMatrix(#[
      #[0.99, 0.01],
      #[0.01, 0.99]
    ])   
  
  laws {
    
    // TODO
        
  }
}
```

