**Git** **Env**\ ironment meta-project.

.. image:: https://travis-ci.org/ruslo/gitenv.png?branch=master
  :target: https://travis-ci.org/ruslo/gitenv

This is simply a collection of some git repos. The goal of the project is to
have unified **layout** of directories with git repos. That is, if you have to
clone some of this repos **anyway**, why don't have similar structure every time
(every machine) and have some benefits from it?

*Note*: It's not a package manager, if you want to have **stable minimal**
release snapshot, please refer to your favorite software manager like ``apt``,
``emerge``, ``macports``, etc.

Usage
-----

Copy `gitenv`_ repo:

.. code-block:: shell

  > git clone https://github.com/ruslo/gitenv && cd gitenv
  Cloning into 'gitenv'...
  remote: Counting objects: 27, done.
  remote: Compressing objects: 100% (24/24), done.
  remote: Total 27 (delta 10), reused 14 (delta 3)
  Unpacking objects: 100% (27/27), done.
  Checking connectivity... done

Init submodules you're interested in:

.. code-block:: shell

  > git submodule init doxygen/ llvm/libcxxabi/ google/gmock/
  Submodule 'doxygen' (http://github.com/doxygen/doxygen.git) registered for path 'doxygen'
  Submodule 'google/gmock' (https://chromium.googlesource.com/external/gmock) registered for path 'google/gmock'
  Submodule 'llvm/libcxxabi' (http://llvm.org/git/libcxxabi) registered for path 'llvm/libcxxabi'

Load inited submodules from remotes:

.. code-block:: shell

  > git submodule update
  Cloning into 'doxygen'...
  remote: Counting objects: 23978, done.
  remote: Compressing objects: 100% (3004/3004), done.
  remote: Total 23978 (delta 20559), reused 23618 (delta 20245)
  Receiving objects: 100% (23978/23978), 11.78 MiB | 489.00 KiB/s, done.
  Resolving deltas: 100% (20559/20559), done.
  Checking connectivity... done
  Submodule path 'doxygen': checked out '983507e0a65e5c2d51209740a89311e122e4f389'
  Cloning into 'google/gmock'...
  remote: Total 1878 (delta 1383), reused 1878 (delta 1383)
  Receiving objects: 100% (1878/1878), 777.71 KiB | 0 bytes/s, done.
  Resolving deltas: 100% (1383/1383), done.
  Checking connectivity... done
  Submodule path 'google/gmock': checked out 'd138e25941faa1a80f11a8e4cf2c7636402cc720'
  Cloning into 'llvm/libcxxabi'...
  remote: Counting objects: 1171, done.
  remote: Compressing objects: 100% (539/539), done.
  remote: Total 1171 (delta 813), reused 869 (delta 612)
  Receiving objects: 100% (1171/1171), 937.08 KiB | 402.00 KiB/s, done.
  Resolving deltas: 100% (813/813), done.
  Checking connectivity... done
  Submodule path 'llvm/libcxxabi': checked out '6dc154019d5f0997d7df1d9e9f3ba1425396dcd8'

Submodules now is in `detach state`_, probably you want to switch
to some branch, for example ``master``:

.. code-block:: shell

  > git submodule foreach 'git checkout master'
  Entering 'doxygen'
  Switched to branch 'master'
  Entering 'google/gmock'
  Switched to branch 'master'
  Entering 'llvm/libcxxabi'
  Switched to branch 'master'

Take a look at the remotes submodule use:

.. code-block:: shell

  > cd llvm/libcxxabi
  > git remote -v
  origin  http://llvm.org/git/libcxxabi (fetch)
  origin  http://llvm.org/git/libcxxabi (push)

.. _gitenv: https://github.com/ruslo/gitenv
.. _detach state: http://git-scm.com/docs/git-submodule
