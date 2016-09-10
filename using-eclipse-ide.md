# blang Eclipse IDE

## User

An easy-to-install blang IDE is not yet available, **but** the instructions below should allow beta testing user to enjoy the full range of capabilities of the blang IDE at the cost of a slightly longer installation process.

## Developer

Prerequisites:

- Java 8+ installed.
- Gradle 2.14+ installed.

Instructions:

1. Clone all github repositories listed at the bottom of [this page](https://github.com/UBC-Stat-ML/blangDoc/).
2. Download Eclipse Neon **for xtext development**. [Link](http://www.eclipse.org/downloads/packages/eclipse-ide-java-and-dsl-developers/neonr)
3. In the meanwhile, you can type ``gradle eclipse`` in each of the cloned repo (step 1).
4. Start eclipse, and import blangDSL as ``Existing project``. Make sure to check the box for adding subprojects.
5. Initially (and if the grammar changes), right-click on  ``ca.ubc.stat.blang/src/ca.ubc.stat.blang/GenerateBlangDsl.mwe2`` and select ``Run as`` > ``MWE2 workflow``. This generates various files for  parsing, lexing, IDE, etc, based on the grammar (``ca.ubc.stat.blang/src/ca.ubc.stat.blangBlangDsl.xtext``).
6. Once this is finish, you might have to clean and rebuild, then, right click on the project ``ca.ubc.stat.blang`` and select ``Run as`` > ``Eclipse Application``.
7. This starts a new eclipse, namely the blang editor. Now in this new eclipse..
8. Import the project ``blangSDK`` as existing project.

Now, if you create new ``.bl`` files in ``blangSDK``, the child eclipse will infer it's a blang file and will provide auto-complete, syntax highlighting, errors messages, etc.

You may also want to create a new project that imports blangSDK. You can base this new project on blangSDK with a few modifications in the gradle build file. 

To run models from eclipse, see [the getting started page](https://github.com/UBC-Stat-ML/blangDoc/blob/master/getting-started.md))