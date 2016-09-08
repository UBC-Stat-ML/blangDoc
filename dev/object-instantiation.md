Summary
-------

Architecture to allow creating all the variables and parameters automatically (from reading string arguments such as command line, JSON files, GUIs, or inter-process communication).

Examples
--------

- Building a ``Real``, ``Str``, ``BioSeq`` etc
- ``Plated<T>`` variables
- More specialized examples such as ``Phylogeny``, ``Clustering``, etc 

Roles
-----

- Object instantiation
- Informing the sampler which variables are observed (e.g. that when NA is read, this should not be marked observed)
- Listing options

Issues
------

- Automatic/declarative type level init is attractive, but...
- Sharing dimensions in ``Plated`` indices becomes a problem, e.g. in a latent and an observed plated variables.
- More generally, dependencies in initialization of different variables becomes hard
- Obvious answer would be procedural model init, but...
- Plain constructors in models have two problems
  - Lots of repetitive things, e.g. there may be several variables of same type
  - Need to hide the boxing somehow
- Parsing of indices is simpler and probably needs different architecture
- How to do command line arguments recursively?
- Recursive parsing such ``Plated<T>`` variables

Strategy
--------

- Provide a ``@Builder`` annotation on interfaces or classes (better than reflection-based constructors reflection as it provides more type guidance)
- Argument of the builder provides:
  - callback for observed/unobserved status
  - access to string arguments
- init + constant blocks to take care of matching dims

```
model {
  random Plated<Real> latent
  random Plated<Real> observed
  const Collection<Index<Int>> timeSteps = 
    pickAnyOf(
      latent.eachDistinct(Int, "time"),
      observed.eachDistinct(Int, "time"))
  laws {
    ...
  }
}
```

Syntax for command line

```
-switch1
-switch2
-key1 value 
-key2 {
  -subkey1 value
  -subkey2 "asdfasdf"
}
```

```
blang my.Model 
  -data { 
    -latent {
      -dims {
        -time 100
      }
    }
    -observed {
      -csv some/File.csv
    }
  }
  -mcmc {
  ...
  }
```

or alternatively,
 
```
blang my.Model
  -data.latent.dims.time 100
  -data.observed.csv some/File.csv
```


Write generic tool that uses introspection + constructors? NB/danger: need special treatment for setObserved.

Things considered and cancelled:

- using mwe2: no, ints and doubles not supported
- xtext-based language extension: overkill, will create head aches with imports, etc. Auto-complete nice but do later not needed for Silico too.
- ``@Option``/fig: 



General organization of command line arguments

Map: qualifiedName -> List<String>
use @Default(key -> default to "", value = ..), make it multiple