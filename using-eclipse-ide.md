# Blang Eclipse IDE

## User

A pre-compiled, easy-to-install Blang IDE is [available on the main Blang website](https://www.stat.ubc.ca/~bouchard/blang/Getting_started.html). Use the pre-compiled version instead of the instructions in this page, unless you want to do development on Blang itself. 

The instructions on this page can also be used for motivated Linux users who want to use Blang IDE (we do not have yet a pre-package Blang IDE for Linux).


## Developer

Prerequisites:

- Java 8+ installed.

Instructions:

1. Clone all github repositories listed at the bottom of [this page](https://github.com/UBC-Stat-ML/blangDoc/).
2. Download Eclipse Oxygen **for xtext development**. [Link](http://www.eclipse.org/)
3. In the meanwhile, you can type ``gradle eclipse`` in each of the cloned repo (step 1). Note: for blangDSL, run the ``gradle eclipse`` command under the subdirectory ``ca.ubc.stat.blang.parent``.
4. Start eclipse, and import blangDSL as ``Existing project``. **Make sure to check the box for adding subprojects.**
5. Initially (and if the grammar changes), right-click on  ``ca.ubc.stat.blang/src/ca.ubc.stat.blang/GenerateBlangDsl.mwe2`` and select ``Run as`` > ``MWE2 workflow``. This generates various files for  parsing, lexing, IDE, etc, based on the grammar (``ca.ubc.stat.blang/src/ca.ubc.stat.blangBlangDsl.xtext``). Note: a potential issue here is that a generated folder may not be included in the path. If you see errors after refreshing and cleaning, right click on ``ca.ubc.stat.blang``, go to properties, java build path, source and make sure ``ca.ubc.stat.blang/src-gen`` is in the list.
6. Once this is finished, you might have to clean and rebuild, then, right click on the project ``ca.ubc.stat.blang`` and select ``Run as`` > ``Eclipse Application``.
7. This starts a new eclipse, namely the Blang IDE. 
8. Now in this new eclipse, import the project ``blangSDK`` as existing project.

Now, if you create new ``.bl`` files in ``blangSDK``, the child eclipse will infer it's a Blang file and will provide auto-complete, syntax highlighting, errors messages, etc.


