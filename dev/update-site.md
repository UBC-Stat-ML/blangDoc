# Creating an update site

## From Maven (recommended)

- Install Maven 3.3.9+, make ``mvn`` accessible from path
- Call ``mvn install`` from ``blangDSL/ca.ubc.stat.blang.parent``
- Eclipse site is in ``ca.ubc.stat.blang.repository/target/repository``

## From eclipse

- ``Import projects`` to make sure all sub-projects imported, especially, ``feature`` and ``repository``
- From project ``ca.ubc.stat.blang.repository``, pic ``Export``, then ``Deployable features``.