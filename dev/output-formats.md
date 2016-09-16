Output format
=============


NOOOO - will make things too complex, need all sort of observers/caches to update this kind of rep - just print everything in between rounds of sampling, use thinning if needed

top level things create zip files

Main output comes in two parts, one mandatory, one optional.

### Part 1

One header line, followed by comma separated triplet:

```
variableId,weight,value
0,0.17,25.4
1,0.25,"(some (tree value))"
...
```

where:

- variableId is an integer, deterministically assigned from the model definition and its dependencies
- weight is an unnormalized weight, for example the number of MCMC iteration at a given state, the process time spent at a given velocity in the BPS, the process time spent at a state in DBPS, or an SMC unnormalize weight.
- value is an arbitrary string


### Part 2 (optional)

```
variableId,variableName
0,variance
1,blah
...
```

This is optional as it can be reconstructed from model.


Rationales
==========

Other formats seems to have limitations:

- Giving printing responsibility to Table, and other top level variables would create bloated files; e.g. if each 
- Stan's format (flast 