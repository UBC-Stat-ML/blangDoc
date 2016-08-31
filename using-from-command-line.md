# Using blang from the command line

Download
--------

Clone the repository at [https://github.com/UBC-Stat-ML/blangSDK](https://github.com/UBC-Stat-ML/blangSDK) 


Requirements
------------

The following should be accessible in your ``PATH`` system variable:

- Java 8
- Gradle (tested with 2.14)

Note: tested on UNIX (Mac OS X) but should run on all platforms.


Installation
------------

1. From the cloned ``blangSDK`` repository, type ``gradle installDist``
2. Add the absolute path to the subdirectory ``blangSDK/build/install/blang/bin`` to your ``PATH`` system variable.


Usage
-----

1. Create a directory for your project, say ``blangProject``
2. Create a blang file, e.g. an empty model ``model MyModel { laws{} }``, save it as ``blangProject/MyModel.bl``
    - Note: the extension ``.bl`` is required.
3. From ``blangProject``, type ``blang --model MyModel``
    - This will compile every ``.bl`` file in ``blangProject`` (and its subdirectories, if any)
    - After compilation, the model ``MyModel`` will be ran (note that the file extension should be stripped here, in parallel to standard Java conventions).
