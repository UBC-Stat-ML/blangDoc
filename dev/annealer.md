# Very rough notes on custom annealing

- Constraints
    - Avoid to change Factor interface, that would involve changing the low level XExpressionProcessor stuff
    - Instead, introduce as a managed ``param`` - actually just a managed field - might be more like ``random``?
- Design: Factors are always wrapped around an annealer
    - For support factor, just add functionality to existing SupportFactor class
    - Use same model for numeric factors (requires low level mods but might actually simplify code)
    - both have a setAnneal 
- Models always have an annealing param - default is the 1-annealer
    - Not shown in signatures/builders
    - Does show in scopes 
- Then, second pass examines which models should be hooked up to the global annealer

Start with auto-anneal only - then no need to change language?

Note: lots of the complexity seems to come   from the manual annealing. 

Note: maybe manual annealing needs to be part of more general custom factor instantiation.

TODO: orthogonal but later, at some point refactor sampler matching to support model matches, interpretation is that they would contain all the factors - will be needed for conjugate models for example

NOTE: don't forget @SkipDependency - both in model and in factor implementations

Need to fiddle with scoping - will need when doing the manual version.. maybe not, just handle the manual case in a more standard fashion. - could be don 


Might need/want to refactor posterior sampling architecture

- matching factor is not useful anymore? No still useful for sampling constrained types!!!
    
    