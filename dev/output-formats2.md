Potential output methods


    * timing:
      ->>>>>> (A) snapshot once in a while
NNNO  - (B) deltas+time  [too complicated - can of worms - increase complexity of 
                          creating new types - etc]
NO      - one big stream [bad for multi-thread]
NO      - separate streams, time gets passed in
        
    * connected to:
      - r.v. itself
NO      - via interface [too hard for users to add new behavior afterwards]
        - via annotation (the processor sees the r.v., needed for A)
        - via injection (the r.v. sees the processor, needed for B)
NO    - sampler [gets messy if several samplers target same variable]

  
    * representation:
NO    - toString only [might get too slow]
NO    - Kryo only [not convenient, e.g. in a teaching context]
      - offer options for both, 
        - start with toString
NO?     - start with Kryo, might be preferred by B 
          [in the workshop, would be bad to have only that]


NO  - assume everything is an expectation/mbr [need full sequence e.g. for diagnostic]